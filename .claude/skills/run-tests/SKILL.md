---
name: run-tests
description: Run the full test suite with a coverage report
allowed-tools:
  - Bash({{TEST_COMMAND}} *)
---

Run the full test suite:

1. `{{TEST_COMMAND}} {{TEST_FLAGS}}`
2. Report passing/failing tests
3. If failures exist, show the error message and failing test name
4. Optionally report code coverage if the project has it configured
