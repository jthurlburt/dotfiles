# Claude Core Preferences for Jacob Hurlburt

## Quick Start

You are interacting with Jacob Hurlburt, Staff Data Engineer at Kin Insurance. This file contains core preferences shared across all Claude interfaces.

## Modern CLI Tools (Enforced by PreToolUse Hook)

YOU MUST use modern CLI tools for these operations. Using legacy tools will cause your commands to be blocked.

### Text and Code Search

**FORBIDDEN:** `grep`, `egrep`, `fgrep` - NEVER use these commands

**REQUIRED:**

- **Text search:** `rg "pattern" path/` (ripgrep via Bash tool)
- **Code structure:** `ast-grep --pattern 'structural pattern'` (via Bash tool)

**Examples:**

```bash
# Finding text in files
rg "TODO" src/
rg -i "error" logs/  # case insensitive
rg "class.*Test" --type py  # with file type filter

# Finding code structures
ast-grep --pattern 'class $NAME { $$$ }'  # find class definitions
ast-grep --pattern 'def $FUNC($$$):' --lang python  # find functions
ast-grep --pattern 'import { $$$ } from "$MOD"'  # find imports
```

### File Finding

**FORBIDDEN:** `find` command - NEVER use this command

**REQUIRED:** `fd` (via Bash tool)

**Examples:**

```bash
# Find by name
fd filename
fd "test.*\.py$"  # regex pattern

# Find by extension
fd -e py
fd -e js -e ts  # multiple extensions

# Find in specific directory
fd pattern directory/

# List all files in directory
fd . directory/
```

### Text Processing

**FORBIDDEN:** `sed`, `awk` for text processing

**REQUIRED:**

- **JSON:** `jq` (via Bash tool)
- **YAML/XML:** `yq` (via Bash tool)
- **Text filtering:** `rg` (via Bash tool)

## Pre-commit Hooks (Enforced by Git Workflow)

YOU MUST NEVER bypass pre-commit hooks. No exceptions.

**Forbidden commands - YOU MUST NOT use:**

- `git commit --no-verify`
- `git commit -n`
- `SKIP=<hook> git commit`
- `pre-commit uninstall`
- Any flag, environment variable, or workaround that skips hooks

**When hooks fail:**

1. Read the error output
2. Fix the underlying issue
3. Stage the fixes
4. Commit again (hooks will re-run automatically)
5. If hooks modify files (formatters), stage those changes and amend IMMEDIATELY

## Python Tooling (Project-Aware)

YOU MUST use the project's package manager for Python tools. Running global `pytest`, `mypy`, or `ruff` in a managed project = broken imports, missing dependencies, wrong versions. Every time.

**Detection signals:**

- `uv.lock` or `[tool.uv]` in pyproject.toml → use `uv run`
- `pixi.toml` or `pixi.lock` → use `pixi run`

**FORBIDDEN in uv/pixi projects:**

- `pytest` (global)
- `mypy` (global)
- `ruff` (global)
- Any Python tool invoked without the project's runner

**REQUIRED:**

```bash
# uv projects
uv run pytest tests/
uv run mypy src/
uv run ruff check .

# pixi projects
pixi run pytest tests/
pixi run mypy src/
pixi run ruff check .
```

**No exceptions.** "It worked with global pytest" means you got lucky—the environment matched by accident. Use the project's tooling.

## Git Workflow

- **Conventional commits:** `type(scope): subject` format
- **Atomic commits:** One logical change per commit
- **No AI co-authorship:** Never include AI attribution in commits
