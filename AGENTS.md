# AGENTS.md

Instructions for agents working in the `gly` repository.

## Required context

Before changing code or documentation, read the current user and developer documentation:

1. `README.md`
2. `docs/index.md`
3. `docs/architecture/index.md`
4. `docs/development/index.md`
5. `docs/limitations/index.md`

Before creating an issue, pull request, or other public contribution, also read:

1. `.github/CONTRIBUTING.md`
2. `.github/CODE_OF_CONDUCT.md`
3. `.github/SECURITY.md` when the work could involve a vulnerability or sensitive information
4. `.github/PULL_REQUEST_TEMPLATE.md` before preparing a pull request

## Language

- Project user documentation is written in English.
- PowerShell command, parameter, file, function, and variable names remain in English.
- Add code comments only for non-obvious decisions and edge cases.

## Commands

Shell commands in this environment use the `rtk` prefix.

Examples:

```powershell
rtk npm run docs:build
rtk pwsh -NoProfile -Command "Invoke-Pester ./tests"
rtk git status --short
```

If `pwsh` is unavailable, report that fact and do not replace the target PowerShell 7+ compatibility with Windows PowerShell `5.1`: the MVP targets PowerShell `7+`.

## MVP boundaries

Do not add the following without a separate decision:

- Windows PowerShell `5.1` support;
- persistent user configuration on disk;
- automatic fallback between glyph sets;
- automatic Nerd Font detection;
- automatic dark/light terminal theme detection;
- Git-aware formatting;
- executable-file highlighting;
- a complex theme import system for `.json`, `.yaml`, `.psd1`, or `.ps1` files.

## Architectural rules

- Standard `FileInfo` / `DirectoryInfo` formatting is implemented through `*.format.ps1xml`.
- Tree/grid/compact/long/human-readable views are separate renderer commands.
- Built-in themes and glyph sets are immutable; users may copy and register them under a new name.
- MVP configuration is stored only in memory for the current PowerShell session.
- The module must not modify input `FileInfo` / `DirectoryInfo` objects.
- The module must not change sort order, provider behavior, or the semantics of `Get-ChildItem` / `Get-Item`.

## Working with changes

- Make minimal, verifiable changes.
- Do not restructure the project without a reason.
- Do not remove or regenerate branding assets without an explicit task.
- Keep contributions focused and avoid unrelated formatting or generated-file changes.
- Update user or developer documentation when behavior changes, and add or update Pester tests for behavior changes.
- Before the final response, run the relevant check from `docs/development/index.md`, or explain why it was not run.

## Contribution workflow

- Create focused pull-request branches from `master`.
- Use the repository's issue forms for reproducible bugs, documentation corrections, and focused feature requests. Use GitHub Discussions for questions, support, and early-stage ideas.
- Never report, discuss, or disclose security vulnerabilities or sensitive information in a public issue or pull request. Follow `.github/SECURITY.md` instead.
- Follow the Code of Conduct in all project spaces.
- When opening a pull request, use `.github/PULL_REQUEST_TEMPLATE.md` without removing its sections or checklist. Complete the Summary and Validation sections with the motivation, implementation, and checks actually run; mark a checklist item only when it is true.
- Apply labels that accurately describe the pull request, and assign it to the person responsible for the agent's actions.
- When an agent opens a pull request for a person who is not a repository maintainer, request a review from a repository maintainer.

## Branch names

Use a short, descriptive branch name with one of these prefixes only:

- `feature/`
- `fix/`
- `hotfix/`
- `chore/`
- `docs/`
- `refactor/`
- `test/`
- `ci/`
