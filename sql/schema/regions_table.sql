CREATE TABLE regions (

    region_id SERIAL PRIMARY KEY,

    cma_name VARCHAR(100) UNIQUE NOT NULL,

    province VARCHAR(50),

    population BIGINT,

    unemployment_rate NUMERIC(5,2)
);