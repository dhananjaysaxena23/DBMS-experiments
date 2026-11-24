-- EXPERIMENT 10: Query Optimization Using EXPLAIN, Indexing and Query Rewriting


-- 1. Create Database
CREATE DATABASE QueryOptimizationDB;
USE QueryOptimizationDB;


-- 2. Create Employee Sales Table
CREATE TABLE EmployeeSales (
    SaleID INT PRIMARY KEY,
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(30),
    City VARCHAR(30),
    Product VARCHAR(50),
    SaleAmount DECIMAL(10,2),
    SaleDate DATE
);


-- 3. Generate Dataset with 10,000 Rows
INSERT INTO EmployeeSales
(SaleID, EmployeeID, EmployeeName, Department, City, Product, SaleAmount, SaleDate)
WITH RECURSIVE Numbers AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1
    FROM Numbers
    WHERE n < 10000
)
SELECT
    n AS SaleID,
    ((n - 1) % 100) + 1 AS EmployeeID,
    CONCAT('Employee_', ((n - 1) % 100) + 1) AS EmployeeName,
    CASE
        WHEN n % 5 = 0 THEN 'IT'
        WHEN n % 5 = 1 THEN 'HR'
        WHEN n % 5 = 2 THEN 'Sales'
        WHEN n % 5 = 3 THEN 'Finance'
        ELSE 'Marketing'
    END AS Department,
    CASE
        WHEN n % 5 = 0 THEN 'Delhi'
        WHEN n % 5 = 1 THEN 'Lucknow'
        WHEN n % 5 = 2 THEN 'Kanpur'
        WHEN n % 5 = 3 THEN 'Mumbai'
        ELSE 'Pune'
    END AS City,
    CASE
        WHEN n % 4 = 0 THEN 'Laptop'
        WHEN n % 4 = 1 THEN 'Mobile'
        WHEN n % 4 = 2 THEN 'Tablet'
        ELSE 'Monitor'
    END AS Product,
    (500 + (n % 5000)) AS SaleAmount,
    DATE_ADD('2025-01-01', INTERVAL (n % 365) DAY) AS SaleDate
FROM Numbers;

-- 4. Verify Number of Records
SELECT COUNT(*) AS TotalRecords
FROM EmployeeSales;

-- 5. Display Sample Records
SELECT *
FROM EmployeeSales
LIMIT 10;


-- Query 1: Searching by Employee Name
-- Slow Query Before Optimization
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';

-- Analyze Using EXPLAIN
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';

-- Create Index
CREATE INDEX idx_employee_name
ON EmployeeSales(EmployeeName);

-- Run Optimized Query
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';

-- Analyze After Optimization
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';


-- Query 2: Searching Records by Department and City
-- Slow Query Before Optimization
SELECT *
FROM EmployeeSales
WHERE Department = 'IT'
AND City = 'Delhi';

-- Analyze Using EXPLAIN
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE Department = 'IT'
AND City = 'Delhi';

-- Create Composite Index
CREATE INDEX idx_department_city
ON EmployeeSales(Department, City);

-- Run Optimized Query
SELECT *
FROM EmployeeSales
WHERE Department = 'IT'
AND City = 'Delhi';

-- Analyze After Optimization
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE Department = 'IT'
AND City = 'Delhi';


-- Query 3: Query Using Function on a Column
-- Slow Query Before Optimization
SELECT *
FROM EmployeeSales
WHERE YEAR(SaleDate) = 2025;

-- Analyze Using EXPLAIN
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE YEAR(SaleDate) = 2025;

-- Rewrite query using date range
SELECT *
FROM EmployeeSales
WHERE SaleDate >= '2025-01-01'
AND SaleDate < '2026-01-01';

-- Create Index on SaleDate
CREATE INDEX idx_sale_date
ON EmployeeSales(SaleDate);

-- Analyze Optimized Query
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE SaleDate >= '2025-01-01'
AND SaleDate < '2026-01-01';


-- Query 4: Searching with a Wildcard
-- Slow Query
SELECT *
FROM EmployeeSales
WHERE EmployeeName LIKE '%25%';

-- Analyze Using EXPLAIN
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE EmployeeName LIKE '%25%';

-- Rewrite the Query
SELECT *
FROM EmployeeSales
WHERE EmployeeName LIKE 'Employee_25%';

-- Analyze Optimized Query
EXPLAIN
SELECT *
FROM EmployeeSales
WHERE EmployeeName LIKE 'Employee_25%';


-- Query 5: Aggregation and Filtering
-- Slow Query
SELECT Department, SUM(SaleAmount) AS TotalSales
FROM EmployeeSales
WHERE City = 'Delhi'
GROUP BY Department;

-- Analyze Using EXPLAIN
EXPLAIN
SELECT Department, SUM(SaleAmount) AS TotalSales
FROM EmployeeSales
WHERE City = 'Delhi'
GROUP BY Department;

-- Create Index
CREATE INDEX idx_city_department
ON EmployeeSales(City, Department);

-- Run Optimized Query
SELECT Department, SUM(SaleAmount) AS TotalSales
FROM EmployeeSales
WHERE City = 'Delhi'
GROUP BY Department;

-- Analyze After Optimization
EXPLAIN
SELECT Department, SUM(SaleAmount) AS TotalSales
FROM EmployeeSales
WHERE City = 'Delhi'
GROUP BY Department;

-- 6. Check All Indexes
SHOW INDEX FROM EmployeeSales;

-- 7. Compare Query Execution Time
-- Before Optimization
EXPLAIN ANALYZE
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';

-- After Optimization
EXPLAIN ANALYZE
SELECT *
FROM EmployeeSales
WHERE EmployeeName = 'Employee_25';

-- Before Optimization (date query)
EXPLAIN ANALYZE
SELECT *
FROM EmployeeSales
WHERE YEAR(SaleDate) = 2025;

-- After Optimization (date range)
EXPLAIN ANALYZE
SELECT *
FROM EmployeeSales
WHERE SaleDate >= '2025-01-01'
AND SaleDate < '2026-01-01';

-- 8. Remove Indexes if Required
DROP INDEX idx_employee_name ON EmployeeSales;
DROP INDEX idx_department_city ON EmployeeSales;
DROP INDEX idx_sale_date ON EmployeeSales;
DROP INDEX idx_city_department ON EmployeeSales;
