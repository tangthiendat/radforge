# Debug Evidence Loop

Use this file when the main `SKILL.md` is not enough and you need a tighter debugging loop.

## Reproduction Checklist

Capture the smallest repeatable case you can.

Record:

- command, input, or action that triggers the issue
- actual output, error, or behavior
- expected behavior
- whether the issue is consistent or intermittent
- smallest known failing component, boundary, or step

If the issue is not reproduced yet, do not jump to fixing.

Before broadening the search, try to identify the narrowest scope that can still explain the failure.

## Hypothesis Loop

Use one hypothesis at a time.

Do not move to the next hypothesis before concluding the current one from the evidence.

If several causes are plausible, rank the leading candidates before choosing the first check.

Ranking factors:

- likelihood based on current evidence
- how narrow the scope is
- how cheaply the hypothesis can be tested
- how much signal the check will produce

Pattern:

1. state the suspected cause
2. choose the smallest-scope check that would confirm it, preferring read-only evidence
3. establish mutation scope before reproduction or any experiment; explicit no-edit requests prohibit mutation
4. if mutation is authorized, prefer isolation and record the pre-experiment state and the agent's exact changes
5. run the reproduction again
6. keep or reject the hypothesis based on evidence
7. restore only experimental changes and confirm restoration before the next hypothesis or handoff, unless retaining the change is already authorized
8. broaden scope only if the narrow check does not explain the failure

Example:

```text
Hypothesis: the failure happens because <cause>
Check: <smallest read-only check or authorized experiment>
Mutation scope: <no-edit | diagnosis-only experiment | fix-authorized>
Experimental changes: <agent-owned changes and relevant prior state, or none>
Result: <what happened>
Conclusion: keep or discard the hypothesis
Restoration: <restored with evidence | authorized retention | unresolved and why>
```

## Experiment Boundaries

- A diagnosis-only request allows diagnosis, not a retained fix. Use read-only checks or an authorized reversible experiment; restore working changes before stopping.
- A no-edit request prohibits mutation even when called temporary or diagnostic.
- A fix request already authorizes routine reversible experiments within its scope. Do not add a new approval gate for each experiment.
- Prefer isolated fixtures or temporary overrides over changing active configuration or the working tree.
- Restore only the agent's experimental edits. Preserve pre-existing and concurrent user changes; do not reset a whole file or repository to remove an experiment.
- If restoration would overwrite user work or cannot safely reverse a state change, stop further mutation and report the unresolved state and smallest recovery step. Do not describe cleanup as complete.
- Report any retained changes and the authorization to retain them before handoff.

## Failure Record Pattern

When reporting progress, capture:

- reproduction path
- failing scope or component boundary
- strongest current evidence
- current best-supported hypothesis or ranked leading hypotheses
- keep or discard conclusion for the current hypothesis
- next check to run
- experiment scope, agent-owned changes, restoration evidence, and any retained or unresolved state
- original goal, acceptance criteria, plan/task position, remaining work, user constraints, and existing authorization for the next skill

Recommended status shape:

```text
Reproduction
Failing Boundary
Evidence
Hypothesis Status
Classification
Next Check
Handoff
```

## Exit Criteria

Before handoff or a diagnosis-only stop, confirm that experiment cleanup is complete or explicitly report authorized retention or unresolved state. Hand off when one of these is true:

- the root cause is clear and implementation is approved
- the root cause is clear and the work should stop at diagnosis for now
- the issue needs an approved broader execution plan
- validation after the fix is complete and the work can close under the active repository or the current Radforge workflow closeout rule
