---
name: deploy
description: Deploy the application to {{CLOUD_PROVIDER}} / production environment
disable-model-invocation: true
allowed-tools:
  - Bash({{BUILD_COMMAND}} *)
  - Bash({{DEPLOY_CLI}} *)
---

Deploy the application:

1. Build in release/production mode: `{{BUILD_COMMAND}} {{RELEASE_FLAGS}}`
2. Run pre-deploy checks (tests, linting): `{{TEST_COMMAND}}`
3. Package / publish artifacts: `{{PUBLISH_COMMAND}}`
4. Deploy to target environment: `{{DEPLOY_COMMAND}}`
5. Verify deployment health: `{{HEALTH_CHECK_COMMAND}}`

Ask the user for environment name, target region, and resource names if not provided.
Always confirm before deploying to production.
