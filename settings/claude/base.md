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
3. Stage the fixes and any changes the linters/formatters made
4. Commit again (hooks will re-run automatically)

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

### Temporary Dependencies (Ultra-Fast Ad-Hoc Usage)

When you need a library for one-off scripts, quick experiments, or CLI tools (even outside any project), use ephemeral dependencies. **This is VASTLY faster and cleaner than pip install.**

**Why this matters:**

- No polluting any environment
- No manual cleanup needed
- Instant isolated execution
- No "did I install this globally?" confusion

**REQUIRED:**

```bash
# For Python packages (PyPI) - use uv (default choice)
uv run --with requests python script.py
uv run --with pandas --with matplotlib analysis.py
uv run --with ruff ruff check .  # one-off tool usage

# For conda packages or non-Python dependencies - use pixi
pixi exec -s gcc python script.py  # need a C compiler
pixi exec -s gdal python geo_script.py  # conda-only package
pixi exec -s jupyterlab jupyter lab  # quick Jupyter session
```

**Common use cases:**

- Quick data analysis with pandas/polars → `uv run --with`
- One-off API calls with requests/httpx → `uv run --with`
- Trying a formatter/linter → `uv run --with`
- Need conda-only packages (GDAL, scientific libs) → `pixi exec -s`
- Need non-Python tools (compilers, system tools) → `pixi exec -s`

**Never use `pip install` for these.** Both `uv` and `pixi` are global CLI tools that handle downloading, caching, isolation, and cleanup automatically. It's literally designed for this exact scenario.

## Git Workflow

- **Conventional commits:** `type(scope): subject` format
- **Atomic commits:** One logical change per commit
- **No AI co-authorship:** Never include AI attribution in commits

## Jacob's JIRA Defaults (MANDATORY)

YOU MUST use these defaults for ALL JIRA operations. These are not suggestions.

### Your Team and Project

**Your Team:** PAACS Data
**Team UUID:** `cbee4e32-b2eb-4ae9-a8d7-598c015fbf75` (customfield_10001)
**Default Project:** CORE

**Default behavior when creating tickets:**

→ Team = NO TEAM (null/unset) unless user specifies
→ Project = CORE (automatic)

**When user says "my team" or "add to my team":**

→ Team = PAACS Data (UUID: `cbee4e32-b2eb-4ae9-a8d7-598c015fbf75`)

**When user says "Platform team" or "create for X team":**

→ Team = X (find team UUID via JQL search)

**When user says "DPLAT ticket" or "create a PROJ ticket":**

→ Project = PROJ (explicit override)

**No exceptions:**

- Default team = NO TEAM (you work across teams)
- "my team" = PAACS Data, always
- No project specified = CORE, always
- Don't ask "which team?" or "which project?" unless user gives conflicting signals

### Your Sprint

**Sprint Prefix:** PAACS Sprint (e.g., "PAACS Sprint 79")

**Default behavior:** New tickets have NO sprint assigned (sprint field = null)

**When user says "add this to my sprint":**

1. **Find your current active sprint** (use JQL with your sprint prefix):

   ```python
   atlassian_api(
       service="jira",
       method="POST",
       endpoint="/rest/api/3/search/jql",
       data='{"jql": "project = CORE AND sprint in openSprints() AND sprint ~ \\"PAACS Sprint\\" ORDER BY created DESC", "fields": ["key", "customfield_10020"], "maxResults": 1}',
       jq_filter=".issues[0].fields.customfield_10020[] | {id, name, state}",
   )
   ```

   Extract sprint ID from result (e.g., 8277 for "PAACS Sprint 79").

2. **Add ticket to sprint** using customfield_10020:

   ```python
   atlassian_api(
       service="jira",
       method="PUT",
       endpoint="/rest/api/3/issue/CORE-123",
       data='{"fields": {"customfield_10020": [8277]}}',
   )
   ```

**Common rationalizations that mean you're about to fail:**

- "I'll ask which sprint" → WRONG. User said "my sprint" = PAACS Sprint XX (current active sprint)
- "I'll assign to current sprint automatically" → WRONG. Default is NO sprint unless user says so
- "Sprint management is too complex" → WRONG. Follow the 2-step process above

**Implementation details** (field structure, API mechanics) are documented in `atlassian-toolkit:using-atlassian-api` skill under `api/jira/create-issue.md` and `api/jira/update-issue.md`.

**No exceptions.** "My team" = PAACS Data. "My sprint" = PAACS Sprint (current active). "Create a ticket" = CORE project. Period.
