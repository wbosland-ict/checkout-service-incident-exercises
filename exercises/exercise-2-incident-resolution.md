# Exercise 2: Incident Resolution with AI

**Time box:** ~40 minutes
**TopDesk phase:** Incident `I 2607 041`, status *In progress* → *Closed*
(and, if needed, a new problem registered)
**Goal:** Use AI to quickly find what triggered the incident, restore
service safely, record what you did in TopDesk, and decide whether the
fix is permanent or a workaround.

> At this stage you need **enough** understanding to restore service, not
> a full root cause analysis. That comes in Exercise 3.

## Setup

Building on Exercise 1, you know checkout success rate has collapsed and
two related critical alerts (latency/errors + DB pool saturation) fired
close together. You now also have these files in
`checkout-service-incident-files/`:

- `checkout-service-metrics-and-deploy-history/`
  - `deploy-history.md`
  - `checkout_latency_p95.csv`, `db_connection_pool.csv`,
    `payment_gateway_calls.csv`: metrics during the incident
  - `post-rollback-recovery.csv`: metrics during and after the rollback
    (for Part B, step 4)
- `checkout-service-runbook/`
  - `checkout-service-runbook.md`
- `checkout-service-topdesk/`
  - `problem-template.md`: for registering a problem in Part C

You probably don't need to point the AI at each file by name. A modern AI
coding assistant can explore the working directory and find the relevant
files itself. Try a general question first (e.g. "look at the data
available and correlate the deploy history with when things started to go
wrong") before listing file paths.

## Task

### Part A: Find the trigger

1. Ask your AI assistant to correlate the **deploy history** with the
   **onset of degradation** in the metrics. Let it find the files itself.
2. Ask it for its confidence level, and what evidence would rule a
   payment-gateway-side problem in or out.

### Part B: Decide and restore

1. Ask the AI to list the **options to restore service**, with pros, cons,
   and risk for each. For example:
   - Roll back `checkout-service` to `v2.13.4`
   - Forward fix: patch the query and hotfix-deploy
   - Increase `max_pool_size` on the DB as a stopgap
   - Disable retries / add a circuit breaker temporarily
2. Pick the fastest safe option for a high priority incident. A rollback is 
   part of handling a high priority incident. It needs no separate RFC, but you 
   must announce it and log it in TopDesk.
3. Have the AI draft:
   - The exact rollback commands (based on the runbook's *Rollback
     procedure*).
   - A short post for the Teams *Incidents* channel announcing the
     rollback **before** you do it.
   - A **verification checklist**: which metrics/logs to watch in the
     5–10 minutes after the rollback to confirm it worked, and which
     signals would tell you it didn't.
4. The rollback to `v2.13.4` has been executed (10:26–10:28 UTC). The
   results are in `checkout-service-metrics-and-deploy-history/post-rollback-recovery.csv`.
   Check them against your verification checklist: did the rollback
   work, and does the recovery follow the rollout?

### Part C: Update and close the incident

1. Have the AI draft the **TopDesk action entries** for what you did
   (timestamps, actions, results) and the **resolution text** for the
   incident.
2. Decide with the AI's help: **is this a permanent solution or a
   workaround?** Think about:
   - What did the rollback remove besides the defect? (See the changelog.)
   - Is the underlying weakness (retries, pool sizing, duplicate-charge
     risk) still there on v2.13.4?
   - Can the team ship the next release as planned?
3. If it's a workaround, write the **brief description and problem
   description** you would use to register a **problem** in TopDesk and
   link it to I 2607 041 (use `problem-template.md`; for now, fill in
   only the header, problem description and workaround sections).
4. Draft a short closing message for the service desk (so they can tell
   callers) and a status-page update for customers. No jargon, no blame,
   no overpromising.

## Questions to answer

- Which deploy triggered the incident, and how confident are you?
- Which restore option did you choose, and why was it faster or safer than
  the others?
- How did you confirm the rollback actually fixed the issue, and not just
  happened at the same time as a recovery?
- Did the AI assume a tool or platform you don't use? Did it propose a
  formal change for the rollback even though your process doesn't need one?
- Is the incident solved permanently or with a workaround? What was your
  reasoning, and what goes into the problem record?

## Try these prompt angles

- "Latency started climbing at 10:00 UTC. Look at the deploy history and
  metrics in this directory and tell me which deploy, if any, is the most
  likely trigger, and how confident you are."
- "Given this cause and this runbook's rollback procedure, list my options
  to restore service, ranked by speed and risk, for a high priority
  incident with 38% of checkouts failing."
- "Draft a Teams post for our Incidents channel announcing we're rolling
  back checkout-service from v2.14.0 to v2.13.4 for TopDesk incident
  I 2607 041. Factual, under 4 sentences."
- "Here is the recovery data after the rollback. Did it work? Cite the
  numbers."
- "Draft TopDesk action entries and a resolution text for this incident.
  Then tell me whether this resolution is a workaround or a permanent fix,
  and why."

## Watch out for

- The AI recommending a fix that sounds reasonable in general but doesn't
  fit your actual platform, tooling, or process. Always adapt commands to
  your real environment; never run AI-generated commands against
  production without review.
- Skipping "announce before you act". This is a good habit with or
  without AI.
- Closing the incident with "rolled back, solved" and moving on. If the
  underlying cause is still there, the next incident is waiting. That's
  what the problem record is for.
- Resolution texts that blame people ("developer broke prod"). Describe
  what happened to the system.
