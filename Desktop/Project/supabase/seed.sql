-- PyDeck Seed Data: Technology Learning Flashcards
-- Run this AFTER schema.sql in Supabase SQL Editor

-- ============ PATHS (Technologies) ============
INSERT INTO paths (id, name, description, icon, display_order) VALUES
  ('a1000000-0000-0000-0000-000000000001', 'Python', 'Master Python programming from basics to advanced', 'Code', 1),
  ('a1000000-0000-0000-0000-000000000002', 'SQL', 'Learn database queries and management', 'Database', 2),
  ('a1000000-0000-0000-0000-000000000003', 'Flask', 'Build web applications with Flask', 'Zap', 3),
  ('a1000000-0000-0000-0000-000000000004', 'Django', 'Full-stack web development with Django', 'Layers', 4);

-- ============ TOPICS ============

-- Python topics (previously paths, now topics under Python)
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b1000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000001', 'Python Basics', 'Code', 1),
  ('b1000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000001', 'Intermediate Python', 'Layers', 2),
  ('b1000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000001', 'Advanced Python', 'Cpu', 3),
  ('b1000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000001', 'Data Structures & Algorithms', 'GitBranch', 4);

-- SQL topics
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b2000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000002', 'SQL Basics', 'Database', 1),
  ('b2000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000002', 'Joins & Relationships', 'Link', 2),
  ('b2000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000002', 'Aggregations & Grouping', 'BarChart', 3),
  ('b2000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000002', 'Advanced SQL', 'Zap', 4);

-- Flask topics
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b3000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000003', 'Flask Basics', 'Zap', 1),
  ('b3000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000003', 'Routes & Views', 'Navigation', 2),
  ('b3000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000003', 'Templates & Jinja2', 'FileText', 3),
  ('b3000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000003', 'Flask with Databases', 'Database', 4);

-- Django topics
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b4000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000004', 'Django Basics', 'Layers', 1),
  ('b4000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000004', 'Models & ORM', 'Database', 2),
  ('b4000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000004', 'Views & Templates', 'Layout', 3),
  ('b4000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000004', 'Django REST Framework', 'Zap', 4);

-- ============ FLASHCARDS ============

-- ========== PYTHON FLASHCARDS ==========

