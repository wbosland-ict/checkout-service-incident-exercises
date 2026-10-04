# Exercise 1: Incident Intake & Triage with AI

**TopDesk phase:** Incident `I 2607 041`, status *Assigned* → *In progress*\
**Goal:** Use AI to turn a TopDesk ticket plus noisy, multi-source signals
into a prioritised understanding of what is broken and how bad it is.

## Setup

The service desk has just assigned incident **I 2607 041** to you. Read
`scenario/00-incident-brief.md` and `scenario/01-architecture.md` if you
haven't already. You have access to these files in
`checkout-service-incident-files/`:

- `topdesk-incident/`
  - `I-2607-041.md`: the TopDesk incident as registered by the
    service desk
- `payload-and-log-excerpts/`
  - `monitoring-alerts.json`: 4 Grafana alerts posted to Teams within
    ~5 minutes
  - `teams-channel-excerpts.md`: messages from the Teams channels
  - `checkout-service.log` and `payment-gateway.log`

## Task

1. Give your AI assistant the TopDesk incident, the alerts and/or log
   excerpts. Ask it to:
   - Summarise what's happening in plain language.
   - Rank the 4 alerts by how much they explain the customer impact
     described in the incident (failed checkouts).
   - Flag anything that looks like a **distraction or downstream symptom**
     rather than a primary issue.
2. Ask the AI to check the **TopDesk classification**: do impact, urgency,
   and priority (High) match the evidence? Is the category/object right?
   Is anything missing from the registration (e.g. the duplicate-charge
   concern)?
3. Ask the AI what evidence you should look at next, based on patterns in
   the logs (e.g. "check recent deploys", "check DB metrics").
4. Write the **first TopDesk action entry**, i.e. what you would log in the
   incident when you set it to *In progress*. Also write a short
   post for the Teams *Incidents* channel so colleagues and the service
   desk know who is working on it. Have the AI draft both, then edit them
   yourself.

## Questions to answer

- Which alert(s) matter most right now, and why?
- Which alert looks like a secondary/downstream effect rather than a root
  cause? What evidence made you (or the AI) conclude that?
- What is the measured customer impact right now? Be specific and cite
  numbers.
- Is priority *High* justified? What would make it go up or down?
- What's your next step in the investigation?

## Try these prompt angles

- "Here is a TopDesk incident and 4 monitoring alerts that fired within
  5 minutes of each other. Rank the alerts by how well they explain the
  customer impact in the ticket, and say which might be downstream noise."
- "Given this incident description and these alerts, review the TopDesk
  impact/urgency/priority classification. Is anything misclassified or
  missing?"
- "Draft a TopDesk action entry (max 5 lines) for taking this incident
  into progress: current impact, what I've checked so far, next step."
- "Summarise this log file in 3 sentences for the service desk, so they
  can update callers. No jargon."

## Watch out for

- The AI ranking alerts with confidence before it has all the context
  (e.g. not noticing the `order-notification-service` alert is almost
  certainly noise until you point it at the "note" field).
- The AI coming up with plausible-sounding root causes at this stage.
  Triage is about **impact and priority**. In Exercise 2 you find what
  *triggered* the incident (enough to restore service); the root cause
  analysis comes in Exercise 3.
- Pasting raw TopDesk tickets or logs into a public AI tool. Real tickets
  contain customer names, email addresses, and phone numbers. Follow your
  organisation's policy on what may be shared with an external AI tool.
