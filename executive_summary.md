# RFM Segmentation & Customer Lifetime Value Analysis

**Dataset:** UCI Online Retail · UK Market · 5,350 Customers · £14.7M Revenue · Dec 2010 – Dec 2011

---

## 🎯 The Business Question

> *Which customers are worth fighting for — and what should the business actually do about it?*

Most e-commerce businesses treat all customers the same — same email campaigns, same win-back spend, same level of attention — regardless of whether a customer has spent £50 or £5,000.

This project challenges that assumption.

Using RFM segmentation and Customer Lifetime Value modelling, I classified 5,350 UK customers into seven behaviour-based segments and translated the findings into a prioritised retention strategy — the kind a CRM or marketing team could act on immediately.

---

## ⚙️ Dataset & Methodology

**Tool:** BigQuery (Standard SQL)

**Approach:** RFM scoring → NTILE(5) segmentation → CLV projection → Strategic recommendations

### Key technical decisions

| Decision | Why it matters |
|---|---|
| Reference date: `DATE('2011-12-11')` | Using Dec 1 produced negative recency values for customers who transacted Dec 1–9 — silently corrupting every recency score |
| Cancellations excluded via `NOT STARTS_WITH(Invoice, 'C')` | Including cancellations inflated frequency and monetary values, overstating customer engagement |
| CLV reliability filter: `active_months >= 3` | Prevents a single large order from generating a misleadingly large 12-month projection |
| NTILE(5) scoring | Recency scored descending (recent = good), frequency and monetary scored ascending (more = good) |

---

## 📊 Segment Results

| Segment | Customers | Revenue | % of Revenue | Avg Customer Value |
|---|---|---|---|---|
| 🏆 Champions | 1,194 | £9.80M | 66.8% | £8,238 |
| ⚠️ At Risk | 538 | £2.20M | 14.9% | £4,089 |
| ❌ Lost | 1,495 | £1.20M | 8.2% | £805 |
| 💛 Loyal | 687 | £826K | 5.6% | £1,203 |
| 🌱 Potential Loyalists | 876 | £337K | 2.3% | £385 |
| 🚨 Can't Lose Them | 56 | £182K | 1.2% | £3,242 |
| 💤 Hibernating | 504 | £138K | 0.9% | £274 |

---

## 📌 Section 1 — Business Situation

The data tells a story that should concern any growth-focused business: **this company's revenue is structurally fragile.**

**Three problems stand out immediately:**

**1. Dangerous concentration at the top.**
Just 22% of customers — the Champions segment — generate 66.8% of total revenue. This is not a sign of strength. It means the business is surviving on a small group of loyal buyers, and very little is being done to protect or replace them.

**2. £2.38M is actively walking out the door.**
The At Risk and Can't Lose Them segments together represent customers who were previously among the most valuable in the database — spending at the same rate as Champions — but who have now gone silent for an average of five months. These are not low-quality customers who drifted away. These are high-value buyers whose disengagement has gone unaddressed.

**3. Acquisition is broken, not just retention.**
47% of Lost customers placed only a single order. This is not purely a retention failure — it is an acquisition quality problem. The business is spending budget to acquire customers who never had any intention of returning, and there is no meaningful second-purchase strategy to catch them before they disappear.

> **Bottom line:** The highest ROI opportunity is not more acquisition spend — it is protecting the Champions already in the database and converting the Potential Loyalists who are still warm and reachable.

---

## 🔍 Section 2 — Key Findings

### 🏆 Finding 1 — The business is existentially dependent on Champions

- **1,194 customers → £9.8M → 66.8% of all revenue**
- Average Champion spends **£8,238/year** and purchases frequently
- There is no formal programme protecting them — losing even 10% of Champions would remove nearly **£1M** from the top line immediately

> This is not a healthy revenue distribution. It is a single point of failure.

---

### ⚠️ Finding 2 — £2.38M is at risk right now, and these are Champion-quality buyers

- At Risk customers (538) have an **average AOV of £420** — identical to Champions (£421)
- They have not downgraded. They have not complained. They have simply stopped buying.
- Average inactivity: **~150 days** and counting
- Can't Lose Them (56 customers) average **£3,242 each** — the highest individual value outside of Champions

> These customers did not leave because they were low quality. They left because the business did not notice them leaving.

---

### 🔎 Finding 3 — 47% of Lost customers were never going to stay

- **1,495 customers classified as Lost** — the largest segment by count
- **47% placed only a single order** in the entire 12-month period
- This points to an acquisition strategy problem, not just a retention failure
- No second-purchase trigger exists to catch new buyers before they become one-time transactions

> The highest leverage fix here is not recovering Lost customers — it is preventing the next wave of customers from becoming them.

---

### 🌱 Finding 4 — 876 warm, reachable customers are sitting in the middle

- Potential Loyalists purchased recently — **average recency: 67 days**
- They know the brand, they've bought once, and they are still within reach
- The window for second-purchase conversion is **narrow — typically 30 days post first order**
- After that window closes, recovery cost rises sharply

> This is the highest conversion opportunity in the dataset — and the most time-sensitive.

---

## 💡 Section 3 — Strategic Recommendations

Segments are grouped into three commercial tiers: **protect**, **grow**, and **recover selectively.**

---

### 🔒 Tier 1 — Protect
*Champions & Can't Lose Them*

#### Champions — Build loyalty before churn happens

Champions are not self-managing. Without intervention, attrition in this segment is a matter of *when*, not *if*.

