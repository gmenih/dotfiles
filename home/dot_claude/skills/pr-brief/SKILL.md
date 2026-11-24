---
name: pr-brief
description: Prepare a pull request for review. Decides whether the PR description alone lets a reviewer understand the change; when it does not (architecture changes, moved modules, dependency graph or schema changes, large or cross-domain diffs), builds a review brief artifact - change outline, size, diagrams, anticipated reviewer questions with answers, files to read closely, and a checklist of at most 7 items - and links it from the PR body. Use every time a PR is opened, after pushing substantial new commits to an open PR, or when I invoke `/pr-brief [PR number]`.
---

# PR brief

A reviewer opening the PR should be able to understand the change without reconstructing it from
the diff. This skill makes sure that is true: either the description already carries it, or a
review brief artifact does. The brief is the main review surface, so it has to answer the
reviewer's questions before they are asked, and point at the few places that need real attention.

## 1. Gather the facts

Run from the PR branch checkout:

```bash
python3 ~/.claude/skills/pr-brief/scripts/pr-facts.py [--pr <number>] [--base <ref>]
```

It prints size per area, the file list with moves, cross-area import edges added and removed,
migrations and schema files, API surface, jobs, dependency changes, "reviewer magnets" (raw SQL,
type escapes, suppressions, forwardRef, TODOs, new env reads, transactions, swallowed errors) on
added lines, source files with no matching test change, and **artifact triggers**. Add `--json`
for the structured version (it has GitHub `diff_url`s per file when a PR exists).

Also read: the PR title and body (`gh pr view --json title,body,url,number`), the ticket if the
body links one, and the repo's CLAUDE.md, so convention deviations are visible.

## 2. Decide: description or brief

Build the brief when **any** of these hold:

- files moved between directories, or a module/package added, removed or split
- cross-area imports changed between domains (edges into `common/*` alone do not count)
- schema or migration change
- dependency added, removed or major-bumped
- raw SQL added
- 3 or more domain areas touched (not counting `common/*`, docs, root config)
- more than ~600 non-test, non-generated lines or ~15 source files
- a flow, state machine, queue topology or transaction boundary changed

Otherwise run the **description test**. Reading only the PR body, could a reviewer:

1. say what behaviour changes, for whom?
2. predict every group of changed files and why it changed?
3. know what has to happen at or after deploy?
4. open the diff and find nothing that surprises them?

All yes: description-only. Any no that a few more lines of body can fix: fix the body and stay
description-only. Otherwise: brief.

State the decision and the reason in one line to the user before continuing.

## 3. Anticipate the reviewer (both paths)

This step runs whether or not a brief gets built.

**Cold read.** The author is the worst narrator of their own diff. Spawn a reader that is never
told the intent: use the repo's `cold-reader` agent if it exists, otherwise a general-purpose
agent. Give it only the diff command (`git diff <base>...HEAD`) and this brief: "Read this diff
with no context. List every choice a careful reviewer would question - surprising approaches,
values without visible justification, deviations from patterns elsewhere in the repo, missing
cases, behaviour that is hard to predict. For each: file:line and the question as a reviewer
would phrase it." Never pass the ticket, title or branch name.

**Merge in** the script's reviewer magnets and anything that breaks a rule in the repo's
CLAUDE.md / architecture docs. Typical questions to have ready:

- Why raw SQL instead of the ORM? (the query it would take otherwise, the plan or row counts)
- Why this shape instead of the obvious one? (the constraint that ruled it out)
- What happens on retry, on concurrent calls, on partial failure, on the empty case?
- What does this cost on production data? (row counts, index used, lock taken)
- Is this backwards compatible for clients already in the field?
- Why is this not tested? Why is this cast/suppression safe?

**Answer each one with evidence** - a file:line, a test, a benchmark, a doc or ADR, a query
result. If there is no good answer, it is not a question to pre-empt, it is a defect: stop and
tell the user before publishing anything. Never invent a justification. Questions that genuinely
need the reviewer's judgement go in as **open**, saying what is unknown and what would settle it.

Keep the questions a reviewer would actually ask. Ten generic ones bury the two real ones.

## 4a. Description-only path

Append to the PR body (replace the section if it exists):

```markdown
## Reviewer notes
**Read closely:** `path/file.ts` - why (max 3 files)
**Q:** question? **A:** answer, with evidence link. (max 3)
```

Then go to step 5's PR-body edit and report.

## 4b. Build the brief

Run `Artifact` `action: "quickstart"` with `intent: "other"` first (the Artifact tool requires
it for a new page), then build the page from `~/.claude/skills/pr-brief/template.html`. Copy it
to the session scratchpad as `pr-brief/<repo>-<pr-number>.html` and fill it. Every `{{...}}` gets
replaced; sections that do not apply are deleted, never left with filler.

### Sections and their rules

- **Header + TL;DR** - 2-4 sentences: what changes for whom, and the one decision that shaped
  the implementation. Risk pill:
  - `high` - writes to production data, migrations on large tables, money, auth, or side effects
    no deploy can take back (emails sent, fields pushed to a third party)
  - `medium` - changes behaviour behind an existing API or job
  - `low` - additive or internal
