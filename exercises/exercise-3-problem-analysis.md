# Exercise 3: Problem Analysis with AI

**Time box:** ~55 minutes
**TopDesk phase:** Problem linked to `I 2607 041`, status *Registered* →
*In analysis* → *Known error* → *Solution proposed*
**Goal:** Use AI to analyse the problem thoroughly: generate root-cause
hypotheses and test them against evidence, find the contributing factors,
and choose a long-term solution, without trusting the first
plausible-sounding answer. Then share what was learned in a blameless
postmortem summary.

## Setup

It is the next day. The incident is closed (solved by a workaround), and you
pick up the problem you registered in Exercise 2. Production is stable on
`v2.13.4`, but there is pressure to move forward. You now have access to
additional evidence that wasn't available during the incident, in
`checkout-service-incident-files/`:

- `checkout-service-problem-evidence/`
  - `pr-4821-diff.md`: the code change behind v2.14.0
  - `checkout-service-config.yaml`: pool, retry, and payment-gateway
    client configuration
  - `traffic-growth.csv`: traffic trend and forecast
  - `payment-reconciliation.md`: Finance's findings on duplicate charges
  - `stakeholder-notes.md`: input from the product owner, release
    manager, DB/infra, and payments
- Everything from Exercises 1 and 2 (logs, metrics, runbook, TopDesk
  records)

Record your analysis in `checkout-service-topdesk/problem-template.md`.

## Task

### Part A: Root cause and causal chain

1. Ask the AI to explain, in technical terms, *why* the v2.14.0 change
   (removed `JOIN FETCH`, lazy-loaded associations) causes the symptoms in
   the DB pool metrics and logs. Hint: compare the SQL queries logged for
   one request before and after the deploy (same `req_id`), and look
   closely at where `@Transactional` sits in the diff.
2. Ask the AI to lay out the **full causal chain** from the code change to
   the customer impact, including why a database problem makes a
   *third-party payment API* start rate-limiting you, and how customers
   could be charged twice.
3. Ask for **alternative hypotheses** (e.g. payment-gateway outage, traffic
   spike, DB infrastructure issue) and the evidence that rules each in or
   out.
4. Have the AI draft a one- or two-sentence root-cause statement. Check it
   yourself: does every claim have a log line, metric, or code line to
   back it up?

### Part B: Contributing factors and known error

1. Ask the AI to identify the **contributing factors**, i.e. why the impact
   was larger than it needed to be, and why this wasn't caught before
   production. Use the config, traffic, test-data, and reconciliation
   evidence.
2. Explain why the rollback is only a **workaround**. What risks remain
   on v2.13.4 (look at the traffic forecast and config)?
3. Write the **known error** description, i.e. what a service desk colleague
   should find in TopDesk if similar symptoms come back.
4. Ask the AI to compare the **runbook** with what actually happened
   during the incident: which steps helped, and what was missing or
   outdated? Have it draft the most important missing section. Review
   and edit it; don't paste it in verbatim.

### Part C: Solution options

1. Ask the AI for **long-term solution options** with pros, cons, risk, and
   rough effort. For example:
   - Re-release the refactor with efficient fetching (entity graph /
     `JOIN FETCH` / batch fetching) and keep the DB transaction short (no
     remote calls inside it)
   - Retry policy: exponential backoff with jitter, no retry on 429
     without honouring `Retry-After`, circuit breaker, idempotency keys
   - Resize the connection pool with headroom for the traffic forecast
   - Ask payment-gateway to raise the rate limit
   - CI safeguards: query-count assertions, realistic test data, load test
2. Choose the solution. Decide **what goes into the RFC** and what
   becomes a separate follow-up action (with owner and target date).
3. Complete the problem record and set it to *Solution proposed*.

### Part D: Postmortem summary

The problem record is the technical record in TopDesk. The postmortem
shares what happened and what was learned with a wider audience
(engineering, management, service desk), without blaming anyone.

1. Ask the AI to turn your problem record (plus the incident timeline from
   Exercise 2) into a **one-page blameless postmortem** with this
   structure (or your organisation's own template, if you have one):
   - Summary (1–2 sentences)
   - Impact: who was affected, how long, how badly. Use numbers:
     failed checkouts, duplicate charges, € at risk.
   - Timeline: key moments, from deploy to recovery
   - Root cause and contributing factors
   - What went well / what went poorly
   - Action items: each with an owner and a target date, marked as
     *in the RFC* or *separate follow-up*, with its TopDesk reference
2. **Edit the draft**:
   - Check every number and timestamp against the source data.
   - Rewrite anything that implies individual blame ("the developer broke
     prod") as a system gap ("the pipeline had no check for query
     regressions").
   - Make vague action items ("improve monitoring") specific: what, who,
     and by when.
3. Have the AI write a **4–5 sentence management summary** from the
   postmortem: business impact and what will prevent this from happening
   again, with no technical detail.

## Questions to answer

- What is the root cause, in one sentence?
- What is the full causal chain from code change to customer impact? List
  each link with its evidence.
- What contributing factors made this worse, and why wasn't it caught
  before production?
- Why is the rollback a workaround and not a solution?
- Which solution did you choose, and what is in or out of scope for the
  RFC?
- Where did the AI's analysis match the evidence, and where (if anywhere)
  did it overreach or guess without support?
- What did you have to correct in the AI's postmortem draft (facts, tone,
  blaming language, vague action items)?
- Does every action item in the postmortem have an owner, a date, and a
  place where it is tracked (the RFC or a separate TopDesk reference)?

## Try these prompt angles

- "Explain what an N+1 query problem is and why switching from `JOIN FETCH`
  to lazy-loaded ORM associations causes one. Then look at this diff:
  is there a second reason why DB connections are held longer?"
- "Here is my root-cause hypothesis. List the evidence in this directory
  that supports it, and separately, any evidence that contradicts it."
- "What alternative explanations are there for these symptoms, and which
  data rules each one in or out?"
- "Using the traffic forecast and current config, what happens on Black
  Friday if we stay on v2.13.4 and change nothing?"
- "List long-term solution options for this problem with pros, cons, risk
  and effort. Which belong in a single RFC for checkout-service, and which
  should be separate actions?"
- "Draft a known-error description for TopDesk that a service desk agent
  can recognise from customer symptoms."
- "Turn this problem record and incident timeline into a one-page
  blameless postmortem using the structure below. Describe system and
  process gaps, not people. [paste structure + problem record + timeline]"
- "Rewrite this action item to be specific and assignable: 'improve
  monitoring for the database.'"
- "Summarise this postmortem for management in 5 sentences: business
  impact and how we'll prevent it from happening again. No technical
  detail."

## Watch out for

- **Confirmation bias amplified by AI**: if you ask a leading question
  ("it's the connection pool, right?"), the AI will often agree. Ask for
  alternatives before settling.
- Stopping at the first cause. "N+1 queries" is true but incomplete. A
  thorough analysis also covers the transaction scope, retries, pool
  sizing, missing safeguards, and the duplicate-charge risk.
- The AI quoting numbers or timestamps it wasn't given. Always check cited
  figures against the data files.
- Blame. "The developer removed the JOIN FETCH" is not a root cause. "The
  pipeline has no check that would catch a query regression" is.
- "Just raise the pool size" as the long-term solution. The DB/infra notes
  explain why that moves the bottleneck instead of removing it.
- Postmortem text that *sounds* blameless but still points at a person
  ("a developer's change caused..."). Rephrase toward missing
  safeguards.
- Overpromising in the management summary ("this will never happen
  again"). Stick to what the actions actually address.
