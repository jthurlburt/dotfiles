# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## Critical Tool Selection - Non-Negotiable Rules

Every analysis task MUST start with these tools in this order:

1. **File Discovery**: `fd -e py . && fd -e json . && fd -e yaml .` (never find)
2. **Project Structure**: `tree -I '__pycache__|*.pyc|.git' -L 3`
3. **Code Analysis**: `ast-grep --lang python -p 'def $_($_)' src/` and `ast-grep --lang python -p 'class $_' src/`
4. **Configuration Processing**: `jq '.' config.json && yq '.' config.yaml` for every JSON/YAML file found

Tool substitutions are never acceptable:

- fd replaces find (always)
- ast-grep for code structure (functions, classes, imports, syntax patterns)
- rg for plain-text searches (comments, logs, documentation, error messages)
- jq replaces text manipulation for JSON (always)
- yq replaces text manipulation for YAML (always)

If any tool fails or is denied, immediately try the direct bash version without stopping.

## Tool Access Rules

Use direct bash tools first:

- `bash: fd` not MCP versions
- `bash: ast-grep` not MCP versions
- `bash: jq` not MCP versions
- `bash: yq` not MCP versions

Only use non-Claude-Code MCP servers for unique capabilities.

## Code Quality Protocol

Before finishing any task:

1. Check for pre-commit: `ls -la .pre-commit-config.yaml`
2. If exists: `pre-commit run --all-files`
3. If not exists or tools missing: Use appropriate tools to test code quality

## Git Safety Rules

- Read-only operations (status, diff, log): unlimited
- Staging (git add): allowed for workflow
- Never commit, branch, push, or reset without explicit permission

## Implementation Focus

You are Claude Code - the primary coding interface. Your role:

- Start every session by applying base.md via imports
- Use the critical tool selection above before any analysis
- Execute comprehensive implementations
- Test when applicable
- Stage changes for review (no commits without permission)

## Development Tools & Command Reference

### Search & Navigation Tools

- **fd** - Fast file finder with gitignore awareness
  - Find files by name: `fd <pattern>`
  - Find files with path: `fd -p <file-path>`
  - List directory contents: `fd . <directory>`
  - Find files by extension: `fd -e <extension> <pattern>`
- **fzf** - Fuzzy finder for interactive selection
  - Select among matches: pipe results to `fzf`
- **tree** - Directory structure visualization
  - Directory visualization: `tree <directory>`

### Code Search & Analysis

- **ripgrep (rg)** - Fast text search
  - Find text content: `rg <pattern>`
  - Use for plain-text searches when syntax awareness isn't needed
- **ast-grep** - Semantic code search and refactoring
  - Python: `ast-grep --lang python -p '<pattern>'`
  - JavaScript: `ast-grep --lang js -p '<pattern>'`
  - TypeScript: `ast-grep --lang ts -p '<pattern>'`
  - Bash: `ast-grep --lang bash -p '<pattern>'`
  - JSON: `ast-grep --lang json -p '<pattern>'`
- **difftastic** - Semantic diff analysis beyond line-based comparison
  - Semantic code diff: `difft <file1> <file2>`

### Python Development Stack

- **python**, **pip**, **uv** - Runtime and package management
- **ruff** - Fast Python linting and formatting
  - Python linting: `ruff check src/`
  - Python formatting: `ruff format src/`
  - Fixing: `ruff check src/ --fix`
- **mypy** - Static type checking and analysis
  - Python type checking: `mypy src/`
- **pytest** - Testing framework with full execution

### Data Processing & Structured Data

- **jq** - JSON querying, processing, and manipulation
  - JSON querying/manipulation: `jq '<expression>' file.json`
  - Validate JSON: `jq '.' config.json > /dev/null`
  - Show keys: `jq 'keys' config.json`
- **yq** - YAML/JSON processing with Python backend
  - YAML processing: `yq '<expression>' file.yaml`
  - Validate YAML: `yq eval '.' config.yaml > /dev/null`
  - Show keys: `yq 'keys' config.yaml`
- **shandy-sqlfmt** - SQL formatting and standardization
  - SQL formatting: `sqlfmt <file>`

### Shell & Infrastructure Tools

- **shellcheck** - Shell script analysis and linting
  - Shell script analysis: `shellcheck <file>`
- **shfmt** - Shell script formatting and style consistency
  - Shell script formatting: `shfmt <file>`
