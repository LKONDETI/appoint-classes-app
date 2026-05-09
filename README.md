# Claude Agents & Skills Template

A reusable `.claude/` template for any project. Copy the `.claude/` folder into your new project root and replace all `{{PLACEHOLDER}}` values.

---

## Folder Structure

```
.claude/
  agents/
    task-planner/AGENT.md       — breaks features into ordered tasks
    architect/AGENT.md          — designs folder structure & patterns
    coding-expert/AGENT.md      — writes the implementation code
    code-reviewer/AGENT.md      — reviews for quality & SOLID issues
    security-reviewer/AGENT.md  — reviews for OWASP Top 10 vulnerabilities
    testing-expert/AGENT.md     — writes unit & integration tests
    task-summarizer/AGENT.md    — summarizes completed work
  skills/
    new-feature/SKILL.md        — full pipeline: plan→arch→code→review→test→summary
    run-tests/SKILL.md          — runs the test suite
    deploy/SKILL.md             — builds and deploys the app
```

---

## Placeholder Reference

Replace every `{{PLACEHOLDER}}` in the agent/skill files with values for your project.

| Placeholder | Description | Examples |
|---|---|---|
| `{{TECH_STACK}}` | Language + framework | `.NET 9`, `Node.js + Express`, `Python + FastAPI`, `Go + Gin` |
| `{{PROJECT_TYPE}}` | What the project is | `REST API`, `web app`, `CLI tool`, `microservice` |
| `{{LANG}}` | Code language for snippets | `csharp`, `typescript`, `python`, `go` |
| `{{DEFAULT_PATTERN}}` | Default architecture pattern | `Clean Architecture + Repository Pattern`, `MVC`, `Hexagonal Architecture` |
| `{{ARCHITECTURE_LAYERS}}` | Layers in the architecture | See examples below |
| `{{FOLDER_STRUCTURE_EXAMPLE}}` | Example folder tree | See examples below |
| `{{BUILD_COMMAND}}` | How to build the project | `dotnet build`, `npm run build`, `go build ./...`, `mvn package` |
| `{{RELEASE_FLAGS}}` | Release build flags | `-c Release`, `--mode=production`, `-ldflags="-s -w"` |
| `{{TEST_COMMAND}}` | How to run tests | `dotnet test`, `npm test`, `pytest`, `go test ./...` |
| `{{TEST_FLAGS}}` | Extra test flags | `--configuration Release --logger "console;verbosity=normal"`, `--coverage` |
| `{{TEST_FRAMEWORK}}` | Test framework name | `xUnit ([Fact]/[Theory])`, `Jest (describe/it)`, `pytest`, `testing.T` |
| `{{INTEGRATION_TEST_APPROACH}}` | How integration tests work | See examples below |
| `{{PUBLISH_COMMAND}}` | How to package artifacts | `dotnet publish -c Release -o ./publish`, `npm run build && zip -r dist.zip dist/` |
| `{{DEPLOY_CLI}}` | Cloud CLI tool | `az`, `aws`, `gcloud`, `fly`, `heroku` |
| `{{DEPLOY_COMMAND}}` | Deploy command | `az webapp deploy ...`, `aws s3 sync ...`, `fly deploy` |
| `{{HEALTH_CHECK_COMMAND}}` | Verify deployment | `az webapp show ...`, `curl https://myapp.com/health`, `fly status` |
| `{{CLOUD_PROVIDER}}` | Cloud target | `Azure`, `AWS`, `GCP`, `Fly.io`, `Railway` |
| `{{CODING_STANDARDS}}` | Language-specific rules | See examples below |

---

## Filled-in Examples by Stack

### .NET 9 Web API (this project's original values)

