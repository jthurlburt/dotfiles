# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## Skills-First Workflow (MANDATORY)

BEFORE starting any task:

1. Ask: "Does ANY available skill match this request?"
2. If yes → Use Skill tool to load and execute it
3. Announce which skill you're using
4. Follow the skill exactly

See using-superpowers skill (auto-injected at session start) for full protocol.

**Critical:** If a skill exists for your task, you MUST use it. "This is simple" or "I remember it" = rationalizations. Check for skills BEFORE acting.

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
