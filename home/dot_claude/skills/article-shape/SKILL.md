---
name: article-shape
description: Take a markdown file of raw material and shape it into an article through a conversational session — drafting candidate openings, growing the piece paragraph by paragraph, holding the through-line, arguing about format at each step. Tuned to the user's voice (plain narrated first-person, no AI tells). Use when the user has a pile of notes, fragments, or a rough draft and wants help turning it into something publishable.
---

<what-to-do>

The user has passed (or will pass) a markdown file of raw material. Treat it as the input pile — anything from a tidy list of fragments, to a wall of unstructured prose, to a rough draft, to two drafts that need merging (often his own rambling notes plus an AI draft he dislikes). The format does not matter. Read it end-to-end before doing anything else.

Then run a shaping session that produces the article. The user usually wants the article written into the same file, replacing the raw material — confirm the target once if it's not stated, then remember it. The user will be editing the article file during the session; always re-read it from disk before writing so their edits are preserved.

This skill is tuned to one writer. The Voice section below is not negotiable defaults to re-ask about every time — they are how he writes. Apply them silently.

</what-to-do>

<supporting-info>

## Voice — apply these by default, do not re-ask

His natural voice for blog posts (menih.si) is plain first-person narration that tells the story of what he actually did. Calibrate against his own edited paragraphs in the pile — those are the ground-truth sample, not the AI draft sitting next to them.

Hard rules:

- **No "buttons."** Paragraphs do not end on polished aphorisms, chiasmus, balanced tricolons, or manufactured punchlines. This is the #1 AI tell he reacts to. A paragraph ends when the thought ends, flatly.
- **No imposed abstract motif.** Never invent a recurring named frame ("the household test", "the remote door", "blast radius", "the airlock") and thread it across sections. Concrete anecdotes carry the stakes; do not abstract them into a metaphor that recurs.
- **Loose texture preserved.** Run-ons, comma splices, casual connectors ("So I just", "The thing is", "Obviously,", "And sure enough"). Fix genuine typos and grammar errors. Do NOT smooth the rhythm into clean, even, polished prose — evenness reads as AI.
- **Concrete consequences over abstraction.** "a text from my wife asking why she can't close the blinds" — not "the household test." Always reach for the specific incident.
- **Dry self-deprecation, sparingly.** A few spots, not every paragraph: owning his own failures plainly.
- **Thinking-out-loud register, dialed to a few places.** "Hmm…", "call me old fashioned", "flabbergasting... thingamajiging..." exist in his notes — keep a couple, don't make it the constant register.

If a sentence sounds like it would survive in a generic tech blog by anyone, it's wrong for him.

## Article shape — the arc he actually uses

His posts are a personal-journey narrative, not an argumentative essay. The recurring spine:

1. **Where it started / the unsolved problem** — plain setup, no heading. What he had, why it annoyed him, what he did about it (usually: not much, left it alone).
2. **The false start** — the obvious first attempt that didn't work, and concretely why. Often a bulleted list of the specific failures.
3. **The insight** — the moment he understood what was actually different. Short.
4. **The real solution** — what he built, with enough concrete detail (commands, file layout, a code block or directory tree) that a reader could picture it.
5. **Where it stands now + what's still wrong** — the payoff (a real anecdote), then an honest "the thing I still don't like is…" with the actual next step. Never a triumphant wrap.

Section headings are `##` (H2). The intro gets no heading. Do not add frontmatter unless it's already in the file or he asks — match the existing frontmatter shape if present.

The conclusion is the most likely place to slip into an AI button or a falsely triumphant ending. It ends on honest unfinished business and a concrete next step, in his flat register.

## The loop

1. **Read the pile.** Read the input file in full. If it contains both his notes and an AI draft, his notes/edits are the voice; the AI draft is only a quarry for facts and structure ideas.
2. **Candidate openings.** Draft 2–3 openings, each implying a different entry into the journey (e.g. start at the annoyance, start at the false start, start at the insight). Show them, let him pick or hybridize. If he's said "just do it," pick the one that best fits the journey arc and move — don't stall asking.
3. **Grow paragraph by paragraph, holding the through-line.** After each block, ask "given what just landed, what does the reader need next?" Pull from the pile to answer.
4. **Write to the article file as you go.** Don't batch. Re-read from disk first.
5. **Loop until he says it's done.**

## The through-line — the "red line"

This is the thing he most reacts to after voice. Every section must open by answering what the previous section left hanging. No unsupported jumps.

- A section that opens with "By then…", "After that…", "Meanwhile…" must have a prior sentence that earns the time reference. If the opening says "I left it alone" and the next section says "By then I'd been using X," that's broken — the bridge (what pulled him back) is missing. Write the bridge.
- A pronoun opening a section ("It bugged me…") must point at a concrete noun in the sentence before it. If it doesn't, make it concrete.
- Before declaring a draft done, trace it end to end: read only the first sentence of each section in order. They should form a chain where each one clearly follows the last. If any link is a non-sequitur, fix that transition before anything else.

Refuse to let a weak transition slide even if the prose inside each section is good. He will catch it and he will be annoyed.

## Conversational feel

Push back. "What does this paragraph do that the previous one didn't?" "If I cut this, what breaks?" "The opening set up X, this section is answering Y — re-thread it." "This sounds like a button — flatten it." Be willing to say a whole section doesn't earn its place and cut it.

## Pulling from the pile

The pile is a quarry, not a script. Rework fragments to fit; split one across paragraphs, merge two, paraphrase. When merging his notes with an AI draft, take facts and structure from either but force everything into his voice. If the article needs a concrete detail the pile lacks (a command, a number, a real anecdote), name the gap explicitly and either get it from him or from the referenced project — do not invent specifics.

## Format arguments to actually have

Weigh these out loud, not silently:

- **Prose vs. list.** Prose carries the narrative; a list is right only when items are genuinely parallel (e.g. the concrete failures of a false start). Don't listify narrative.
- **Code block / directory tree vs. prose.** When he describes a tool he built, a real directory tree or command block makes it concrete and is usually worth it. Pull the real structure from the referenced project, don't fabricate it.
- **Quote vs. paraphrase.** Quote when the exact wording is the point (e.g. an actual request he made to the tool). Paraphrase otherwise.
- **Inline vs. callout.** He doesn't lean on callout admonitions. Default to inline unless an aside genuinely derails the line of thought.

## Out of scope

- Inventing fragments, facts, or specifics not in the pile or the referenced project.
- Bolting on a unifying metaphor or a tidy closing aphorism.
- Publishing, or adding frontmatter he didn't ask for.

</supporting-info>
