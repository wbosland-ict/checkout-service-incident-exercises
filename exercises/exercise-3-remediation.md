# Exercise 3: Remediation with AI

**Time box:** ~30 minutes
**Goal:** Use AI to help decide between remediation options, draft the
actual commands/steps, and identify what a human must still verify before
acting — especially under incident pressure.

## Setup

You've identified the likely root cause in Exercise 2: the `v2.14.0`
deploy introduced an N+1 query pattern that exhausted the DB connection
pool, triggering a retry storm that breached payment-gateway's rate limit.

You now have `data/runbooks/checkout-service-runbook.md` (note its gaps) and
your root-cause analysis from Exercise 2.

## Task

### Part A — Decide

Ask your AI assistant to lay out the **remediation options** available,
with pros/cons/risk for each, for example:
- Roll back `checkout-service` to `v2.13.4`
- Forward-fix: patch the N+1 query and hotfix-deploy
- Increase `max_pool_size` on the DB as a stopgap
- Add a circuit breaker / disable retries temporarily
- Some combination, and in what order

Ask it to recommend a fastest-safe option and justify why, given this is a
customer-facing SEV-2 with ~38% checkout failure rate.

### Part B — Draft the execution

Have the AI draft:
1. The exact rollback command(s) for this environment (base it on the
   `Rollback procedure` section of the runbook).
2. A short Slack message to post in `#incidents` announcing the action
   you're about to take, before you take it.
3. A **verification checklist** — what metrics/logs should you watch in
   the 5-10 minutes after rollback to confirm it worked (and what would
   tell you it *didn't* work, so you don't wait too long before trying
   something else).

### Part C — Fix the runbook gap

The runbook has no section on DB connection pool saturation. Ask the AI to
draft a new runbook section for this failure mode, based on what you
learned in this incident. Review and edit its draft — don't just paste it
in verbatim.

## Questions to answer

- Which remediation option did you choose, and why was it faster/safer
  than the alternatives?
- What would you check to confirm the rollback actually fixed the issue,
  versus just correlating with a coincidental recovery?
- What did the AI get right or wrong about your specific environment when
  drafting the rollback commands (e.g., did it assume a tool/platform you
  don't use, like assuming Kubernetes when you use ECS)?
- What's one thing in the AI's draft runbook section you changed or
  removed before considering it "ready," and why?

## Try these prompt angles

- "Given this root cause and this runbook's existing rollback procedure,
  what are my remediation options, ranked by speed and risk, for a
  customer-facing SEV-2 currently at 38% checkout failure rate?"
- "Draft a Slack incident update announcing we're rolling back
  checkout-service from v2.14.0 to v2.13.4 due to a DB connection pool
  exhaustion issue. Keep it factual and under 4 sentences."
- "What metrics and log signals would confirm this rollback fixed the
  issue within 10 minutes, versus signals that would tell us it didn't
  help and we need a different fix?"
- "Draft a new runbook section for 'DB connection pool saturation' for
  checkout-service, including detection, immediate mitigation, and
  root-cause investigation steps, in the style of the existing runbook."

## Watch out for

- AI recommending a fix that sounds reasonable in general but doesn't fit
  your actual deployment platform, tooling, or approval process — always
  adapt commands to your real environment, don't run AI-generated commands
  verbatim against production without review.
- Skipping the "announce before you act" step — a good habit whether or
  not AI is involved.
- Treating the AI-drafted runbook section as complete without a human
  (ideally the team that owns the service) reviewing it.
