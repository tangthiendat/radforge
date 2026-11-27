#!/usr/bin/env python3
"""Consistency checks for Radforge skills and docs.

Standard library only. Run from anywhere:  python3 scripts/check.py
Add --cli to also confirm the skills CLI discovers every skill (needs Node and network).
Exits 1 when any check reports a problem.
"""
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SKILLS = ROOT / "skills"
README = ROOT / "README.md"
AGENTS = ROOT / "AGENTS.md"
CONTRACT = SKILLS / "use-radforge" / "references" / "workflow-contract.md"
HIGH_LEVEL = ROOT / "docs" / "radforge-high-level-orchestration.md"
FULL = ROOT / "docs" / "radforge-full-orchestration.md"
CLI_VERSION = "1.9.0"  # the skills CLI version the README says it was verified with

REQUIRED_FIELDS = ["name", "description", "maturity", "kind", "owner", "lastReviewed", "compatibility"]
CONTRACT_SENTENCE = (
    "Load the `use-radforge` skill's `references/workflow-contract.md` once per task, "
    "before other steps. Repository-local rules win on conflict. If the file is missing, "
    "say so and keep the approval, evidence, and closeout gates anyway."
)

# Shared rules that must appear in both AGENTS.md and the installed contract.
# This guards against drift in these rules only; it is not a full equivalence check.
SHARED_RULES = [
    ("one active skill", "use one active primary skill at a time"),
    ("no success without evidence", "do not claim success without fresh evidence"),
    ("narrowest check first", "run the narrowest high-signal check first"),
    ("skipped validation", "if validation is skipped, state exactly why"),
    ("observed vs assumed", "distinguish observed evidence from assumptions"),
    ("environment vs product", "distinguish environment limitations from product failures"),
    ("closeout: changed", "what changed"),
    ("closeout: validated", "what was validated"),
    ("closeout: skipped", "what was skipped and why"),
    ("closeout: risk", "any remaining risk"),
    ("closeout: state", "complete with remaining risk"),
    ("secrets", "do not expose or commit secrets, credentials, tokens, or private environment files"),
    ("escalate: ambiguity", "ambiguity appears during execution"),
    ("escalate: scope", "scope grows beyond a few obvious steps"),
    ("escalate: validation", "validation fails"),
    ("optional review", "optional last step"),
]

STALE = re.compile(r"(?<!un)install\.(sh|ps1)|providers/\*|manifest\.json")


def norm(text):
    return re.sub(r"\s+", " ", text.replace("`", "")).lower()


def skill_files():
    return sorted(SKILLS.glob("*/SKILL.md"))


def frontmatter(text):
    parts = text.split("---")
    return parts[1] if len(parts) > 2 else ""


def headings(text):
    return [line[3:].strip().lower() for line in text.splitlines() if line.startswith("## ")]


def check_frontmatter():
    problems = []
    for path in skill_files():
        fm = frontmatter(path.read_text())
        for field in REQUIRED_FIELDS:
            if not re.search(rf"(?m)^{field}:\s*\S", fm):
                problems.append(f"{path.relative_to(ROOT)}: missing frontmatter field '{field}'")
        name = re.search(r"(?m)^name:\s*(.+)$", fm)
        if name and name.group(1).strip() != path.parent.name:
            problems.append(f"{path.relative_to(ROOT)}: name '{name.group(1).strip()}' does not match folder")
        if not re.search(r'(?m)^lastReviewed:\s*"\d{4}-\d{2}-\d{2}"$', fm):
            problems.append(f"{path.relative_to(ROOT)}: lastReviewed must look like \"YYYY-MM-DD\"")
    return problems


def check_contract_section():
    problems = []
    if not CONTRACT.is_file():
        return [f"missing {CONTRACT.relative_to(ROOT)}"]
    for path in skill_files():
        text = path.read_text()
        rel = path.relative_to(ROOT)
        if text.count(CONTRACT_SENTENCE) != 1:
            problems.append(f"{rel}: contract sentence must appear exactly once")
        elif "## Shared Contract" not in text or text.index("## Shared Contract") > text.index("## Process"):
            problems.append(f"{rel}: '## Shared Contract' must come before '## Process'")
    return problems


def check_supporting_refs():
    problems = []
    for path in skill_files():
        for ref in set(re.findall(r"`((?:references|templates)/[A-Za-z0-9_.-]+\.md)`", path.read_text())):
            if ref == "references/workflow-contract.md":
                continue
            if not (path.parent / ref).is_file():
                problems.append(f"{path.relative_to(ROOT)}: referenced file '{ref}' does not exist")
    return problems


