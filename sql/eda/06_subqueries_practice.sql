-- SUBQUERY Question 1
-- Find:
-- all housing records
-- where median housing price
-- is greater than
-- the overall average housing price.
-- Requirements:
-- Use:
-- a scalar subquery.

SELECT *
FROM housing_affordability
WHERE median_housing_price >
(
    SELECT
        ROUND(AVG(median_housing_price), 2)
    FROM housing_affordability
);

-- SUBQUERY Question 2
-- Find:
-- all CMA regions
-- whose average housing price
-- is greater than
-- the overall average housing price.
-- Requirements:
-- Use:
-- GROUP BY
-- and a scalar subquery.

SELECT

    cma_name,

    ROUND(
        AVG(median_housing_price),
        2
    ) AS average_housing_price

FROM housing_affordability

GROUP BY cma_name

HAVING ROUND(
    AVG(median_housing_price),
    2
) >
(
    SELECT
        ROUND(
            AVG(median_housing_price),
            2
        )
    FROM housing_affordability
);


-- SUBQUERY Question 3
-- Find:
-- all housing records
-- where the median housing price
-- is equal to
-- the maximum housing price
-- within its CMA region.
-- Requirements:
-- Use:
-- a correlated subquery.

SELECT *
FROM housing_affordability h

WHERE median_housing_price =
(
    SELECT
        MAX(median_housing_price)
    FROM housing_affordability

    WHERE cma_name = h.cma_name
);

-- SUBQUERY Question 4
-- Find:
-- all housing records
-- where the median housing price
-- is above the average housing price
-- within the same CMA region.
-- Requirements:
-- Use:
-- a correlated subquery.

SELECT *
FROM housing_affordability h

WHERE median_housing_price >
(
    SELECT
        AVG(median_housing_price)
    FROM housing_affordability

    WHERE cma_name = h.cma_name
);

-- SUBQUERY Question 5
-- Find:
-- all CMA regions
-- where the average housing price
-- is greater than
-- the average housing price
-- of Vancouver.
-- Requirements:
-- Use:
-- a scalar subquery.

SELECT

    cma_name,

    ROUND(
        AVG(median_housing_price),
        2
    ) AS average_housing_price

FROM housing_affordability

GROUP BY cma_name

HAVING ROUND(
    AVG(median_housing_price),
    2
) >
(
    SELECT
        ROUND(
            AVG(median_housing_price),
            2
        )
    FROM housing_affordability

    WHERE cma_name = 'Vancouver'
);
-- SUBQUERY Question 6
-- Find:
-- housing records
-- where the mortgage burden
-- is greater than
-- the average mortgage burden
-- for the same housing type.
-- Requirements:
-- Use:
-- a correlated subquery.

SELECT *
FROM housing_affordability h

WHERE mortgage_payment_percent_income >
(
    SELECT
        AVG(mortgage_payment_percent_income)
    FROM housing_affordability

    WHERE housing_type = h.housing_type
);


-- SUBQUERY Question 7
-- Find:
-- regions that have at least one housing record
-- with housing prices above 1 million.
-- Requirements:
-- Use:
-- EXISTS

SELECT r.cma_name
FROM regions r

WHERE EXISTS
(
    SELECT 1
    FROM housing_affordability h

    WHERE h.cma_name = r.cma_name
    AND h.median_housing_price > 1000000
);

SUBQUERY Question 8
-- Find:
-- regions that do NOT have
-- any housing record
-- with housing prices above 1 million.
-- Requirements:
-- Use:
-- NOT EXISTS

SELECT r.cma_name
FROM regions r

WHERE NOT EXISTS
(
    SELECT 1
    FROM housing_affordability h

    WHERE h.cma_name = r.cma_name
    AND h.median_housing_price > 1000000
);

-- SUBQUERY Question 9
-- Find:
-- all housing records
-- belonging to regions
-- whose unemployment rate
-- is above 6%.
-- Requirements:
-- Use:
-- IN

SELECT *
FROM housing_affordability

WHERE cma_name IN
(
    SELECT cma_name
    FROM regions

    WHERE unemployment_rate > 6
);