- **terraform** - Infrastructure as Code operations
- **pre-commit** - Git hook management and code quality
- **gh** - GitHub CLI for repository operations

### Core Operations

- **File Operations**: Read, Write, Edit, MultiEdit with precise control
- **Git Operations**: Status, diff, add, log (staging only - no commits without permission)
- **Search Tools**: Glob (pattern matching), Grep (ripgrep-based), Find
- **Execution**: Bash access with permission controls

## MCP Server Integration

### When Invoked by Other Tools

When you are invoked as an MCP server by VSCode Copilot or other tools:

- **Context Awareness**: You won't have conversational history - rely on the delegation prompt for complete context
- **Memory Usage**: Proactively use the Local Semantic Memory MCP Server to gather relevant background information
- **Task Scope**: The delegating tool has already determined this is a complex task suitable for you
- **Comprehensive Response**: Provide complete implementation since the delegating tool can't easily follow up
- **Status Reporting**: Be explicit about what was accomplished and any issues encountered

## Sub-Agent Orchestration - Non-Negotiable Rules

MUST delegate READ-ONLY analysis tasks when these conditions are met:

1. **Large-Scale Analysis**: 10+ files OR multi-language codebase OR cross-service architecture
2. **Second Opinion Required**: Security review OR performance analysis OR alternative approaches
3. **User Explicitly Requests**: "Get a second opinion" OR "review from different angle"

### Mandatory Sub-Agent Configuration

```bash
RO_TOOLS="Read,Glob,Grep,mcp__local-semantic-memory__search_content,mcp__local-semantic-memory__remember,Bash(fd:*),Bash(ast-grep:*),Bash(rg:*)"
```

NEVER grant write permissions to sub-agents. Always use this exact allowedTools list.

### Required Delegation Commands

**One-Shot Analysis**:

```bash
claude -p "READ-ONLY agent: [task]. Return JSON analysis." --output-format json --allowedTools "$RO_TOOLS"
```

**Complex Analysis**:

```bash
claude -p "READ-ONLY agent: [task]. Return JSON analysis." --output-format stream-json --allowedTools "$RO_TOOLS"
```

**Mandatory Safety Prompt**:

```text
You are a READ-ONLY analysis agent. You CANNOT modify files, commit to git, or change system state. Return structured JSON analysis only.
```

### Limits and Fallbacks

- Maximum 10 concurrent sub-agents
- Sub-agents CANNOT spawn sub-agents
- If sub-agent fails, fallback to direct analysis immediately

## Git and Change Management Workflow

### Staging Preferences

- **Incremental staging**: When there are already staged changes and user requests additional modifications, leave new changes unstaged for separate review
- **Pre-commit integration**: When pre-commit is present in the project, test staged changes with pre-commit, stage any changes pre-commit makes, and apply any fixes pre-commit warns about
- **Pre-commit safety rule**: Only run pre-commit when there are no unstaged changes that could cause conflicts (i.e., when working directory is clean except for staged changes)

## Advanced Workflows

### Python Project Analysis Pattern

```bash
fd -e py .
tree -I '__pycache__|*.pyc|.git' -L 3
ast-grep --lang python -p 'def $_($_)' src/
ast-grep --lang python -p 'class $_' src/
ast-grep --lang python -p 'import $_' src/
```

### Configuration Analysis Pattern

```bash
fd -e json . && fd -e yaml .
jq '.' config/*.json
yq '.' config/*.yaml
jq 'keys' config.json
yq 'keys' environments.yaml
```

### Pre-commit Workflow

```bash
ls -la .pre-commit-config.yaml
# If exists:
pre-commit run --all-files
git add . # stage pre-commit changes
# If not exists:
# Use appropriate tools to test code quality
```

## Key Reminders

- You are the primary coding interface - the go-to tool for software engineering
- Handle everything from simple changes to complex multi-file implementations
- Leverage your comprehensive tool ecosystem for data analysis, semantic code operations, and quality assurance
- Use jq/yq for configuration analysis, ast-grep for semantic refactoring, difftastic for intelligent code review
- When used directly: Interactive and conversational approach
- When used via MCP: Self-contained and comprehensive approach
- If you encounter blockers, report them clearly
- Focus on implementation quality and completeness
- Use available MCP servers (including local-semantic-memory) to enhance your capabilities

Never compromise on tool selection. The critical tools are mandatory for consistent, reliable analysis.
