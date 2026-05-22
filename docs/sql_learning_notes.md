# SQL Learning Notes

## Overview

This document contains important SQL concepts learned during the Vancouver Housing Analytics project.

The focus is on analytical SQL and business-oriented data analysis.

---

# SQL Execution Order

FROM
WHERE
GROUP BY
HAVING
SELECT
ORDER BY
LIMIT

Important concept:

- WHERE filters rows before aggregation
- HAVING filters aggregated groups after aggregation

---

# GROUP BY

GROUP BY controls:

- aggregation granularity
- business grouping level

Example:

GROUP BY year

means:

- one row per year

Example:

GROUP BY year, housing_type

means:

- one row per year + housing type combination

---

# Granularity

Granularity determines:

- what one row represents
- analytical detail level
- business interpretation

Very important concept in analytical SQL.

---

# Window Functions

Window functions operate across rows without collapsing them.

Functions learned:

- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- LAG()
- LEAD()
- PERCENT_RANK()
- CUME_DIST()
- NTILE()

---

# PARTITION BY

PARTITION BY defines:

- where window calculations restart

Example:

PARTITION BY housing_type

means:

- calculations happen independently for each housing type

---

# Moving Average

Example:

ROWS BETWEEN 2 PRECEDING
AND CURRENT ROW

Meaning:

- current row
- previous 2 rows

Used for:

- trend smoothing
- rolling analytics

---

# Cumulative Window

Example:

ROWS BETWEEN UNBOUNDED PRECEDING
AND CURRENT ROW

Meaning:

- all previous rows
- plus current row

Used for:

- cumulative totals
- running averages
- cumulative trends

---

# Important Analytical Principle

Aggregate first → Window later

Common analytical pipeline:

1. Aggregate business metric
2. Store in CTE
3. Apply window functions

---

# Important Business Analytics Concepts

Learned concepts:

- time-series analytics
- ranking analytics
- segmentation analytics
- cumulative analytics
- moving analytics
- growth analytics
- affordability analytics

---

# Key Learning Outcome

The major learning outcome from this project:

SQL is not only syntax.

SQL is:

- analytical reasoning
- business interpretation
- granularity management
- metric analysis
- trend analysis