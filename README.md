# Customer Churn Prediction in R

This repository contains a small R-based customer churn prediction workflow built around the file `data.csv`.

## Project goal

The objective is to estimate whether a customer is likely to churn, using transaction, purchasing, delivery, and credit behavior as predictors.

Because there is no explicit churn flag in `data.csv`, the notebook uses `Buyers.Manual.scorring` as a practical proxy target:
- `A` = retained / low-risk customer
- `B` = high-risk / churn-prone customer
- `N/A` = dropped from the supervised learning dataset

This is a useful starter project, but in a production setting you would want a true churn label defined by business rules or historical outcomes.

## Files

- `data.csv`: raw customer dataset
- `customer_churn_prediction.Rmd`: exploratory analysis + model training notebook
- `scripts/customer_churn_model.R`: script version of the same workflow

## Run the project

In R or RStudio:

```r
rmarkdown::render("customer_churn_prediction.Rmd")
```

Or run the script directly:

```r
source("scripts/customer_churn_model.R")
```

## Expected workflow

1. Load the dataset
2. Clean and convert columns to numeric types
3. Create the churn target using the manual score
4. Split into training/testing data
5. Train a logistic regression model
6. Evaluate precision, recall, accuracy, and AUC-like metrics
7. Review the most influential predictors

## Notes

This is intentionally simple and educational. It can be extended with:
- additional preprocessing
- feature engineering
- class imbalance handling
- model comparison
- deployment-ready pipelines
