---
name: standup
description: Reconstruct what I actually did over a date window by reading git history and Claude session transcripts across every repo, then report it as standup notes. Use when I invoke `/standup [window]`, ask what I did yesterday / in the last few days / since Friday, or need something to read out on the daily call.
---

# Standup

Rebuild a day's (or a few days') work from two sources of truth and turn it into notes I can read out loud on a call.

- **git** — what actually landed: commits, merges, tags/releases, PRs, uncommitted work sitting in worktrees.
- **Claude session transcripts** — what I was *thinking about*: investigations, decisions, dead ends, and work that never produced a commit.

Neither alone is enough. Git misses the half-day spent chasing a Stripe misconfiguration; sessions miss what shipped from a branch I never opened Claude in.

## Input

`/standup [window]`

| Window | Meaning |
| --- | --- |
| *(none)* | 2 days back. **On a Monday, back to Friday 00:00** so the weekend doesn't swallow Friday. |
| `3d`, `5d` | N days back, from 00:00 |
| `today`, `yesterday` | that day only |
| `week` | back to Monday 00:00 |
| `2026-08-20` | from that date until now |
| `2026-08-20..2026-08-22` | explicit range, end date inclusive |

## Process

### 1. Collect

```sh
~/.claude/skills/standup/scripts/collect.sh [window]
```

Roughly 7s and ~6k tokens of digest. It scans git repos up to 3 levels under **`~/Work`** (override with `STANDUP_ROOTS` / `STANDUP_REPO_DEPTH`), plus every `~/.claude/projects/*/**.jsonl` transcript with activity in the window. Personal repos under `~/Projects` are deliberately out of scope - this is for the day job.

Run it **once**. Do not re-run with a wider window "just in case" - ask me first if the window looks wrong.

### 2. Read the digest

Three sections:

- `# WINDOW` — the resolved range, and today's weekday. Sanity-check it matches what I asked for.
- `# GIT` — only repos with real activity in the window. Per repo: commits authored by me whose **commit date** falls inside the window (merges flagged `MERGE`), `uncommitted @ <path> [branch]` blocks for the main checkout **and every mn worktree**, and `PR #N [STATE]` lines.

  Three filters keep this honest, and they are worth trusting rather than second-guessing:
  - A repo appears only if it has in-window commits, or dirty files in a tree where a session actually ran. A repo carrying month-old scratch files is silently skipped.
  - Commits are windowed on commit date, so a rebased-forward old branch does not masquerade as today's work.
  - PRs listed are ones I **opened or merged** inside the window - not ones that merely collected a comment. A merged PR carries its merge date: `[MERGED 08-24]`.
- `# CLAUDE SESSIONS` — per session: cwd, git branch, the AI-generated session title, time span, prompt count, then my prompts one-per-line (multi-line prompts folded with ` / `, pasted logs and stack traces stripped).

Reading rules:

- Sessions tagged **`[automation]`** are scripted, not me working - release-note generation, staging-bot conflict resolution, a previous `/standup`. Collapse them to at most one line in the report ("staging-bot resolved N merges cleanly") or drop them.
- A session's **title and first prompt** carry the intent; the trailing prompts (`commit`, `do it`, `continue`) carry nothing. Weight accordingly.
- **Frustration is signal, not content.** If I was swearing at you, the interesting fact is that the bug was a regression on something already shipped - report the bug, never the tone.
- A long session with no matching commit is still work: an investigation, a decision, a spec. It belongs under investigations.
- Cross-reference: a commit and a session on the same branch are **one item**, not two.

If something in the digest is genuinely ambiguous and matters, read that one transcript with `jq` before guessing. Do not read transcripts wholesale - that is what the digest is for.

### 3. Report

Group by **theme**, never by repo or by tool. One project's work usually spans pump-api, the monorepo and a script.

```
## Shipped
## In flight
## Ops / investigations
```

- **Shipped** — merged to main, tagged, deployed. Lead with the version and release title if there is one, then what it actually does in user terms. Cite PR numbers and ticket keys (`PA-####`) where the digest has them.
- **In flight** — branches with commits but no merge, and open PRs. Say what state each is in, not just its name.
- **Ops / investigations** — data repairs, one-shot scripts that were run, prod questions answered, config changes, things learned. This section is usually the one I'd otherwise forget on the call.

Rules for the write-up:

- **Bold the subject** of each bullet so it scans in a terminal at speed.
- One line per item. If it needs two, it is two items.
- Order each section by significance, not chronology. What the team cares about first.
- Say what a thing *does*, not what the commit message said. "Catch-up workouts no longer spend the current day" beats "fix(workout): stop a catch-up workout spending the current day".
- **Call out uncommitted work explicitly** at the end - it is the stuff most likely to be forgotten, and it tells me what to pick up next.
- Close with a one-line status note: whether anything shipped today, and what is waiting on someone else.
- Never invent a ticket key, PR number, or outcome. If the digest does not say whether something merged, say it is open.
- Do not mention Claude, sessions, or transcripts in the output. It is my work; the sources are plumbing.

Keep the whole thing readable in about 60 seconds. If the window covers several days of heavy work, tighten rather than spill into a fourth section.

### 4. Offer follow-ups

After the report, offer in one line: a tighter version for Slack, a wider window, or a drill-down into one item.
