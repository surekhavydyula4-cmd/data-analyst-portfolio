-- Project: Shopping Data Analysis
-- Description: End-to-end data cleaning and sales analysis using SQL

-- Steps:
-- 1. Data Cleaning
-- 2. Data Transformation
-- 3. Business Analysis

-- -------------------------------------
-- 1. DATABASE SETUP
-- -------------------------------------
CREATE DATABASE shopping_db;
USE shopping_db;

-- -------------------------------------
-- 2. TABLE CREATION
-- -------------------------------------
CREATE TABLE shopping_data (
    invoice_no VARCHAR(50),
    customer_id VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2),
    payment_method VARCHAR(50),
    invoice_date VARCHAR(50),  -- keep as text initially
    shopping_mall VARCHAR(100)
);

-- -------------------------------------
-- 3. DATA LOADING & INITIAL EXPLORATION
-- -------------------------------------

-- 3.1 Preview dataset (top 10 rows)
SELECT * 
FROM shopping_data 
LIMIT 10;

-- 3.2 Total number of records
SELECT COUNT(*) AS total_records 
FROM shopping_data;

-- 3.3 Total number of columns
SELECT COUNT(*) AS total_columns
FROM information_schema.columns
WHERE table_name = 'shopping_data';

-- 3.4 Check table structure
DESC shopping_data;

-- 3.5 Add primary key column
ALTER TABLE shopping_data 
ADD id INT AUTO_INCREMENT PRIMARY KEY;

-- -------------------------------------
-- 4. DATA CLEANING
-- -------------------------------------
-- 4.1 Checking for NULL values
SELECT *
FROM shopping_data
WHERE invoice_no IS NULL
OR customer_id IS NULL
OR quantity IS NULL 
OR price IS NULL
OR invoice_date IS NULL; 

-- 4.2 Counting NULL values column-wise
SELECT 
    SUM(CASE WHEN invoice_no IS NULL THEN 1 ELSE 0 END) AS invoice_no_nulls,
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS customer_id_nulls,
	SUM(CASE WHEN quantity IS NULL THEN 1 ELSE 0 END) AS quantity_nulls,
    SUM(CASE WHEN price IS NULL THEN 1 ELSE 0 END) AS price_nulls,
    SUM(CASE WHEN invoice_date IS NULL THEN 1 ELSE 0 END) AS invoice_date_nulls
FROM shopping_data;

-- 4.3 Checking for duplicate invoices
SELECT invoice_no, COUNT(*) AS duplicate_count
FROM shopping_data
GROUP BY invoice_no
HAVING COUNT(*) > 1;

-- -------------------------------------
-- 5. DATA TRANSFORMATION
-- -------------------------------------

-- 5.1 Check invoice_date format
SELECT invoice_date 
FROM shopping_data 
LIMIT 10;

-- 5.2 Convert invoice_date from text to DATE
SET SQL_SAFE_UPDATES = 0;

UPDATE shopping_data
SET invoice_date = STR_TO_DATE(invoice_date, '%d/%m/%Y');

SET SQL_SAFE_UPDATES = 1;

-- 5.3 Verify conversion
SELECT invoice_date
FROM shopping_data
LIMIT 10;

-- 5.4 Change column datatype
ALTER TABLE shopping_data
MODIFY invoice_date DATE;

-- 5.5 Add total_sales column
ALTER TABLE shopping_data
ADD COLUMN total_sales DECIMAL(10,2);

-- 5.6 Calculate total_sales
UPDATE shopping_data
SET total_sales = price * quantity;

-- 5.7 Verify total_sales
SELECT price, quantity, total_sales
FROM shopping_data
LIMIT 10;

-- -------------------------------------
-- 6. BUSINESS ANALYSIS
-- -------------------------------------

-- 6.1 Total revenue
SELECT SUM(total_sales) AS total_revenue 
FROM shopping_data;

-- 6.2 Revenue by category
SELECT category, SUM(total_sales) AS revenue 
FROM shopping_data 
GROUP BY category
ORDER BY revenue DESC;

-- 6.3 Gender-wise spending
SELECT gender, SUM(total_sales) AS total_spend
FROM shopping_data 
GROUP BY gender;

-- 6.4 Payment method analysis
SELECT payment_method, COUNT(*) AS transactions
FROM shopping_data
GROUP BY payment_method
ORDER BY transactions DESC;

-- 6.5 Top shopping malls by revenue
SELECT shopping_mall, SUM(total_sales) AS revenue
FROM shopping_data 
GROUP BY shopping_mall
ORDER BY revenue DESC;

-- 6.6 Monthly sales trend
SELECT 
    DATE_FORMAT(invoice_date, '%b-%Y') AS month_yr,
    SUM(total_sales) AS revenue
FROM shopping_data
GROUP BY month_yr
ORDER BY MIN(invoice_date);

-- 6.7 Sales by age group
SELECT CASE
    WHEN age < 20 THEN 'Teen'
    WHEN age BETWEEN 20 AND 40 THEN 'Young Adult'
    WHEN age BETWEEN 41 AND 60 THEN 'Adult'
    ELSE 'Senior'
END AS age_group,
SUM(total_sales) AS revenue
FROM shopping_data
GROUP BY age_group
ORDER BY revenue DESC;

-- 6.8 Top 5 customers
SELECT customer_id, SUM(total_sales) AS total_spent
FROM shopping_data
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 5;

-- 6.9 Most sold category
SELECT category, 
       SUM(quantity) AS total_items,
       SUM(total_sales) AS revenue
FROM shopping_data
GROUP BY category
ORDER BY revenue DESC;

SELECT * FROM shopping_data;








