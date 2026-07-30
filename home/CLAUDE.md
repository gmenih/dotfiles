# Work ethics

We are a team. The purpose is that we work optimally together. This is our working environment, and we can both contribute to improving it. This is considered our IDE:

- Ghostty terminal on MacOS
- Herdr is our workspace, tabs, panes and windows manager (tmux alternative)
- We use zsh (ohmyzsh + spaceship prompt)
- We have a `~/.zshrc.d` directory, where we define all of our terminal aliases, helpers, etc
- `~/.bin` has some of our scripts, and we install any binaries there that are user specific
- We use `chezmoi` to manage our workspace (source lives in `~/.local/share/chezmoi/home`)
- Neovim to edit files
- We usually run our DB commands in DBeaver or Metabase

## mn

Mn (short for monastery) is our custom-built tool that we can both interact with across our environment. It manages workspaces: projects (git repos) and the monks (claude subprocesses) that work on tasks within them - one worktree + branch + window per task. We should both work towards improving this tool - if we see a feature missing, we can both suggest an implementation of it, and we can try to implement that. If we feel that mn is limiting, we can try to reach for `herdr` commands, to interact with our working environment.

Mn is in `~/Projects/monastery`, where we can build improvements. Its config lives in `~/.config/mn/`.

Both `mn` and `herdr` evolve quickly - run `mn --help` or `herdr --help` for the current commands instead of trusting any cached dump of their output.

# Where work happens

- Day job is Pump - everything lives in `~/Work/Pump`. The main project is `pump-api` (NestJS + Prisma + GraphQL); each project there has its own CLAUDE.md with the project rules.
- Personal projects live in `~/Projects` - notably `monastery` (mn), `fintra`, and `dotfiles` (the chezmoi source).

# Package managers

Projects use different package managers (npm, pnpm, yarn). NEVER assume - check the lockfile (`pnpm-lock.yaml` / `yarn.lock` / `package-lock.json`) or the `packageManager` field in package.json before running any install or script command.

# Commits

- Format: `type(scope): subject` - conventional commits. Types: feat, fix, docs, refactor, test, chore, build. Scope optional.
- Subject: imperative mood, lowercase, no trailing period, max 72 chars. Never vague subjects like "updates", "changes", "wip".
- Add a body only when the why is not obvious from the diff.
- Claude may commit WITHOUT asking only in the dotfiles repo (`~/.local/share/chezmoi`). In every other repo: never commit unless explicitly asked, every time.
- Exception: an agent running `/jira-implement` inside an mn task worktree commits on that task branch as part of the job - never on main or staging, and pushing/PRs still require a yes.

# Writing rules

- NEVER use em-dash (`—`), always use normal dash (`-`)

# Tool rules

- Always use `rg` instead of `grep`. Never call `grep` in Bash.
- `rg` uses different flags than `grep` - namely, `-r` in `rg` is "replace", not "regex"
- Always use `fd` instead of `find`. Never call `find` in Bash.
