CREATE TABLE housing_affordability (

    housing_id SERIAL PRIMARY KEY,

    cma_id INT,

    cma_name VARCHAR(100),

    year INT,

    quarter INT,

    housing_type VARCHAR(100),

    median_housing_price NUMERIC(12,2),

    median_after_tax_annual_family_income NUMERIC(12,2),

    prime_interest_rate NUMERIC(5,2),

    mortgage_payment_percent_income NUMERIC(5,2),

    historic_payment_percent_income NUMERIC(5,2),

    number_of_resales INT
);





