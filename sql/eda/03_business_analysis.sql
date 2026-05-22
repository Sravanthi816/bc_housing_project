-- Question 22
-- Find yearly average median housing prices.
-- Also calculate:
-- cumulative average housing price trend
-- across years.
-- Sort chronologically.

WITH yearly_average AS (

    SELECT
        year,

        ROUND(
            AVG(median_housing_price),
            2
        ) AS average_median_housing_price

    FROM housing_affordability

    GROUP BY year
)

SELECT
    year,

    average_median_housing_price,

    ROUND(
        AVG(average_median_housing_price)
            OVER(
                ORDER BY year ASC
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
            ),
        2
    ) AS cumulative_average_housing_price

FROM yearly_average

ORDER BY year ASC;


- Question 23
-- Find yearly average median housing prices.
-- Also calculate:
-- cumulative housing price total trend
-- across years.
-- Sort chronologically.

WITH yearly_average AS (

    SELECT
        year,

        ROUND(
            AVG(median_housing_price),
            2
        ) AS average_median_housing_price

    FROM housing_affordability

    GROUP BY year
),

cumulative_housing_price AS (

    SELECT
        year,

        average_median_housing_price,

        SUM(average_median_housing_price)
            OVER(
                ORDER BY year ASC
                ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
            ) AS cumulative_sum_housing_price

    FROM yearly_average
)

SELECT *
FROM cumulative_housing_price

ORDER BY year ASC;

-- Question 24
-- Find yearly average median housing prices.
-- Also calculate:
-- previous year's average price
-- yearly growth percentage.
-- Sort chronologically.

WITH yearly_average AS (

    SELECT
        year,

        ROUND(
            AVG(median_housing_price),
            2
        ) AS average_median_housing_price

    FROM housing_affordability

    GROUP BY year
),

previous_avg AS (

    SELECT
        year,

        average_median_housing_price,

        LAG(average_median_housing_price)
            OVER(ORDER BY year)
            AS previous_year_average

    FROM yearly_average
)

SELECT
    year,

    average_median_housing_price,

    previous_year_average,

    ROUND(
        (
            (
                average_median_housing_price
                - previous_year_average
            )
            /
            previous_year_average
        ) * 100,
        2
    ) AS percentage_growth

FROM previous_avg

ORDER BY year ASC;

-- Question 25
-- Find yearly average median housing prices
-- for each housing type.
-- Also calculate:
-- previous year's average price
-- within each housing type
-- and yearly growth percentage.
-- Sort by:
-- 1. housing type
-- 2. year ascending

WITH yearly_average AS (

    SELECT
        year,
        housing_type,

        ROUND(
            AVG(median_housing_price),
            2
        ) AS average_median_housing_price

    FROM housing_affordability

    GROUP BY year, housing_type
),

previous_avg AS (

    SELECT
        year,
        housing_type,
        average_median_housing_price,

        LAG(average_median_housing_price)
            OVER(
                PARTITION BY housing_type
                ORDER BY year
            ) AS previous_year_average

    FROM yearly_average
)

SELECT
    year,
    housing_type,
    average_median_housing_price,
    previous_year_average,

    ROUND(
        (
            (
                average_median_housing_price
                - previous_year_average
            )
            /
            previous_year_average
        ) * 100,
        2
    ) AS percentage_growth
FROM previous_avg
ORDER BY housing_type, year ASC;