| Placeholder | Value |
|---|---|
| `{{TECH_STACK}}` | `.NET 9` |
| `{{PROJECT_TYPE}}` | `banking API` |
| `{{LANG}}` | `csharp` |
| `{{DEFAULT_PATTERN}}` | `Clean Architecture + Repository Pattern` |
| `{{BUILD_COMMAND}}` | `dotnet build` |
| `{{TEST_COMMAND}}` | `dotnet test` |
| `{{TEST_FLAGS}}` | `--configuration Release --logger "console;verbosity=normal"` |
| `{{TEST_FRAMEWORK}}` | `xUnit ([Fact], [Theory], [InlineData])` |
| `{{DEPLOY_CLI}}` | `az` |
| `{{CLOUD_PROVIDER}}` | `Azure` |

`{{ARCHITECTURE_LAYERS}}`:
```
- Domain (entities, value objects, interfaces)
- Infrastructure (EF Core, repositories, cloud integrations)
- Application (services, use cases, DTOs)
- API (controllers, request/response models, middleware)
- Tests (unit + integration)
```

`{{INTEGRATION_TEST_APPROACH}}`:
```
- For integration tests: use WebApplicationFactory<Program> + in-memory SQLite or Testcontainers
```

`{{CODING_STANDARDS}}`:
```
- Use record types for DTOs
- Use ILogger<T> for logging
- Use async methods with CancellationToken throughout
- Return proper HTTP status codes
- Never hardcode secrets — use environment variables or Key Vault
```

---

### Node.js + Express REST API

| Placeholder | Value |
|---|---|
| `{{TECH_STACK}}` | `Node.js + Express` |
| `{{PROJECT_TYPE}}` | `REST API` |
| `{{LANG}}` | `typescript` |
| `{{DEFAULT_PATTERN}}` | `Layered Architecture (routes → controllers → services → repositories)` |
| `{{BUILD_COMMAND}}` | `npm run build` |
| `{{TEST_COMMAND}}` | `npm test` |
| `{{TEST_FLAGS}}` | `--coverage` |
| `{{TEST_FRAMEWORK}}` | `Jest (describe/it/expect)` |
| `{{DEPLOY_CLI}}` | `aws` |
| `{{CLOUD_PROVIDER}}` | `AWS` |

---

### Python + FastAPI

| Placeholder | Value |
|---|---|
| `{{TECH_STACK}}` | `Python 3.12 + FastAPI` |
| `{{PROJECT_TYPE}}` | `REST API` |
| `{{LANG}}` | `python` |
| `{{DEFAULT_PATTERN}}` | `Layered Architecture (routers → services → repositories)` |
| `{{BUILD_COMMAND}}` | `pip install -r requirements.txt` |
| `{{TEST_COMMAND}}` | `pytest` |
| `{{TEST_FLAGS}}` | `-v --cov=app --cov-report=term-missing` |
| `{{TEST_FRAMEWORK}}` | `pytest` |
| `{{DEPLOY_CLI}}` | `gcloud` |
| `{{CLOUD_PROVIDER}}` | `GCP` |

---

## How to Use This Template

1. Copy the `.claude/` folder into your new project root
2. Open each `AGENT.md` and `SKILL.md` file
3. Replace every `{{PLACEHOLDER}}` with the correct value for your project
4. Optionally add/remove agents that don't apply (e.g., remove `azure-ops` if not using Azure)
5. Add a `CLAUDE.md` file at your project root describing project-specific context

That's it — Claude Code will automatically discover and use the agents and skills.

---

## Agent Trigger Phrases (quick reference)

| Agent | When to use |
|---|---|
| `task-planner` | "plan X", "I want to add X", "what do I need to build X" |
| `architect` | "design X", "what structure for X", "how should I architect X" |
| `coding-expert` | "implement X", "write the code for X", "create X" |
| `code-reviewer` | "review X", "check quality of X", "is my code good?" |
| `security-reviewer` | "security review X", "check for vulnerabilities in X" |
| `testing-expert` | "write tests for X", "test X", "add unit tests to X" |
| `task-summarizer` | "summarize what we did", "recap", "what did we build" |

## Skill Trigger Phrases

| Skill | Trigger |
|---|---|
| `/new-feature` | Starting a new feature from scratch (runs full pipeline) |
| `/run-tests` | Run the test suite |
| `/deploy` | Deploy to the target environment |
