-- PyDeck MySQL Fixes
-- Run this in Supabase SQL Editor to fix SQL content to be MySQL-specific
-- Also renames the path from "SQL" to "MySQL"

-- ============ RENAME PATH ============
UPDATE paths SET name = 'MySQL', description = 'Master MySQL — the world''s most popular open-source relational database'
WHERE name = 'SQL';

-- ============ FIX 1: SELECT with Expressions — remove PostgreSQL/SQL Server ============
UPDATE concepts SET
content = '## SELECT with Expressions

You can perform calculations and use functions directly inside SELECT statements.

## Arithmetic Operations

```sql
-- Calculate discounted price
SELECT
  product_name,
  price,
  price * 0.9 AS discounted_price
FROM products;

-- Calculate total cost
SELECT
  product_name,
  price,
  quantity,
  price * quantity AS total_cost
FROM order_items;
```

## String Concatenation in MySQL

In MySQL, use `CONCAT()` to combine strings — NOT `+` or `||`:

```sql
-- CORRECT: MySQL uses CONCAT()
SELECT
  CONCAT(first_name, '' '', last_name) AS full_name
FROM customers;

-- Multiple strings
SELECT
  CONCAT(city, '', '', country) AS location
FROM customers;

-- CONCAT_WS (separator) — puts separator between each arg
SELECT
  CONCAT_WS(''-'', year, month, day) AS formatted_date
FROM events;
-- Result: 2024-01-15
```

## Built-in MySQL String Functions

```sql
-- String functions
SELECT
  UPPER(name) AS uppercase_name,
  LOWER(email) AS lowercase_email,
  LENGTH(description) AS desc_length,
  SUBSTRING(name, 1, 3) AS first_3_chars,
  TRIM(''  hello  '') AS trimmed
FROM products;

-- Date functions
SELECT
  order_date,
  YEAR(order_date) AS order_year,
  MONTH(order_date) AS order_month,
  DAY(order_date) AS order_day,
  DATE_FORMAT(order_date, ''%d-%m-%Y'') AS formatted
FROM orders;
```',
code_examples = '[{"title": "Calculations", "code": "SELECT \n  product_name,\n  price,\n  price * 1.18 AS price_with_gst,\n  ROUND(price * 1.18, 2) AS rounded_price\nFROM products;"}, {"title": "CONCAT in MySQL", "code": "SELECT \n  CONCAT(first_name, '' '', last_name) AS full_name,\n  UPPER(city) AS city_upper,\n  LENGTH(email) AS email_length\nFROM customers;"}]'
WHERE id = 'd5000000-0000-0000-0000-000000000002';

-- ============ FIX 2: LIMIT and OFFSET — remove SQL Server syntax ============
UPDATE concepts SET
content = '## LIMIT and OFFSET in MySQL

MySQL uses `LIMIT` and `OFFSET` to control how many rows are returned. This is essential for pagination.

## LIMIT Clause

Restrict the number of rows returned:

```sql
-- Get first 10 products
SELECT * FROM products
LIMIT 10;

-- Top 5 most expensive products
SELECT product_name, price
FROM products
ORDER BY price DESC
LIMIT 5;
```

## OFFSET (Pagination)

Skip a number of rows before returning results:

```sql
-- Skip first 10 rows, get next 10
SELECT * FROM products
LIMIT 10 OFFSET 10;

-- Page 3 (rows 21-30)
SELECT * FROM customers
ORDER BY customer_id
LIMIT 10 OFFSET 20;
```

## MySQL Shorthand: LIMIT offset, count

MySQL supports a shorthand with comma syntax:

```sql
-- LIMIT offset, count  (note: order is reversed from LIMIT...OFFSET)
SELECT * FROM products
LIMIT 10, 10;   -- skip 10, take 10 (same as LIMIT 10 OFFSET 10)

SELECT * FROM products
LIMIT 20, 5;    -- skip 20, take 5
```

**Which is clearer?**
`LIMIT 10 OFFSET 10` is more readable and explicit — prefer it over `LIMIT 10, 10`.

## Pagination Formula

```sql
-- Page formula: OFFSET = (page_number - 1) * items_per_page
-- Page 1: LIMIT 10 OFFSET 0
-- Page 2: LIMIT 10 OFFSET 10
-- Page 3: LIMIT 10 OFFSET 20

-- Example: Page 4 with 15 items per page
SELECT * FROM products
ORDER BY product_name
LIMIT 15 OFFSET 45;
```

## Common Use Cases

