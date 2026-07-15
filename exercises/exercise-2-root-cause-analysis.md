# Exercise 2: Root Cause Analysis with AI

**Time box:** ~35 minutes
**Goal:** Use AI to generate and test root-cause hypotheses against
evidence, without just trusting the first plausible-sounding answer.

## Setup

Building on Exercise 1, you now know checkout success rate has collapsed
and two related alerts (latency/errors + DB pool saturation) fired close
together. You now have access to:

- `data/deploy-history.md`
- `data/metrics/db_connection_pool.csv`
- `data/metrics/checkout_latency_p95.csv`
- `data/metrics/payment_gateway_calls.csv`
- Both log files in `data/logs/`

You probably don't need to point the AI at each file by name — a modern AI
coding assistant can explore the working directory and figure out which
files are relevant on its own. Try asking it a general question first (e.g.,
"look into the data available and correlate the deploy history with the
onset of degradation") before explicitly listing file paths.

## Task

1. Ask your AI assistant to correlate the **deploy history** with the
   **onset of degradation** in the metrics. Let it find and read the relevant 
   files itself first — only point it to specific paths if it doesn't.
2. Ask the AI to explain, in technical terms, *why* a change like the one
   in `v2.14.0`'s changelog ("removed manual `JOIN FETCH` query" /
   "lazy-loaded associations") could cause the symptoms you're seeing in
   the DB pool metrics and logs. (Hint: look for the term "N+1" in the
   logs — ask the AI to explain what an N+1 query problem is and why it
   matters here if you're not familiar.)
3. Ask the AI to explain the **causal chain** from the deploy to the
   customer-facing payment-gateway 429s — i.e., why would a database
   problem cause a *third-party payment API* to start rate-limiting you?
4. Have the AI draft a root-cause statement in one or two sentences.
   Compare it against the evidence yourself — does every claim in that
   sentence have a corresponding log line or metric to back it up?

## Questions to answer

- What is the root cause, in one sentence?
- What is the full causal chain from deploy → customer impact? (Draw or
  list each link.)
- What contributing factors made this worse than it needed to be (e.g.,
  pool sizing, retry behavior)?
- Where did the AI's hypothesis match the evidence, and where (if
  anywhere) did it overreach or guess without support?

## Try these prompt angles

- "Latency started climbing at 10:00 UTC — look at the deploy history and
  metrics files in this directory and tell me which deploy, if any, is the
  most likely trigger, and what's your confidence level?"
- "Explain what an N+1 query problem is and why switching from
  `JOIN FETCH` to lazy-loaded ORM associations could cause one. Keep it
  to 5 sentences."
- "I have a service with a saturated DB connection pool causing 5xx/504s,
  and a downstream 3rd-party payment API now returning 429s. Explain the
  likely mechanism connecting these two, assuming standard retry logic."
- "Given this root-cause hypothesis, check the data in this directory for
  evidence that supports or contradicts it. [state hypothesis]"

## Watch out for

- **Confirmation bias amplified by AI**: if you feed the AI a leading
  question ("this must be the connection pool, right?"), it will often
  agree. Ask it to consider alternative hypotheses too (e.g., "could this
  be a payment-gateway outage instead? What evidence would rule that in or
  out?") before settling.
- AI stating specific numbers or timestamps it wasn't given — always
  verify cited figures against the actual data files.
- Treating an AI-generated root cause as final without a human checking
  the causal chain end-to-end.