**Recommended actions:**
- Launch a **formal VIP programme** — early product access, exclusive rewards, personalised recommendations, priority service
- Set a **churn early-warning trigger at 60 days inactivity** — intervene before a Champion quietly becomes an At Risk customer
- Focus on **switching cost**, not just incentives — a customer enrolled in a loyalty programme forfeits accumulated value if they leave, which is what converts a transactional relationship into a durable one

#### Can't Lose Them — High-touch, not high-volume

56 customers. Average spend £3,242. Standard email campaigns will not recover these people.

**Recommended actions:**
- **Direct personal outreach** from a customer manager — not an automated sequence
- A **tailored, individual offer** based on their specific purchase history
- The ROI maths are clear: recovering even 50% of this segment at their historical spend rate returns **£90K+**

---

### 📈 Tier 2 — Grow
*Loyal & Potential Loyalists*

#### Loyal — Move them toward Champions

Loyal customers are buying consistently but have not made the jump to Champion-level frequency. The risk of ignoring them is not immediate churn — it is stagnation that slowly drifts toward disengagement.

**Recommended actions:**
- Build a **tiered loyalty structure** that makes progression to VIP status visible and desirable
- Deploy **personalised cross-sell recommendations** — increase purchase frequency through relevance, not discounting
- Avoid margin erosion: loyalty here should be driven by recognition and value, not repeated discount codes

#### Potential Loyalists — The 30-day window

This is the most time-sensitive segment in the entire analysis. Research consistently shows that **second-purchase conversion probability drops sharply after 30 days.**

**Recommended actions:**
- Deploy a **triggered follow-up sequence within 30 days** of first purchase
- Lead with **category-specific product recommendations** ("based on what you bought, you might also like...") rather than a generic discount
- Include a **time-limited incentive** to create urgency without training customers to only buy on promotion
- If this cohort is missed, the path to recovery becomes significantly more expensive

---

### 🔁 Tier 3 — Recover Selectively
*At Risk, Hibernating & Lost*

#### At Risk — Highest ROI recovery opportunity

£2.2M at risk. Champion-quality buyers. The clock is running.

**Recommended actions:**
- Deploy a **personalised win-back campaign triggered at 120–150 days inactivity** — the point at which disengagement is becoming structural
- Reference **specific purchase history**, not generic messaging — "you haven't restocked X" outperforms "we miss you" every time
- Include a **time-limited offer** to create urgency
- Recovering **20% of this segment = £440K+ in recaptured revenue**

#### Hibernating — Last chance before they're gone

**Recommended actions:**
- Run a **short reactivation sequence** — 2–3 targeted emails over 30 days
- Low investment, but more personalised than the approach used for Lost customers
- Goal: prevent transition into the Lost segment before it happens

#### Lost — Control costs, don't over-invest

The honest commercial call: most of these customers were not retainable to begin with.

**Recommended actions:**
- **One low-cost annual reactivation campaign** — no heavy personalisation, no significant spend
- Implement a **sunset strategy**: remove consistently unengaged contacts from active lists after a defined period
- This protects email deliverability, reduces campaign costs, and ensures budget flows toward segments with real recovery potential

---

## ⚠️ Section 4 — Model Limitations

### Limitation 1 — Wholesale & B2B buyers are misclassified

The NTILE(5) frequency scoring system is count-based, not value-based. A wholesale buyer who places **3 orders of £40,000** scores lower on frequency than a consumer who places **25 orders of £50** — and gets pushed into Lost or Hibernating regardless of revenue contribution.

**Example:** Customer 16446 — R=5, F=2, M=5 — spent £168,000 across two orders. Classified as Lost. Likely a wholesale or institutional buyer whose purchasing pattern simply doesn't fit the B2C RFM model.

**Fix:** Any business with a meaningful wholesale segment should apply a **value-weighted override tier** to protect high-spend, low-frequency accounts from misclassification.

---

### Limitation 2 — Scores are relative, not absolute

NTILE scoring produces rankings *within this dataset*, not against universal benchmarks. A customer with an RFM score of 15 is in the top tier relative to this customer base — but that says nothing about how they compare to customers in a different time period or a different industry.

**Segment labels like "Champions" and "Loyal" are positional, not absolute.** They should always be calibrated against hard KPIs — AOV, repeat purchase rate, CLV — when informing budget decisions.

---

### Limitation 3 — CLV projections assume the past predicts the future

The projected 12-month CLV is calculated as `monthly_spend_rate × 12`. This assumes a customer's future behaviour mirrors their historical behaviour.

- For **Champions** — reasonable working assumption
- For **At Risk, Hibernating, and Lost** — likely materially overstated

A customer inactive for 5 months with a projected CLV of £20,000 may deliver **£0** if win-back efforts fail. This analysis uses a simplified extrapolation as a **directional indicator**, not a precise forecast.

---

## 🛠️ Tools & Skills Demonstrated

| Area | Approach |
|---|---|
| Data cleaning | Exclusion of cancellations, NULL filtering, reference date correction |
| RFM scoring | NTILE(5) in BigQuery Standard SQL with CTEs and window functions |
| Segmentation | Custom CASE logic across 7 behavioural segments |
| CLV modelling | AOV × monthly frequency × 12-month projection with reliability flag |
| Visualisation | Power BI — KPI cards, revenue by segment, recency vs monetary scatter, cohort heatmap |
| Business framing | Every metric translated to a commercial recommendation |

---

*Dataset: UCI Machine Learning Repository — Online Retail Dataset*
*Scope: UK customers only · Period: December 2010 – December 2011 · Tool: BigQuery Standard SQL*
