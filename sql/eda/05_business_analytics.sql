-- BUSINESS ANALYTICS Question 1
-- Create:
-- an affordability score

-- using:
-- median housing price
-- mortgage burden
-- unemployment rate
-- for each CMA region.

-- Requirements:
-- Higher housing price
-- Higher mortgage burden
-- Higher unemployment
-- should indicate:
-- lower affordability.
-- Sort:
-- least affordable regions first.


SELECT 
    h.cma_name,

    ROUND(
        (
            h.median_housing_price
            *
            h.mortgage_payment_percent_income
            *
            r.unemployment_rate
        ),
        2
    ) AS affordability_score
FROM housing_affordability h
JOIN regions r
    ON h.cma_name = r.cma_name
ORDER BY affordability_score DESC;


-- BUSINESS ANALYTICS Question 2
-- Find:
-- the top 5 least affordable CMA regions.
-- Use:
-- average housing price
-- average mortgage burden
-- unemployment rate
-- Create:
-- an affordability KPI score.
-- Requirements:
-- Higher score =
-- less affordable region.
-- Sort:
-- least affordable first.

SELECT 
    h.cma_name,

    ROUND(
        (
            AVG(h.median_housing_price)
            *
            AVG(h.mortgage_payment_percent_income)
            *
            r.unemployment_rate
        ),
        2
    ) AS affordability_kpi_score
FROM housing_affordability h
JOIN regions r
    ON h.cma_name = r.cma_name
GROUP BY h.cma_name, r.unemployment_rate
ORDER BY affordability_kpi_score DESC
LIMIT 5;



-- BUSINESS ANALYTICS Question 3
-- Categorize CMA regions into:
-- High Risk
-- Medium Risk
-- Low Risk
-- based on:
-- affordability score.
-- Requirements:
-- Create:
-- a CASE-based business segmentation.

WITH affordability AS (

    SELECT

        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY h.cma_name
),

categorize_cma_regions AS (

    SELECT

        cma_name,

        affordability_score,

        CASE

            WHEN affordability_score > 65
                THEN 'High Risk'

            WHEN affordability_score BETWEEN 35 AND 65
                THEN 'Medium Risk'

            ELSE 'low risk'

        END AS business_segmentation

    FROM affordability
)

SELECT *
FROM categorize_cma_regions;

-- BUSINESS ANALYTICS Question 4
-- Find:
-- yearly affordability trend
-- for each CMA region.
-- Requirements:
-- Compare:
-- current year affordability score
-- vs
-- previous year affordability score.
-- Then calculate:
-- yearly affordability change.

WITH affordability AS (

    SELECT

        h.year,
        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY
        h.cma_name,
        h.year
),

categorize_cma_regions AS (

    SELECT

        year,
        cma_name,

        affordability_score,

        LAG(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
            ) AS previous_year_score

    FROM affordability
)

SELECT

    year,
    cma_name,
    affordability_score,
    previous_year_score,

    ROUND(
        (
            (
                affordability_score
                - previous_year_score
            )
            / previous_year_score
        )*100,
        2
    ) AS yearly_affordability_change_percenage

FROM categorize_cma_regions;

-- BUSINESS ANALYTICS Question 5
-- Create:
-- an executive regional housing report.
-- For each CMA region show:
-- average housing price
-- average mortgage burden
-- unemployment rate
-- affordability score
-- affordability risk category
-- regional housing price rank
-- Requirements 
-- Rank:
-- most expensive regions first.


WITH average_housing_report AS (

    SELECT

        h.cma_name,

        ROUND(
            AVG(h.median_housing_price),
            2
        ) AS average_median_housing_price,

        ROUND(
            AVG(h.mortgage_payment_percent_income),
            2
        ) AS average_mortgage_burden,

        ROUND(
            AVG(r.unemployment_rate),
            2
        ) AS average_unemployment_rate

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY h.cma_name
),

affordability_analysis AS (

    SELECT

        cma_name,

        average_median_housing_price,

        average_mortgage_burden,

        average_unemployment_rate,

        ROUND(
            (
                (average_median_housing_price / 10000)
                +
                average_mortgage_burden
                +
                average_unemployment_rate
            ),
            2
        ) AS affordability_score,

        RANK() OVER (
            ORDER BY average_median_housing_price DESC
        ) AS regional_price_rank

    FROM average_housing_report
)

SELECT

    cma_name,

    average_median_housing_price,

    average_mortgage_burden,

    average_unemployment_rate,

    affordability_score,

    regional_price_rank,

    CASE

        WHEN affordability_score > 65
            THEN 'High Risk'

        WHEN affordability_score BETWEEN 35 AND 65
            THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS business_segmentation

FROM affordability_analysis;


-- BUSINESS ANALYTICS Question 6
-- Find:
-- the top 3 regions
-- with the highest affordability deterioration
-- over time.
-- Requirements:
-- Use:
-- year-over-year affordability change.
-- Then:
-- rank regions by:
-- average yearly deterioration.

WITH affordability AS (

    SELECT

        h.year,

        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY
        h.cma_name,
        h.year
),

yearly_changes AS (

    SELECT

        year,

        cma_name,

        affordability_score,

        LAG(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
            ) AS previous_year_score,

        ROUND(
            (
                (
                    affordability_score
                    -
                    LAG(affordability_score)
                        OVER (
                            PARTITION BY cma_name
                            ORDER BY year
                        )
                )
                /
                LAG(affordability_score)
                    OVER (
                        PARTITION BY cma_name
                        ORDER BY year
                    )
            ) * 100,
            2
        ) AS yearly_affordability_change_percentage

    FROM affordability
),

