# Exercise 3: Problem Analysis & Change Request with AI

**TopDesk phase:** Problem linked to `I 2607 041`, status *Registered* →
*In analysis* → *Known error* → *Solution proposed* → new change request
linked to the problem and incident\
**Goal:** Use AI to analyse the problem thoroughly: generate root-cause
hypotheses and test them against evidence, find the contributing factors,
and choose a long-term solution, without trusting the first
plausible-sounding answer. Then turn that analysis into a complete,
reviewable Request for Change, while you stay responsible for accuracy,
risk assessment, and planning.

## Setup

It is the next day. The incident is closed (solved by a workaround), and you
pick up the problem you registered in Exercise 2. Production is stable on
`v2.13.4`, but there is pressure to move forward. You now have access to
additional evidence that wasn't available during the incident, in
`checkout-service-incident-files/`:

- `problem-evidence/`
  - `pr-4821-diff.md`: the code change behind v2.14.0
  - `checkout-service-config.yaml`: pool, retry, and payment-gateway
    client configuration
  - `traffic-growth.csv`: traffic trend and forecast
  - `payment-reconciliation.md`: Finance's findings on duplicate charges
  - `stakeholder-notes.md`: input from the product owner, release
    manager, DB/infra, and payments
- `request-for-change/`
  - `rfc-template.docx`: the organisation's Request for Change form,
    which you'll fill in during Part D
- Everything from Exercises 1 and 2 (logs, metrics, runbook, TopDesk
  records)

Record your analysis in `topdesk-problem/template.md`.

Once you've chosen a long-term solution (Part C), you'll fill in the
organisation's RFC form in Part D (`rfc-template.docx`, listed above). The
template has these sections:

| Section | What it should contain for this case |
|---|---|
| General information | Requester, department, application (checkout-service), dates, RFC tracking number, problem number, assigned handler |
| 1. Problem description – reason for the change | Why this change is needed: the problem, its impact, why the workaround isn't enough. Plus stakeholders. |
| 2. Description of the change – WHAT needs to be different | The functional/technical change, without the "how" |
| 3. Description of the solution | HOW: the technical approach |
| 4. References | Incident, problem, PRs, reconciliation report, etc. |
| 5. Special considerations / risks | Risks, mitigations, rollback plan, deploy window, dependencies, approvals |
| 6. Work breakdown structure | Tasks and hours per phase: design, infrastructure, software development, testing, delivery & acceptance, rework |

## Task

### Part A: Root cause and causal chain

1. Ask the AI to explain, in technical terms, *why* the v2.14.0 change
   (removed eager loading via `.Include()`, switched to lazy-loaded
   navigation properties) causes the symptoms in the DB pool metrics and
   logs. Hint: compare the SQL queries logged for one request before and
   after the deploy (same `req_id`), and look closely at where the
   transaction scope sits in the diff.
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
   - Re-release the refactor with efficient fetching (eager loading via
     `.Include()`/`.ThenInclude()`, or split queries) and keep the DB
     transaction short (no remote calls inside it)
   - Retry policy: exponential backoff with jitter, no retry on 429
     without honouring `Retry-After`, circuit breaker, idempotency keys
   - Resize the connection pool with headroom for the traffic forecast
   - Ask payment-gateway to raise the rate limit
   - CI safeguards: query-count assertions, realistic test data, load test
2. Choose the solution. Decide **what goes into the RFC** and what
   becomes a separate follow-up action (with owner and target date).
3. Complete the problem record and set it to *Solution proposed*.

### Part D: Request for Change

1. **Draft the content.** Give the AI your problem record from Parts A–C
   and the template's section list above. Ask it to draft text for each
   section.
   - If you're using an AI coding assistant that can run code (e.g.
     GitHub Copilot CLI), you can ask it to fill in `rfc-template.docx`
     directly and save the result as a new file, so the template stays
     intact. Check the result in Word afterwards.
   - Otherwise, have it draft the text and paste it into the form
     yourself.
2. **Get the scope right.** Check that sections 2 and 3 cover only what
   you decided belongs in this RFC. Follow-up actions outside the RFC
   (e.g. a separate rate-limit request or CI improvements owned by
   another team) go under references or considerations, not in the WBS.
3. **Make the risk section concrete.** Push the AI for:
   - Specific risks with likelihood/impact and a mitigation for each
   - A **rollback plan** (to what version, how, how long, who decides)
   - Verification after deployment (which metrics, which thresholds,
     for how long)
   - Deploy window and constraints (traffic peaks, the deploy freeze, the
     upcoming campaign)
4. **Make the WBS realistic.** Ask the AI for a breakdown with hours, then
   change it based on your own experience. Is there a load test? Does
   DB/infra review the new queries and transaction scope? Is there time
   for rework?
5. **Review as a change approver.** Ask the AI to review the completed RFC
   critically, as a Change Advisory Board member would: what's missing,
   vague, or unsupported? Fix the most important gaps.

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
- What did you have to correct or rewrite in the AI's RFC draft, and why
  (facts, scope, vague risks, unrealistic estimates)?
- Does every claim in RFC section 1 trace back to evidence from the
  incident or problem?
- Is the rollback plan specific enough that a colleague on call at night
  could carry it out?
- Which items did you deliberately leave **out** of this RFC, and where
  are they tracked?
- Would you approve this RFC if you were on the Change Advisory Board?
  Why or why not?

## Try these prompt angles

- "Explain what an N+1 query problem is and why switching from eager
  loading (`.Include()`) to lazy-loaded EF Core navigation properties
  causes one. Then look at this diff: is there a second reason why DB
  connections are held longer?"
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
- "Here is my TopDesk problem record and the sections of our RFC template.
  Draft the text for each section. Keep section 2 about WHAT changes and
  section 3 about HOW. [paste problem record + section list]"
- "Fill in rfc-template.docx with the content we drafted and save it as
  a new file. Keep the existing layout; put text in the empty cells under
  each heading."
- "Rewrite this risk section so each risk has a likelihood, impact,
  mitigation, and owner. Add a concrete rollback plan."
- "Create a work breakdown structure with hour estimates for this change,
  using these phases: design requirements, infrastructure, software
  development, testing, delivery & acceptance, rework."
- "Review this RFC as a sceptical Change Advisory Board member. List the
  top 5 questions you would ask before approving it."

## Watch out for

- **Confirmation bias amplified by AI**: if you ask a leading question
  ("it's the connection pool, right?"), the AI will often agree. Ask for
  alternatives before settling.
- Stopping at the first cause. "N+1 queries" is true but incomplete. A
  thorough analysis also covers the transaction scope, retries, pool
  sizing, missing safeguards, and the duplicate-charge risk.
- The AI quoting numbers or timestamps it wasn't given. Always check cited
  figures against the data files.
- Blame. "The developer removed the eager loading" is not a root cause.
  "The pipeline has no check that would catch a query regression" is.
- "Just raise the pool size" as the long-term solution. The DB/infra notes
  explain why that moves the bottleneck instead of removing it.
- The AI inventing facts: RFC numbers, dates, names, hour estimates, or
  test results that don't exist. Check every number against your
  analysis.
- Vague risk statements ("deployment could fail"). They give the CAB
  nothing to decide on.
- Scope creep: the AI tends to put every good idea into one change.
  Smaller, focused changes are easier to test, approve, and roll back.
- Treating the AI draft as final. You are the requester, so you sign
  off on the RFC.
- Customer data in the RFC or in prompts (names or emails from the
  duplicate-charge cases). Refer to the reconciliation report instead.
