# Credit Risk Scorecard Project - Overview

Leveraging R, Quarto, and tidymodels, this credit risk scorecard project integrates advanced machine learning techniques—including hyperparameter-tuned logistic regression and random forest models—with robust risk management frameworks like Monte Carlo simulations and expected loss calculations. The analysis establishes a five-tier risk classification system and translates complex data into actionable business intelligence through professional visualizations, such as interactive dashboards, ROC curves, and feature importance plots, to drive risk-based recommendations and precise capital requirement estimates.

---

## 📁 Complete File Structure

```
credit_risk_scorecard/
│
├── credit_risk_scorecard.qmd         # Main analysis (200+ lines of comprehensive code)
├── README.md                          # Full documentation
├── setup.R                            # One-click environment setup
├── run_analysis.R                     # Quick start script
├── requirements.txt                   # Package dependencies
├── .gitignore                         # GitHub-ready
│
├── R/
│   ├── generate_credit_data.R        # Synthetic data generator (5,000 records)
│   └── model_deployment.R            # Production scoring functions
│
├── data/                              # Generated after running
│   ├── credit_data.csv
│   ├── train_data.csv
│   └── test_data.csv
│
└── outputs/                           # Rendered reports
    └── credit_risk_scorecard.html
```

---

## How to Use This Project

### Step 1: Setup (First Time Only)
```r
# Open RStudio and run:
source("setup.R")
```

This installs all required packages automatically.

### Step 2: Run Complete Analysis
```r
# Generate data and render report:
source("run_analysis.R")
```

Or do it step-by-step:
```r
# Generate data:
source("R/generate_credit_data.R")

# Then render in RStudio by opening credit_risk_scorecard.qmd 
# and clicking "Render"
```

### Step 3: View Results
Open `credit_risk_scorecard.html` in your browser to see:
- Executive summary with key findings
- Exploratory data analysis with interactive charts
- Model development and comparison
- Risk scorecard with five-tier classification
- Portfolio analytics with Monte Carlo simulation
- Business recommendations

---

## 🔧 Troubleshooting

### If packages won't install:
```r
# Try with dependencies:
install.packages("tidymodels", dependencies = TRUE)

# Or install from source:
install.packages("tidymodels", type = "source")
```

### If Quarto won't render:
- Make sure you have Quarto installed: https://quarto.org/
- Or use RStudio's built-in Quarto (just click "Render")
- Check R version: `getRversion()` should be ≥ 4.0.0

### If data generation fails:
- Check that the data/ folder exists
- Verify tidyverse is loaded: `library(tidyverse)`
- Check for file permissions

---