```sql
-- Latest 5 orders
SELECT * FROM orders
ORDER BY order_date DESC
LIMIT 5;

-- Second page of products (10 per page)
SELECT * FROM products
ORDER BY product_name
LIMIT 10 OFFSET 10;

-- Random sample of 5 rows
SELECT * FROM customers
ORDER BY RAND()
LIMIT 5;
```',
code_examples = '[{"title": "Top Results", "code": "-- Top 3 bestselling products\nSELECT product_name, units_sold \nFROM products \nORDER BY units_sold DESC \nLIMIT 3;"}, {"title": "Pagination", "code": "-- Page 2 (items 11-20)\nSELECT * FROM customers \nORDER BY customer_id \nLIMIT 10 OFFSET 10;\n\n-- Shorthand MySQL style\nSELECT * FROM customers\nORDER BY customer_id\nLIMIT 10, 10;"}]'
WHERE id = 'd5000000-0000-0000-0000-000000000008';

-- ============ FIX 3: SQL Data Types — MySQL-specific only ============
UPDATE concepts SET
title = 'MySQL Data Types',
content = '## MySQL Data Types

Choosing the right data type affects storage size, performance, and data integrity.

## Numeric Types

### Integer Types
```sql
TINYINT       -- 1 byte  (-128 to 127) or (0 to 255 unsigned)
SMALLINT      -- 2 bytes (-32,768 to 32,767)
INT           -- 4 bytes (-2 billion to 2 billion)
BIGINT        -- 8 bytes (very large numbers)
```

### Decimal Types
```sql
DECIMAL(10, 2)  -- Exact: 10 total digits, 2 after decimal — use for MONEY
FLOAT           -- Approximate (4 bytes) — avoid for currency!
DOUBLE          -- Approximate (8 bytes) — avoid for currency!
```

**Always use `DECIMAL` for prices and money — `FLOAT` and `DOUBLE` have rounding errors!**

```sql
CREATE TABLE products (
  id        INT          PRIMARY KEY AUTO_INCREMENT,
  price     DECIMAL(10, 2),   -- e.g., 99999999.99 max
  rating    FLOAT,             -- 4.5 (approximate ok here)
  stock     INT
);
```

## String Types

```sql
CHAR(10)      -- Fixed length, always 10 characters (padded with spaces)
VARCHAR(255)  -- Variable length, up to 255 characters
TEXT          -- Up to 65,535 characters
MEDIUMTEXT    -- Up to 16 MB
LONGTEXT      -- Up to 4 GB
ENUM(''a'',''b'')  -- One value from a fixed list
```

```sql
CREATE TABLE customers (
  id           INT PRIMARY KEY AUTO_INCREMENT,
  name         VARCHAR(100),
  email        VARCHAR(255),
  bio          TEXT,
  country_code CHAR(2),        -- ''US'', ''IN'', ''UK''
  status       ENUM(''active'', ''inactive'', ''banned'') DEFAULT ''active''
);
```

## Date and Time Types

```sql
DATE          -- Date only: ''2024-01-15''
TIME          -- Time only: ''14:30:00''
DATETIME      -- Date + time: ''2024-01-15 14:30:00'' (no timezone)
TIMESTAMP     -- Like DATETIME but auto-updates, timezone-aware
YEAR          -- Year only: 2024
```

```sql
CREATE TABLE orders (
  id           INT PRIMARY KEY AUTO_INCREMENT,
  order_date   DATE,
  created_at   DATETIME DEFAULT NOW(),
  updated_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
```

## Boolean in MySQL

MySQL does NOT have a true BOOLEAN type — it uses `TINYINT(1)`:

```sql
-- Both work the same in MySQL:
is_active  TINYINT(1) DEFAULT 1   -- 0 = false, 1 = true
is_active  BOOL DEFAULT TRUE       -- MySQL converts BOOL to TINYINT(1)

-- Stored as 0 or 1
INSERT INTO users (name, is_active) VALUES (''Alice'', 1);
INSERT INTO users (name, is_active) VALUES (''Bob'', TRUE);  -- TRUE = 1
```',
code_examples = '[{"title": "CREATE TABLE with MySQL Types", "code": "CREATE TABLE employees (\n  id         INT PRIMARY KEY AUTO_INCREMENT,\n  name       VARCHAR(100) NOT NULL,\n  salary     DECIMAL(10, 2),\n  hire_date  DATE,\n  is_active  TINYINT(1) DEFAULT 1,\n  dept       ENUM(''HR'', ''Tech'', ''Sales'') DEFAULT ''Tech''\n) ENGINE=InnoDB;"}, {"title": "Inserting MySQL Data", "code": "INSERT INTO employees (name, salary, hire_date, is_active, dept)\nVALUES \n  (''Alice'', 75000.50, ''2024-01-15'', 1, ''Tech''),\n  (''Bob'', 95000.00, ''2023-06-20'', TRUE, ''HR'');"}]'
WHERE id = 'd5000000-0000-0000-0000-000000000020';

