# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) when working with any git repository.

## Git Workflow Requirements

### Branch Naming Convention

All branches must be prefixed with one of:

- `feature/` - New features or enhancements
- `fix/` - Bug fixes
- `chore/` - Maintenance tasks, refactoring, or non-user-facing changes

Examples:

- `feature/user-authentication`
- `fix/login-validation-error`
- `chore/update-dependencies`

### Commit Message Format

All commits MUST include a `Change-type:` footer with one of:

- `major` - Breaking changes that require major version bump
- `minor` - New features that are backward compatible
- `patch` - Bug fixes and small improvements

Example commit message:

```
Add user authentication system

Implement login/logout functionality with JWT tokens
and session management.

Change-type: minor
```

### Semantic Versioning Guidelines

Follow semantic versioning (semver) principles when determining change types:

**MAJOR version** (`Change-type: major`) when you make incompatible API changes:

- Breaking changes to public APIs
- Removing or renaming public functions/methods
- Changing function signatures
- Removing configuration options
- Changes that require users to modify their code

**MINOR version** (`Change-type: minor`) when you add functionality in a backward compatible manner:

- Adding new features
- Adding new public APIs
- Adding new configuration options
- Deprecating functionality (without removing)
- Performance improvements

**PATCH version** (`Change-type: patch`) when you make backward compatible bug fixes:

- Bug fixes
- Security patches
- Documentation updates
- Internal refactoring without API changes
- Dependency updates (that don't add features)

### Linear History Requirements

- **ALWAYS use `git rebase`** instead of `git merge`
- Maintain a linear commit history
- Before pushing, rebase your branch on the latest main: `git rebase main`
- Use `git rebase -i` to clean up commits before pushing
- Fast-forward merges are preferred when possible

### Common Commands

```bash
# Start new feature
git checkout main
git pull
git checkout -b feature/my-feature

# Before pushing (clean up history)
git rebase -i main
git rebase main
git push --force-with-lease origin feature/my-feature

# Update feature branch with latest main
git checkout main
git pull
git checkout feature/my-feature
git rebase main
```

### Pre-commit Checks

Before creating commits, ensure:

1. Code follows project conventions
2. Tests pass (if applicable)
3. Linting/formatting is applied
4. Commit message includes proper `Change-type:` footer
5. Branch name follows the required prefix convention
6. Change type follows semantic versioning guidelines
