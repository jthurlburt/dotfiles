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