-- ============ FIX 4: Type Conversion — MySQL CAST/CONVERT only ============
UPDATE concepts SET
title = 'Type Conversion and Constraints in MySQL',
content = '## Type Casting in MySQL

MySQL uses `CAST()` and `CONVERT()` to change data types.

## CAST() Function

```sql
-- Convert string to integer
SELECT CAST(''123'' AS INT);             -- 123
SELECT CAST(''99.99'' AS DECIMAL(5,2)); -- 99.99
SELECT CAST(99 AS CHAR);              -- ''99''
SELECT CAST(''2024-01-01'' AS DATE);    -- 2024-01-01

-- In a query
SELECT
  product_name,
  CAST(price AS CHAR) AS price_as_text
FROM products;
```

## CONVERT() Function

MySQL-specific syntax:

```sql
-- CONVERT(value, type)
SELECT CONVERT(''123'', INT);            -- 123
SELECT CONVERT(''2024-01-01'', DATE);    -- 2024-01-01
SELECT CONVERT(price, CHAR) FROM products;

-- CONVERT for character encoding
SELECT CONVERT(name USING utf8mb4) FROM customers;
```

## Common Constraints in MySQL

### NOT NULL
```sql
CREATE TABLE users (
  id    INT PRIMARY KEY AUTO_INCREMENT,
  email VARCHAR(255) NOT NULL,
  name  VARCHAR(100) NOT NULL
);
```

### UNIQUE
```sql
CREATE TABLE users (
  id       INT PRIMARY KEY AUTO_INCREMENT,
  email    VARCHAR(255) UNIQUE,
  username VARCHAR(50) UNIQUE
);
```

### DEFAULT
```sql
CREATE TABLE posts (
  id         INT PRIMARY KEY AUTO_INCREMENT,
  title      VARCHAR(200) NOT NULL,
  created_at DATETIME DEFAULT NOW(),
  status     VARCHAR(20) DEFAULT ''draft''
);
```

### CHECK (MySQL 8.0.16+)
```sql
CREATE TABLE products (
  id       INT PRIMARY KEY AUTO_INCREMENT,
  price    DECIMAL(10, 2) CHECK (price > 0),
  stock    INT CHECK (stock >= 0),
  discount INT CHECK (discount BETWEEN 0 AND 100)
);
```

## AUTO_INCREMENT in MySQL

MySQL uses `AUTO_INCREMENT` to auto-generate unique IDs:

```sql
CREATE TABLE users (
  id   INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100)
);

-- Insert without specifying id
INSERT INTO users (name) VALUES (''Alice'');
INSERT INTO users (name) VALUES (''Bob'');

-- IDs are assigned automatically: 1, 2, 3...
SELECT * FROM users;
-- id=1, Alice
-- id=2, Bob

-- Check last inserted id
SELECT LAST_INSERT_ID();
```

## Full MySQL Table Example

```sql
CREATE TABLE customers (
  id         INT           PRIMARY KEY AUTO_INCREMENT,
  username   VARCHAR(50)   NOT NULL UNIQUE,
  email      VARCHAR(255)  NOT NULL UNIQUE,
  balance    DECIMAL(10,2) DEFAULT 0.00 CHECK (balance >= 0),
  created_at DATETIME      DEFAULT NOW(),
  is_active  TINYINT(1)    DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```',
code_examples = '[{"title": "CAST in MySQL", "code": "-- Convert types in SELECT\nSELECT \n  CAST(''42'' AS INT) + 10 AS result,      -- 52\n  CAST(price AS CHAR) AS price_text,\n  CAST(''2024-01-15'' AS DATE) AS my_date\nFROM products\nLIMIT 1;"}, {"title": "AUTO_INCREMENT Example", "code": "CREATE TABLE orders (\n  id          INT PRIMARY KEY AUTO_INCREMENT,\n  customer_id INT NOT NULL,\n  total       DECIMAL(10,2) CHECK (total > 0),\n  created_at  DATETIME DEFAULT NOW(),\n  status      ENUM(''pending'',''shipped'',''delivered'') DEFAULT ''pending'',\n  FOREIGN KEY (customer_id) REFERENCES customers(id)\n) ENGINE=InnoDB;"}]'
WHERE id = 'd5000000-0000-0000-0000-000000000021';

