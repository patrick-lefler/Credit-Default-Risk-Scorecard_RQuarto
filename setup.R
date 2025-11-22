# Setup Script for Credit Risk Scorecard Project
# Run this script once to set up your environment

cat("=== Credit Risk Scorecard Setup ===\n\n")

# Check R version
r_version <- getRversion()
cat(sprintf("R version: %s\n", r_version))

if (r_version < "4.0.0") {
  warning("This project requires R >= 4.0.0. Please upgrade R.")
}

# List of required packages
required_packages <- c(
  "tidyverse",
  "tidymodels",
  "themis",
  "vip",
  "plotly",
  "knitr",
  "kableExtra",
  "scales",
  "patchwork",
  "ggridges",
  "pdp"
)

# Check which packages are already installed
installed <- installed.packages()[, "Package"]
to_install <- required_packages[!required_packages %in% installed]

# Install missing packages
if (length(to_install) > 0) {
  cat("\nInstalling missing packages:\n")
  cat(paste("-", to_install, collapse = "\n"), "\n\n")
  
  install.packages(to_install, 
                   dependencies = TRUE,
                   repos = "https://cloud.r-project.org/")
  
  cat("\nPackage installation complete!\n")
} else {
  cat("\nAll required packages are already installed.\n")
}

# Verify installation
cat("\nVerifying package installation:\n")
success <- TRUE

for (pkg in required_packages) {
  tryCatch({
    library(pkg, character.only = TRUE, quietly = TRUE)
    cat(sprintf("✓ %s\n", pkg))
  }, error = function(e) {
    cat(sprintf("✗ %s - ERROR: %s\n", pkg, e$message))
    success <<- FALSE
  })
}

if (success) {
  cat("\n=== Setup Complete! ===\n")
  cat("\nNext steps:\n")
  cat("1. Run: source('R/generate_credit_data.R')\n")
  cat("2. Render the Quarto document: quarto render credit_risk_scorecard.qmd\n")
  cat("   (or click 'Render' in RStudio)\n")
} else {
  cat("\n=== Setup Failed ===\n")
  cat("Please fix the errors above and try again.\n")
}

# Check if Quarto is installed
if (system("quarto --version", ignore.stdout = TRUE, ignore.stderr = TRUE) != 0) {
  cat("\nNote: Quarto CLI not found. Install from: https://quarto.org/docs/get-started/\n")
  cat("(RStudio includes Quarto, so you can render from RStudio IDE)\n")
}
