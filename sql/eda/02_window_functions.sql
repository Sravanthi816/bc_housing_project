-- Question 18
-- Find the average median housing price for each year.
-- Also show:
-- previous year's average price and yearly price difference.
-- Sort chronologically.

WITH yearly_prices AS (

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

    LAG(average_median_housing_price)
        OVER(ORDER BY year ASC)
        AS previous_year_average_price,

    average_median_housing_price
        - LAG(average_median_housing_price)
            OVER(ORDER BY year ASC)
        AS yearly_price_difference

FROM yearly_prices

ORDER BY year ASC;

-- Question 19
-- Find the average median housing price for each year.
-- Also calculate:
-- 3-year moving average housing price.
WITH yearly_prices AS (

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
                ROWS BETWEEN 2 PRECEDING
                AND CURRENT ROW
            ),
        2
    ) AS three_year_moving_average

FROM yearly_prices

ORDER BY year ASC;

-- Question 20
-- Rank CMA regions based on average median housing price.
-- Show:
-- CMA region ,average median housing price ,regional price rank
-- Sort by highest average price first.

WITH average_medians AS (

    SELECT
        cma_name,

        ROUND(
            AVG(median_housing_price),
            2
        ) AS average_median_housing_price

    FROM housing_affordability

    GROUP BY cma_name
),

ranked_price AS (

    SELECT
        cma_name,
        average_median_housing_price,

        RANK() OVER(
            ORDER BY average_median_housing_price DESC
        ) AS regional_price_rank

    FROM average_medians
)

SELECT *
FROM ranked_price;

-- Question 21

-- Rank housing types within each year based on average median housing price.
-- Show:
-- year
-- housing type
-- average median housing price
-- housing type rank within year
-- Sort by:
-- 1. year ascending
-- 2. rank ascending

WITH ranking_price_house AS (

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

ranking_by_year AS (

    SELECT
        year,
        housing_type,
        average_median_housing_price,

        RANK() OVER(
            PARTITION BY year
            ORDER BY average_median_housing_price DESC
        ) AS rank_within_year

    FROM ranking_price_house
)

SELECT *
FROM ranking_by_year

ORDER BY year,
         rank_within_year ASC;

--rank years with in each housing type

WITH ranking_price_house AS (

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

ranking_by_year AS (

    SELECT
        year,
        housing_type,
        average_median_housing_price,

        RANK() OVER(
            PARTITION BY housing_type
            ORDER BY average_median_housing_price DESC
        ) AS rank_within_year

    FROM ranking_price_house
)

SELECT *
FROM ranking_by_year

ORDER BY year,
         rank_within_year ASC;