-- Python Basics
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b1000000-0000-0000-0000-000000000001', 'In Python, the ____ function is used to check the data type of a variable.', 'type()', 'type(x) returns the class/type of x. Example: type(42) returns <class ''int''>'),
  ('b1000000-0000-0000-0000-000000000001', 'Python has ____ main numeric data types: int, float, and ____.', 'three, complex', 'Complex numbers use j for the imaginary part. Example: 3 + 4j'),
  ('b1000000-0000-0000-0000-000000000001', 'A variable in Python is created the moment you first ____ a value to it.', 'assign', 'Python has no command for declaring a variable. x = 5 creates x.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ keyword is used to check if two variables refer to the same object in memory.', 'is', 'Use ''is'' for identity comparison, == for value comparison.'),
  ('b1000000-0000-0000-0000-000000000001', 'Python is ____ typed, meaning you don''t need to declare variable types.', 'dynamically', 'The interpreter determines the type at runtime based on the assigned value.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ function converts a value to an integer.', 'int()', 'int("42") returns 42, int(3.7) returns 3 (truncates towards zero).'),
  ('b1000000-0000-0000-0000-000000000001', 'None in Python represents the absence of a ____.', 'value', 'None is a singleton object of type NoneType. Use "is None" to check for it.'),
  ('b1000000-0000-0000-0000-000000000001', 'A ____ is an immutable sequence of characters in Python.', 'string', 'Strings can be created with single quotes, double quotes, or triple quotes.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ statement is used to skip the current iteration and continue with the next one.', 'continue', 'continue jumps to the next iteration of the nearest enclosing loop.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ statement immediately exits the loop entirely.', 'break', 'break terminates the nearest enclosing for or while loop.'),
  ('b1000000-0000-0000-0000-000000000001', 'The range() function generates a sequence of ____.', 'numbers', 'range(5) generates 0,1,2,3,4. range(2,5) generates 2,3,4.'),
  ('b1000000-0000-0000-0000-000000000001', 'Python uses ____ instead of curly braces to define code blocks.', 'indentation', 'Standard is 4 spaces per indentation level. Mixing tabs and spaces causes errors.'),
  ('b1000000-0000-0000-0000-000000000001', 'Functions in Python are defined using the ____ keyword.', 'def', 'Syntax: def function_name(parameters): followed by indented body.'),
  ('b1000000-0000-0000-0000-000000000001', 'A function that doesn''t explicitly return a value returns ____.', 'None', 'If no return statement is reached, or return is called without a value, None is returned.'),
  ('b1000000-0000-0000-0000-000000000001', '*args allows a function to accept any number of ____ arguments.', 'positional', '*args collects extra positional arguments into a tuple.'),
  ('b1000000-0000-0000-0000-000000000001', '**kwargs allows a function to accept any number of ____ arguments.', 'keyword', '**kwargs collects extra keyword arguments into a dictionary.'),
  ('b1000000-0000-0000-0000-000000000001', 'Lists are ____ while tuples are ____.', 'mutable, immutable', 'Lists use [], tuples use (). Tuples are faster and can be used as dict keys.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ method adds an element to the end of a list.', 'append()', 'append() adds one element. Use extend() to add multiple elements from an iterable.'),
  ('b1000000-0000-0000-0000-000000000001', 'Dictionaries store data in ____ pairs.', 'key-value', 'Keys must be immutable (str, int, tuple). Values can be any type.'),
  ('b1000000-0000-0000-0000-000000000001', 'The ____ method returns a value for a key, with an optional default if key is missing.', 'get()', 'd.get("key", "default") returns "default" if "key" doesn''t exist. No KeyError.');

-- Intermediate Python
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b1000000-0000-0000-0000-000000000002', 'The ____ function is used to open a file in Python.', 'open()', 'Syntax: open(filename, mode). Common modes: "r" read, "w" write, "a" append.'),
  ('b1000000-0000-0000-0000-000000000002', 'The ____ statement is the recommended way to handle files as it auto-closes them.', 'with', 'with open("file.txt") as f: ensures the file is closed even if an error occurs.'),
  ('b1000000-0000-0000-0000-000000000002', 'Python handles errors using ____, except, and finally blocks.', 'try', 'try contains risky code, except catches errors, finally always runs.'),
  ('b1000000-0000-0000-0000-000000000002', 'The ____ keyword is used to manually trigger an exception.', 'raise', 'raise ValueError("Invalid input") throws a ValueError with a message.'),
  ('b1000000-0000-0000-0000-000000000002', 'The ____ method is the constructor in a Python class.', '__init__', '__init__(self) is called automatically when a new instance is created.'),
  ('b1000000-0000-0000-0000-000000000002', 'The first parameter of every method in a class is ____.', 'self', 'self refers to the current instance. It''s a convention, not a keyword.'),
  ('b1000000-0000-0000-0000-000000000002', '____ allows a child class to inherit attributes and methods from a parent class.', 'Inheritance', 'class Child(Parent): inherits everything from Parent. Use super() to call parent methods.'),
  ('b1000000-0000-0000-0000-000000000002', 'A list comprehension has the syntax: [expression for item in ____ if condition].', 'iterable', 'Example: [x**2 for x in range(10) if x % 2 == 0] gives squares of even numbers.'),
  ('b1000000-0000-0000-0000-000000000002', 'A ____ comprehension uses curly braces {} and creates a dictionary.', 'dictionary', '{k: v for k, v in pairs} creates a dict from key-value pairs.'),
  ('b1000000-0000-0000-0000-000000000002', 'A ____ function is a small anonymous function defined with the lambda keyword.', 'lambda', 'Syntax: lambda arguments: expression. Example: lambda x: x * 2'),
  ('b1000000-0000-0000-0000-000000000002', 'The map() function applies a function to every item of an ____.', 'iterable', 'map(func, iterable) returns a map object. Use list() to convert to list.'),
  ('b1000000-0000-0000-0000-000000000002', 'The filter() function returns items where the function returns ____.', 'True', 'filter(func, iterable) keeps only items where func(item) is truthy.');

