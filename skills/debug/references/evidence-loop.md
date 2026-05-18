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
2. choose the smallest-scope check that would confirm it
3. run the reproduction again
4. keep or reject the hypothesis based on evidence
5. broaden scope only if the narrow check does not explain the failure

Example:

```text
Hypothesis: the failure happens because <cause>
Check: inspect or change <smallest thing>
Result: <what happened>
Conclusion: keep or discard the hypothesis
```

## Failure Record Pattern

When reporting progress, capture:

- reproduction path
- failing scope or component boundary
- strongest current evidence
- current best-supported hypothesis or ranked leading hypotheses
- keep or discard conclusion for the current hypothesis
- next check to run

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

Hand off when one of these is true:

- the root cause is clear and implementation is approved
- the root cause is clear and the work should stop at diagnosis for now
- the issue needs a broader execution plan
- validation after the fix is complete and the work can close under the active repository or the current Radforge workflow closeout rule
