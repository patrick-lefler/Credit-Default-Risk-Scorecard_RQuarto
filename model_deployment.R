# Model Deployment Script
# Score new credit applications using the trained model

library(tidyverse)
library(tidymodels)

#' Score New Credit Applications
#'
#' @param new_data A dataframe with the same structure as training data
#' @param model_file Path to saved model (RDS file)
#' @return Dataframe with risk scores and classifications
#'
score_applications <- function(new_data, model_file = "outputs/final_model.rds") {
  
  # Load model
  if (!file.exists(model_file)) {
    stop("Model file not found. Please train the model first.")
  }
  
  model <- readRDS(model_file)
  
  # Generate predictions
  predictions <- new_data %>%
    bind_cols(
      predict(model, new_data, type = "prob"),
      predict(model, new_data, type = "class")
    ) %>%
    rename(
      predicted_class = .pred_class,
      prob_no_default = .pred_No,
      prob_default = .pred_Yes
    ) %>%
    mutate(
      # Risk score (0-1000)
      risk_score = round(prob_default * 1000, 0),
      
      # Risk tier classification
      risk_tier = case_when(
        risk_score < 200 ~ "Low Risk",
        risk_score < 400 ~ "Medium-Low Risk",
        risk_score < 600 ~ "Medium Risk",
        risk_score < 800 ~ "Medium-High Risk",
        TRUE ~ "High Risk"
      ),
      
      # Recommended action
      recommendation = case_when(
        risk_score < 200 ~ "Auto-Approve",
        risk_score < 400 ~ "Approve with Standard Terms",
        risk_score < 600 ~ "Manual Review Required",
        risk_score < 800 ~ "Approve with Enhanced Terms",
        TRUE ~ "Decline or Secured Loan Only"
      ),
      
      # Expected loss calculation (simplified)
      lgd = case_when(
        risk_tier == "Low Risk" ~ 0.30,
        risk_tier == "Medium-Low Risk" ~ 0.40,
        risk_tier == "Medium Risk" ~ 0.50,
        risk_tier == "Medium-High Risk" ~ 0.60,
        risk_tier == "High Risk" ~ 0.70
      ),
      expected_loss = prob_default * lgd * loan_amount
    )
  
  return(predictions)
}

#' Generate Risk Report for Applications
#'
#' @param scored_data Output from score_applications()
#' @return Summary statistics
#'
generate_risk_report <- function(scored_data) {
  
  report <- list(
    summary = scored_data %>%
      summarise(
        total_applications = n(),
        avg_risk_score = mean(risk_score),
        median_risk_score = median(risk_score),
        total_requested_amount = sum(loan_amount),
        total_expected_loss = sum(expected_loss),
        loss_rate = total_expected_loss / total_requested_amount
      ),
    
    by_tier = scored_data %>%
      group_by(risk_tier, recommendation) %>%
      summarise(
        count = n(),
        avg_score = mean(risk_score),
        total_amount = sum(loan_amount),
        expected_loss = sum(expected_loss),
        .groups = "drop"
      ) %>%
      arrange(desc(count)),
    
    by_purpose = scored_data %>%
      group_by(loan_purpose) %>%
      summarise(
        count = n(),
        avg_risk_score = mean(risk_score),
        high_risk_pct = mean(risk_tier == "High Risk"),
        .groups = "drop"
      ) %>%
      arrange(desc(avg_risk_score))
  )
  
  return(report)
}

#' Export Scored Applications
#'
#' @param scored_data Output from score_applications()
#' @param output_file Path for CSV export
#'
export_scores <- function(scored_data, output_file = "outputs/scored_applications.csv") {
  
  if (!dir.exists("outputs")) {
    dir.create("outputs")
  }
  
  scored_data %>%
    select(
      customer_id,
      loan_amount,
      risk_score,
      risk_tier,
      prob_default,
      recommendation,
      expected_loss
    ) %>%
    write_csv(output_file)
  
  cat(sprintf("Scores exported to: %s\n", output_file))
}

# Example usage:
if (FALSE) {
  
  # Load new applications
  new_applications <- read_csv("data/new_applications.csv")
  
  # Score applications
  scored <- score_applications(new_applications, "outputs/final_model.rds")
  
  # Generate report
  report <- generate_risk_report(scored)
  
  # View summary
  print(report$summary)
  print(report$by_tier)
  
  # Export results
  export_scores(scored)
  
}

#' Batch Scoring Function for Production
#'
#' @param input_csv Path to CSV with new applications
#' @param output_csv Path for scored output
#' @param model_file Path to model file
#'
batch_score <- function(input_csv, 
                       output_csv = "outputs/scored_applications.csv",
                       model_file = "outputs/final_model.rds") {
  
  cat("=== Batch Scoring System ===\n\n")
  
  # Load data
  cat("Loading applications...\n")
  applications <- read_csv(input_csv, show_col_types = FALSE)
  cat(sprintf("  Loaded %s applications\n", comma(nrow(applications))))
  
  # Score
  cat("\nScoring applications...\n")
  scored <- score_applications(applications, model_file)
  
  # Generate report
  cat("\nGenerating risk report...\n")
  report <- generate_risk_report(scored)
  
  # Print summary
  cat("\n=== Scoring Summary ===\n")
  cat(sprintf("Total Applications: %s\n", comma(report$summary$total_applications)))
  cat(sprintf("Avg Risk Score: %.0f\n", report$summary$avg_risk_score))
  cat(sprintf("Total Requested: %s\n", 
             dollar(report$summary$total_requested_amount)))
  cat(sprintf("Expected Loss: %s (%.2f%%)\n", 
             dollar(report$summary$total_expected_loss),
             report$summary$loss_rate * 100))
  
  cat("\n=== Distribution by Risk Tier ===\n")
  print(report$by_tier)
  
  # Export
  cat("\nExporting results...\n")
  export_scores(scored, output_csv)
  
  cat("\n=== Batch Scoring Complete ===\n")
  
  invisible(scored)
}
