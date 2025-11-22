# Generate Synthetic Credit Default Dataset
# This creates realistic credit data with controlled default patterns

set.seed(42)
library(tidyverse)

n <- 5000

# Generate features with realistic distributions
credit_data <- tibble(
  customer_id = 1:n,
  
  # Demographics
  age = round(rnorm(n, 45, 12)),
  income = exp(rnorm(n, 10.5, 0.8)) * 1000,  # Log-normal distribution
  employment_length = pmax(0, round(rnorm(n, 8, 5))),
  
  # Credit history
  credit_history_length = pmax(0, round(rnorm(n, 12, 6))),
  num_credit_lines = rpois(n, 4),
  num_delinquencies = rpois(n, 0.5),
  
  # Loan characteristics
  loan_amount = exp(rnorm(n, 9.8, 0.7)) * 1000,
  interest_rate = rnorm(n, 12, 4),
  loan_term = sample(c(36, 60), n, replace = TRUE, prob = c(0.7, 0.3)),
  
  # Financial ratios
  debt_to_income = rnorm(n, 0.35, 0.15),
  credit_utilization = pmin(1, pmax(0, rnorm(n, 0.45, 0.25))),
  
  # Payment behavior
  payment_to_income = rnorm(n, 0.15, 0.08),
  
  # Purpose
  loan_purpose = sample(
    c("debt_consolidation", "home_improvement", "business", "other"),
    n, replace = TRUE, prob = c(0.5, 0.2, 0.15, 0.15)
  ),
  
  # Housing
  housing_status = sample(
    c("mortgage", "rent", "own"),
    n, replace = TRUE, prob = c(0.5, 0.35, 0.15)
  )
) %>%
  mutate(
    # Ensure realistic bounds
    age = pmax(18, pmin(80, age)),
    income = pmax(15000, pmin(250000, income)),
    employment_length = pmin(40, employment_length),
    interest_rate = pmax(5, pmin(25, interest_rate)),
    debt_to_income = pmax(0, pmin(0.8, debt_to_income)),
    credit_utilization = pmax(0, pmin(1, credit_utilization)),
    payment_to_income = pmax(0.05, pmin(0.4, payment_to_income))
  )

# Generate default probability based on risk factors
credit_data <- credit_data %>%
  mutate(
    # Calculate risk score components
    risk_score = 
      # Higher DTI = higher risk
      (debt_to_income - 0.35) * 3 +
      # Higher utilization = higher risk  
      (credit_utilization - 0.45) * 2 +
      # More delinquencies = higher risk
      num_delinquencies * 0.8 +
      # Lower income = higher risk
      -(log(income) - 10.5) * 0.5 +
      # Shorter credit history = higher risk
      -(credit_history_length - 12) * 0.05 +
      # Higher interest rate = higher risk (reflects risk assessment)
      (interest_rate - 12) * 0.1 +
      # Higher payment to income = higher risk
      (payment_to_income - 0.15) * 2 +
      # Add some noise
      rnorm(n, 0, 0.5),
    
    # Convert to probability
    default_prob = 1 / (1 + exp(-risk_score)),
    
    # Generate actual defaults
    default = rbinom(n, 1, default_prob),
    default = factor(default, levels = c(0, 1), labels = c("No", "Yes"))
  ) %>%
  select(-risk_score, -default_prob)

# Split into train/test
set.seed(123)
train_idx <- sample(1:n, size = 0.7 * n)

train_data <- credit_data[train_idx, ]
test_data <- credit_data[-train_idx, ]

# Save datasets
write_csv(credit_data, "/home/claude/credit_risk_scorecard/data/credit_data.csv")
write_csv(train_data, "/home/claude/credit_risk_scorecard/data/train_data.csv")
write_csv(test_data, "/home/claude/credit_risk_scorecard/data/test_data.csv")

cat("Data generation complete!\n")
cat(sprintf("Total observations: %d\n", n))
cat(sprintf("Training set: %d\n", nrow(train_data)))
cat(sprintf("Test set: %d\n", nrow(test_data)))
cat(sprintf("Default rate: %.2f%%\n", mean(credit_data$default == "Yes") * 100))
