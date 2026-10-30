# Customer Churn Prediction in R

This repository contains a small R-based customer churn prediction project.

## Goal

The objective is to estimate whether a customer is likely to churn using transaction, purchase, delivery, and credit behaviors.

Because the dataset does not contain a direct churn flag, the project derives the target from `Buyers.Manual.scorring`:
- `A` = non-churn / retained
- `B` = churn risk
- `N/A` rows are excluded from the supervised model

## Files

- `data.csv`: the customer dataset
- `customer_churn_prediction.Rmd`: notebook version of the analysis
- `customer_churn_model.R`: script version of the same workflow

## Run the notebook

```r
rmarkdown::render("customer_churn_prediction.Rmd")
```

## Run the script

```r
source("customer_churn_model.R")
```

## Notes

This is a baseline project meant to demonstrate how to build a churn-prediction model in R. It can be extended with:
- more robust class labeling
- model validation and tuning
- feature engineering
- class imbalance techniques
- alternative models such as random forest or XGBoost