-- SUBQUERY Question 10
-- Find:
-- all housing records
-- where the median housing price
-- is greater than
-- ALL housing prices
-- in Nanaimo.
-- Requirements:
-- Use:
-- ALL

SELECT *
FROM housing_affordability

WHERE median_housing_price > ALL
(
    SELECT median_housing_price
    FROM housing_affordability

    WHERE cma_name = 'Nanaimo'
);


-- SUBQUERY Question 11
-- Find:
-- all housing records
-- where the median housing price
-- is greater than
-- ANY housing price
-- in Nanaimo.
-- Requirements:
-- Use:
-- ANY

SELECT *
FROM housing_affordability

WHERE median_housing_price > ANY
(
    SELECT median_housing_price
    FROM housing_affordability

    WHERE cma_name = 'Nanaimo'
);

-- SUBQUERY Question 12
-- Find:
-- housing records
-- where the median housing price
-- is the highest
-- within the same:
-- CMA region
-- AND housing type.
-- Requirements:
-- Use:
-- correlated subquery.

SELECT *
FROM housing_affordability h

WHERE median_housing_price =
(
    SELECT MAX(median_housing_price)
    FROM housing_affordability h1

    WHERE h.cma_name = h1.cma_name
    AND h.housing_type = h1.housing_type
);

-- SUBQUERY Question 13
-- Find:
-- regions whose average housing price
-- is higher than
-- the average housing price
-- of all regions combined.
-- Requirements:
-- Use:
-- nested aggregate comparison.

SELECT

    cma_name,

    ROUND(
        AVG(median_housing_price),
        2
    ) AS average_housing_price

FROM housing_affordability

GROUP BY cma_name

HAVING ROUND(
    AVG(median_housing_price),
    2
) >
(
    SELECT
        ROUND(
            AVG(median_housing_price),
            2
        )
    FROM housing_affordability
);

-- SUBQUERY Question 14
-- Find:
-- housing records
-- where the median housing price
-- is within the TOP 3 highest prices
-- inside the same CMA region.
-- Requirements:
-- Use:
-- correlated subquery.

SELECT *
FROM housing_affordability h

WHERE
(
    SELECT COUNT(*)
    FROM housing_affordability h1

    WHERE h1.cma_name = h.cma_name

    AND h1.median_housing_price >
        h.median_housing_price
) < 3;

-- SUBQUERY Question 15
-- Find:
-- housing records
-- whose mortgage burden
-- is higher than
-- the highest mortgage burden
-- within the same housing type
-- in Vancouver.
-- Requirements:
-- Use:
-- correlated subquery.

SELECT *
FROM housing_affordability h

WHERE h.mortgage_payment_percent_income >
(
    SELECT
        MAX(h1.mortgage_payment_percent_income)

    FROM housing_affordability h1

    WHERE h1.housing_type = h.housing_type
    AND h1.cma_name = 'Vancouver'
);

with mortage_payment_percent_income as (
    select
        cma_name,
        housing_type,
        max(mortgage_payment_percent_income) as max_mortgage_payment_percent_income
    from housing_affordability
    where cma_name = 'Vancouver'
    group by cma_name, housing_type
)

select *
from housing_affordability h
join mortage_payment_percent_income m
    on h.housing_type = m.housing_type
where h.mortgage_payment_percent_income > m.max_mortgage_payment_percent_income;

Find:
-- regions where:
-- the average housing price
-- is greater than
-- the average housing price
-- of EVERY other region.
-- Requirements:
--
-- Use:
-- ALL
-- with grouped subqueries.

SELECT

    h.cma_name,

    ROUND(
        AVG(h.median_housing_price),
        2
    ) AS average_housing_price
FROM housing_affordability h
GROUP BY h.cma_name
HAVING ROUND(
    AVG(h.median_housing_price),
    2
) > ALL
(
    SELECT
        ROUND(
            AVG(h1.median_housing_price),
            2
        )
    FROM housing_affordability h1
    WHERE h1.cma_name != h.cma_name
    GROUP BY h1.cma_name
);


