# Exercise 4: Postmortem & Communications with AI

**Time box:** ~30 minutes
**Goal:** Use AI to accelerate writing a blameless postmortem and
stakeholder communications, while keeping ownership of accuracy, tone, and
judgment calls with the human author.

## Setup

The incident is resolved (assume the rollback from Exercise 3 worked and
checkout success rate has returned to ~99.4% by 10:35 UTC). You now need
to write:

1. An internal blameless postmortem.
2. A customer-facing status update.
3. A short executive/leadership summary.

You have everything from the previous exercises: the timeline, root cause,
contributing factors, and remediation steps.

## Task

### Part A — Internal postmortem

Ask your AI assistant to draft a blameless postmortem using this
structure (or your org's own template if you have one):

- Summary (1-2 sentences)
- Impact (who/what was affected, duration, magnitude — be quantitative)
- Timeline (key events with timestamps)
- Root cause
- Contributing factors
- What went well
- What went poorly
- Action items (owner + rough timeframe for each)

Feed it your Exercise 1-3 findings (or the ground-truth timeline your
facilitator shares) and have it produce a first draft. Then **edit it**:
check every factual claim against the source data, fix the tone if it
reads as blame-y ("the developer broke prod" vs. "the deploy pipeline
lacked a safeguard that would have caught this before production"), and
make sure action items are specific and assigned.

### Part B — Customer-facing status update

Ask the AI to draft a short public status-page update (2-3 sentences,
no internal jargon, no blame, no overpromising) for:
- The initial "investigating" update (posted around 10:10 UTC)
- The "resolved" update (posted around 10:40 UTC)

### Part C — Leadership summary

Ask the AI to draft a 4-5 sentence summary for a VP/leadership audience:
what happened, customer impact in business terms (e.g., failed
checkouts/revenue-at-risk, not just percentages), and what's being done to
prevent recurrence.

## Questions to answer

- What did you have to correct or rewrite in the AI's postmortem draft,
  and why (facts, tone, missing nuance, blame-y language)?
- How did the AI's customer-facing update differ in tone/detail from the
  internal postmortem? Was anything in the AI's customer draft too
  technical, or did it accidentally overpromise/underplay impact?
- Are the action items specific and assigned, or generic ("improve
  monitoring")? Tighten any that are vague.
- Where does blameless-postmortem culture require you to override or
  rephrase something the AI produced?

## Try these prompt angles

- "Draft a blameless postmortem for this incident using the structure
  below. Avoid blaming any individual; focus on systemic/process gaps.
  [paste structure + timeline + root cause + contributing factors]"
- "Rewrite this action item to be specific and assignable: 'improve
  monitoring for the database.'"
- "Draft a 2-sentence public status page update for customers about a
  checkout outage that's now resolved. No internal jargon, no blame,
  don't overpromise on 'this will never happen again.'"
- "Summarize this postmortem for a VP audience in 5 sentences, focused on
  business impact and prevention, not technical detail."

## Watch out for

- AI defaulting to vague action items ("add more monitoring," "improve
  testing") — push for specificity (what monitor, what threshold, what
  test, who owns it, by when).
- AI-generated text that sounds blameless on the surface but still
  implies individual fault ("a developer's change caused...") — rephrase
  toward systemic causes and missing safeguards.
- Overpromising in customer communications ("this will never happen
  again") — AI drafts often default to reassuring language that a human
  should tone down to what's actually true.
- Publishing an AI draft without verifying every fact/number against your
  actual incident data.
