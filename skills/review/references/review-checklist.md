# Review Checklist

Use this checklist when the main `SKILL.md` is not enough and you need a tighter pass over the review surface.

## Correctness

- does the changed behavior still match the intended outcome?
- are there edge cases, null paths, or conditional branches that now behave incorrectly?
- were state, output, or file-format assumptions changed without updating all readers?

## Regression Risk

- does the change affect behavior outside the immediate file or component?
- does it alter install, update, uninstall, migration, or rollback behavior?
- does it depend on ordering, timing, or hidden environmental assumptions?

## Validation Gaps

- is the current evidence strong enough for the risk level?
- is a claimed success missing the one command, repro, or readback that would actually prove it?
- were high-risk surfaces left unvalidated without explanation?

## Rollout And Operations

- could the change confuse users during install, upgrade, or removal?
- does it need a doc, state, or config update on the same surface?
- is rollback or recovery unclear if the change fails in use?

## Docs And Intent Drift

- do README, specs, plans, or instructions now describe a different behavior from the code or skill?
- are historical docs likely to be mistaken for current guidance?

## Review Closeout

Before stopping, confirm that you have:

- prioritized the findings by severity
- separated true findings from open questions or residual risk
- named missing validation when it affects confidence
- said explicitly when no material findings were found
