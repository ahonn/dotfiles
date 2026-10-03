# Chinese Rules

STE is an English standard. Its rules for tenses, articles, and phrasal verbs, and its dictionary, do not apply to Chinese. This file gives the Chinese counterpart of each core rule in `SKILL.md`. The counterparts are an adaptation. STE does not define them.

## Contents

- Sentences
- Verbs
- Words
- Punctuation
- Example

## Sentences

Split a comma chain. Chinese permits many clauses in one sentence, with "，" between them. Such a chain hides where one idea stops. A sentence has a maximum of 3 clauses.

| Do not write | Write |
|---|---|
| 我检查了配置文件，发现 `timeout` 设置为 0，这会导致请求立即超时，所以把它改成了 30，然后重新运行测试，全部通过。 | 配置文件中的 `timeout` 是 0，所以请求会立即超时。我把它改成了 30。我重新运行了测试，全部通过。 |

State the subject when the actor changes, and at the start of a paragraph. A report has three actors: "我" (the agent), the system or the code, and "你" (the user). Without a subject, the user cannot tell who did the action or who must do it.

| Do not write | Write |
|---|---|
| 已重启服务，需要重新登录。 | 我重启了服务。你需要重新登录。 |
| 需要运行 `pnpm install` 更新 lockfile。 | 你需要运行 `pnpm install` 来更新 lockfile。 |

Keep the connectives that carry the logic: 因为、所以、但是、如果、否则. Do not replace them with arrows or with a list of bare facts.

Limit a chain of modifiers. One noun phrase has a maximum of two "的".

| Do not write | Write |
|---|---|
| 用于处理登录请求的认证模块的配置文件的路径是 `config/auth.toml`。 | 认证模块处理登录请求。它的配置文件是 `config/auth.toml`。 |

Do not use a double negative. Write "有影响", not "并非没有影响".

## Verbs

Use the verb directly. Remove the weak verbs 进行、做出、加以、予以.

| Do not write | Write |
|---|---|
| 对配置进行了修改 | 修改了配置 |
| 实现了对缓存的清理 | 清理了缓存 |
| 做出了调整 | 调整了 |

Use an active sentence. Use "被" only when the actor is unknown or not important.

| Do not write | Write |
|---|---|
| 文件被脚本删除了。 | 脚本删除了文件。 |

Remove structures that come from word-for-word translation of English.

| Do not write | Write |
|---|---|
| 在 token 过期的情况下 | 如果 token 过期 |
| 回滚是可能的 | 可以回滚 |
| 一个可能的原因是 | 可能的原因是 |
| 值得注意的是 | Delete it |

## Words

One name for one thing:

- Do not rotate a Chinese term and an English term for one concept, such as "回调", "callback", and "回调函数".
- Keep an established technical term in English. Put an identifier in backticks.
- Define an abbreviation where it first occurs.
- Do not use a label that you made during the work. The reader has not seen it.

One hedge at most. Do not stack 可能、大概、似乎、应该. Say which claims you confirmed, which you inferred, and which you did not verify.

| Status | Example |
|---|---|
| Confirmed | 已确认：`timeout` 的值是 0。 |
| Inferred | 推断：缓存没有清理。依据是内存持续增长。 |
| Not verified | 未验证：生产环境的行为。 |

"应该" has two readings: an obligation and an expectation. For an obligation, write "必须" or "需要". For an expectation, write "预计" and say that you did not verify it.

Delete praise without a measurement: 显著、完美、优雅、强大、全面、彻底. Give the measurement, for example "构建时间从 42 秒降到 18 秒".

Delete frames:

- At the start: "好的，我来……", "经过分析发现".
- At the end: "综上所述", "希望这对你有帮助", "如果需要，我可以……".

Use exact values. Write the date as `2026-10-03`, not "昨天". Write the path and the command in backticks.

## Punctuation

- Use full-width punctuation in a Chinese sentence.
- Do not use `；`. Split the sentence, or use a list.
- Do not join two clauses with `——`. Split the sentence.
- Use `、` for a short series in a sentence. Use a list for steps, and for items that need an explanation.

## Example

A report to the user. Before:

```text
好的，我已经对这个问题进行了深入的排查。经过分析发现，问题可能大概是由于 `CacheStore.evict()` 没有对过期条目进行正确的清理所导致的缓存持续增长，于是把过期检查从 `get()` 挪到了 `evict()` 里，现在应该已经可以正常工作了，`pnpm test cache` 也通过了，不过生产数据上的内存占用还没来得及看，整体性能得到了显著提升。如果还有问题可以随时告诉我！
```

After:

```text
原因可能是 `CacheStore.evict()` 没有正确清理过期条目，所以缓存持续增长。我没有确认这个原因。

我把过期检查从 `get()` 移到了 `evict()`。

验证：`pnpm test cache` 通过。我没有检查生产数据上的内存占用。
```

The rewrite makes these changes:

- It removes "性能得到了显著提升", because the original text gives no measurement.
- It keeps one hedge, "可能", and states that the cause is not confirmed.
- It replaces "应该已经可以正常工作" with the test result, which is the evidence.
