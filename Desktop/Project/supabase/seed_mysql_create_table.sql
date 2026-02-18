-- PyDeck MySQL: Add CREATE TABLE subtopic and concepts
-- Run this in Supabase SQL Editor

-- ============ NEW SUBTOPIC: CREATE TABLE & DDL ============
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('c5000000-0000-0000-0000-000000000007', 'b2000000-0000-0000-0000-000000000001', 'CREATE TABLE & DDL', 7)
ON CONFLICT (id) DO NOTHING;

-- ============ CONCEPT 1: CREATE TABLE ============
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('d5000000-0000-0000-0000-000000000030',
 'c5000000-0000-0000-0000-000000000007',
 'CREATE TABLE in MySQL',
 '## What is DDL?

**DDL (Data Definition Language)** is the set of SQL commands used to define and manage database structure:
- `CREATE TABLE` — create a new table
- `ALTER TABLE` — modify an existing table
- `DROP TABLE` — delete a table
- `TRUNCATE TABLE` — delete all rows but keep the table

These are different from DML (Data Manipulation Language) like SELECT, INSERT, UPDATE, DELETE which work with data *inside* tables.

## CREATE TABLE Syntax

```sql
CREATE TABLE table_name (
    column_name  data_type  constraints,
    column_name  data_type  constraints,
    ...
);
```

## Basic Example

```sql
CREATE TABLE students (
    id        INT           PRIMARY KEY AUTO_INCREMENT,
    name      VARCHAR(100)  NOT NULL,
    email     VARCHAR(255)  UNIQUE,
    age       INT,
    enrolled  TINYINT(1)    DEFAULT 1,
    joined_on DATE          DEFAULT (CURRENT_DATE)
);
```

**Breaking it down:**
| Part | Meaning |
|------|---------|
| `INT` | Integer number |
| `VARCHAR(100)` | Text up to 100 characters |
| `PRIMARY KEY` | Unique identifier for each row |
| `AUTO_INCREMENT` | MySQL auto-generates 1, 2, 3... |
| `NOT NULL` | Column must have a value |
| `UNIQUE` | No two rows can have the same value |
| `DEFAULT` | Value used if none is provided |

## CREATE TABLE IF NOT EXISTS

Prevents error if table already exists:

```sql
CREATE TABLE IF NOT EXISTS students (
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL
);
```

## ENGINE and CHARSET

MySQL-specific options at the end of CREATE TABLE:

```sql
CREATE TABLE products (
    id    INT          PRIMARY KEY AUTO_INCREMENT,
    name  VARCHAR(200) NOT NULL,
    price DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

- `ENGINE=InnoDB` → supports foreign keys and transactions (default in MySQL 8)
- `CHARSET=utf8mb4` → supports all Unicode characters including emojis ✅

## Viewing Table Structure

After creating a table, inspect it with:

```sql
-- Show column names and types
DESCRIBE students;
-- or shorthand:
DESC students;

-- Show the full CREATE TABLE statement
SHOW CREATE TABLE students;

-- List all tables in the database
SHOW TABLES;
```',
 '[{"title": "Create a Products Table", "code": "CREATE TABLE products (\n    id          INT           PRIMARY KEY AUTO_INCREMENT,\n    name        VARCHAR(200)  NOT NULL,\n    price       DECIMAL(10,2) NOT NULL CHECK (price > 0),\n    stock       INT           DEFAULT 0,\n    category    VARCHAR(100),\n    created_at  DATETIME      DEFAULT NOW()\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\n-- Inspect the table\nDESC products;"}, {"title": "Create a Users Table", "code": "CREATE TABLE users (\n    id         INT          PRIMARY KEY AUTO_INCREMENT,\n    username   VARCHAR(50)  NOT NULL UNIQUE,\n    email      VARCHAR(255) NOT NULL UNIQUE,\n    password   VARCHAR(255) NOT NULL,\n    is_active  TINYINT(1)   DEFAULT 1,\n    role       ENUM(''user'', ''admin'', ''moderator'') DEFAULT ''user'',\n    created_at DATETIME     DEFAULT NOW()\n) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;\n\nSHOW TABLES;"}]',
 1);

-- ============ CONCEPT 2: ALTER TABLE and DROP TABLE ============
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('d5000000-0000-0000-0000-000000000031',
 'c5000000-0000-0000-0000-000000000007',
 'ALTER TABLE and DROP TABLE',
 '## ALTER TABLE — Modifying an Existing Table

Once a table exists, you can modify its structure with `ALTER TABLE`. This is one of the most commonly used DDL commands in real projects.

## Add a Column

```sql
-- Add a single column
ALTER TABLE students
ADD phone VARCHAR(15);

-- Add with position (AFTER specifies where)
ALTER TABLE students
ADD phone VARCHAR(15) AFTER email;

-- Add at the beginning
ALTER TABLE students
ADD profile_pic VARCHAR(500) FIRST;
```

## Remove a Column

```sql
-- Drop a column permanently
ALTER TABLE students
DROP COLUMN phone;
```

⚠️ **Warning:** `DROP COLUMN` permanently deletes the column and all its data!

## Modify a Column (Change Type or Constraints)

```sql
-- Change data type or size
ALTER TABLE students
MODIFY COLUMN name VARCHAR(200);   -- was VARCHAR(100)

-- Change type AND rename at the same time
ALTER TABLE students
CHANGE COLUMN age student_age TINYINT UNSIGNED;
--              old_name  new_name  new_type
```

## Rename a Table

```sql
-- Rename the table
ALTER TABLE students RENAME TO learners;
-- or:
RENAME TABLE students TO learners;
```

## Add or Drop Constraints

```sql
-- Add a UNIQUE constraint
ALTER TABLE students
ADD CONSTRAINT uq_email UNIQUE (email);

-- Add a FOREIGN KEY
ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id) REFERENCES customers(id)
ON DELETE CASCADE;

