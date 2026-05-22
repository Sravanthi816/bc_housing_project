-- Question 1
-- Find total number of records in the housing affordability dataset.

SELECT COUNT(*) AS total_records
FROM housing_affordability;

-- Question 2
-- Find all distinct housing types avalible in the dataset.

SELECT DISTINCT housing_type
FROM housing_affordability
ORDER BY housing_type;

-- Question 3
-- FIND ALL DISTINCT CMA REGIONS AVALIABLE IN THE DATASET.

SELECT DISTINCT cma_name
FROM housing_affordability
ORDER BY cma_name;

Question 4
-- Find the earliest and latest year  available in the dataset.

SELECT MIN(year) as earliest_year, MAX(year) as latest_year 
FROM housing_affordability;

-- Question 5
--Find the total number of records for each housing type.

SELECT housing_type, COUNT(*) AS total_records
FROM housing_affordability
GROUP BY housing_type
ORDER BY total_records DESC;

-- Question 6
-- Find the average median housing price for each housing type.

SELECT housing_type, ROUND(AVG(median_housing_price)::numeric, 2) as average_median_housing_price
FROM housing_affordability
GROUP BY housing_type
ORDER BY average_median_housing_price DESC;

-- Question 7
--Find the average median housing price for each year.
-- Sort results chronologically.

SELECT year, ROUND(AVG(median_housing_price)::numeric, 2) as average_median_housing_price
FROM housing_affordability
GROUP BY year
ORDER BY year ASC;

-- Question 8
-- Find the top 10 CMA regions with the highest average median housing price.

SELECT cma_name, ROUND(AVG(median_housing_price)::numeric, 2) as average_median_housing_price
FROM housing_affordability
GROUP BY cma_name
ORDER BY average_median_housing_price DESC
LIMIT 10;

-- Question 9
-- Find the average mortgage payment percent income
-- for each housing type. Sort results from highest affordability burden to lowest affordability burden.

SELECT housing_type,  ROUND(AVG(mortgage_payment_percent_income)::NUMERIC, 2)  AS average_mortgage_payment_percent_income from housing_affordability
GROUP BY housing_type
ORDER BY average_mortgage_payment_percent_income DESC;

-- Question 10
-- Find the average median housing price for each housing type within each year.
-- Sort results: First by year ascending,then by average price descending.

SELECT year, housing_type, ROUND(AVG(median_housing_price)::NUMERIC, 2) AS average_median_housing_price
FROM housing_affordability
GROUP BY year, housing_type
ORDER BY year ASC, average_median_housing_price DESC;

-- Question 11
-- Find the top 5 CMA regions with the highest average mortgage payment percent income,
-- Sort from highest affordability burden to lowest.

SELECT cma_name, ROUND(AVG(mortgage_payment_percent_income)::NUMERIC, 2) AS average_mortgage_payment_percent_income FROM housing_affordability
GROUP BY cma_name
ORDER BY average_mortgage_payment_percent_income DESC
LIMIT 5;


-- Question 12

-- Find the average median housing price for Vancouver only, grouped by housing type. 
--Sort from highest average price to lowest.


Select cma_name, housing_type, round(avg(median_housing_price):: numeric, 2) as average_median_housing_price from housing_affordability
WHERE cma_name = 'Vancouver'
Group by cma_name, housing_type
Order by average_median_housing_price desc;

Select cma_name, housing_type, round(avg(median_housing_price):: numeric, 2) as average_median_housing_price from housing_affordability
Group by cma_name, housing_type
Having cma_name = 'Vancouver' 
Order by average_median_housing_price desc;

-- Question 13
-- Find housing types whose average median housing price is greater than 500000. 
-- Sort from highest average price to lowest.

SELECT housing_type, ROUND(AVG(median_housing_price)::NUMERIC, 2) AS average_median_housing_price
FROM housing_affordability
GROUP BY housing_type
HAVING AVG(median_housing_price) > 500000
ORDER BY average_median_housing_price DESC;

-- Question 14
-- Find the average median housing price for each CMA region and housing type combination.
-- Only include combinations where average median housing price exceeds 700000.
-- Sort by: 1. CMA name ascending2. average price descending

SELECT cma_name, housing_type, ROUND(AVG(median_housing_price),2) AS average_median_housing_price from housing_affordability
GROUP BY cma_name, housing_type
HAVING ROUND(AVG(median_housing_price),2) > 700000
ORDER BY cma_name ASC, average_median_housing_price DESC;

-- Question 15
-- Find CMA regions that have more than 500 records in the dataset.
-- Show:
-- CMA region
-- total number of records
-- Sort from highest record count to lowest.

SELECT  cma_name, COUNT(cma_id) AS total_records FROM housing_affordability
GROUP BY cma_name
HAVING  COUNT(cma_id)> 400
ORDER BY total_records DESC;

-- Question 16
-- Find years where the average median housing price exceeded 600000.
-- Show:year
-- average median housing price
-- Sort chronologically.

SELECT year, ROUND(AVG(median_housing_price),2) AS average_median_housing_price from housing_affordability
GROUP BY year
HAVING ROUND(AVG(median_housing_price),2) > 600000
ORDER BY year ASC;
-- Question 17
-- Find the average median housing price for each year and CMA region combination.
-- Only include combinations where average price exceeds 800000.
-- Sort by:
-- 1. year ascending
-- 2. average price descending

SELECT year, cma_name, ROUND(AVG(median_housing_price),2) AS average_median_housing_price from housing_affordability
GROUP BY year, cma_name 
HAVING ROUND(AVG(median_housing_price),2) > 800000
ORDER BY year ASC, average_median_housing_price DESC;
