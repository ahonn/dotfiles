# English Rules

These rules add to the core rules in `SKILL.md`. The sections "Sentences", "Verbs", and "Punctuation" are mandatory in each mode. The section "Words" is advisory in prose mode and mandatory in strict mode.

## Contents

- Sentences
- Verbs
- Words
- Punctuation
- Examples

## Sentences

- Keep the articles and the subject. Write "Run the script", not "Run script".
- A pronoun must have one possible antecedent. If "it" or "this" can refer to two nouns, repeat the noun.
- A noun cluster has a maximum of 3 words. This limit is a ceiling, not a target. Keep "session token". Change "session token refresh retry handler" to "the handler that retries the token refresh".
- Do not use a double negative. Write "supported", not "not unsupported".
- For the sentence limit, a code span, a number, a path, or a hyphenated word is one word.

## Verbs

- Use the imperative for an instruction: "Run `nix flake check`." Do not write "You should run" or "The check should be run".
- Use the simple present, the simple past, and the simple future. Keep a compound tense only when the simple tense changes the meaning. "The job has completed" tells the reader that the result is available now.
- Use `must` for a requirement and `can` for an ability. Keep `may` or `might` only as a hedge for real uncertainty.
- Do not use `should` for a requirement, because the reader cannot tell if the step is optional. Use `must` or the imperative. For a recommendation, write "We recommend" and give the reason.
- Replace an informal phrasal verb with one verb. Keep a phrasal verb that is the established technical term: "log in", "roll back", "check out a branch".
- Use the verb for an action, not a noun with a weak verb.

| Do not write | Write |
|---|---|
| spin up, kick off | start |
| figure out | find |
| look into, dive into | examine |
| carry out | do |
| get rid of | remove |
| come up with | propose |
| reach out to | contact |
| perform an analysis of | analyze |
| make a decision | decide |
| provide support for | support |
| carry out the installation of | install |

## Words

Use the short, common word.

| Do not write | Write |
|---|---|
| utilize, leverage | use |
| commence, initiate | start |
| terminate | stop |
| facilitate | help |
| ensure | make sure |
| perform, conduct | do |
| obtain, acquire | get |
| demonstrate | show |
| prior to | before |
| subsequent to | after |
| in order to | to |
| in the event that | if |
| is able to, is capable of | can |
| due to the fact that | because |
| additionally, furthermore, moreover | also |
| regarding, with respect to | about |
| e.g. | for example |
| i.e. | that is |
| etc. | name the items |

Delete these words and phrases:

- Praise without a measurement: seamless, robust, powerful, elegant, comprehensive, cutting-edge.
- Words that hide difficulty: simply, just, easily, obviously.
- Frames: "It is important to note that", "Please note that", "This PR aims to", "As mentioned above", "In conclusion".

More word rules:

- Write contractions in full: "do not", "cannot".
- Follow the spelling that the repository uses. The default is American English.
- Write a date as `2026-10-03`. Give the unit with each number.

## Punctuation

- Do not use a semicolon. Split the sentence, or use a list.
- Do not join two clauses with a dash. Split the sentence, or use a colon.
- Parentheses can contain an identifier, a unit, or a short example. They cannot contain a second sentence.
- Write "A or B", not "A/B". Write "A, B, or both", not "A and/or B".

## Examples

Each rewrite keeps each fact, number, and hedge of the original text.

PR description, prose mode. Before:

```text
This PR aims to address the flaky 401s that users have been seeing by leveraging a more robust approach in `SessionClient` where the session token is proactively refreshed 60 seconds prior to expiry rather than only after a request has already failed; a failed refresh is retried up to 3 times, and the unused `legacyRefresh` helper has also been cleaned up. Tests pass, though this hasn't been checked against the production identity provider.
```

After:

```text
Refresh the session token before it expires, to stop intermittent 401 responses.

Before this change, `SessionClient` refreshed the token only after a request failed.

Changes:

- `SessionClient` refreshes the token 60 seconds before the token expires.
- `SessionClient` tries a failed refresh again, a maximum of 3 times.
- Remove the `legacyRefresh` helper. No caller uses it.

Verification: the tests pass. I did not test with the production identity provider.
```

Procedure, strict mode. Before:

```text
Once the dependencies have been installed with `pnpm install`, `config.example.json` should be copied to `config.json` and then the dev server can be spun up via `pnpm dev`, after which the app will be available on port 3000 (make sure Node 20+ is being used, otherwise the install will fail).
```

After:

```text
Prerequisite: Node.js 20 or later. With an earlier version, the installation fails.

1. Install the dependencies: `pnpm install`
2. Copy `config.example.json` to `config.json`.
3. Start the development server: `pnpm dev`

The application is available on port 3000.
```

Error message, strict mode. The rewrite keeps the hedge, because the cause is not known. Before:

```text
Something went wrong while trying to save, possibly due to permissions or the disk being full.
```

After:

```text
Cannot save. Possible causes: you do not have write permission, or the disk is full.
```
