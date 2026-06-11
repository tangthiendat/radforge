# Radforge High-Level Orchestration

This document mirrors the simplified orchestration view shown in the README.

Use this version when you want a quick routing overview rather than the full workflow state machine.

```mermaid
flowchart TD
    A([Start a task]) --> B{Is the task small and simple?}

    B -- Yes --> C([Handle it directly])
    B -- No --> D[Use use-radforge]

    D --> E[Choose the right workflow skill]
    E --> F{What kind of task is it?}

    F -->|Existing change needs assessment| R[Use review]
    F -->|Validation is the main job| T[Use test]
    F -->|Clear direct change| I[Use implement]
    F -->|Execution needs sequencing and checkpoints| P[Use plan]
    F -->|Approved direction needs a durable design| S[Use spec-writing]
    F -->|Direction is unclear or needs tradeoffs| BRAIN[Use brainstorming]
    F -->|Old path to new path transition| M[Use migration]
    F -->|Something is broken| DBUG[Use debug]

    BRAIN -.-> M
    BRAIN --> S
    M --> S
    S --> P
    P --> I
    DBUG --> I
    DBUG -.-> T
    I --> T

    R -.-> T
    R --> Z([Finish])
    T --> Z

    classDef start fill:#f5f0ff,stroke:#9b87f5,stroke-width:2px,color:#333;
    classDef decision fill:#ede9fe,stroke:#9b87f5,stroke-width:2px,color:#333;
    classDef action fill:#f3f0ff,stroke:#9b87f5,stroke-width:2px,color:#333;

    class A,Z,C start;
    class B,F decision;
    class D,E,R,T,I,P,S,BRAIN,M,DBUG action;
```

Notes:

- Solid arrows show the primary teaching path.
- Dashed arrows show common secondary handoffs.
- Repository-local workflow rules can still override this view.
