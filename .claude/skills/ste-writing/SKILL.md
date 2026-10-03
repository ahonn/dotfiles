---
name: ste-writing
description: Write or rewrite prose that a reader must act on, such as reports to the user, PR descriptions, and documentation, with ASD-STE100-derived rules that give each sentence one reading.
argument-hint: "[file_path or text to rewrite]"
---

# STE Writing

ASD-STE100 (Simplified Technical English) is the controlled language of aircraft maintenance manuals. It removes the two main causes of misreading: a word with more than one meaning, and a sentence with more than one structure.

This skill applies that discipline to two readers. The user reads a report and must decide or act on it. An external reader of a PR or a document does not have the conversation and cannot ask the author.

The rules are derived from STE. They do not make a text STE-compliant, because compliance needs the official dictionary from asd-ste100.org. Do not claim compliance.

## Scope

| Text | Apply |
|---|---|
| Report, finding, summary, plan, or explanation for the user | Core rules, report order |
| PR description, commit body, issue, review comment | Core rules, PR order |
| README, guide, reference page | Core rules, documentation order |
| Procedure, runbook, migration steps, error message, warning | Core rules in strict mode |
| Code, identifiers, commands, log output, quoted text | No change |
| Marketing copy, blog post, text where voice is the point | Out of scope |

This skill does not select the language. Before you draft, read the reference for the language of the text:

- English: [references/english.md](references/english.md)
- Chinese: [references/chinese.md](references/chinese.md)

The user's instructions, a repository template, a project style guide, and a required format take precedence over this skill. Apply the skill to what they leave open.

## Meaning Comes First

A text that obeys each rule and changes the meaning is a failure. Do not do these things to satisfy a rule:

- Do not change or remove a fact, a number, a condition, or a scope qualifier.
- Do not remove or strengthen a hedge. "The request may have failed" does not mean "The request failed".
- Do not invent an actor to remove a passive.
- Do not replace a precise term with a plain word that has a different meaning.
- Do not add a cause, a number, or a mechanism that you did not observe.

When a rule and precision conflict, keep the precise wording.

The rules correct the form of a text. They do not supply content. If a paragraph has nothing to say, delete the paragraph.

## Core Rules

| Rule | Do | Do not |
|---|---|---|
| One name for one thing | Select one term and use it each time | Rotate "check", "verify", and "validate" for one action |
| One idea in each sentence | "Open the file. Read line 3." | "Open the file and read line 3, then compare it." |
| Name the actor | "The server deletes the file." | "The file is deleted." |
| Verb, not noun | "Analyze the log." | "Perform an analysis of the log." |
| Keep the structure words | Keep the subject, the connective, and the condition | Fragments, arrows in place of verbs, labels that the reader never saw |
| One hedge at most | "The cache is probably stale. I did not confirm this." | "It may potentially be possible that the cache could be stale." |
| Measurement, not praise | "The build time decreases from 42 s to 18 s." | "The build is significantly faster." |
| Condition before instruction | "If the test fails, run the test again." | "Run the test again if it fails." |
| One topic in each paragraph | A maximum of 6 sentences | One paragraph for the cause, the fix, and the follow-up |
| List for a sequence | A numbered list for 3 or more steps | A sequence in one sentence |
| No frame around the content | Start with the content. Stop when it is complete. | A preamble, a recap, a closing offer |

A passive is correct when the actor is unknown or not important.

Do not make a text shorter than its meaning permits. The goal is one reading, not the minimum number of words.

## Modes and Limits

Prose mode is the default. Use strict mode for a procedure, an error message, or a warning. Strict mode adds these requirements:

- Each sentence gives one instruction.
- Each instruction uses the imperative.
- The word rules in the language reference are mandatory, not advisory.

| Limit | English | Chinese |
|---|---|---|
| Sentence, prose mode | 25 words | 40 units |
| Sentence, strict mode | 20 words | 32 units |
| Clauses in a sentence | No limit | 3 |
| Sentences in a paragraph | 6 | 6 |
| Semicolons | 0 | 0 |

One unit is one Chinese character, or one Latin word, number, or code span. The Chinese limits are a scaled equivalent of the English limits. STE does not define them.

## Order

Each list gives an order, not a template. Do not add headings to a short text.

Report to the user:

1. The conclusion, or the decision that the user must make.
2. The evidence: what you observed, with the path, the command, or the output.
3. What you verified and what you did not verify.
4. The next action, if there is one.

PR description. If the repository has a PR template, follow the template.

1. What changes for the caller or the user, and why.
2. The decisions that a reviewer cannot infer from the diff.
3. The verification: each command and its result.
4. What you did not verify, and the known risks.

Describe the change. Do not tell the story of the session that made it.

Documentation:

- Before you write a section, classify it as a procedure or a description.
- For a procedure, write numbered steps with one action in each step. Put a warning before the step that it applies to.
- If the reader cannot see that a step succeeded, state the expected result.
- For a description, use the present tense.
- Define a term where it first occurs. Then keep that term.

## Workflow

For new text, apply the rules while you draft. Do not write a dense draft and then clean it.

For a rewrite of existing text:

1. Read the text one time for its meaning.
2. Rewrite one sentence at a time.
3. Return only the rewritten text.
4. If you kept wording that breaks a rule, add a line that starts with `Kept:` and gives the reason.

Show a table of the changes only when the user asks for one. If the text already obeys the rules, say so and change nothing.

## Check

Before you deliver a PR description or documentation, run the linter. For a chat reply, apply the limits by inspection.

```bash
python3 scripts/ste_lint.py FILE            # prose mode, or read stdin without FILE
python3 scripts/ste_lint.py --strict FILE   # procedures and error messages
```

The linter counts. It reports sentence length, semicolons, dashes that join clauses, comma chains in Chinese, and paragraph length. It does not check code blocks, tables, headings, or block quotes. It reports the line where the paragraph starts. It cannot judge word choice, voice, or hedges.

Correct each reported sentence directly. Do not repeat the full rewrite, because a second pass replaces correct terms with synonyms.

Then ask these questions:

- Can a reader who has only this text act on it?
- Does each thing have one name?
- Does the text show which claims you verified?