def check_handoffs():
    problems = []
    names = {p.parent.name for p in skill_files()}
    for path in skill_files():
        for src, dst in re.findall(r"(?m)^- `([a-z-]+)` -> (`[a-z-]+`|stop)", path.read_text()):
            dst = dst.strip("`")
            if src != path.parent.name:
                problems.append(f"{path.relative_to(ROOT)}: handoff source '{src}' is not this skill")
            if dst != "stop" and dst not in names:
                problems.append(f"{path.relative_to(ROOT)}: handoff target '{dst}' is not a skill")
    return problems


def output_contract(text):
    section = re.search(r"(?s)## Output Contract.*?```text\n(.*?)```", text)
    return [line.strip().lower() for line in section.group(1).splitlines() if line.strip()] if section else []


def check_templates():
    problems = []
    for path in skill_files():
        templates = sorted((path.parent / "templates").glob("*.md"))
        contract = output_contract(path.read_text())
        for template in templates:
            if headings(template.read_text()) != contract:
                problems.append(f"{template.relative_to(ROOT)}: headings differ from the Output Contract in {path.name}")
            examples = sorted((path.parent / "references").glob("example-*.md"))
            for example in examples:
                if headings(example.read_text()) != headings(template.read_text()):
                    problems.append(f"{example.relative_to(ROOT)}: headings differ from {template.name}")
    return problems


def mermaid(path):
    match = re.search(r"```mermaid\n(.*?)```", path.read_text(), re.S)
    return match.group(1) if match else None


def check_diagrams():
    a, b = mermaid(README), mermaid(HIGH_LEVEL)
    if a is None or b is None:
        return ["missing mermaid diagram in README.md or the high-level orchestration doc"]
    return [] if a == b else ["README.md and docs/radforge-high-level-orchestration.md diagrams differ"]


def check_diagram_handoffs():
    """Every handoff a skill declares must exist in the full diagram, and the reverse."""
    text = mermaid(FULL)
    if text is None:
        return ["missing mermaid diagram in docs/radforge-full-orchestration.md"]
    names = {p.parent.name for p in skill_files()}
    node_of = {label: node for node, label in re.findall(r"\b([A-Z][A-Z0-9_]*)\[([a-z-]+)\]", text) if label in names}
    skill_of = {node: label for label, node in node_of.items()}
    edges = {}
    for line in text.splitlines():
        match = re.match(r"\s*([A-Z][A-Z0-9_]*)\s+(?:--[^>]*?-->|-->|-\.->)\s*(?:\|[^|]*\|\s*)?([A-Z][A-Z0-9_]*)", line)
        if match:
            edges.setdefault(match.group(1), set()).add(match.group(2))

    def reach(start):
        found, can_stop, seen, stack = set(), False, {start}, [start]
        while stack:
            for nxt in edges.get(stack.pop(), ()):
                if nxt in skill_of:
                    if nxt != start:
                        found.add(skill_of[nxt])
                    continue
                if nxt in seen:
                    continue
                seen.add(nxt)
                can_stop = can_stop or nxt not in edges
                stack.append(nxt)
        return found, can_stop

    problems = []
    for path in skill_files():
        skill = path.parent.name
        if skill not in node_of:
            problems.append(f"{skill}: no node in the full diagram")
            continue
        declared = {dst.strip("`") for _, dst in re.findall(r"(?m)^- `([a-z-]+)` -> (`[a-z-]+`|stop)", path.read_text())}
        declared_stop = "stop" in declared
        declared.discard("stop")
        shown, shown_stop = reach(node_of[skill])
        for target in sorted(declared - shown):
            problems.append(f"{skill}: declares a handoff to '{target}' that the full diagram does not show")
        for target in sorted(shown - declared):
            problems.append(f"{skill}: the full diagram shows a handoff to '{target}' that the skill does not declare")
        if declared_stop != shown_stop:
            problems.append(f"{skill}: stop is {'declared' if declared_stop else 'not declared'} but {'shown' if shown_stop else 'not shown'} in the diagram")
    return problems


def check_script_refs():
    problems = []
    for path in list(SKILLS.rglob("*.md")) + [README, AGENTS]:
        for script in set(re.findall(r"scripts/([A-Za-z0-9_.-]+\.(?:sh|ps1|py))", path.read_text())):
            if not (ROOT / "scripts" / script).is_file():
                problems.append(f"{path.relative_to(ROOT)}: scripts/{script} does not exist")
    return problems


