---
name: plan-with-docs
description: Plan a feature or change while keeping the project's lightweight docs in sync - decisions become ADRs in docs/adr/, domain vocabulary lands in CONTEXT.md. Use when planning work that involves real trade-offs, architectural decisions, or new domain terms, or when the user mentions ADRs, the domain glossary, or "plan with docs".
---

# Plan with docs

Produce a plan for the requested work, and treat documentation as a first-class output of planning: decisions become ADRs, vocabulary becomes CONTEXT.md entries. The point is that agreements made during planning survive the session instead of dying in the transcript.

## Flow

1. **Read existing docs first.** Check `docs/adr/` and `CONTEXT.md` / `CONTEXT-MAP.md` at the repo root. Existing ADRs constrain the plan - never propose something a prior ADR already rejected without explicitly calling out that it contradicts the ADR and asking whether to supersede it.
2. **Plan the work.** Explore the code and lay out the implementation plan as usual. While planning, keep a running list of:
   - Decisions that pass the ADR bar in [ADR-FORMAT.md](ADR-FORMAT.md): hard to reverse, surprising without context, the result of a real trade-off
   - Domain terms that are new, ambiguous, or used inconsistently (see [CONTEXT-FORMAT.md](CONTEXT-FORMAT.md))
3. **Resolve open decisions with the user.** Where the plan hinges on a genuine trade-off, present the options and get a decision before finalizing the plan.
4. **Write the docs when the decision is made, not after implementation.** As soon as a direction is approved:
   - Write one ADR per qualifying decision, following ADR-FORMAT.md
   - Update CONTEXT.md (or the right context under CONTEXT-MAP.md) for new or clarified terms, following CONTEXT-FORMAT.md

## Rules

- Don't force it: a plan with zero ADRs and no glossary changes is fine when nothing qualifies. Never pad.
- Keep ADRs short - a single paragraph is a complete ADR. The formats are deliberately lightweight.
- ADRs record the why; the plan records the how. Don't duplicate the implementation steps into the ADR.
