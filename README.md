# Treatment Efficacy Analysis of a Randomised Trial

A clinical-trial **treatment-efficacy analysis** in **R**: does a single dose of
rectal indomethacin prevent pancreatitis after ERCP? Built from a real,
published randomised, placebo-controlled trial, this project quantifies the
effect the way a clinical journal reports it: absolute and relative risk
reduction, odds ratio, **number needed to treat (NNT)**, and a subgroup analysis.

> Indomethacin roughly halved the risk of post-ERCP pancreatitis, from 16.9% on
> placebo to 9.2% (relative risk 0.54, 95% CI 0.35 to 0.84; P = 0.007). The
> absolute risk reduction of 7.8 percentage points gives a **number needed to
> treat of 13**. The effect held after adjustment (adjusted OR 0.45, 95% CI 0.27
> to 0.74) and was consistent across every subgroup.

---

## Read the report

**[Full report (HTML)](https://kingsley-amg.github.io/clinical-trial-efficacy/)**,
with the baseline table, effect sizes, an adjusted-odds forest plot and a
subgroup forest plot, plus a plain-English explanation under every figure. A
**PDF version** is in [`report/`](report/).

## The question

A trial can show not only *whether* a treatment works but *how much* it helps, in
units a clinician and patient can act on. This analysis estimates the size of the
benefit, tests whether it survives adjustment for baseline risk, and asks whether
it is consistent across patient types.

## What it does

1. **Baseline balance** (Table 1, gtsummary): confirms the arms were comparable,
   as randomisation should deliver.
2. **Primary efficacy**: event rates by arm, the absolute risk reduction,
   relative risk, relative risk reduction, odds ratio and **number needed to
   treat**, each with 95% confidence intervals, plus a chi-square test.
3. **Adjusted analysis**: a logistic-regression model with an adjusted-odds-ratio
   forest plot, showing the effect is independent of baseline risk factors.
4. **Subgroup analysis**: the relative risk within pre-specified subgroups, a
   subgroup forest plot, and formal interaction (effect-modification) tests.

## Key findings

| Measure | Value |
|---|---|
| Pancreatitis, placebo vs indomethacin | 16.9% vs 9.2% |
| Absolute risk reduction | 7.8 percentage points (95% CI 2.5 to 13.1) |
| Relative risk | 0.54 (95% CI 0.35 to 0.84) |
| Number needed to treat | 13 (95% CI 8 to 41) |
| Adjusted odds ratio | 0.45 (95% CI 0.27 to 0.74), P = 0.002 |
| Subgroup consistency | benefit in every subgroup, no significant interaction |

## Recommendation

Because the benefit is large, robust to adjustment, consistent across subgroups,
and the intervention is inexpensive and single-dose, the results support routine
prophylactic rectal indomethacin for patients at high risk of post-ERCP
pancreatitis.

## Structure

```
clinical-trial-efficacy/
|- 01_prepare.R           # load + relabel the trial data, write tidy CSV + dictionary
|- efficacy_analysis.Rmd  # the full analysis (source)
|- data/                  # indo_clean.csv + data_dictionary.csv
|- docs/index.html        # knitted HTML report (GitHub Pages)
|- report/                # PDF version
```

## Reproduce

```r
install.packages(c("medicaldata","dplyr","forcats","broom",
                   "gtsummary","ggplot2","scales","rmarkdown"))
Rscript 01_prepare.R
rmarkdown::render("efficacy_analysis.Rmd")
```

## Data and tools

R, with dplyr, gtsummary, broom and ggplot2. Data: the `indo_rct` dataset in the
**medicaldata** package, the patient-level data from a real randomised,
placebo-controlled trial of rectal indomethacin for preventing post-ERCP
pancreatitis (Elmunzer et al., New England Journal of Medicine, 2012).

## Honest limitations

The trial enrolled high-risk patients, so the absolute benefit and NNT apply to
that population and would be smaller in average-risk patients. The bleeding safety
endpoint was too sparsely recorded in this dataset to analyse, so this report
addresses efficacy only. Subgroup analyses are exploratory and have limited power.

## Author

**Kingsley Amegah**, Health Data Scientist. GitHub: [@Kingsley-amg](https://github.com/Kingsley-amg)
