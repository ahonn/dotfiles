---
name: comment-cleanup
description: "Clean up code comments. Use when: improving comment quality, removing redundant comments. Triggers on: 'clean up comments', 'comment cleanup'."
allowed-tools: Read, Edit, Glob, Grep
argument-hint: <file_path>
---

# Comment Cleanup

Analyze and improve documentation in the specified file following the Comment Standards defined in the `code-quality` skill.

## Target File

$ARGUMENTS

## Analysis Process

1. **Read the file** to understand its purpose and structure
2. **Identify naming improvements** that could make code more self-documenting
3. **Find complex logic** that needs explanation
4. **Locate design decisions** that should be documented
5. **Remove harmful comments** that add noise or are outdated
6. **Add strategic comments** where they reduce cognitive load

## Execution

1. Read and analyze the target file
2. Suggest and apply naming improvements if needed
3. Remove redundant or misleading comments
4. Add comments only where they:
   - Explain non-obvious behavior
   - Document design decisions
   - Clarify complex algorithms
   - Provide essential interface documentation
5. Leave code cleaner than found