-- Advanced Python
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b1000000-0000-0000-0000-000000000003', 'A decorator is a function that takes a ____ as argument and returns a modified function.', 'function', 'Decorators use @decorator_name syntax above the function definition.'),
  ('b1000000-0000-0000-0000-000000000003', 'The @____ decorator makes a method accessible like an attribute.', 'property', '@property turns a method into a getter. Use @name.setter for the setter.'),
  ('b1000000-0000-0000-0000-000000000003', 'The @staticmethod decorator defines a method that doesn''t receive ____ or cls.', 'self', 'Static methods are utility functions that belong to the class namespace.'),
  ('b1000000-0000-0000-0000-000000000003', 'The ____ keyword turns a function into a generator function.', 'yield', 'yield pauses the function and sends a value back. The state is preserved.'),
  ('b1000000-0000-0000-0000-000000000003', 'The ____ function retrieves the next item from an iterator.', 'next()', 'next(iterator) returns the next value. Raises StopIteration when exhausted.'),
  ('b1000000-0000-0000-0000-000000000003', 'Generators are memory-efficient because they produce values ____.', 'lazily (on-demand)', 'Unlike lists, generators don''t store all values in memory at once.'),
  ('b1000000-0000-0000-0000-000000000003', 'A context manager implements ____ and __exit__ methods.', '__enter__', 'Used with the with statement for resource management (files, locks, etc.).'),
  ('b1000000-0000-0000-0000-000000000003', 'The threading module is used for ____ in Python.', 'multithreading', 'Due to GIL, use multiprocessing for CPU-bound tasks, threading for I/O-bound.'),
  ('b1000000-0000-0000-0000-000000000003', 'Type hints use ____ syntax to specify expected types.', 'colon (:)', 'def greet(name: str) -> str: indicates name should be str, returns str.');

-- Data Structures & Algorithms
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b1000000-0000-0000-0000-000000000004', 'A ____ is a data structure that follows Last In, First Out (LIFO) principle.', 'stack', 'Push adds to top, pop removes from top. Used in undo operations, function calls.'),
  ('b1000000-0000-0000-0000-000000000004', 'A ____ is a data structure that follows First In, First Out (FIFO) principle.', 'queue', 'Enqueue adds to back, dequeue removes from front. Used in task scheduling.'),
  ('b1000000-0000-0000-0000-000000000004', 'The time complexity of accessing an element in an array by index is ____.', 'O(1)', 'Direct access by index is constant time. No iteration needed.'),
  ('b1000000-0000-0000-0000-000000000004', 'Binary search has a time complexity of ____.', 'O(log n)', 'Each step halves the search space. Requires a sorted array.'),
  ('b1000000-0000-0000-0000-000000000004', 'A ____ list is a data structure where each element points to the next.', 'linked', 'Nodes contain data and a reference to the next node. O(1) insertion/deletion.'),
  ('b1000000-0000-0000-0000-000000000004', 'A hash table provides average ____ time complexity for lookup.', 'O(1)', 'Hash function maps keys to indices. Collisions can degrade to O(n).'),
  ('b1000000-0000-0000-0000-000000000004', 'In a binary tree, each node has at most ____ children.', 'two', 'Left child and right child. A binary search tree maintains sorted order.'),
  ('b1000000-0000-0000-0000-000000000004', 'Bubble sort has a time complexity of ____ in the worst case.', 'O(n²)', 'Compares adjacent elements and swaps. Simple but inefficient for large datasets.'),
  ('b1000000-0000-0000-0000-000000000004', 'Quick sort has an average time complexity of ____.', 'O(n log n)', 'Divide and conquer using a pivot. Worst case O(n²) with bad pivot choice.'),
  ('b1000000-0000-0000-0000-000000000004', 'A recursive function must have a ____ case to stop recursion.', 'base', 'Without a base case, recursion continues infinitely causing stack overflow.');