-- Drop an index/constraint
ALTER TABLE students
DROP INDEX uq_email;
```

## DROP TABLE — Delete a Table Completely

```sql
-- Delete table AND all its data — CANNOT be undone!
DROP TABLE students;

-- Safe version: only drops if it exists
DROP TABLE IF EXISTS students;

-- Drop multiple tables at once
DROP TABLE IF EXISTS orders, order_items, cart;
```

## TRUNCATE TABLE — Delete All Rows, Keep Structure

```sql
-- Removes all rows but keeps the empty table
TRUNCATE TABLE logs;

-- Difference from DELETE:
-- TRUNCATE is faster (no row-by-row logging)
-- TRUNCATE resets AUTO_INCREMENT back to 1
-- DELETE can use WHERE; TRUNCATE cannot
```

## Summary: DDL Commands

| Command | What it does |
|---------|-------------|
| `CREATE TABLE` | Create a new table |
| `ALTER TABLE ... ADD` | Add a column |
| `ALTER TABLE ... DROP COLUMN` | Remove a column |
| `ALTER TABLE ... MODIFY` | Change column type |
| `ALTER TABLE ... RENAME` | Rename the table |
| `DROP TABLE` | Delete table + all data |
| `TRUNCATE TABLE` | Delete all rows, keep table |',
 '[{"title": "ALTER TABLE Examples", "code": "-- Add a column\nALTER TABLE users\nADD last_login DATETIME;\n\n-- Modify a column size\nALTER TABLE users\nMODIFY COLUMN username VARCHAR(100);\n\n-- Remove a column\nALTER TABLE users\nDROP COLUMN last_login;\n\n-- Verify the changes\nDESC users;"}, {"title": "DROP and TRUNCATE", "code": "-- Remove all test data but keep table structure\nTRUNCATE TABLE test_orders;\n-- AUTO_INCREMENT resets to 1\n\n-- Completely delete the table\nDROP TABLE IF EXISTS temp_data;\n\n-- Check remaining tables\nSHOW TABLES;"}]',
 2);
