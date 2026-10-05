# eCourts: Does Representation Associate with Case Outcomes?

Tested two independent ways on 81M real Indian district court records (2014 subset) — statistical hypothesis testing, then machine learning — to see whether two different methods agree.

## Data
81M district court case records (Development Data Lab, devdatalab.org/judicial-data). Case-type text cleaned via a dbt + Python (rapidfuzz) pipeline — regex normalization, fuzzy-match grouping, human-reviewed crosswalk.

## Phase 1: Statistical Testing

**Method:** Cleaned and canonicalized 842 raw case-type spellings. Excluded case types structurally tied to one gender by legal definition (maintenance, divorce, domestic violence — verified against real case law, not assumed). Ran an independent t-test per remaining case type, comparing disposal time by petitioner gender, controlling for case type rather than a pooled national average.

**Finding:** Across 784 comparable case types, 274 (34.9%) showed a statistically significant difference — far more than the ~39 expected by chance alone. The direction was nearly evenly split: 142 case types favored faster resolution for female petitioners, 132 for male. **Not a uniform, system-wide pattern in either direction — a real, case-type-specific effect.** The most extreme gaps were asymmetric: the biggest female-slower gap reached ~10x; the biggest male-slower gap reached ~2.6x.

## Phase 2: Classification

**Method:** Random Forest classifier predicting case disposal category. Model A used only district, state, year, and case type. Model B added representation fields (petitioner/defendant/advocate gender), with missing and unclear values kept as their own honest category, never merged into 0/1.

**A real debugging finding along the way:** the first two attempts at Model B showed accuracy collapsing (38% to 32% to 28%) and "unclear gender" ranking as a top predictor — which looked like a genuine effect at first. It wasn't. One-hot encoding the representation columns ballooned the feature count from 4 to 20, which diluted Random Forest's per-split feature sampling and crowded out `canonical_type`, the model's actual strongest signal. Switching to label encoding (consistent with how every other categorical column was already handled) restored a fair comparison.

**Finding, once fairly controlled:** accuracy dropped only slightly, 38% to 35%. Representation features showed real but modest importance (0.03-0.08 each) — present, but clearly secondary to case type (0.29) and location (0.31-0.34).

## Combined Conclusion
Two independent methods — statistical and machine learning — converge on the same measured picture: representation is associated with case outcomes in a real, detectable way, but it is not the dominant factor, and it does not show a uniform system-wide direction. This is an association, not a causation claim — case complexity, representation quality, and court assignment could all contribute to any gap found here.

## Limitations
- Single year (2014) only — not yet a multi-year trend
- Structural-case exclusion used a keyword-matching flag, checked by hand against real legal sources for ambiguous cases (e.g., `mjcr` confirmed structural, `gandw` confirmed not), but not exhaustively verified for every case type
- p<0.01 used in Phase 1 as a conservative, informal safeguard against running hundreds of simultaneous tests — a formal Bonferroni correction would be more rigorous
- Phase 2's fair comparison relied on matching total feature count (label encoding over one-hot) rather than a fully rigorous max_features fraction control
- Association only, throughout — no causal claim is made or implied

## Tools
PostgreSQL, dbt (staging, testing), Python (pandas, rapidfuzz, scipy, scikit-learn), Power BI