regional_deterioration AS (

    SELECT

        cma_name,

        ROUND(
            AVG(yearly_affordability_change_percentage),
            2
        ) AS average_yearly_deterioration

    FROM yearly_changes

    GROUP BY cma_name
)

SELECT

    cma_name,

    average_yearly_deterioration,

    RANK() OVER (
        ORDER BY average_yearly_deterioration DESC
    ) AS deterioration_rank

FROM regional_deterioration

ORDER BY average_yearly_deterioration DESC

LIMIT 3;
-- BUSINESS ANALYTICS Question 7
-- Find:
-- regions where affordability worsened
-- every single year continuously.
-- Requirements:
-- Use:
-- affordability trend analysis.
-- Return:
-- only regions with continuously increasing
-- affordability deterioration.

WITH affordability AS (

    SELECT

        h.year,
        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY
        h.cma_name,
        h.year
),

yearly_changes AS (

    SELECT

        year,

        cma_name,

        affordability_score,

        LAG(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
            ) AS previous_year_score,

        ROUND(
            (
                (
                    affordability_score
                    -
                    LAG(affordability_score)
                        OVER (
                            PARTITION BY cma_name
                            ORDER BY year
                        )
                )
                /
                LAG(affordability_score)
                    OVER (
                        PARTITION BY cma_name
                        ORDER BY year
                    )
            ) * 100,
            2
        ) AS yearly_affordability_change_percentage

    FROM affordability
)

SELECT

    cma_name

FROM yearly_changes

WHERE yearly_affordability_change_percentage IS NOT NULL

GROUP BY cma_name

HAVING COUNT(*) =
SUM(
    CASE
        WHEN yearly_affordability_change_percentage > 0
        THEN 1
        ELSE 0
    END
);


-- BUSINESS ANALYTICS Question 8
-- Find:
-- regions with the most volatile affordability trends.
-- Requirements:
-- Volatility means:
-- affordability changes fluctuate heavily
-- across years.
-- Use:
-- statistical-style analytical reasoning.
-- Hint:
-- think about measuring variation
-- in yearly affordability changes.

WITH affordability AS (

    SELECT

        h.year,
        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY
        h.cma_name,
        h.year
),
yearly_changes AS (

    SELECT

        year,

        cma_name,

        affordability_score,

        LAG(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
            ) AS previous_year_score,

        ROUND(
            (
                (
                    affordability_score
                    -
                    LAG(affordability_score)
                        OVER (
                            PARTITION BY cma_name
                            ORDER BY year
                        )
                )
                /
                LAG(affordability_score)
                    OVER (
                        PARTITION BY cma_name
                        ORDER BY year
                    )
            ) * 100,
            2
        ) AS yearly_affordability_change_percentage

    FROM affordability
)

SELECT

    cma_name,

    ROUND(
        STDDEV(yearly_affordability_change_percentage),
        2
    ) AS volatility

FROM yearly_changes

WHERE yearly_affordability_change_percentage IS NOT NULL

GROUP BY cma_name

ORDER BY volatility DESC;

-- BUSINESS ANALYTICS Question 9
-- Find:
-- regions whose affordability trend
-- improved overall across years.
-- Requirements:
-- Compare:
-- first affordability score
-- vs
-- latest affordability score.
-- Return
-- only regions where affordability improved.

WITH affordability AS (

    SELECT

        h.year,

        h.cma_name,

        ROUND(
            (
                AVG(h.median_housing_price / 100000)
                +
                AVG(h.mortgage_payment_percent_income)
                +
                AVG(r.unemployment_rate)
            ),
            2
        ) AS affordability_score

    FROM housing_affordability h

    JOIN regions r
        ON h.cma_name = r.cma_name

    GROUP BY
        h.cma_name,
        h.year
),

affordability_scores AS (

    SELECT

        year,

        cma_name,

        affordability_score,

        FIRST_VALUE(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
            ) AS first_affordability_score,

        LAST_VALUE(affordability_score)
            OVER (
                PARTITION BY cma_name
                ORDER BY year
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
            ) AS latest_affordability_score

    FROM affordability
)

SELECT DISTINCT

    cma_name,

    first_affordability_score,

    latest_affordability_score

FROM affordability_scores

WHERE latest_affordability_score < first_affordability_score;

-- BUSINESS ANALYTICS Question 10
-- Find:
-- the top 5 regions
-- with the highest average mortgage burden.
-- Requirements:
-- Return:
-- region
-- average mortgage burden
-- affordability category:

-- > 40 = Critical
-- 30-40 = High
-- 20-30 = Medium
-- < 20 = Low
-- Order:
-- highest burden first.

WITH highest_mortage_payment AS
(
    SELECT

        h.cma_name,

        ROUND(
            AVG(h.mortgage_payment_percent_income),
            2
        ) AS average_mortage_payment

    FROM housing_affordability h

    GROUP BY h.cma_name
)

SELECT

    cma_name,

    average_mortage_payment,

    CASE

        WHEN average_mortage_payment > 40
            THEN 'Critical'

        WHEN average_mortage_payment BETWEEN 30 AND 40
            THEN 'High'

        WHEN average_mortage_payment BETWEEN 20 AND 30
            THEN 'Medium'

        ELSE 'Low'

    END AS affordability_category

FROM highest_mortage_payment

ORDER BY average_mortage_payment DESC

LIMIT 5;
