# Quick Start Script - Run Complete Analysis
# This script generates data and renders the full report

cat("=== Credit Risk Scorecard - Quick Start ===\n\n")

# 1. Load required libraries
cat("Loading libraries...\n")
suppressPackageStartupMessages({
  library(tidyverse)
  library(tidymodels)
})

# 2. Generate synthetic data
cat("Generating synthetic credit data...\n")
if (!dir.exists("data")) {
  dir.create("data")
}

source("R/generate_credit_data.R")

# 3. Check if Quarto is available
quarto_available <- system("quarto --version", 
                          ignore.stdout = TRUE, 
                          ignore.stderr = TRUE) == 0

# 4. Render the report
if (quarto_available) {
  cat("\nRendering Quarto report...\n")
  system("quarto render credit_risk_scorecard.qmd")
  
  cat("\n=== Analysis Complete! ===\n")
  cat("\nThe report has been generated:\n")
  cat("  credit_risk_scorecard.html\n\n")
  cat("Open it in your browser to view the results.\n")
  
  # Optionally open in browser
  if (interactive()) {
    answer <- readline("Open report in browser? (y/n): ")
    if (tolower(answer) == "y") {
      browseURL("credit_risk_scorecard.html")
    }
  }
} else {
  cat("\n=== Quarto CLI not found ===\n")
  cat("Please render the document using one of these methods:\n")
  cat("1. Open credit_risk_scorecard.qmd in RStudio and click 'Render'\n")
  cat("2. Install Quarto CLI from: https://quarto.org/docs/get-started/\n")
  cat("\nData has been generated successfully in the 'data' folder.\n")
}

# 5. Display summary statistics
cat("\n=== Data Summary ===\n")
train_data <- read_csv("data/train_data.csv", show_col_types = FALSE)

cat(sprintf("Total observations: %s\n", comma(nrow(train_data))))
cat(sprintf("Default rate: %.2f%%\n", mean(train_data$default == "Yes") * 100))
cat(sprintf("Average loan amount: %s\n", 
           dollar(mean(train_data$loan_amount))))
cat(sprintf("Average income: %s\n", 
           dollar(mean(train_data$income))))
