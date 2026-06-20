# =============================================================================
# Clinical trial treatment-efficacy analysis: data preparation
# -----------------------------------------------------------------------------
# Source: the rectal indomethacin trial to prevent post-ERCP pancreatitis
# (Elmunzer et al., New England Journal of Medicine 2012), a real randomised,
# placebo-controlled trial. Patient-level data ship in R's `medicaldata` package
# (dataset `indo_rct`).
#
# 602 high-risk patients undergoing ERCP were randomised to a single dose of
# rectal indomethacin or placebo. Primary endpoint: post-ERCP pancreatitis (PEP).
#
# This script selects and relabels the analysis variables and writes a tidy CSV
# plus a data dictionary used by the R Markdown analysis.
# =============================================================================
suppressMessages({library(medicaldata); library(dplyr)})

d <- indo_rct

clean <- d |>
  transmute(
    id        = id,
    site      = factor(site, labels = c("UM", "IU", "UK", "Case")),
    rx        = factor(rx, levels = c("0_placebo", "1_indomethacin"),
                       labels = c("Placebo", "Indomethacin")),
    prior_pep = factor(pep, levels = c("0_no", "1_yes"),
                       labels = c("No", "Yes")),           # history of prior PEP
    pep       = factor(outcome, levels = c("0_no", "1_yes"),
                       labels = c("No", "Yes")),          # PRIMARY ENDPOINT
    pep_event = as.integer(outcome == "1_yes"),
    age       = age,
    gender    = factor(gender, levels = c("1_female", "2_male"),
                       labels = c("Female", "Male")),
    risk      = risk,                                      # composite risk score
    risk_group= factor(ifelse(risk > 2.5, "Higher risk (>2.5)",
                                          "Lower risk (<=2.5)"),
                       levels = c("Lower risk (<=2.5)", "Higher risk (>2.5)")),
    sod       = factor(sod, levels = c("0_no", "1_yes"), labels = c("No", "Yes")),
    psphinc   = factor(psphinc, levels = c("0_no", "1_yes"), labels = c("No", "Yes")),
    precut    = factor(precut, levels = c("0_no", "1_yes"), labels = c("No", "Yes")),
    difcan    = factor(difcan, levels = c("0_no", "1_yes"), labels = c("No", "Yes")),
    train     = factor(train, levels = c("0_no", "1_yes"), labels = c("No", "Yes"))
  )

stopifnot(nrow(clean) == 602, sum(is.na(clean)) == 0)
write.csv(clean, "data/indo_clean.csv", row.names = FALSE)

dict <- tibble::tribble(
  ~variable,    ~description,
  "id",         "Patient identifier",
  "site",       "Enrolling centre (UM, IU, UK, Case)",
  "rx",         "Randomised treatment: Placebo or Indomethacin",
  "pep",        "PRIMARY ENDPOINT: post-ERCP pancreatitis (No/Yes)",
  "pep_event",  "Primary endpoint as 0/1 (1 = pancreatitis occurred)",
  "age",        "Age in years",
  "gender",     "Female / Male",
  "risk",       "Composite pre-procedure risk score (higher = greater PEP risk)",
  "risk_group", "Risk score split at the value 2.5 (lower vs higher)",
  "prior_pep",  "History of prior post-ERCP pancreatitis (risk factor)",
  "sod",        "Sphincter of Oddi dysfunction (risk factor)",
  "psphinc",    "Pancreatic sphincterotomy performed (risk factor)",
  "precut",     "Precut sphincterotomy performed (risk factor)",
  "difcan",     "Difficult cannulation (risk factor)",
  "train",      "Trainee involved in the procedure"
)
write.csv(dict, "data/data_dictionary.csv", row.names = FALSE)

cat("Wrote data/indo_clean.csv (", nrow(clean), "patients ) and data_dictionary.csv\n")
cat("Randomisation:\n"); print(table(clean$rx))
cat("Primary endpoint (PEP) by arm:\n"); print(table(clean$rx, clean$pep))
