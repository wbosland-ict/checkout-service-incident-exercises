# Exercise 4: Fixing the Source Code with AI

**TopDesk phase:** Change `W 2607 012` approved → implementation\
**Goal:** Use an AI coding assistant to implement the solution approved in
the RFC (Exercise 3) directly in the `checkout-service` source code, with
the engineer reviewing and understanding every change rather than
accepting it blindly.

## Setup

Your RFC from Exercise 3 has been approved. Now you implement
it in `checkout-service`. You'll need:

- The sample source repo: `checkout-service-incident-sourcecode/` (see its
  `README.md` for build/test instructions). It is the real v2.14.0 code —
  no comments or notes point out what's wrong; use your RFC and the
  evidence files to scope the fix.
- Your problem record and RFC from Exercise 3 (sections 2 and 3 describe
  WHAT must change and HOW)
- `checkout-service-incident-files/problem-evidence/pr-4821-diff.md`: the
  diff that introduced the bug, as a reference for what to undo/redo
- `checkout-service-incident-files/problem-evidence/checkout-service-config.yaml`:
  pool, retry, and payment-gateway client settings relevant to the fix

## Task

1. Point the AI coding assistant to your RFC and ask it to propose a
   concrete implementation plan against the real source files, **before**
   writing any code. Check the plan against the RFC scope.
2. **Write the regression test first, and watch it fail.** Add a
   query-count test using realistic cart sizes (4–11 items) that asserts
   cart retrieval doesn't issue one query per item. Run it against the
   unchanged code and confirm it **fails**. A test you've never seen fail
   proves nothing.
3. Implement the two changes from the RFC with AI assistance:
   - **Eager-loading fix:** fetch cart items + products in a single query
     with `.Include()`/`.ThenInclude()` instead of the N+1 lazy-loaded
     navigation properties, and narrow the transaction scope in
     `CheckoutService.StartAsync()` so it no longer wraps the inventory
     and payment-gateway remote calls.
   - **Retry policy:** harden the payment client with exponential backoff
     with jitter, honour `Retry-After` on `429`, a circuit breaker, and
     an `Idempotency-Key` on charge requests.
4. Re-run the suite. The regression test from step 2 should now **pass**,
   and the existing smoke test should still pass.
5. Ask the AI to explain each change and how it addresses the root cause
   from your problem record. Don't accept a diff you can't explain
   yourself.
6. Ask the AI to review its own diff critically: does it match the RFC
   scope exactly (nothing extra, nothing missing)? Did it introduce any
   new risk (e.g. a different N+1 elsewhere, a breaking API change)?
7. Draft a short pull request description linking back to the RFC,
   problem, and incident numbers, for a human reviewer.

## Questions to answer

- Did the AI's implementation match what was scoped in the RFC, or did it
  add changes you didn't ask for?
- What did you have to correct in the AI's code (correctness, style, a
  missed edge case)?
- Does the new regression test actually fail without the fix, and pass
  with it?
- What would you still want a human reviewer to check before merging?

## Try these prompt angles

- "Read sections 2 and 3 of my approved RFC in [path to your RFC]. Propose
  an implementation plan against this codebase before writing any code."
- "Write a test that fails if cart retrieval issues more than one SQL
  query for a cart with N items. Don't change the production code yet — I
  want to see the test fail first."
- "Rewrite this repository method to fetch cart items and their products
  in a single query instead of relying on lazy-loaded navigation
  properties. Explain the trade-offs of `.Include()`/`.ThenInclude()` vs.
  a split query vs. a projection here."
- "Narrow this transaction scope so the database connection is not held
  during the inventory and payment-gateway calls. What has to change for
  lazy loading to still work?"
- "This payment client's retry policy matches the one in our config file.
  Critique it against the incident timeline, then fix it: exponential
  backoff with jitter, honour `Retry-After` on 429, add a circuit
  breaker, and make charges idempotent."
- "Review this diff as a strict code reviewer: does it match this RFC
  scope exactly? Any risk it introduces that isn't mentioned in the RFC?"

## Watch out for

- Accepting a diff without understanding it; you own what gets merged.
- Scope creep: the AI "improving" code beyond what the RFC covers.
- Tests that would still pass even with the original bug present (a weak
  regression test is worse than none, because it looks safe).
- AI-invented library or API usage that doesn't match your actual stack,
  framework version, or internal conventions.
- Treating "tests are green" as proof the fix is complete; also check it
  against the RFC's acceptance criteria and risk section.
