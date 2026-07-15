# Incident Brief

**Company:** ShopFast (fictional e-commerce platform)
**Your role:** On-call SRE
**Time:** 10:07 UTC, Tuesday

---

## The alert

You are paged by PagerDuty (an on-call alerting/incident-management tool that
notifies engineers when monitoring systems detect a problem):

> **[SEV-2] High latency & elevated error rate — checkout-service**
> p95 latency > 2000ms for 5+ minutes. 5xx rate > 5%.
> Runbook: `data/runbooks/checkout-service-runbook.md`

Two minutes later, a second alert fires:

> **[SEV-2] DB connection pool saturation — checkout-service-db**
> Active connections at 100% of max pool size for 3+ minutes.

Slack (a team messaging app used for real-time chat channels) `#incidents` is
starting to light up:

> **#support-escalations:** "Getting a spike in tickets — customers say
> checkout is stuck on 'Processing...' or shows a generic error. Anyone
> looking at this?"

> **#eng-payments:** "payment-gateway is seeing a wave of 429s from
> checkout-service, way more than normal traffic would explain."

## What you know at the start

- Checkout success rate has dropped from a normal ~99.5% to ~62% over the
  last 15 minutes.
- Customers are reporting failed or stuck checkouts on the website and app.
- No known regional cloud provider issues (status pages are green).
- The on-call channel has evidence available: alerts, logs, metrics, and
  recent deploy history (see `data/`).

## Your task

Using the data provided in this repo (and any AI assistant you have
access to), work through the exercises in `exercises/` in order:

1. **Triage** — figure out what's actually broken and how bad it is.
2. **Root cause analysis** — figure out *why* it's broken.
3. **Remediation** — decide and (on paper) execute a fix.
4. **Postmortem & communications** — write up what happened and tell people.

Treat this like a real incident: skim fast, form hypotheses, verify against
evidence, and don't be afraid to be wrong and correct course.