def check_readme_cli_version():
    if f"skills CLI {CLI_VERSION}" not in README.read_text():
        return [f"README.md must say the commands were last verified with skills CLI {CLI_VERSION}"]
    return []


def check_cli_discovery():
    """Optional (--cli): the skills CLI should discover every skill folder. Uses the network."""
    try:
        run = subprocess.run(["npx", "-y", f"skills@{CLI_VERSION}", "add", str(ROOT), "--list"],
                             capture_output=True, text=True, timeout=180, env=dict(os.environ, DISABLE_TELEMETRY="1"))
    except (OSError, subprocess.TimeoutExpired) as error:
        return [f"could not run the skills CLI: {error}"]
    found = set(re.findall(r"(?m)^\u2502    ([a-z-]+)\s*$", run.stdout))
    expected = {p.parent.name for p in skill_files()}
    problems = [f"skills CLI did not discover '{name}'" for name in sorted(expected - found)]
    problems += [f"skills CLI discovered unexpected '{name}'" for name in sorted(found - expected)]
    return problems


def check_artifact_folders():
    """Shipped text must not hardcode docs/plans, docs/specs, or docs/reviews outside docs/radforge/."""
    problems = []
    hardcoded = re.compile(r"(?<!radforge/)docs/(plans|specs|reviews)\b")
    for path in list(SKILLS.rglob("*.md")) + [README]:
        for number, line in enumerate(path.read_text().splitlines(), 1):
            if hardcoded.search(line):
                problems.append(f"{path.relative_to(ROOT)}:{number}: hardcoded artifact folder; use the repository's folder or docs/radforge/")
    contract = CONTRACT.read_text()
    for default in ("docs/radforge/specs/", "docs/radforge/plans/"):
        if default not in contract:
            problems.append(f"{CONTRACT.relative_to(ROOT)}: must name the default folder {default}")
    if "a location the user names always wins" not in contract:
        problems.append(f"{CONTRACT.relative_to(ROOT)}: must say a user-named location always wins")
    for skill in ("plan", "spec-writing"):
        if "the path the user names" not in (SKILLS / skill / "SKILL.md").read_text():
            problems.append(f"skills/{skill}/SKILL.md: must put the user-named path first when choosing a location")
    return problems


def check_stale_refs():
    problems = []
    files = list(SKILLS.rglob("*.md")) + [README, AGENTS]
    for path in files:
        for number, line in enumerate(path.read_text().splitlines(), 1):
            if STALE.search(line) and "Earlier releases installed with" not in line:
                problems.append(f"{path.relative_to(ROOT)}:{number}: reference to a removed install script or manifest")
    return problems


def check_shared_rules():
    problems = []
    agents, contract = norm(AGENTS.read_text()), norm(CONTRACT.read_text())
    for label, phrase in SHARED_RULES:
        for name, text in (("AGENTS.md", agents), ("workflow-contract.md", contract)):
            if phrase not in text:
                problems.append(f"shared rule '{label}' not found in {name}: \"{phrase}\"")
    return problems


CHECKS = [
    ("skill frontmatter", check_frontmatter),
    ("shared contract section in every skill", check_contract_section),
    ("supporting file references", check_supporting_refs),
    ("handoff targets", check_handoffs),
    ("templates, output contracts, and examples", check_templates),
    ("README and high-level diagram parity", check_diagrams),
    ("full diagram matches declared handoffs", check_diagram_handoffs),
    ("scripts mentioned in docs exist", check_script_refs),
    ("README states the verified skills CLI version", check_readme_cli_version),
    ("artifact folders are namespaced, not hardcoded", check_artifact_folders),
    ("no references to removed install scripts", check_stale_refs),
    ("AGENTS.md and contract share the same rules", check_shared_rules),
]


def main():
    checks = list(CHECKS)
    if "--cli" in sys.argv[1:]:
        checks.append(("skills CLI discovers every skill (--cli, network)", check_cli_discovery))
    total = 0
    for label, check in checks:
        problems = check()
        total += len(problems)
        print(f"{'FAIL' if problems else 'ok  '}  {label}")
        for problem in problems:
            print(f"        {problem}")
    print(f"\n{len(checks)} checks, {total} problem(s)")
    return 1 if total else 0


if __name__ == "__main__":
    sys.exit(main())
