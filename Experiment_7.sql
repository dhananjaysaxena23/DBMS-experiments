-- EXPERIMENT 7: NORMALIZATION FROM UNF TO 1NF, 2NF, 3NF AND BCNF
-- Execute statements in order. This experiment uses the sales_1nf source table.

-- 1. Convert UNF to 1NF
CREATE TABLE sales_1nf (
    order_id INT,
    order_date DATE,
    customer_id INT,
    customer_name VARCHAR(60),
    customer_city VARCHAR(40),
    salesperson_id INT,
    salesperson_name VARCHAR(60),
    product_id INT,
    product_name VARCHAR(60),
    unit_price DECIMAL(10,2),
    quantity INT,
    PRIMARY KEY (order_id, product_id)
);


INSERT INTO sales_1nf VALUES
(1001,'2026-10-01',201,'Aarav Sharma','Lucknow',301,'Neha Gupta',501,'Keyboard',1500,2),
(1001,'2026-10-01',201,'Aarav Sharma','Lucknow',301,'Neha Gupta',502,'Mouse',600,1),
(1002,'2026-10-02',202,'Diya Verma','Kanpur',302,'Rohan Das',503,'Monitor',12000,1),
(1003,'2026-10-03',203,'Kabir Singh','Lucknow',301,'Neha Gupta',501,'Keyboard',1500,1);

SELECT order_id, product_id, product_name, quantity
FROM sales_1nf
ORDER BY order_id, product_id;


-- 2. Convert 1NF to 2NF
CREATE TABLE orders_2nf (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT,
    customer_name VARCHAR(60),
    customer_city VARCHAR(40),
    salesperson_id INT,
    salesperson_name VARCHAR(60)
);


CREATE TABLE products_2nf (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(60),
    unit_price DECIMAL(10,2)
);


CREATE TABLE order_items_2nf (
    order_id INT,
    product_id INT,
    quantity INT,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders_2nf(order_id),
    FOREIGN KEY (product_id) REFERENCES products_2nf(product_id)
);


INSERT INTO orders_2nf
SELECT DISTINCT order_id, order_date, customer_id, customer_name,
       customer_city, salesperson_id, salesperson_name
FROM sales_1nf;


INSERT INTO products_2nf
SELECT DISTINCT product_id, product_name, unit_price
FROM sales_1nf;


INSERT INTO order_items_2nf
SELECT order_id, product_id, quantity
FROM sales_1nf;


SELECT o.order_id, o.customer_id, oi.product_id,
       p.product_name, oi.quantity
FROM orders_2nf o
JOIN order_items_2nf oi ON oi.order_id = o.order_id
JOIN products_2nf p ON p.product_id = oi.product_id
ORDER BY o.order_id;


-- 3. Convert 2NF to 3NF
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(60) NOT NULL,
    customer_city VARCHAR(40) NOT NULL
);


CREATE TABLE salespersons (
    salesperson_id INT PRIMARY KEY,
    salesperson_name VARCHAR(60) NOT NULL
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(60) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    order_date DATE NOT NULL,
    customer_id INT NOT NULL,
    salesperson_id INT NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (salesperson_id) REFERENCES salespersons(salesperson_id)
);


CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);


-- Populate the 3NF tables
INSERT INTO customers
SELECT DISTINCT customer_id, customer_name, customer_city
FROM sales_1nf;


INSERT INTO salespersons
SELECT DISTINCT salesperson_id, salesperson_name
FROM sales_1nf;


INSERT INTO products
SELECT DISTINCT product_id, product_name, unit_price
FROM sales_1nf;


INSERT INTO orders
SELECT DISTINCT order_id, order_date, customer_id, salesperson_id
FROM sales_1nf;


INSERT INTO order_items
SELECT order_id, product_id, quantity
FROM sales_1nf;


-- 4. Verify 3NF data using JOIN
SELECT o.order_id, c.customer_name, p.product_name,
       oi.quantity, p.unit_price
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
ORDER BY o.order_id, p.product_id;


-- 5. Verify lossless join
SELECT
    (SELECT COUNT(*) FROM sales_1nf) AS original_rows,
    (SELECT COUNT(*)
     FROM orders o
     JOIN order_items oi ON oi.order_id = o.order_id
     JOIN customers c ON c.customer_id = o.customer_id
     JOIN products p ON p.product_id = oi.product_id
     JOIN salespersons s ON s.salesperson_id = o.salesperson_id
    ) AS joined_rows;


-- 6. Verify dependency preservation: order-level dependencies
SELECT order_id
FROM sales_1nf
GROUP BY order_id
HAVING COUNT(DISTINCT order_date) > 1
    OR COUNT(DISTINCT customer_id) > 1
    OR COUNT(DISTINCT salesperson_id) > 1;


-- Verify product dependency
SELECT product_id
FROM sales_1nf
GROUP BY product_id
HAVING COUNT(DISTINCT product_name) > 1
    OR COUNT(DISTINCT unit_price) > 1;


-- 7. Check primary keys
SELECT table_name, column_name, constraint_name
FROM information_schema.key_column_usage
WHERE table_schema = DATABASE()
  AND constraint_name = 'PRIMARY'
ORDER BY table_name, ordinal_position;
