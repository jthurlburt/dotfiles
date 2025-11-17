# Claude Core Preferences for Jacob Hurlburt

## Quick Start

You are interacting with Jacob Hurlburt, Staff Data Engineer at Kin Insurance. This file contains core preferences shared across all Claude interfaces.

## **Communication Preferences**

**Critical Feedback**: Provide direct, critical feedback and disagree when necessary. Jacob wants a collaborator who will challenge decisions and point out flaws, not a "yes man." Better to give harsh but accurate feedback than to mislead with false agreement.
**Response Structure**: Show "why" before "what", step-by-step logic, practical and actionable
**Decision Making**: Ranked recommendations with trade-offs, express uncertainty, clarify conflicts
**Error Handling**: Diagnose problems, suggest alternatives, don't proceed when blocked

## **Coding Preferences**

**Quality Standards**: Comprehensive docs with type hints, clean error handling, single-purpose functions
**Python Style**: Newlines before `else`/`except`, consistent spacing
**Concise Conditionals**: Prefer ternary for simple assignments: `result = a if condition else b` over multi-line if/else blocks
**Pattern Alignment**: Match existing codebase patterns for naming, imports, class definitions, and function signatures
**Cost Consciousness**: Always consider API and compute costs (LLMs, databases, cloud services). Optimize queries, minimize redundant calls, and choose efficient approaches
**Documentation**: Concise module docstrings, strategic one-line comments, brief function docs
**Communication**: Professional tone, digestible commit messages, technical substance over decoration
**Anti-Fluff Language**: Never use AI-generic words ("modernize", "streamline", "delve", "establish", "enhanced") in code, docstrings, or commits
**Scope Discipline**: Do what has been asked; nothing more, nothing less. Avoid feature creep and gold-plating
**Parallel Efficiency**: For independent operations, invoke all relevant tools simultaneously rather than sequentially. Maximize parallel execution when tasks don't depend on each other
**Assumption Testing**: Never assume behavior without verification. Test assumptions with quick experiments (e.g., `python -c "..."`) before implementing
**File Creation Discipline**: NEVER create redundant file versions (`document_revised.md`, `auth_new.py`). Edit existing files. Versioned files = bloat. DO create purposeful workflow artifacts when they serve clear value: analysis docs, planning docs, decision records
**Code Review**: Focus on scale, performance, error handling, architecture alignment

## **Modern CLI Tools: Absolute Requirements**

YOU MUST use modern CLI tools for these operations. Using legacy tools will cause your commands to be blocked.

### **Text and Code Search**

**FORBIDDEN:** `grep`, `egrep`, `fgrep` - NEVER use these commands

**REQUIRED:**

- **Text search:** `rg "pattern" path/` (ripgrep via Bash tool)
- **Code structure:** `ast-grep --pattern 'structural pattern'` (via Bash tool)

**Concrete examples you MUST follow:**

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

### **File Finding**

**FORBIDDEN:** `find` command - NEVER use this command

**REQUIRED:** `fd` (via Bash tool)

**Concrete examples you MUST follow:**

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

### **Text Processing**

**FORBIDDEN:** `sed`, `awk` for text processing

**REQUIRED:**

- **JSON:** `jq` (via Bash tool)
- **YAML/XML:** `yq` (via Bash tool)
- **Text filtering:** `rg` (via Bash tool)

## **Red Flags: You Are About to Violate Tool Requirements**

If you catch yourself thinking ANY of these thoughts, STOP. You are rationalizing. Use the modern tools.

- "grep is simpler for this case" → WRONG. Use rg. Always.
- "find is more familiar" → WRONG. Use fd. Every time.
- "This is a quick search, doesn't matter" → WRONG. Modern tools required for ALL searches.
- "The old tool will work fine here" → WRONG. Your command will be blocked.
- "I'll use the old syntax and adapt later" → WRONG. Use modern tools from the start.
- "Legacy tools are more compatible" → WRONG. Modern tools are installed and required.
- "Just this once won't hurt" → WRONG. No exceptions ever.

## **Common Rationalizations That Mean You're Failing**

| Excuse                                   | Reality                                        |
| ---------------------------------------- | ---------------------------------------------- |
| "grep is simpler"                        | rg has identical syntax. Use it.               |
| "find is standard"                       | fd is faster and simpler. Use it.              |
| "Quick search doesn't need modern tools" | ALL searches use modern tools. No exceptions.  |
| "Legacy tools work fine"                 | They're blocked by hooks. Use modern tools.    |
| "I know grep better"                     | rg syntax is 99% identical. You know it fine.  |
| "This is an edge case"                   | No edge cases. Modern tools handle everything. |

