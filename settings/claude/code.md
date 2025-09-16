# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## Initial Analysis Protocol - Non-Negotiable Rules

Every analysis task MUST start with these tools in this order:

1. **File Discovery**: `fd -e py -e json -e yaml -e js -e ts -e go -e java -e rb .` (never find)
2. **Project Structure**: `tree -I '__pycache__|*.pyc|.git'`
3. **Delegation Assessment**:
   - Consider if this analysis would benefit from multiple specialized perspectives
   - Look for complex, multi-domain projects (security + infrastructure + data flows + etc.)
   - Check if user explicitly requests delegation ("delegate", "comprehensive review", "full analysis", "second opinion")
   - **If delegation appropriate**: Split into 2-10 specialized domains and run multiple parallel headless agents per "Recursive Delegation System" below
   - **If single-agent sufficient**: Continue to step 4
4. **Code Analysis** (only if not delegating): `ast-grep --lang python -p 'def $_($_)' src/` and `ast-grep --lang python -p 'class $_' src/`
5. **Configuration Processing** (only if not delegating): `jq '.' config.json && yq '.' config.yaml` for every JSON/YAML file found

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

## Recursive Delegation System

### Multi-Agent Parallel Delegation

When delegation is appropriate, split analysis into 2-10 specialized domains and run multiple agents in parallel:

**Example domains:** Security analysis, Infrastructure/CDK, Data flow architecture, Performance patterns, Configuration management

**Command template for each domain:**

```bash
claude -p "READ-ONLY ANALYSIS: [specific domain only]

Focus exclusively on [domain] aspects:
- [Domain-specific analysis goals]
- If domain still too complex, delegate up to 10 sub-tasks using this template
- You are read-only: cannot modify files or system state
- Return structured JSON findings for your domain only" \
--output-format stream-json \
--verbose \
--allowedTools "$RO_TOOLS" \
--disallowedTools "$DENIED_TOOLS"
```

**Execution instructions:**

- Set tool variables before launching sub-agents
- Launch all sub-agents in a single bash command using `&` for parallel execution
- Use `wait` command to ensure all agents complete before proceeding
- **CRITICAL**: Use the Bash tool's timeout parameter (not environment variables) for 10-minute timeout
- Example using the Bash tool with timeout parameter:

```xml
<invoke name="Bash">
<parameter name="timeout">600000</parameter>  <!-- 10 minutes -->
<parameter name="command">
# Set tool variables
RO_TOOLS="Read,Glob,Grep,mcp__local-semantic-memory__search_content,mcp__local-semantic-memory__search_semantic,mcp__local-semantic-memory__remember,Bash(fd:*),Bash(ast-grep:*),Bash(rg:*),Bash(tree:*),Bash(find:*),Bash(ls:*),Bash(cat:*),Bash(head:*),Bash(tail:*),Bash(wc:*),Bash(sort:*),Bash(uniq:*),Bash(cut:*)"
DENIED_TOOLS="Write,Edit,MultiEdit,NotebookEdit,Bash(git add:*),Bash(git commit:*),Bash(git push:*),Bash(rm:*),Bash(mv:*),Bash(cp:*),Bash(chmod:*),Bash(mkdir:*)"

# Launch parallel agents
claude -p "Security analysis..." --output-format stream-json --verbose --allowedTools "$RO_TOOLS" --disallowedTools "$DENIED_TOOLS" &
claude -p "Infrastructure analysis..." --output-format stream-json --verbose --allowedTools "$RO_TOOLS" --disallowedTools "$DENIED_TOOLS" &
claude -p "Data flow analysis..." --output-format stream-json --verbose --allowedTools "$RO_TOOLS" --disallowedTools "$DENIED_TOOLS" &
wait
</parameter>
</invoke>
```

### Key Rules

- Each agent can spawn up to 10 sub-agents
- Infinite recursion depth allowed
- All agents are read-only
- 10-minute timeout applies to entire delegation tree
- Return structured JSON results

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
