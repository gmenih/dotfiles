# Work ethics

We are a team. The purpose is that we work optimally together. This is our working environment, and we can both contribute to improving it. This is considered our IDE:

- Ghostty terminal on MacOS
- Herdr is our workspace, tabs, panes and windows manager (tmux alternative)
- We use zsh (ohmyzsh + spaceship prompt)
- We have a `~/.zshrc.d` directory, where we define all of our terminal aliases, helpers, etc
- `~/.bin` has some of our scripts, and we install any binaries there that are user specific
- We use `chezmoi` to manage our workspace (source lives in `~/.local/share/chezmoi`; the repo is PUBLIC - work-specific files go in via `chezmoi add --encrypt`)
- Neovim to edit files
- We usually run our DB commands in DBeaver or Metabase

## mn

Mn (short for monastery) is our working tool - the thing we run work *through*, not just something we talk about. It manages projects (git repos) and the tasks inside them: one worktree + branch + herdr window per task, with a claude session already open in it. Nothing is written into the repos themselves; state lives in `~/.local/share/mn`.

Reach for it instead of juggling branches by hand: `mn <task>` creates or rejoins a task, `mn ticket PA-123` starts one from a Jira ticket, `mn ls -a` lists every task across every repo, `mn rm <task>` tears one down.

Mn is ours to improve - it lives in `~/Projects/monastery`, config in `~/.config/mn/`. If either of us sees a feature missing, propose it and build it. If mn is limiting, drop to `herdr` commands and shape the environment directly.

Both `mn` and `herdr` evolve quickly - run `mn --help` or `herdr --help` for the current commands instead of trusting any cached dump of their output.

# Directory is context

Where we are standing tells us what job we are doing. Check the cwd before deciding how to act.

**In a task worktree** - any path under a `*.trees/` directory (mn's default layout: task `feat/x` of `pump-api` lands in `~/Work/Pump/pump-api.trees/feat/x`). We are one task on one branch, and the task name is the scope. Work here goes deep and narrow: implement, verify, commit on the task branch. Unrelated repo-wide cleanup we notice along the way gets mentioned, not done.

**In a repo root** - the main checkout (`~/Work/Pump/pump-api`, `~/Projects/monastery`). The branch here is shared, so this is for work that does not want a branch of its own: answering questions about the codebase, reading history, gathering data, running one-off scripts, the occasional hotfix. The moment it turns into a feature, it belongs in a task - `mn <name>` and move there.

**Anywhere else** - home, `~/Work/Pump`, a scratch dir: we are the orchestrator. A task handed to us here is not ours to type out, it is ours to route - create the worktrees, give each one its brief, check on them, and pull the results back together when they report.

Orchestrating includes tidying up after ourselves. Finished and abandoned tasks leave worktrees, branches and herdr tabs lying around; clearing them is part of the job, not an interruption to it.

# Where work happens

- Day job is Pump - everything lives in `~/Work/Pump`. The main project is `pump-api` (NestJS + Prisma + GraphQL); each project there has its own CLAUDE.md with the project rules.
- Personal projects live in `~/Projects` - notably `monastery` (mn), `fintra`, and `dotfiles` (the chezmoi source).

# Package managers

Projects use different package managers (npm, pnpm, yarn). NEVER assume - check the lockfile (`pnpm-lock.yaml` / `yarn.lock` / `package-lock.json`) or the `packageManager` field in package.json before running any install or script command.

# Commits

- Format: `type(scope): subject` - conventional commits. Types: feat, fix, docs, refactor, test, chore, build. Scope optional.
- Subject: imperative mood, lowercase, no trailing period, max 72 chars. Never vague subjects like "updates", "changes", "wip".
- Add a body only when the why is not obvious from the diff.
- Claude may commit WITHOUT asking only in the dotfiles repo (`~/.local/share/chezmoi`) and in `~/Projects/monastery` (stewardship delegated 2026-07-30 - "take mn over"). In every other repo: never commit unless explicitly asked, every time. Pushing always requires a yes.
- Exception: an agent running `/jira-implement` inside an mn task worktree commits on that task branch as part of the job - never on main or staging, and pushing/PRs still require a yes.
- NEVER add a Co-Authored-By line or any other Claude attribution to commit messages.

# Code style

- ALWAYS put double quotes around columns and table names in SQL queries, even if they are not reserved words or contain special characters
- Prefer descriptive code over comments
- Prefer interfaces to types unless working with complex generics
- Never use the `async` keyword on methods or functions, unless something needs to be `await`-ed inside the function

# How to handle: Questions

When I ask a question, I EXPECT AN ANSWER! Always answer my questions first, unless otherwise requested. When I ask a question it is not about pointing out problems with solutions, it's to get actual answers. Don't immediately start changing code when I simply ask a question.

# Writing rules

- NEVER use em-dash (`—`), always use normal dash (`-`)

# Tool rules

`rg` instead of `grep`, `fd` instead of `find`. Both are denied in Bash, and the
`~/.bin/claude-bash-guard` PreToolUse hook answers with the rewrite. Translate the
flags, never carry them across verbatim:

    grep -rn pat .            ->  rg -n pat        # rg recurses by DEFAULT
    grep -r --include='*.ts'  ->  rg -g '*.ts'     # or: rg -t ts
    cmd | grep pat            ->  cmd | rg pat
    find . -name '*.ts'       ->  fd -e ts         # or: fd -g '*.ts'
    find . -type d            ->  fd -t d
    find . -maxdepth 2        ->  fd -d 2
    find . -exec CMD {} \;    ->  fd -x CMD        # {} + is fd -X

- `rg -r` is `--replace`, NOT recursive. It swallows the next token and prints
  silently-wrong output instead of erroring. There is no `-R` at all.
- `fd`'s positional pattern is a REGEX, not a glob - `-g` for glob, `-e` for extension.
- Both skip `.gitignore`d and hidden files by default: `rg -uu`, `fd -HI` to see everything.
- `-i -n -l -w -v -F -A -B -C` mean the same in `rg` as in `grep`.
- Prefer the built-in `Grep`/`Glob` tools over shelling out at all - `Grep` *is* ripgrep.
- If a raw `grep`/`find` is genuinely needed, append `# noguard` to the command.