-- ============ FIX 5: FULL OUTER JOIN — MySQL workaround focused ============
UPDATE concepts SET
title = 'FULL OUTER JOIN in MySQL (UNION Workaround)',
content = '## MySQL Does NOT Support FULL OUTER JOIN

Unlike PostgreSQL or SQL Server, **MySQL does not have a FULL OUTER JOIN keyword**. Instead, you simulate it using `LEFT JOIN UNION RIGHT JOIN`.

## What FULL OUTER JOIN Does (Conceptually)

It returns:
- ALL rows from the left table (even without matches in right)
- ALL rows from the right table (even without matches in left)
- Combined rows where both match

## MySQL Workaround: LEFT JOIN + UNION + RIGHT JOIN

```sql
-- Simulate FULL OUTER JOIN in MySQL
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
```

**UNION automatically removes duplicates** — so matched rows appear only once.

## Step-by-Step Explanation

```sql
-- Step 1: LEFT JOIN — all customers + their orders (NULL if no orders)
SELECT c.customer_id, c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- Alice  → order 1
-- Bob    → NULL   (no orders)
-- Carol  → order 3

-- Step 2: RIGHT JOIN — all orders + their customers (NULL if orphaned)
SELECT c.customer_id, c.name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;
-- Alice  → order 1
-- Carol  → order 3
-- NULL   → order 5  (orphaned order, no customer)

-- Combined with UNION (removes the duplicate Alice/Carol rows)
-- Alice  → order 1
-- Bob    → NULL
-- Carol  → order 3
-- NULL   → order 5
```

## Finding Rows That Exist in ONLY One Table

```sql
-- Find customers with no orders OR orders with no customer
SELECT
  c.customer_id,
  c.name,
  o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL     -- customers with no orders

UNION

SELECT
  c.customer_id,
  c.name,
  o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IS NULL; -- orders with no customer
```

## Practical: Reconcile Two Tables

```sql
-- Compare products in two warehouses
SELECT
  COALESCE(w1.product_id, w2.product_id) AS product_id,
  w1.quantity AS warehouse1_qty,
  w2.quantity AS warehouse2_qty,
  CASE
    WHEN w1.quantity IS NULL THEN ''Missing in Warehouse 1''
    WHEN w2.quantity IS NULL THEN ''Missing in Warehouse 2''
    WHEN w1.quantity != w2.quantity THEN ''Mismatch''
    ELSE ''Match''
  END AS status
FROM warehouse1 w1
LEFT JOIN warehouse2 w2 ON w1.product_id = w2.product_id

UNION

SELECT
  COALESCE(w1.product_id, w2.product_id),
  w1.quantity,
  w2.quantity,
  CASE
    WHEN w1.quantity IS NULL THEN ''Missing in Warehouse 1''
    ELSE ''Match''
  END
FROM warehouse1 w1
RIGHT JOIN warehouse2 w2 ON w1.product_id = w2.product_id
WHERE w1.product_id IS NULL;
```',
code_examples = '[{"title": "MySQL FULL OUTER JOIN Workaround", "code": "-- All employees and departments (including unmatched)\nSELECT \n  e.name AS employee,\n  d.name AS department\nFROM employees e\nLEFT JOIN departments d ON e.dept_id = d.id\n\nUNION\n\nSELECT \n  e.name,\n  d.name\nFROM employees e\nRIGHT JOIN departments d ON e.dept_id = d.id;"}, {"title": "Find Orphaned Records", "code": "-- Find unmatched records in both tables\nSELECT p.id AS product_id, NULL AS category_id\nFROM products p\nLEFT JOIN categories c ON p.category_id = c.id\nWHERE c.id IS NULL\n\nUNION\n\nSELECT NULL, c.id\nFROM products p\nRIGHT JOIN categories c ON p.category_id = c.id\nWHERE p.id IS NULL;"}]'
WHERE id = 'd6000000-0000-0000-0000-000000000020';

-- ============ FIX 6: CTEs — fix interval syntax to MySQL ============
UPDATE concepts SET
content = '## Common Table Expressions (CTEs) in MySQL

CTEs are supported in **MySQL 8.0+**. They are temporary named result sets that exist only during query execution.

## Basic Syntax

```sql
WITH cte_name AS (
  SELECT ...
)
SELECT * FROM cte_name;
```

