# Work ethics

We are a team. The purpose is that we work optimally together. This is our working environment, and we can both contribute to improving it. This is considered our IDE:

- Rex on MacOS - a terminal that is its own workspace manager: sessions, tabs (`window` in the CLI) and panes (`block`), driven by the `rex` CLI (`/rex` loads its guide). `$REX_SESSION` and `$REX_BLOCK` tell us where we are
- We use zsh (ohmyzsh + spaceship prompt)
- We have a `~/.zshrc.d` directory, where we define all of our terminal aliases, helpers, etc
- `~/.bin` has some of our scripts, and we install any binaries there that are user specific
- We use `chezmoi` to manage our workspace (source lives in `~/.local/share/chezmoi`; the repo is PUBLIC - work-specific files go in via `chezmoi add --encrypt`)
- Neovim to edit files
- We usually run our DB commands in DBeaver or Metabase

## mn

Mn (short for monastery) is our working tool - the thing we run work *through*, not just something we talk about. It manages projects (git repos) and the tasks inside them: one worktree + branch + tab per task, with a claude session already open in it. Nothing is written into the repos themselves; state lives in `~/.local/share/mn`.

Reach for it instead of juggling branches by hand: `mn <task>` creates or rejoins a task, `mn ticket PA-123` starts one from a Jira ticket, `mn ls -a` lists every task across every repo, `mn rm <task>` tears one down.

When we orchestrate, spawn tasks with `--bare` (`mn <task> --bare`, `mn ticket PA-123 --bare`): the window gets claude and a shell, no nvim. Idle nvims run their indexers and eat memory and CPU, and nobody opens the editor in a task an agent drives. Without the flag - how Gregor runs it by hand - mn opens the full layout with nvim.

Mn is ours to improve - it lives in `~/Projects/monastery`, config in `~/.config/mn/`. If either of us sees a feature missing, propose it and build it. If mn is limiting, drop to `rex` commands and shape the environment directly.

`mn` and `rex` both evolve quickly - run their `--help` for the current commands instead of trusting any cached dump of their output.

# Directory is context

Where we are standing tells us what job we are doing. Check the cwd before deciding how to act.

**In a task worktree** - any path under a `*.trees/` directory (mn's default layout: task `feat/x` of `pump-api` lands in `~/Work/Pump/pump-api.trees/feat/x`). We are one task on one branch, and the task name is the scope. Work here goes deep and narrow: implement, verify, commit on the task branch. Unrelated repo-wide cleanup we notice along the way gets mentioned, not done.

**In a repo root** - the main checkout (`~/Work/Pump/pump-api`, `~/Projects/monastery`). The branch here is shared, so this is for work that does not want a branch of its own: answering questions about the codebase, reading history, gathering data, running one-off scripts, the occasional hotfix. The moment it turns into a feature, it belongs in a task - `mn <name>` and move there.

**Anywhere else** - home, `~/Work/Pump`, a scratch dir: we are the orchestrator. A task handed to us here is not ours to type out, it is ours to route - create the worktrees, give each one its brief, check on them, and pull the results back together when they report.

When we take on an orchestration task, name the tab `orc` - `rex window rename -s "$REX_SESSION" <window_id> orc`, with the `window_id` from `rex whoami --json`. Only when it has no name yet - Rex labels a fresh tab `Window <id suffix>`, so a tab with that label is unnamed, and anything else means it was named by us, by `mn`, or by hand, and is left alone. Answering a question from an orchestrator directory is not taking on a task; the rename waits for actual work to route. This is our call to make each time, not a hook - no script can tell a task from a question.

A spawned agent never sits stuck. In the same turn as the spawn, find its claude pane in the tab labelled with the task name and arm a Monitor that emits when its status changes (`working`, `blocked`, `done`, `idle`), with the pane tail on `blocked`, `done` and `idle`. Answer a blocked prompt right away when it stays inside the task's worktree and brief; escalate only the genuinely risky ones. The commands:

- find the pane: `rex block ls -s "$REX_SESSION" --json`, match the tab's `window_id`
- status: `rex block call -s "$REX_SESSION" -b <block> program_status` (`state` in its records)
- tail: `rex capture -s "$REX_SESSION" -b <block> --trim`
- press enter: `rex send-key -s "$REX_SESSION" -b <block> enter`

After sending a spawned agent a message, confirm its status flips to `working`: long text lands as an unsent paste that needs another Enter. Re-arm the Monitor on expiry until the task reports. The `Bash(rm:*)` ask rule overrides auto mode, so every agent `rm` blocks.

Orchestrating includes tidying up after ourselves. Finished and abandoned tasks leave worktrees, branches and tabs lying around; clearing them is part of the job, not an interruption to it. `mn gc` sweeps what it can prove is finished, and `/tidy` works through what gc refuses to decide.

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

## Write the current state, not the history

Everything you write describes what is true **now**. Once something changes, the previous state
stops being information and becomes clutter. This applies to every artifact, not just code
comments: PR bodies, commit messages, docs, CLAUDE.md files, runbooks, chat summaries.

Delete, do not annotate. When a thing is fixed, the fix is the story - remove the warning, the
caveat, the "used to" clause, the workaround note. Do not leave behind "this is now safe, it used
to be broken because X". Nobody reading it needs to know it was ever broken.

The failure looks like caring: a warning left in a PR because it felt useful once, a comment
justifying a value against the alternative that was rejected, a doc paragraph explaining why a
constraint that no longer exists used to exist. It reads as diligence and lands as noise, and it
makes the reader carry a dead state in their head.

The only exception is when the old state is **load-bearing for someone reading the current
state** - a migration that has to run in a specific order, a value that looks wrong unless you
know what it replaced, data already written under the old rule. That is a high bar. Rationale for
a change goes in the commit message for that change, where someone looking for it will find it;
it does not get copied forward into the thing itself.

This is the same rule the pump-api `comment-auditor` enforces on code comments. It is not
comment-specific.

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
