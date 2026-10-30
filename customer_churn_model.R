# Customer churn prediction model

# Load data
raw_data <- read.csv(
  "data.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", "N/A", "n/a", "")
)

# Clean target label
raw_data$Buyers.Manual.scorring <- as.character(raw_data$Buyers.Manual.scorring)
raw_data <- raw_data[!is.na(raw_data$Buyers.Manual.scorring) &
                     raw_data$Buyers.Manual.scorring %in% c("A", "B"), ]
raw_data$churn <- ifelse(raw_data$Buyers.Manual.scorring == "B", 1, 0)

# Prepare feature columns
feature_cols <- setdiff(names(raw_data), c("Vendor.ID", "Buyers.Manual.scorring", "churn"))
for (col in feature_cols) {
  raw_data[[col]] <- suppressWarnings(as.numeric(as.character(raw_data[[col]])))
}

# Remove rows with missing values in features or target
model_data <- raw_data[complete.cases(raw_data[c(feature_cols, "churn")]), ]

# Train/test split
set.seed(42)
train_idx <- sample.int(nrow(model_data), size = floor(0.75 * nrow(model_data)))
train_data <- model_data[train_idx, ]
test_data  <- model_data[-train_idx, ]

# Fit logistic regression model
formula_text <- paste("churn ~", paste(feature_cols, collapse = " + "))
model_formula <- as.formula(formula_text)
model <- glm(model_formula, data = train_data, family = binomial())

# Predict
probabilities <- predict(model, newdata = test_data, type = "response")
predicted_labels <- ifelse(probabilities >= 0.5, 1, 0)

# Metrics
confusion_matrix <- table(Actual = test_data$churn, Predicted = predicted_labels)
print(confusion_matrix)

accuracy <- mean(predicted_labels == test_data$churn)
precision <- sum(predicted_labels == 1 & test_data$churn == 1) / max(sum(predicted_labels == 1), 1)
recall <- sum(predicted_labels == 1 & test_data$churn == 1) / max(sum(test_data$churn == 1), 1)

cat(sprintf("Accuracy: %.3f\n", accuracy))
cat(sprintf("Precision: %.3f\n", precision))
cat(sprintf("Recall: %.3f\n", recall))

positive_scores <- probabilities[test_data$churn == 1]
negative_scores <- probabilities[test_data$churn == 0]
if (length(positive_scores) > 0 && length(negative_scores) > 0) {
  rank_sum <- sum(rank(c(positive_scores, negative_scores))[seq_along(positive_scores)])
  auc <- (rank_sum - length(positive_scores) * (length(positive_scores) + 1) / 2) /
    (length(positive_scores) * length(negative_scores))
  cat(sprintf("AUC: %.3f\n", auc))
} else {
  cat("AUC could not be computed because one class is missing in the test set.\n")
}

# Important variables
coefficients <- coef(model)
print(coefficients[order(abs(coefficients), decreasing = TRUE)])

# Save model
saveRDS(model, file = "customer_churn_model.rds")