## Simple Example

```sql
-- Without CTE (using subquery — harder to read)
SELECT * FROM (
  SELECT customer_id, SUM(total) AS total_spent
  FROM orders
  GROUP BY customer_id
) AS customer_totals
WHERE total_spent > 1000;

-- With CTE (cleaner and more readable)
WITH customer_totals AS (
  SELECT customer_id, SUM(total) AS total_spent
  FROM orders
  GROUP BY customer_id
)
SELECT * FROM customer_totals
WHERE total_spent > 1000;
```

## Advantages Over Subqueries

1. **Readability** — give your logic a meaningful name
2. **Reusability** — reference the CTE multiple times in one query
3. **Debugging** — test the CTE SELECT independently

## Multiple CTEs

```sql
WITH
  high_value_customers AS (
    SELECT customer_id
    FROM orders
    GROUP BY customer_id
    HAVING SUM(total) > 5000
  ),
  recent_orders AS (
    -- MySQL interval syntax: INTERVAL 30 DAY (no quotes)
    SELECT *
    FROM orders
    WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  )
SELECT
  c.name,
  COUNT(ro.id) AS recent_order_count
FROM high_value_customers hvc
JOIN customers c ON hvc.customer_id = c.id
LEFT JOIN recent_orders ro ON c.id = ro.customer_id
GROUP BY c.name;
```

## Recursive CTEs (MySQL 8.0+)

Useful for hierarchical/tree data:

```sql
-- Employee hierarchy using RECURSIVE CTE
WITH RECURSIVE employee_tree AS (
  -- Base case: top-level managers (no manager)
  SELECT id, name, manager_id, 1 AS level
  FROM employees
  WHERE manager_id IS NULL

  UNION ALL

  -- Recursive: employees under current level
  SELECT e.id, e.name, e.manager_id, et.level + 1
  FROM employees e
  JOIN employee_tree et ON e.manager_id = et.id
)
SELECT * FROM employee_tree
ORDER BY level, name;
```

## MySQL Date Intervals (Important!)

```sql
-- MySQL syntax for date math:
DATE_SUB(CURDATE(), INTERVAL 30 DAY)    -- 30 days ago
DATE_ADD(NOW(), INTERVAL 7 DAY)         -- 7 days from now
DATE_SUB(NOW(), INTERVAL 1 MONTH)       -- 1 month ago
DATE_SUB(NOW(), INTERVAL 1 YEAR)        -- 1 year ago

-- In a CTE:
WITH recent_sales AS (
  SELECT * FROM orders
  WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
)
SELECT COUNT(*) AS recent_count FROM recent_sales;
```

## Practical Example: Monthly Sales Summary

```sql
WITH monthly_sales AS (
  SELECT
    DATE_FORMAT(order_date, ''%Y-%m'') AS month,
    SUM(total) AS sales,
    COUNT(*) AS order_count
  FROM orders
  GROUP BY DATE_FORMAT(order_date, ''%Y-%m'')
)
SELECT
  month,
  sales,
  order_count,
  sales - LAG(sales) OVER (ORDER BY month) AS growth
FROM monthly_sales
ORDER BY month;
```',
code_examples = '[{"title": "Basic CTE", "code": "WITH high_spenders AS (\n  SELECT customer_id, SUM(total) AS spent\n  FROM orders\n  GROUP BY customer_id\n  HAVING SUM(total) > 10000\n)\nSELECT c.name, hs.spent\nFROM customers c\nJOIN high_spenders hs ON c.id = hs.customer_id\nORDER BY hs.spent DESC;"}, {"title": "MySQL Date Interval in CTE", "code": "-- Last 30 days sales summary\nWITH recent AS (\n  SELECT \n    DATE_FORMAT(order_date, ''%Y-%m-%d'') AS day,\n    SUM(total) AS daily_total\n  FROM orders\n  WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)\n  GROUP BY DATE_FORMAT(order_date, ''%Y-%m-%d'')\n)\nSELECT day, daily_total,\n  SUM(daily_total) OVER (ORDER BY day) AS running_total\nFROM recent;"}]'
WHERE id = 'd8000000-0000-0000-0000-000000000022';

-- ============ UPDATE PATH REFERENCE IN CONCEPTS TITLES ============
-- Update the SQL Data Types concept title reference
UPDATE concepts SET title = 'INSERT Statement (MySQL)'
WHERE id = 'd5000000-0000-0000-0000-000000000005'
  AND title = 'INSERT Statement';
