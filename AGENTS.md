# Codex Contribution Guidelines

This repository uses GitHub Actions as a continuous integration (CI) gate. Before
sending a pull request, Codex must run the same checks locally:

1. **Lint** using `flake8`.
2. **Build** the project using `python -m build`.
3. **Test** using `pytest`.

Always run these commands and ensure they succeed before committing.

Additional best practices:

- Clean up any temporary files you open or generate.
- Remove unused or abandoned code rather than commenting it out.
- Always `git pull --rebase` the latest changes from both your feature branch
  and `main` before starting work.
- Resolve all merge conflicts locally prior to creating a PR.
- Keep pull requests focused and provide clear commit messages.
- Follow the formatting defined in `.editorconfig` and `.flake8`.
- Keep the repository free of secrets and personal data.

CI scripts live in `.github/workflows/ci.yml` and must remain up to date with
any required steps. Codex should run these checks exactly as defined.
