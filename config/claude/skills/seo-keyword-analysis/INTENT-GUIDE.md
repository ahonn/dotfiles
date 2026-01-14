# Search Intent Classification Guide

Deep reference for classifying keyword search intent.

## The Four Intent Types

### 1. Informational Intent

User wants to **learn** something.

**Signal Words**:
- how to, what is, why does, when to
- guide, tutorial, examples, tips
- definition, meaning, explained

**Examples**:
- "how to improve SEO"
- "what is keyword difficulty"
- "React hooks tutorial"

**Best Content**:
- Blog posts with depth
- How-to guides
- Educational content pages
- Video tutorials

**Monetization**: Harder to monetize directly. Use for:
- Building authority
- Email list building
- Soft product mentions

---

### 2. Commercial Intent

User is **researching** before a purchase decision.

**Signal Words**:
- best, top, review, vs, comparison
- alternative to, like [product]
- pros and cons, should I

**Examples**:
- "best AI headshot generator"
- "Ahrefs vs SEMrush"
- "Notion alternatives"

**Best Content**:
- Comparison pages
- Review roundups
- "Best X for Y" lists
- Detailed product reviews

**Monetization**: High value
- Affiliate links
- Lead generation
- Direct sales (if your product is compared)

---

### 3. Transactional Intent

User is **ready to act** (buy, sign up, download, use).

**Signal Words**:
- buy, price, discount, deal, coupon
- free, download, generator, tool
- sign up, login, order

**Examples**:
- "buy domain name"
- "free profile picture generator"
- "Headshot Pro pricing"

**Best Content**:
- Landing pages
- Free tools
- Pricing pages
- Product pages

**Monetization**: Highest conversion
- Direct sales
- Freemium conversion
- Paid tool access

---

### 4. Navigational Intent

User wants to **find a specific site/page**.

**Signal Words**:
- [brand name]
- [product] login
- [company] official site

**Examples**:
- "GitHub login"
- "Stripe documentation"
- "Claude AI"

**Best Content**:
- Only pursue if it's YOUR brand
- Brand protection
- Competitor brand bidding (risky)

**Monetization**: Limited unless it's your brand

---

## Intent Modifiers Quick Reference

| Modifier | Primary Intent | Secondary |
|----------|---------------|-----------|
| how to | Informational | - |
| what is | Informational | - |
| best | Commercial | Transactional |
| vs / versus | Commercial | - |
| review | Commercial | Informational |
| free | Transactional | Commercial |
| generator | Transactional | - |
| tool | Transactional | Commercial |
| buy | Transactional | - |
| price / pricing | Transactional | Commercial |
| alternative | Commercial | - |
| examples | Informational | Commercial |
| template | Transactional | Informational |

---

## Mixed Intent Keywords

Some keywords have multiple intents. Analyze SERP to determine dominant intent.

**Example**: "AI headshot generator"
- Could be Informational (what is it?)
- Could be Commercial (which one is best?)
- Could be Transactional (I want to use one)

**SERP shows**: Mostly tools and landing pages → **Transactional**

**Strategy**: Match the dominant SERP intent, or find angle for underserved intent.

---

## Intent Evolution

User intent for keywords can shift over time:

1. **New technology**: Informational → Commercial → Transactional
2. **Maturing market**: Transactional → Commercial (more comparison shopping)
3. **Commoditization**: Commercial → Transactional (direct to cheapest)

**Monitor monthly**: Check if SERP composition changes (blog posts vs landing pages ratio).

---

## Content Type Mapping

| Intent | Primary Content | Secondary |
|--------|----------------|-----------|
| Informational | Blog, Guide | Content Page |
| Commercial | Comparison, Review | Content Page |
| Transactional | Landing Page, Tool | Free Tool |
| Navigational | Homepage | - |

---

## Decision Tree

```
Keyword Analysis
│
├─ Contains "how/what/why/guide"?
│  └─ YES → Informational
│
├─ Contains "best/vs/review/alternative"?
│  └─ YES → Commercial
│
├─ Contains "free/buy/generator/tool/price"?
│  └─ YES → Transactional
│
├─ Contains brand name?
│  └─ YES → Navigational
│
└─ None of above?
   └─ Check SERP → Match dominant content type
```