-- ========== SQL FLASHCARDS ==========

-- SQL Basics
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b2000000-0000-0000-0000-000000000001', 'The ____ statement is used to retrieve data from a database.', 'SELECT', 'SELECT column1, column2 FROM table_name; Use * to select all columns.'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ clause is used to filter records in a query.', 'WHERE', 'WHERE condition filters rows. Example: WHERE age > 18'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ statement is used to add new records to a table.', 'INSERT INTO', 'INSERT INTO table (col1, col2) VALUES (val1, val2);'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ statement is used to modify existing records.', 'UPDATE', 'UPDATE table SET column = value WHERE condition; Always use WHERE!'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ statement is used to remove records from a table.', 'DELETE', 'DELETE FROM table WHERE condition; Without WHERE, deletes all rows!'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ keyword is used to sort the result set.', 'ORDER BY', 'ORDER BY column ASC/DESC; ASC is ascending (default), DESC is descending.'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ keyword eliminates duplicate rows from results.', 'DISTINCT', 'SELECT DISTINCT column FROM table; Returns only unique values.'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ clause limits the number of rows returned.', 'LIMIT', 'SELECT * FROM table LIMIT 10; Returns first 10 rows. Use OFFSET for pagination.'),
  ('b2000000-0000-0000-0000-000000000001', 'NULL represents a ____ or unknown value in SQL.', 'missing', 'Use IS NULL or IS NOT NULL to check. NULL != NULL is not true!'),
  ('b2000000-0000-0000-0000-000000000001', 'The ____ operator is used to search for a pattern in a column.', 'LIKE', 'WHERE name LIKE ''A%'' finds names starting with A. % = any chars, _ = one char.');

-- Joins & Relationships
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b2000000-0000-0000-0000-000000000002', 'An ____ JOIN returns only matching rows from both tables.', 'INNER', 'INNER JOIN is the default. Only rows with matches in both tables are returned.'),
  ('b2000000-0000-0000-0000-000000000002', 'A ____ JOIN returns all rows from the left table and matched rows from the right.', 'LEFT', 'LEFT JOIN (or LEFT OUTER JOIN) keeps all left rows, NULLs for unmatched right.'),
  ('b2000000-0000-0000-0000-000000000002', 'A ____ JOIN returns all rows from both tables, matched or not.', 'FULL OUTER', 'FULL OUTER JOIN combines LEFT and RIGHT joins. NULLs for unmatched on either side.'),
  ('b2000000-0000-0000-0000-000000000002', 'A ____ key uniquely identifies each record in a table.', 'PRIMARY', 'PRIMARY KEY is unique and NOT NULL. Each table should have one.'),
  ('b2000000-0000-0000-0000-000000000002', 'A ____ key is a column that references the primary key of another table.', 'FOREIGN', 'FOREIGN KEY creates relationships between tables. Enforces referential integrity.'),
  ('b2000000-0000-0000-0000-000000000002', 'A ____ JOIN returns the Cartesian product of two tables.', 'CROSS', 'CROSS JOIN combines every row of table1 with every row of table2.'),
  ('b2000000-0000-0000-0000-000000000002', 'A table can reference itself using a ____ join.', 'self', 'Self join: SELECT * FROM employees e1 JOIN employees e2 ON e1.manager_id = e2.id'),
  ('b2000000-0000-0000-0000-000000000002', 'The ON clause specifies the ____ condition for a join.', 'join/matching', 'ON table1.column = table2.column defines how tables are related.');

