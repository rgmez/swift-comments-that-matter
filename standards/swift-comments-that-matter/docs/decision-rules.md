# Decision Rules

## Pre-Comment Gate

Before writing a comment, ask:

1. Can I improve naming instead?
2. Is there hidden behavior?
3. Are there constraints or risks?
4. Will someone misuse this?

If all answers are "no", do not write a comment.

## Refactor-First Rule

Try these first:
- rename symbols for clarity
- extract smaller functions
- flatten confusing control flow

If readability improves enough, stop there.

## Rewrite Playbook: No -> Bad -> Good -> Best

Use this sequence when reviewing existing comments.

### 1) No Comment

Code may look clean but miss critical context.
Add a comment only if hidden risk or a non-obvious contract exists.

### 2) Bad Comment

Typical anti-patterns:
- paraphrases the implementation
- starts with "This function/method/class..."
- generic text with zero decision context

### 3) Good Comment

Make it useful:
- explain intent or constraint
- mention one concrete risk
- keep it short

### 4) Best Comment

Staff-level quality:
- states intent
- states what must not break
- includes constraint/assumption
- includes reasoning or trade-off

## Output Rule

When generating alternatives, always output all four levels:
- no comment
- bad
- good
- best