- **Review checklist** - **never more than 7 items.** Each is a concrete thing to verify, points
  at a file and line, and is ordered by risk. Nothing that CI, lint or tests already check, nothing
  generic ("code is readable"). If you have more than 7, the PR is probably too big - say so to
  the user.
- **At a glance** - numbers straight from the facts script; one bar per area, widths as a
  percentage of the largest area.
- **What changed** - files grouped by *intent* ("dedup on Redis", "REST surface",
  "schema"), not by directory. Every reviewable file lands in exactly one group. Generated and
  lock files are named once in "Safe to skim", not listed.
- **Behaviour in examples** - every rule, threshold, eligibility or calculation change as a
  table of concrete inputs with real numbers, before vs after. "Sums paid invoices" is skimmable;
  "a member on $59/year qualifies in year two" is not.
- **Diagrams** - see below. Only diagrams that carry information.
- **Reading order** - the path through the diff that builds understanding fastest: usually
  schema/types, then the domain service, then the transport layer, then tests.
- **Pay attention to** - the 3-6 places where a bug would hurt, each with a line-range link and
  why. Then "Safe to skim": mechanical renames, generated files, boilerplate DTOs.
- **Questions a reviewer will ask** - from step 3, with evidence links. Open ones tagged `open`.
- **Database** - per migration: what it does, locks/cost on production-size tables, whether
  old code runs against the new schema during a rolling deploy.
- **Shipping it** - everything not finished by deploying: SQL before migration, jobs to push,
  flags, console changes, runbook links. "Nothing by hand" when empty. Blast radius and rollback.
- **How it was verified** - commands actually run and their results; untested paths named.
- **Not in this PR** - what was deliberately left out, and where it goes (ticket, follow-up).

### Diagrams

Mermaid 11 is loaded by the template; put sources in `<pre class="mermaid">`. Keep each diagram
under ~15 nodes - collapse `common/*` into one node, group siblings, drop unchanged leaves.
Add a one-line caption saying what to look at. Green = added, red dashed = removed, grey =
unchanged.

**Dependency / architecture change** - when import edges between areas changed or a module
appeared, moved or split. Build it from the script's edge lists.

```
flowchart LR
  classDef added stroke:#1f9d55,stroke-width:2px
  classDef removed stroke:#d64545,stroke-dasharray:5 4,color:#d64545
  rest["rest/email-relay"]:::added --> notif["modules/notification"]
  notif --> subs["modules/subscriptions"]
  notif -.-x legacy["modules/legacy"]:::removed
  linkStyle 0 stroke:#1f9d55,stroke-width:2px
  linkStyle 2 stroke:#d64545,stroke-dasharray:5 4
```

**Files or modules moved** - before and after side by side.

```
flowchart LR
  subgraph Before
    a1["modules/user/referral/*"]
  end
  subgraph After
    b1["modules/referral/*"]
  end
  a1 -- moved, 14 files --> b1
```

**Schema change** - only the touched models and their direct relations; mark new and changed
fields in the comment slot.

```
erDiagram
  User ||--o{ GuestPass : issues
  GuestPass {
    string id PK
    string code "NEW unique"
    datetime redeemedAt "NEW nullable"
  }
```

**Flow / state machine** - `stateDiagram-v2` with new transitions labelled. **Request or job
path** - `sequenceDiagram` across controller, service, queue, external API, when the order of
calls or the retry behaviour is the point.

No diagram for a change that is a single-file edit or purely additive inside one module. A
diagram that restates the file list is noise.

### Links

Use the per-file `diff_url` from `--json` for file links. For specific lines use
`https://github.com/<owner>/<repo>/blob/<head_sha>/<path>#L<start>-L<end>` (pinned to the head
SHA so links survive force-pushes).

## 5. Publish and link

1. Publish with `Artifact` (`icon: "review"`, a one-sentence `description`). Title is 2-4 words
   naming the change, never "PR #123 ...".
2. Add or replace a `## Review guide` section at the end of the PR body with the link, via
   `gh pr edit <n> --body-file`. Read the current body first and change only that section.
   Running this skill authorizes that one body edit - not comments, not pushes, not labels.
3. **Re-runs** (new commits pushed): find the existing link in the PR body, `Artifact`
   `action: "read"` it, and republish to the same `url`. Update the head SHA, numbers, and every
   section the new commits touched.

The artifact is private until shared. If someone else reviews, tell the user to share it.

## 6. Report

Tell the user, briefly: the decision and why, the artifact link (if any), the open questions,
and anything found in step 3 that looks like a defect rather than a question.

## Rules

- No AI or tool attribution anywhere - PR body, artifact, captions.
- Never use em-dashes; use `-`.
- Write the current state of the change, not the story of how it got there. "Initially tried X"
  belongs in a commit message, if anywhere.
- The checklist has at most 7 items. Always.
- Every claim about behaviour, performance or safety links to its evidence or says it is
  unverified.