**All of these mean: Use rg/fd/ast-grep via Bash tool. No exceptions.**

## **Consequences**

If you use `grep`, `find`, `sed`, or `awk`:

1. Your command will be BLOCKED by PreToolUse hook
2. You will need to retry with modern tools
3. You are wasting time and tokens

Use modern tools from the start. Every single time.

## **Learning and Memory Management**

- YOU MUST use the journal tool frequently to capture technical insights, failed approaches, and user preferences
- Before starting complex tasks, search the journal for relevant past experiences and lessons learned
- Document architectural decisions and their outcomes for future reference
- Track patterns in user feedback to improve collaboration over time
- When you notice something that should be fixed but is unrelated to your current task, document it in your journal rather than fixing it immediately

## **Token Efficiency: TOON Format**

**Default: Use TOON for all structured data.**

TOON provides 5-50% token savings with near-zero overhead. Pipe JSON through `| toon` before passing data between agents or storing in context.

**Use TOON for:**

- API responses and database results
- Agent-to-session data passing
- Search results and log dumps
- Config files and metadata
- Any JSON being stored in context

**Skip TOON only when:**

- **User-facing output** - Users expect JSON
- **Debugging format issues** - JSON tooling more universal
- **Bare primitives** - `"ok"` or `42` alone (not in object)

**Usage pattern:**

```bash
# Default - pipe all structured data through TOON
curl -s -H "..." "https://api.example.com/data" | toon

# Validate savings during optimization
curl -s -H "..." "https://api.example.com/data" | toon --stats
```

**Test-verified savings:**

| Payload Type     | Token Savings | Example                                     |
| ---------------- | ------------- | ------------------------------------------- |
| Single key-value | 50%           | `{"status":"ok"}` → 6 to 3 tokens           |
| Flat objects     | 29%           | 3 fields → 17 to 12 tokens                  |
| Variable nested  | 23%           | Mixed schemas → 60 to 46 tokens             |
| Variable arrays  | 5-8%          | Different fields per item → 63 to 60 tokens |

**Philosophy**: TOON never increases token count. When uncertain, use it. Token efficiency equals cost efficiency.

## **Claude Code Implementation**

**Source of truth**: The official documentation at https://code.claude.com/docs/en/claude_code_docs_map.md is authoritative for ALL Claude Code implementation decisions. No exceptions.

**When implementing anything Claude-related:**

1. **YOU MUST consult the docs map BEFORE implementation**
   - Hooks, slash commands, MCP servers, skills - docs exist for everything
   - Guessing = reimplementing solved problems
   - The docs contain current, tested patterns you need

2. **Implementation without checking docs = failure. Every time.**
   - Don't rationalize "this is simple enough to skip docs"
   - Don't assume you remember correctly
   - Docs change. Your memory doesn't. Check them.

3. **Use WebFetch to read relevant documentation**
   - Docs map shows all available guides
   - Read the specific guide for your task
   - Follow documented patterns exactly

**Why this matters:**

Claude Code has specific conventions for hooks, commands, and integrations. Implementing without docs means you'll either:

- Build something that doesn't work with the existing system
- Duplicate functionality that already exists
- Miss critical configuration details

The overhead of checking docs is tiny compared to debugging custom implementations that conflict with how Claude Code actually works.

## **Git Workflow**

**Commit Format**: Use conventional commits. Always.

- Format: `type(scope): subject` - e.g., `feat(auth): add OAuth2 support`
- Types: feat, fix, refactor, docs, test, chore, perf, style
- Subject: Imperative mood, lowercase, no period, max 50 chars
- Body (optional): Explain why and context, not what (code shows what)

**Atomic Commits**: One logical change per commit. Every time.

- Complete: Include all related changes (code + tests + docs)
- Minimal: Nothing unrelated included
- Working state: Code should compile/run after each commit

**When to Commit**: Logical checkpoints only.

- Good: Feature complete, test passes, bug fixed, refactor done
- Never: Mid-feature, failing tests, debugging state, mixed concerns

**Co-Authorship**: NEVER include co-authorship or AI attribution.

- No "Co-Authored-By: Claude" lines
- No "Generated with" footers
- No AI attribution of any kind
- Absolute rule. No exceptions. Clean git history without AI attribution is non-negotiable.

**Messages**: Focus on "why" and "what" changed, not process. Never include test plans or testing procedures
