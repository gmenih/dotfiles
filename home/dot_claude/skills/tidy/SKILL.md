---
name: tidy
description: Clear out finished and abandoned work - stale mn tasks with their worktrees and branches, and herdr tabs stranded by torn-down tasks. Runs `mn gc` for the provable half, then works through what gc deliberately refuses to decide. Use when orchestrating and the workspace has grown cluttered, when `mn ls` has gotten long, or when I invoke `/tidy`.
---

# Tidy

`mn gc` already does the mechanical half. This skill is the judgment half: the entries gc prints under **NEEDS A CALL** and will not touch on its own.

Do not reimplement what gc does. Run it, read it, then reason about the remainder.

## Flow

1. **Get the plan.** `mn gc --dry-run -a --fetch`.

   `--fetch` is not optional here. gc judges "merged" from the refs on disk, so without a fetch, work that landed upstream days ago still reads as in flight and the whole sweep under-reports.

2. **Let gc sweep its own set.** `mn gc -a --fetch`, confirm at the prompt. It removes only what it proved: branches that landed in their base with clean worktrees, and tabs whose panes all sit in worktree directories that no longer exist.

3. **Work the NEEDS A CALL list**, one entry at a time, cheapest check first. The table below says what each verdict usually means.

4. **Propose, never act unilaterally.** Group the findings into one list of suggested removals with a reason each, and ask once. Anything that would discard committed or uncommitted work needs an explicit yes for that specific task, not a blanket one.

5. **Report** what was swept, what was left, and what still wants a decision.

## The cases gc hands over

| gc says | What it usually means | How to settle it |
| --- | --- | --- |
| `merged into <base>, but has uncommitted changes` | The work landed; the worktree still holds scratch files, a debug log, a half-idea | `mn diff <task>` and read it. Junk means the task is safe to remove; anything real gets rescued to a branch first |
| `never started: no commits, no changes` | A task opened and abandoned, or one whose work happened somewhere else | Safe to remove once confirmed. Check `mn todo` first: an open todo means it was planned, not forgotten |
| `worktree is gone, branch <b> remains` | Someone deleted the directory by hand | The branch is the only thing left. Merged or empty means remove; unmerged commits mean leave it and say so |
| `a worktree mn doesn't track` | A worktree made by hand or before mn | `mn <branch>` adopts it into a task, or remove it with plain git. Never silently delete |
| **nothing, but `mn ls` looks stale** | Almost always a **squash merge** | See below |

## The squash-merge blind spot

gc proves a merge by reachability: is the branch tip an ancestor of its base. A squash merge rewrites the commits, so the tip is never reachable and gc reads the task as unmerged forever. That is deliberate, and it is where most long-lived clutter hides.

Settle it from the forge, not from git:

```
gh pr list --head <branch> --state merged --json number,title,mergedAt
```

A merged PR for that branch means the work landed and the task is finished, whatever the graph says. Confirm, then `mn rm --force <task>` (force because git cannot see the merge either).

No PR and no commits ahead of base means it was abandoned. No PR but real commits means live work - leave it alone.

## Rules

- Never `mn rm --force` without an explicit yes for that task. Force discards uncommitted changes and deletes unmerged branches; it is the one gesture here that can lose work.
- Never touch a task that is in flight. gc does not list those for a reason, and "it looks quiet" is not evidence.
- Uncommitted changes worth keeping get committed on the task branch before anything is removed, never stashed. The stash is shared across every worktree.
- Closing a tab is cheap and reversible; deleting a branch is not. When unsure, close the tab and leave the branch.
