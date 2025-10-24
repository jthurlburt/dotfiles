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