-- Aggregations & Grouping
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b2000000-0000-0000-0000-000000000003', 'The ____ function returns the number of rows.', 'COUNT()', 'COUNT(*) counts all rows. COUNT(column) counts non-NULL values.'),
  ('b2000000-0000-0000-0000-000000000003', 'The ____ function calculates the average of a numeric column.', 'AVG()', 'AVG(column) returns the mean. NULL values are ignored.'),
  ('b2000000-0000-0000-0000-000000000003', 'The ____ function returns the total sum of a numeric column.', 'SUM()', 'SUM(column) adds all values. Returns NULL if all values are NULL.'),
  ('b2000000-0000-0000-0000-000000000003', 'The ____ clause groups rows that have the same values.', 'GROUP BY', 'GROUP BY column; Often used with aggregate functions like COUNT, SUM.'),
  ('b2000000-0000-0000-0000-000000000003', 'The ____ clause filters groups after GROUP BY.', 'HAVING', 'HAVING is like WHERE but for groups. Example: HAVING COUNT(*) > 5'),
  ('b2000000-0000-0000-0000-000000000003', 'MAX() and MIN() return the ____ and ____ values.', 'largest, smallest', 'Works on numbers, strings, and dates. NULL values are ignored.');

-- Advanced SQL
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b2000000-0000-0000-0000-000000000004', 'A ____ is a named query that can be referenced like a table.', 'view', 'CREATE VIEW view_name AS SELECT...; Views simplify complex queries.'),
  ('b2000000-0000-0000-0000-000000000004', 'A ____ is a query nested inside another query.', 'subquery', 'SELECT * FROM t WHERE id IN (SELECT id FROM other); Can be in SELECT, FROM, WHERE.'),
  ('b2000000-0000-0000-0000-000000000004', 'The ____ keyword combines result sets of two SELECT statements.', 'UNION', 'UNION removes duplicates. UNION ALL keeps all rows including duplicates.'),
  ('b2000000-0000-0000-0000-000000000004', 'A ____ is a database object that speeds up data retrieval.', 'index', 'CREATE INDEX idx ON table(column); Faster reads but slower writes.'),
  ('b2000000-0000-0000-0000-000000000004', 'The ____ statement creates a new table in the database.', 'CREATE TABLE', 'CREATE TABLE name (column1 datatype, column2 datatype, ...);'),
  ('b2000000-0000-0000-0000-000000000004', 'A ____ ensures that values in a column meet a specific condition.', 'constraint', 'CHECK, UNIQUE, NOT NULL, PRIMARY KEY, FOREIGN KEY are common constraints.'),
  ('b2000000-0000-0000-0000-000000000004', 'Window functions operate on a set of rows called a ____.', 'window/partition', 'ROW_NUMBER(), RANK(), LAG(), LEAD() are window functions. Use OVER() clause.'),
  ('b2000000-0000-0000-0000-000000000004', 'A CTE (Common Table Expression) is defined using the ____ keyword.', 'WITH', 'WITH cte_name AS (SELECT...) SELECT * FROM cte_name; Improves readability.');

-- ========== FLASK FLASHCARDS ==========

-- Flask Basics
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b3000000-0000-0000-0000-000000000001', 'Flask is a ____ web framework for Python.', 'micro', 'Micro means minimal core with extensions. No ORM or form validation built-in.'),
  ('b3000000-0000-0000-0000-000000000001', 'The Flask application instance is created using ____.', 'Flask(__name__)', 'from flask import Flask; app = Flask(__name__) creates the app.'),
  ('b3000000-0000-0000-0000-000000000001', 'To run a Flask app in debug mode, set app.run(____=True).', 'debug', 'Debug mode enables auto-reload and detailed error pages. Never use in production!'),
  ('b3000000-0000-0000-0000-000000000001', 'The default port for Flask development server is ____.', '5000', 'Access at http://localhost:5000. Change with app.run(port=8080).'),
  ('b3000000-0000-0000-0000-000000000001', 'Flask uses ____ as its default templating engine.', 'Jinja2', 'Jinja2 allows embedding Python-like expressions in HTML templates.');

