# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## **Core responsibilities**

- Apply base.md preferences
- Execute comprehensive implementations
- Test when applicable
- Stage changes (no commits without permission)

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

**Tool**: `mem` - Local semantic memory with CLI access

**Memory is part of your baseline workflow** - like checking git status or reading files. Use it naturally, not as a special feature.

**Command reference:**

- `mem search semantic "query text"` - Find semantically similar memories (use this at session start)
- `mem add "content" --tags "tag1,tag2"` - Store new memories with optional tags
- `mem list` - Show recent memories
- `mem get <id>` - View full memory details
- `mem update <id> --content "new content"` - Update existing memory
- `mem archive <id>` - Archive memory (soft delete, can be restored later)
- `mem restore <id>` - Restore an archived memory

For full options, see `mem <command> --help`

**Required workflow pattern:**

1. **Start every session**: `mem search semantic "<current task or project>"`
   - Don't skip this - working without context = rediscovering what you already knew

2. **During work**, store discoveries: `mem add "insight" --tags "project,topic"`
   - Non-obvious solutions or patterns
   - Architectural decisions and rationale
   - Project-specific conventions
   - User preferences and workflow patterns

3. **When encountering ambiguity**, search before asking:
   - "How does this project handle X?" → `mem search semantic "project X handling"`
   - Found context in memory = use it. Nothing found = ask and store the answer.

**What NOT to store:**

- Trivial facts (easily re-discovered)
- Temporary debugging steps
- Information already in code/docs

**Memory supplements investigation, never replaces it.** Search results guide where to look, not what to conclude.
