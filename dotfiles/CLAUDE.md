# CLAUDE.md

This file provides global guidance to Claude Code (claude.ai/code) when working with any git repository.

## 🚨 Critical Principles (Non-Negotiable)

### Technical Integrity

- **Be direct and concise** in responses but also in generated text. Do not over hype changes or make unsubtantiaged claims. Do not use too many words. Respond to questions directly and without unnecessary praise. Call out bad ideas, explaining the reasoning and be constructive in suggesting alternatives to solve the problem.

### Core Engineering Practices

- **Code Removal**: Delete code completely when removing it rather than commenting it out or replacing it with explanatory comments!
- **Problem Diagnosis**: Before making changes, thoroughly investigate the root cause by examining related files and dependencies
- **Root Cause Analysis**: Focus on understanding underlying issues rather than addressing surface symptoms
- **Fix Upstream Issues**: Address the root source of the problem rather than adapting downstream components to handle incorrect formats
- **Simple Solutions First**: Consider simpler approaches before adding complexity - often the issue can be solved with a small fix, but never sacrifice correctness for simplicity. Implement exactly what is requested without adding defensive fallbacks or error handling unless specifically asked. Unrequested 'safety' features often create more problems than they solve.

## Architectural principles

### Tool Architecture

- **Single Responsibility**: Design tools with focused functionality. Extraction tools should extract, persistence tools should store - separating concerns improves flexibility and reuse.
- **Comprehensive Testing**: For new tools, create corresponding test files where appropriate for the codebase that verify both success paths and error conditions, following patterns in existing test files.

### Interface Design

- **Interface Correctness**: Ensure interfaces are used as designed. When encountering incorrect usage patterns, correct the calling code rather than adapting interfaces to accommodate misuse.
- **Tool Interface Consistency**: Ensure all tool implementations follow the same patterns for input/output handling and error management
- **Keep it simple** do not add unnecesasary complexity to interfaces. Do not make an interface public unless it is a user facing feature. There should NOT be multiple ways to do the same operation when designing interfaces.
- **Response Formatting**: Adhere to established response structures and formatting conventions when modifying or adding outputs
- **Type Enforcement**: Honor type annotations as contracts. If a parameter is defined as a specific type (e.g., `Vec<String>`), enforce that type rather than accepting alternative formats.

### Dependency Management

- **Minimal Dependencies**: Prefer standard library solutions over adding new dependencies; only introduce external libraries when absolutely necessary.
- **Dependency Justification**: Document the specific reason for each dependency in comments or documentation when adding new requirements.

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

Use `--no-gpg-sign` when creating, amending or rebasing commits to avoid signature issues. I can sign them later.

### Pre-commit Checks

Before creating commits, ensure:

1. Code follows project conventions
2. Tests pass (if applicable)
3. Linting/formatting is applied
4. Commit message includes proper `Change-type:` footer
5. Branch name follows the required prefix convention
6. Change type follows semantic versioning guidelines
