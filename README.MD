# Vancouver Housing Market Analytics

## Project Overview

This project analyzes housing affordability trends across Vancouver and multiple British Columbia CMA (Census Metropolitan Area) regions using PostgreSQL and advanced analytical SQL.

The project is designed to simulate real-world business analytics workflows while strengthening advanced SQL and analytical reasoning skills.

The analysis focuses on:
- housing affordability trends
- mortgage burden analysis
- regional comparisons
- affordability deterioration
- business KPI analytics
- trend and volatility analysis
- segmentation and ranking analytics
- time-series analytical reporting

This project is part of a long-term learning journey toward:
- advanced SQL engineering
- analytics engineering
- business intelligence
- data analytics
- data-driven decision making

---

# Project Objectives

- Analyze long-term housing affordability trends
- Practice real-world analytical SQL
- Learn advanced window functions
- Build business KPI reporting queries
- Develop analytical thinking and business reasoning
- Practice trend and time-series analysis
- Learn correlated subqueries and advanced SQL
- Build portfolio-quality analytics projects
- Simulate executive-level analytical reporting

---

# Dataset Source

Dataset:
BC Housing Affordability Dataset

Source:
https://catalogue.data.gov.bc.ca/dataset/b-c-housing-affordability

Example dataset:
bc-data-catalogue-cma-2025-q4.csv

The dataset contains information related to:
- median housing prices
- household income
- mortgage burden
- housing affordability
- housing types
- CMA regional data
- economic indicators

---

# Tech Stack

## Current Stack

- PostgreSQL
- SQL
- VS Code
- Git
- GitHub
- CSV data processing

## Planned Additions

- Python
- Pandas
- Matplotlib
- Seaborn
- Power BI / Tableau
- Forecasting models
- Geospatial visualization

---

# Database Tables

## 1. housing_affordability

Main analytical dataset containing:
- CMA regions
- housing types
- housing prices
- mortgage burden metrics
- yearly affordability metrics

## 2. regions

Regional demographic information:
- population
- unemployment rate
- regional metadata

## 3. yearly_interest_rates

Economic indicator dataset:
- interest rates
- inflation rates
- yearly economic trends

---

# SQL Concepts Implemented

## Core SQL
- SELECT
- WHERE
- ORDER BY
- GROUP BY
- HAVING

## JOINS
- INNER JOIN
- LEFT JOIN
- one-to-many relationships
- analytical joins

## Window Functions
- RANK()
- DENSE_RANK()
- ROW_NUMBER()
- LAG()
- LEAD()
- FIRST_VALUE()
- LAST_VALUE()

## Business Analytics
- affordability scoring
- KPI reporting
- trend analysis
- business segmentation
- volatility analytics
- executive reporting queries

## Subqueries
- scalar subqueries
- correlated subqueries
- EXISTS / NOT EXISTS
- IN
- ANY / ALL
- nested analytical filtering

---

# Example Business Questions Solved

- Which regions have the highest mortgage burden?
- Which housing types are least affordable?
- Which regions show worsening affordability trends?
- Which regions are above the provincial average?
- Which regions have the most volatile housing trends?
- Which regions consistently deteriorate over time?
- Which housing categories show the highest financial risk?
- Top-N housing market analysis within regions

---

# Project Structure

```text
vancouver_housing_project/

├── data/
│   └── raw CSV datasets
│
├── docs/
│   ├── dataset_description.md
│   ├── analytical_findings.md
│   ├── sql_learning_notes.md
│   ├── subqueries_notes.md
│   └── future_scope.md
│
├── notebooks/
│   └── future Python analytics notebooks
│
├── sql/
│   ├── eda/
│   │   ├── 01_dataset_overview.sql
│   │   ├── 02_window_functions.sql
│   │   ├── 03_business_analysis.sql
│   │   ├── 04_joins.sql
│   │   ├── 05_business_analytics.sql
│   │   └── 06_subqueries_practice.sql
│   │
│   └── schema/
│       ├── create_housing_table.sql
│       ├── regions_table.sql
│       ├── regions_insert.sql
│       ├── yearly_interest_rates.sql
│       └── yearly_interest_rates_insert.sql
│
├── screenshots/
│   └── sample_query_outputs.png
│
└── README.md