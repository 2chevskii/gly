# Contributing to gly

Thank you for contributing to `gly`.

## Before You Start

- Read the [README](../README.md) and the relevant pages in the [documentation](https://2chevskii.github.io/gly/).
- Search existing [issues](https://github.com/2CHEVSKII/gly/issues) and [discussions](https://github.com/2CHEVSKII/gly/discussions) before opening a new one.
- Report security vulnerabilities through the process in [SECURITY.md](SECURITY.md), not in a public issue.
- Follow the [Code of Conduct](CODE_OF_CONDUCT.md) in all project spaces.

## Issues and Discussions

Use the issue templates for reproducible bugs, documentation corrections, and focused feature requests. Use GitHub Discussions for questions, setup help, and ideas that are still being explored.

Good bug reports include the `gly` version, PowerShell version, operating system, the smallest reproducible example, expected behavior, actual behavior, and relevant non-sensitive output.

## Pull Requests

1. Create a focused branch from `master`.
2. Keep the change scoped and update user or developer documentation when behavior changes.
3. Add or update Pester tests for behavior changes.
4. Run the relevant checks locally:

   ```powershell
   pwsh -NoProfile -Command "Invoke-Pester ./tests"
   npm ci
   npm run docs:build
   ```

5. Open a pull request using the repository template and describe the motivation, implementation, and validation.

The CI workflow runs the test suite on Windows and Ubuntu and builds the documentation. Maintainers may request changes to keep the module's PowerShell 7+ scope, pipeline semantics, and MVP boundaries intact.

## Style and Scope

- Keep user-facing documentation in English.
- Keep PowerShell command, parameter, file, function, and variable names in English.
- Avoid unrelated formatting or generated-file changes.
- Do not add persistent configuration, automatic terminal detection, Git-aware formatting, or Windows PowerShell 5.1 support without a prior project decision.

By contributing, you agree that your contributions are licensed under the repository's [MIT License](../LICENSE).
