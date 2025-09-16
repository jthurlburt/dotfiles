# Claude Code Instructions

## Imports

- @~/dotfiles/settings/claude/base.md

## **Required Steps When Analyzing**

**MUST** complete these steps in order for every analysis task:

1. Identify important files with `fd`
2. Examine project structure with `tree -I '__pycache__|*.pyc|.git'`
3. **Delegation check**: If complex multi-domain task or user requests "delegate"/"comprehensive review"/"full analysis", use Recursive Delegation System
4. **If single-agent**: `ast-grep --lang python -p 'def $_($_)' src/` and `ast-grep --lang python -p 'class $_' src/`
5. **If single-agent**: Process all JSON/YAML with `jq '.' file.json` and `yq '.' file.yaml`

## **Code Quality Protocol**

Before finishing any task:

1. `ls -la .pre-commit-config.yaml`
2. **If exists**: Try `prek run --all-files` first, fallback to `pre-commit run --all-files` if prek unavailable
3. **If missing**: Use appropriate quality tools

**Core responsibilities**:

- Apply base.md preferences
- Follow analysis protocol above
- Execute comprehensive implementations
- Test when applicable
- Stage changes (no commits without permission)

## **Tools Quick Reference**

**Search**: `fd`, `rg`, `ast-grep --lang <lang> -p '<pattern>'`, `tree`
**Python**: `ruff check/format`, `mypy`, `pytest`, `uv`
**Config**: `jq`, `yq`, `sqlfmt`
**Shell**: `shellcheck`, `shfmt`, `prek`, `gh`
**Core**: Read, Write, Edit, MultiEdit, Glob, Grep, Bash

## **Delegation System**

**When to delegate**: Complex multi-domain tasks (security + infrastructure + data flows)

**Detailed Process**:

1. Split into 2-10 specialized domains
2. Set tool variables:
   - `RO_TOOLS="Read,Glob,Grep,mcp__local-semantic-memory__search_content,mcp__local-semantic-memory__search_semantic,mcp__local-semantic-memory__remember,Bash(fd:*),Bash(ast-grep:*),Bash(rg:*),Bash(tree:*),Bash(find:*),Bash(ls:*),Bash(cat:*),Bash(head:*),Bash(tail:*),Bash(wc:*),Bash(sort:*),Bash(uniq:*),Bash(cut:*)"`
   - `DENIED_TOOLS="Write,Edit,MultiEdit,NotebookEdit,Bash(git add:*),Bash(git commit:*),Bash(git push:*),Bash(rm:*),Bash(mv:*),Bash(cp:*),Bash(chmod:*),Bash(mkdir:*)"`
3. Launch with XML example using Bash tool timeout parameter:

```xml
<invoke name="Bash">
<parameter name="timeout">600000</parameter>
<parameter name="command">
# Set tool variables
RO_TOOLS="Read,Glob,Grep,mcp__local-semantic-memory__search_content,mcp__local-semantic-memory__search_semantic,mcp__local-semantic-memory__remember,Bash(fd:*),Bash(ast-grep:*),Bash(rg:*),Bash(tree:*),Bash(find:*),Bash(ls:*),Bash(cat:*),Bash(head:*),Bash(tail:*),Bash(wc:*),Bash(sort:*),Bash(uniq:*),Bash(cut:*)"
DENIED_TOOLS="Write,Edit,MultiEdit,NotebookEdit,Bash(git add:*),Bash(git commit:*),Bash(git push:*),Bash(rm:*),Bash(mv:*),Bash(cp:*),Bash(chmod:*),Bash(mkdir:*)"

# Launch parallel agents
claude -p "READ-ONLY: [domain] analysis only" --output-format stream-json --allowedTools "$RO_TOOLS" --disallowedTools "$DENIED_TOOLS" &
claude -p "READ-ONLY: [domain2] analysis only" --output-format stream-json --allowedTools "$RO_TOOLS" --disallowedTools "$DENIED_TOOLS" &
wait
</parameter>
</invoke>
```

**Rules**:

- Each agent can spawn up to 10 sub-agents
- Infinite recursion depth allowed
- All agents are read-only
- 10-minute timeout for entire tree
- Return structured JSON results

## **Staging Workflow**

- **Incremental**: Leave new changes unstaged when staged changes already exist
- **Pre-commit**: Run only when no unstaged conflicts exist
- **Safety**: Stage pre-commit changes automatically
