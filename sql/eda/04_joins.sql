-- JOIN Question 1
-- Show: 
-- CMA region
-- housing type
-- median housing price
-- population
-- unemployment rate
-- Join: housing_affordability with regions
-- Sort by:
-- highest housing price first



SELECT
    h.cma_name,
    h.housing_type,
    h.median_housing_price,
    r.unemployment_rate,
    r.population

FROM housing_affordability h

JOIN regions r
    ON h.cma_name = r.cma_name

ORDER BY h.median_housing_price DESC;

-- JOIN Question 2
-- Find:
-- average median housing price
-- and average mortgage burden
-- for each CMA region.
-- Also show:
-- population
-- unemployment rate
-- Sort by:
-- highest average housing price first

SELECT
    h.cma_name,
    r.unemployment_rate,
    r.population,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_median_housing,

    ROUND(
        AVG(h.mortgage_payment_percent_income),
        2
    ) AS average_mortgage_burden

FROM housing_affordability h

JOIN regions r
    ON h.cma_name = r.cma_name

GROUP BY
    h.cma_name,
    r.unemployment_rate,
    r.population

ORDER BY average_median_housing DESC;

-- JOIN Question 3
-- Find:
-- average housing price
-- average mortgage burden
-- average interest rate
-- inflation rate
-- for each year.
-- Join:
-- housing_affordability
-- with yearly_interest_rates
-- Sort by:
-- year ascending

SELECT
    h.year,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_median_housing_price,

    ROUND(
        AVG(h.mortgage_payment_percent_income),
        2
    ) AS average_mortgage_burden,

    y.average_interest_rate,

    y.inflation_rate

FROM housing_affordability h

JOIN yearly_interest_rates y
    ON h.year = y.year

GROUP BY
    h.year
    y.average_interest_rate,
    y.inflation_rate,

ORDER BY year ASC;


-- JOIN Question 4
-- Find:
-- CMA region
-- population
-- unemployment rate
-- average housing price
-- average mortgage burden
-- average yearly interest rate
-- Join:
-- housing_affordability
-- regions
-- yearly_interest_rates
-- Sort by:
-- highest average housing price first

SELECT

    h.cma_name,

    r.unemployment_rate,

    r.population,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_median_housing_price,

    ROUND(
        AVG(h.mortgage_payment_percent_income),
        2
    ) AS average_mortgage_burden,

    ROUND(
        AVG(y.average_interest_rate),
        2
    ) AS average_interest_rate

FROM housing_affordability h

JOIN regions r
    ON h.cma_name = r.cma_name

JOIN yearly_interest_rates y
    ON h.year = y.year

GROUP BY

    h.cma_name,
    r.unemployment_rate,
    r.population

ORDER BY average_median_housing_price DESC;

-- JOIN Question 5
-- Show:
-- all CMA regions
-- from the regions table
-- along with:
-- average housing price
-- even if some regions
-- do not have housing data.

SELECT

    r.cma_name,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_median_housing_price

FROM regions r

LEFT JOIN housing_affordability h
    ON r.cma_name = h.cma_name

GROUP BY r.cma_name

ORDER BY average_median_housing_price DESC;

-- JOIN Question 6
-- Find:
-- regions that do NOT have housing affordability data.
-- Show:
-- cma_name
-- population
-- unemployment_rate

SELECT

    r.cma_name,
    r.population,
    r.unemployment_rate

FROM regions r

LEFT JOIN housing_affordability h
    ON r.cma_name = h.cma_name

WHERE h.cma_name IS NULL;

-- JOIN Question 7
-- Find:
-- for each housing type:
-- average housing price
-- average mortgage burden
-- average unemployment rate
-- using:
-- housing_affordability
-- and regions
-- Sort by:
-- highest average housing price first

SELECT

    h.housing_type,

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

GROUP BY h.housing_type

ORDER BY average_median_housing_price DESC;

-- JOIN Question 8
-- Rank CMA regions
-- by average housing price.
-- Also show:
-- population
-- unemployment rate
-- using:
-- housing_affordability
-- and regions

SELECT

    h.cma_name,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_median_housing_price,

    r.population,

    r.unemployment_rate,

    RANK() OVER (
        ORDER BY AVG(h.median_housing_price) DESC
    ) AS housing_price_rank

FROM housing_affordability h

JOIN regions r
    ON h.cma_name = r.cma_name

GROUP BY

    h.cma_name,
    r.population,
    r.unemployment_rate;

-- JOIN Question 9
-- For each year:
-- calculate:
-- average housing price
-- and cumulative average housing price trend
-- using:
-- housing_affordability
-- and yearly_interest_rates
-- Also show:
-- average interest rate  

WITH yearly_rates AS (

    SELECT

        h.year,

        ROUND(
            AVG(h.median_housing_price),
            2
        ) AS average_median_housing_price,

        y.average_interest_rate

    FROM housing_affordability h

    JOIN yearly_interest_rates y
        ON h.year = y.year

    GROUP BY
        h.year,
        y.average_interest_rate
),

cumulative_totals AS (

    SELECT

        year,

        average_median_housing_price,

        average_interest_rate,

        SUM(average_median_housing_price)
            OVER (
                ORDER BY year ASC
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
            ) AS cumulative_avg_housing_price

    FROM yearly_rates
)

SELECT *
FROM cumulative_totals;

-- JOIN Question 10
-- Count:
-- total joined rows
-- after joining:
-- housing_affordability
-- with yearly_interest_rates
-- Then compare:
-- original row count
-- vs joined row count.

SELECT COUNT(*)

FROM housing_affordability h

JOIN yearly_interest_rates y
    ON h.year = y.year;
-- JOIN Question 11
-- Find:
-- total population
-- after joining:
-- housing_affordability
-- with regions
-- Then explain:
-- why the result may be analytically incorrect.

SELECT
    SUM( r.population) AS total_population

FROM regions r

JOIN housing_affordability h
    ON r.cma_name = h.cma_name;

SELECT
    SUM(r.population) AS total_population

FROM regions r;

-- JOIN Question 12
-- Find:
-- average population
-- for each housing type
-- using:
-- housing_affordability
-- and regions

SELECT
    h.housing_type,

    ROUND(
        AVG(r.population),
        2
    ) AS average_population
FROM housing_affordability h
JOIN regions r
    ON h.cma_name = r.cma_name
GROUP BY h.housing_type;    

-- JOIN Question 13
-- Compare:
-- COUNT(*)
-- vs
-- COUNT(DISTINCT h.cma_name)
-- after joining:
-- housing_affordability
-- with regions



SELECT

    COUNT(DISTINCT h.cma_name) AS total_places

FROM housing_affordability h

JOIN regions r
    ON h.cma_name = r.cma_name;