-- Routes & Views
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b3000000-0000-0000-0000-000000000002', 'The ____ decorator is used to bind a URL to a function.', '@app.route()', '@app.route("/path") defines the URL. The function below handles requests.'),
  ('b3000000-0000-0000-0000-000000000002', 'Dynamic URL parameters are captured using ____ syntax.', '<variable>', '@app.route("/user/<username>") passes username to the function.'),
  ('b3000000-0000-0000-0000-000000000002', 'The ____ object contains data about the current HTTP request.', 'request', 'from flask import request; request.method, request.args, request.form, etc.'),
  ('b3000000-0000-0000-0000-000000000002', 'To restrict a route to specific HTTP methods, use the ____ parameter.', 'methods', '@app.route("/login", methods=["GET", "POST"]) allows both methods.'),
  ('b3000000-0000-0000-0000-000000000002', 'The ____ function generates a URL for a given function name.', 'url_for()', 'url_for("function_name") returns the URL. Useful for redirects and links.'),
  ('b3000000-0000-0000-0000-000000000002', 'The ____ function sends the user to a different URL.', 'redirect()', 'from flask import redirect; return redirect(url_for("home"))');

-- Templates & Jinja2
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b3000000-0000-0000-0000-000000000003', 'The ____ function renders an HTML template with context.', 'render_template()', 'return render_template("index.html", name=name) passes name to template.'),
  ('b3000000-0000-0000-0000-000000000003', 'In Jinja2, variables are displayed using ____ syntax.', '{{ }}', '{{ variable }} outputs the value. {{ user.name }} accesses attributes.'),
  ('b3000000-0000-0000-0000-000000000003', 'Jinja2 control structures use ____ syntax.', '{% %}', '{% if condition %}...{% endif %}, {% for item in items %}...{% endfor %}'),
  ('b3000000-0000-0000-0000-000000000003', 'Template ____ allows child templates to override sections of a parent.', 'inheritance', '{% extends "base.html" %} and {% block content %}...{% endblock %}'),
  ('b3000000-0000-0000-0000-000000000003', 'The ____ filter escapes HTML characters to prevent XSS.', 'escape (or e)', '{{ user_input|e }} converts < to &lt;, etc. Auto-escaping is on by default.');

-- Flask with Databases
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b3000000-0000-0000-0000-000000000004', 'Flask-____ is the popular ORM extension for Flask.', 'SQLAlchemy', 'pip install flask-sqlalchemy. Provides db.Model base class for models.'),
  ('b3000000-0000-0000-0000-000000000004', 'The database URI is configured via app.config["____"].', 'SQLALCHEMY_DATABASE_URI', 'Example: "sqlite:///app.db" or "postgresql://user:pass@host/db"'),
  ('b3000000-0000-0000-0000-000000000004', 'To create all tables defined in models, call db.____.', 'create_all()', 'with app.app_context(): db.create_all() creates tables from models.'),
  ('b3000000-0000-0000-0000-000000000004', 'To add a record to the database session, use db.session.____.', 'add()', 'db.session.add(user); db.session.commit() saves to database.'),
  ('b3000000-0000-0000-0000-000000000004', 'Flask-____ handles database migrations.', 'Migrate', 'flask db init, flask db migrate, flask db upgrade for schema changes.');

-- ========== DJANGO FLASHCARDS ==========

-- Django Basics
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b4000000-0000-0000-0000-000000000001', 'Django follows the ____ architectural pattern.', 'MTV (Model-Template-View)', 'Model = data, Template = presentation, View = logic. Similar to MVC.'),
  ('b4000000-0000-0000-0000-000000000001', 'A new Django project is created using ____.', 'django-admin startproject', 'django-admin startproject myproject creates project structure.'),
  ('b4000000-0000-0000-0000-000000000001', 'A new Django app is created using ____.', 'python manage.py startapp', 'python manage.py startapp myapp creates an app within the project.'),
  ('b4000000-0000-0000-0000-000000000001', 'The ____ file contains project-wide settings.', 'settings.py', 'INSTALLED_APPS, DATABASES, TEMPLATES, etc. are configured here.'),
  ('b4000000-0000-0000-0000-000000000001', 'Django includes a built-in ____ panel for managing data.', 'admin', 'Access at /admin. Register models with admin.site.register(Model).'),
  ('b4000000-0000-0000-0000-000000000001', 'To run the development server, use python manage.py ____.', 'runserver', 'Default runs at http://127.0.0.1:8000. Can specify port: runserver 8080');

