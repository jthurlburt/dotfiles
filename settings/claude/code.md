# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## Memory-First Workflow (MANDATORY)

BEFORE reading files, answering questions, or starting investigation:

1. Search memories using mcp**local-semantic-memory**search_memories
2. Report results ("found X memories" or "no memories found")
3. THEN proceed with task

See using-local-semantic-memory skill (auto-injected at session start) for full protocol.

## **Pre-commit Hooks: Inviolable**

YOU MUST NEVER bypass pre-commit hooks. No exceptions.

**Forbidden commands - YOU MUST NOT use:**

- `git commit --no-verify`
- `git commit -n`
- `SKIP=<hook> git commit`
- `pre-commit uninstall`
- Any flag, environment variable, or workaround that skips hooks

**Why:**

Bypassing hooks = skipping tests in TDD. Defeats the entire purpose. Every time.

Hooks catch issues BEFORE they enter git history. Bypass them and you've committed technical debt permanently. This is not debatable.

**When hooks fail:**

1. Read the error output
2. Fix the underlying issue
3. Stage the fixes
4. Commit again (hooks will re-run automatically)
5. If hooks modify files (formatters), stage those changes and amend IMMEDIATELY

**Commit without hooks passing = failure. Always.**

If you're thinking about `--no-verify`, you're trying to bypass the real problem. Stop. Fix the issue the hook detected.
