# Credit Default Risk Scorecard

A comprehensive predictive modeling project demonstrating advanced risk analytics and data visualization using R, Quarto, and tidymodels.

## 🎯 Project Overview

This project showcases:
- **Machine Learning**: Logistic regression and random forest models with hyperparameter tuning
- **Risk Analytics**: Credit scorecard development, portfolio loss estimation, Monte Carlo simulation
- **Data Visualization**: Interactive dashboards with plotly, professional-grade charts
- **Business Intelligence**: Risk-based recommendations and capital requirement calculations

## 📊 Key Features

### Predictive Modeling
- Tidymodels workflow with cross-validation
- SMOTE for class imbalance handling
- Feature engineering (interactions, normalization)
- Model comparison and selection

### Risk Management
- Five-tier risk classification system
- Expected loss calculations (PD × LGD × EAD)
- Value-at-Risk (VaR) and Expected Shortfall
- Portfolio optimization scenarios

### Visualizations
- ROC curves and calibration plots
- Feature importance and partial dependence plots
- Interactive risk dashboards
- Monte Carlo simulation results

## 🚀 Quick Start

### Prerequisites

Install R (≥4.0.0) and RStudio, then install required packages:

```r
# Install required packages
install.packages(c(
  "tidyverse",      # Data manipulation and visualization
  "tidymodels",     # Machine learning framework
  "themis",         # SMOTE for class imbalance
  "vip",            # Variable importance
  "plotly",         # Interactive visualizations
  "knitr",          # Report generation
  "kableExtra",     # Enhanced tables
  "scales",         # Scale functions
  "patchwork",      # Combining plots
  "ggridges",       # Ridge plots
  "pdp",            # Partial dependence plots
  "quarto"          # Document rendering
))
```

### Running the Analysis

1. **Generate Data**
```r
source("R/generate_credit_data.R")
```

2. **Render Report**
```r
# In RStudio: Click "Render" button
# Or from terminal:
quarto render credit_risk_scorecard.qmd
```

The rendered HTML report will be saved in the same directory.

## 📁 Project Structure

```
credit_risk_scorecard/
├── credit_risk_scorecard.qmd    # Main Quarto analysis document
├── README.md                     # This file
├── requirements.txt              # R package list
├── data/
│   ├── credit_data.csv          # Full dataset
│   ├── train_data.csv           # Training set
│   └── test_data.csv            # Test set
├── R/
│   └── generate_credit_data.R   # Data generation script
└── outputs/                      # Generated reports (after rendering)
```

## 📈 Dataset

**Synthetic credit application data** (5,000 observations):

### Features
- **Demographics**: Age, income, employment length
- **Credit History**: Credit history length, number of credit lines, delinquencies
- **Loan Characteristics**: Amount, interest rate, term, purpose
- **Financial Ratios**: Debt-to-income, credit utilization, payment-to-income
- **Categorical**: Housing status, loan purpose

### Target Variable
- Binary default indicator (Yes/No)
- Default rate: ~15-20%

## 🎓 Technical Highlights

### Machine Learning Techniques
- **Regularization**: LASSO logistic regression with tuned penalty
- **Ensemble Methods**: Random forest with 500 trees
- **Resampling**: 5-fold stratified cross-validation
- **Preprocessing**: SMOTE, normalization, one-hot encoding

### Risk Analytics
- **Probability of Default (PD)**: From ML model predictions
- **Loss Given Default (LGD)**: Risk-tier based assumptions (30-70%)
- **Exposure at Default (EAD)**: Loan amounts
- **Expected Loss**: PD × LGD × EAD aggregation

### Visualization Techniques
- Ridge density plots for feature distributions
- Interactive ROC and calibration curves
- Heatmaps for correlation and confusion matrices
- Partial dependence plots for model interpretation

## 💼 Business Applications

### For Risk Managers
- Automated credit decisioning framework
- Portfolio monitoring and stress testing
- Capital requirement estimation
- Risk-based pricing recommendations

### For Data Scientists
- End-to-end ML workflow demonstration
- Model validation and performance metrics
- Feature engineering best practices
- Production-ready R code

### For Executives
- Clear risk stratification (5-tier system)
- Expected loss and VaR calculations
- Scenario analysis for strategic planning
- ROI-driven recommendations

## 📊 Key Results

The analysis produces:
- **Model Performance**: ~0.85+ AUC on test set
- **Risk Tiers**: Five-level classification (Low to High risk)
- **Portfolio Metrics**: Expected loss, VaR, capital requirements
- **Recommendations**: Risk-based approval and pricing strategies

## 🔧 Customization

### Modify Risk Parameters
Edit `LGD assumptions` in the Quarto document:
```r
lgd_assumptions <- tibble(
  risk_tier = c("Low Risk", "Medium-Low Risk", "Medium Risk", 
                "Medium-High Risk", "High Risk"),
  lgd_rate = c(0.30, 0.40, 0.50, 0.60, 0.70)  # Adjust these
)
```

### Change Model Specifications
Tune different hyperparameters:
```r
rf_spec <- rand_forest(
  mtry = tune(),
  trees = 1000,  # Increase trees
  min_n = tune()
)
```

### Add New Features
Extend the data generation script with additional variables:
```r
credit_data <- tibble(
  # ... existing features ...
  new_feature = your_data_here
)
```

## 📚 Learning Resources

This project demonstrates concepts from:
- **Statistical Learning**: Classification, regularization, ensemble methods
- **Risk Management**: Credit risk modeling, Basel framework, stress testing
- **Data Science**: Feature engineering, model validation, visualization

Recommended reading:
- "Applied Predictive Modeling" by Kuhn & Johnson
- "Credit Risk Analytics" by Baesens et al.
- Tidymodels documentation: https://www.tidymodels.org/

## 🤝 Contributing

This is a portfolio/demonstration project. Feel free to:
- Fork and adapt for your own use case
- Extend with additional models (XGBoost, neural networks)
- Add time-series analysis for vintage performance
- Integrate with Shiny for interactive dashboards

## 📄 License

This project is provided as-is for educational and portfolio purposes.

## 👤 Author

Created to demonstrate risk analytics and data visualization capabilities for fintech applications.

## 🔍 Keywords

Credit Risk, Machine Learning, Tidymodels, Risk Scorecard, Portfolio Analytics, Monte Carlo Simulation, Data Visualization, Quarto, R Programming, Predictive Modeling, Financial Risk Management

---

**Note**: This uses synthetic data generated for demonstration purposes. For production use, integrate with actual credit bureau data and regulatory requirements.