-- Models & ORM
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b4000000-0000-0000-0000-000000000002', 'Django models inherit from ____.', 'models.Model', 'from django.db import models; class MyModel(models.Model):'),
  ('b4000000-0000-0000-0000-000000000002', 'To create database tables from models, run python manage.py ____.', 'migrate', 'First run makemigrations to create migration files, then migrate to apply.'),
  ('b4000000-0000-0000-0000-000000000002', 'The ____ method returns a human-readable string for a model instance.', '__str__', 'def __str__(self): return self.name displays nicely in admin.'),
  ('b4000000-0000-0000-0000-000000000002', 'Model.objects is the default ____ for database queries.', 'manager', 'User.objects.all(), User.objects.filter(), User.objects.get()'),
  ('b4000000-0000-0000-0000-000000000002', 'ForeignKey creates a ____ relationship between models.', 'many-to-one', 'ForeignKey(OtherModel, on_delete=models.CASCADE) links to another model.'),
  ('b4000000-0000-0000-0000-000000000002', 'ManyToManyField creates a ____ relationship without an explicit join table.', 'many-to-many', 'Django automatically creates the intermediate table.'),
  ('b4000000-0000-0000-0000-000000000002', 'The ____ lookup performs a case-insensitive contains search.', 'icontains', 'User.objects.filter(name__icontains="john") finds John, JOHN, etc.');

-- Views & Templates
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b4000000-0000-0000-0000-000000000003', 'Django views receive a ____ object and return a response.', 'request', 'def my_view(request): return HttpResponse("Hello")'),
  ('b4000000-0000-0000-0000-000000000003', 'The ____ shortcut renders a template with context.', 'render()', 'return render(request, "template.html", {"key": value})'),
  ('b4000000-0000-0000-0000-000000000003', 'URL patterns are defined in ____ files.', 'urls.py', 'from django.urls import path; urlpatterns = [path("route/", view)]'),
  ('b4000000-0000-0000-0000-000000000003', 'Class-based views inherit from ____.', 'View (or generic views)', 'from django.views import View; from django.views.generic import ListView'),
  ('b4000000-0000-0000-0000-000000000003', 'The {% ____ %} tag generates URLs in templates.', 'url', '{% url "view_name" arg1 arg2 %} generates the URL for that view.'),
  ('b4000000-0000-0000-0000-000000000003', 'The {% ____ %} tag includes CSRF token in forms.', 'csrf_token', 'Required for POST forms. Protects against Cross-Site Request Forgery.');

-- Django REST Framework
INSERT INTO flashcards (topic_id, question, answer, explanation) VALUES
  ('b4000000-0000-0000-0000-000000000004', 'DRF ____ convert model instances to JSON and vice versa.', 'serializers', 'class MySerializer(serializers.ModelSerializer): handles conversion.'),
  ('b4000000-0000-0000-0000-000000000004', 'The @____decorator converts a function to an API view.', 'api_view', 'from rest_framework.decorators import api_view; @api_view(["GET", "POST"])'),
  ('b4000000-0000-0000-0000-000000000004', 'DRF ____ provide CRUD operations with minimal code.', 'ViewSets', 'class MyViewSet(viewsets.ModelViewSet): + router = automatic CRUD URLs.'),
  ('b4000000-0000-0000-0000-000000000004', 'The Response class returns data with content ____.', 'negotiation', 'Response(data) automatically renders as JSON, HTML, etc. based on request.'),
  ('b4000000-0000-0000-0000-000000000004', 'DRF includes a browsable ____ for testing endpoints.', 'API', 'Access endpoints in browser for interactive testing with forms.');
