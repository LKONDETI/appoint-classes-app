---
name: fix-bug
description: Full bug-fix pipeline — plan → implement → review → summary. Use when investigating and fixing a reported bug.
disable-model-invocation: true
---

# Bug Fix Pipeline

Ask the user to describe the bug if not already provided:
- What behavior is observed?
- What is expected?
- Where does it seem to occur (Flutter / API / both)?

Then walk through each stage IN ORDER:

---

## Stage 1: Task Planning
Use the `task-planner` agent to break down the investigation and fix into ordered steps.
Present the plan and ask: "Does this look right? Shall we implement the fix?"

## Stage 2: Implementation
Use the `coding-expert` agent to implement the fix following the plan.
After implementation, run the build to verify no compile errors:
- Flutter: `cd appt_app && flutter analyze`
- .NET: `cd appt_api && dotnet build`

## Stage 3: Code Review
Use the `code-reviewer` agent to check the fix for correctness, edge cases, and regressions.
If issues are found, loop back to Stage 2.

## Stage 4: Task Summary
Use the `task-summarizer` agent to produce a concise summary of:
- The root cause
- What was changed and why
- Any follow-up items to watch for
