# Exercise 4: Request for Change with AI

**Time box:** ~35 minutes
**TopDesk phase:** Problem *Solution proposed* → new change request
linked to the problem and incident
**Goal:** Use AI to turn your problem analysis into a complete,
reviewable Request for Change, while you stay responsible for accuracy,
risk assessment, and planning.

## Setup

Your problem analysis from Exercise 3 is complete, and you have chosen a
long-term solution. To implement it in production, you need an approved
change. Fill in the organisation's RFC form: `rfc-template.docx` (in the
root of this workshop folder). Make a copy first, e.g.
`rfc-checkout-service-<your-name>.docx`.

The template has these sections:

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

1. **Draft the content.** Give the AI your problem record from Exercise 3
   and the template's section list. Ask it to draft text for each section.
   - If you're using an AI coding assistant that can run code (e.g.
     GitHub Copilot CLI), you can ask it to fill in your copy of the
     `.docx` directly (for example with `python-docx`). Check the result
     in Word afterwards.
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

- What did you have to correct or rewrite in the AI's draft, and why
  (facts, scope, vague risks, unrealistic estimates)?
- Does every claim in section 1 trace back to evidence from the incident
  or problem?
- Is the rollback plan specific enough that a colleague on call at night
  could carry it out?
- Which items did you deliberately leave **out** of this RFC, and where
  are they tracked?
- Would you approve this RFC if you were on the Change Advisory Board?
  Why or why not?

## Try these prompt angles

- "Here is my TopDesk problem record and the sections of our RFC template.
  Draft the text for each section. Keep section 2 about WHAT changes and
  section 3 about HOW. [paste problem record + section list]"
- "Fill in this copy of rfc-template.docx with the content we drafted.
  Keep the existing layout; put text in the empty cells under each
  heading."
- "Rewrite this risk section so each risk has a likelihood, impact,
  mitigation, and owner. Add a concrete rollback plan."
- "Create a work breakdown structure with hour estimates for this change,
  using these phases: design requirements, infrastructure, software
  development, testing, delivery & acceptance, rework."
- "Review this RFC as a sceptical Change Advisory Board member. List the
  top 5 questions you would ask before approving it."

## Watch out for

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
