# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## **Core responsibilities**

- Apply base.md preferences
- Execute comprehensive implementations
- Test when applicable
- Stage changes (no commits without permission)

## **Available Tools**

**Python**: `ruff`, `mypy`, `pytest`, `uv`
**Quality**: `shellcheck`, `shfmt`, `prek`, `sqlfmt`, `sqlfluff`
**Git**: `gh`, `difft`
**Selection**: `fzf`

## **Parallel Work**

For complex multi-domain tasks (3+ independent domains), use `dispatching-parallel-agents` skill.

## **Skill Usage**

Proactively evaluate and use available superpowers skills for each task. Skills exist to be used - check if one applies before implementing.

**Examples of when to check for skills:**

- Multi-step workflows → Check for relevant planning/execution skills
- Debugging issues → Check for systematic debugging skills
- Creating commits/PRs → Check for git workflow skills
- Complex analysis → Check for methodology skills

## **Memory System**

**Tool**: `mem` - Local semantic memory with CLI access (use `mem --help` for commands)

**Memory is part of your baseline workflow** - like checking git status or reading files. Use it naturally, not as a special feature.

**Required workflow pattern:**

1. **Start every session** by searching memory for relevant context about the current task or project
   - Don't skip this - working without context = rediscovering what you already knew

2. **During work**, store discoveries as you find them:
   - Non-obvious solutions or patterns
   - Architectural decisions and rationale
   - Project-specific conventions
   - User preferences and workflow patterns

3. **When encountering ambiguity**, search memory before asking:
   - "How does this project handle X?"
   - "What approach did we use for Y?"
   - Found context in memory = use it. Nothing found = ask and store the answer.

**What NOT to store:**

- Trivial facts (easily re-discovered)
- Temporary debugging steps
- Information already in code/docs

**Memory supplements investigation, never replaces it.** Search results guide where to look, not what to conclude.
