# Claude Assistant Instructions

## Project State Management

**TODO.md is the source of truth** for determining the current state of the project and what tasks need to be completed. Always check TODO.md first when:

- Understanding what has been completed
- Determining next steps
- Planning new features or fixes
- Assessing project progress

## Git Commit Guidelines

When writing commit messages to GitHub:

- **Never mention Claude or AI assistance** in commit messages
- Write commit messages as if they were written by a human developer
- Focus on the technical changes and business value
- Use conventional commit format when applicable

### Examples:

❌ **Don't do this:**
```
Add user authentication with Claude's help
Fix bug identified by AI assistant
```

✅ **Do this instead:**
```
Add user authentication with JWT tokens
Fix null pointer exception in checkout flow
```

## Development Workflow

1. Check TODO.md for current project state
2. Update TODO.md as work progresses
3. Write human-style commit messages
4. Keep documentation updated alongside code changes