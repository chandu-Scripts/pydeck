-- PyDeck Full Concepts Seed Data
-- Run this in Supabase SQL Editor
-- First, clear existing concepts to avoid duplicates
DELETE FROM concepts;

-- ============ CONCEPTS FOR VARIABLES & DATA TYPES ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000001', 'Introduction to Variables',
'# Variables in Python

A **variable** is a named container that stores data in your computer''s memory. Think of it as a labeled box where you can put different values.

## Creating Variables

In Python, you create a variable by simply assigning a value to a name using the `=` operator. No need to declare the type!

```python
# Creating variables
name = "Alice"
age = 25
height = 5.6
is_student = True

# Python figures out the type automatically
print(name)      # Output: Alice
print(age)       # Output: 25
```

## Variable Naming Rules

1. Must start with a letter or underscore (`_`)
2. Can contain letters, numbers, and underscores
3. Case-sensitive (`age` and `Age` are different)
4. Cannot use Python keywords (`if`, `for`, `class`, etc.)

```python
# Valid variable names
my_name = "John"
_private = 100
userName2 = "Jane"

# Invalid variable names (will cause errors)
# 2name = "Error"      # Cannot start with number
# my-name = "Error"    # Cannot use hyphens
# class = "Error"      # Cannot use keywords
```

## Dynamic Typing

Python is dynamically typed - variables can change their type during execution:

```python
x = 10          # x is an integer
print(type(x))  # <class ''int''>

x = "Hello"     # Now x is a string
print(type(x))  # <class ''str''>

x = [1, 2, 3]   # Now x is a list
print(type(x))  # <class ''list''>
```', 1),

('c1000000-0000-0000-0000-000000000001', 'Python Data Types',
'# Python Data Types

Python has several built-in data types to handle different kinds of data.

## Numeric Types

### Integer (int)
Whole numbers without decimal points.

```python
age = 25
count = -10
big_number = 1_000_000  # Underscores for readability

print(type(age))  # <class ''int''>
```

### Float
Numbers with decimal points.

```python
price = 19.99
temperature = -5.5
pi = 3.14159

print(type(price))  # <class ''float''>
```

### Complex
Numbers with real and imaginary parts.

```python
z = 3 + 4j
print(z.real)  # 3.0
print(z.imag)  # 4.0
```

## Text Type (str)

Strings are sequences of characters enclosed in quotes.

```python
# Single or double quotes
name = ''Alice''
message = "Hello, World!"

# Triple quotes for multiline
poem = """Roses are red,
Violets are blue,
Python is awesome,
And so are you!"""

# String operations
greeting = "Hello" + " " + "World"  # Concatenation
repeat = "Ha" * 3                    # HaHaHa
```

## Boolean Type (bool)

Represents True or False values.

```python
is_valid = True
is_empty = False

# Booleans from comparisons
result = 10 > 5   # True
result = 10 == 5  # False
```

## None Type

Represents the absence of a value.

```python
data = None

if data is None:
    print("No data available")
```

## Type Conversion

Convert between types using built-in functions:

```python
# String to Integer
num_str = "42"
num = int(num_str)  # 42

# Integer to String
age = 25
age_str = str(age)  # "25"

# String to Float
price_str = "19.99"
price = float(price_str)  # 19.99

# To Boolean
bool(0)       # False
bool(1)       # True
bool("")      # False
bool("text")  # True
```', 2);

-- ============ CONCEPTS FOR STRINGS ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000003', 'String Basics',
'# Python Strings

A **string** is a sequence of characters enclosed in quotes. Strings are one of the most commonly used data types in Python.

## Creating Strings

```python
# Using single quotes
name = ''Alice''

# Using double quotes
message = "Hello, World!"

# Using triple quotes (for multiline)
description = """This is a
multiline string that spans
multiple lines."""

# Empty string
empty = ""
```

## String Indexing

Access individual characters using their index (position). Python uses **zero-based indexing**.

```python
text = "Python"
#       012345

print(text[0])   # P (first character)
print(text[1])   # y (second character)
print(text[5])   # n (last character)
print(text[-1])  # n (last character using negative index)
print(text[-2])  # o (second to last)
```

## String Slicing

Extract a portion of a string using `[start:stop:step]`.

```python
text = "Hello, World!"

print(text[0:5])    # Hello (characters 0 to 4)
print(text[7:12])   # World
print(text[:5])     # Hello (from start)
print(text[7:])     # World! (to end)
print(text[::2])    # Hlo ol! (every 2nd character)
print(text[::-1])   # !dlroW ,olleH (reversed)
```

## String Immutability

Strings cannot be changed after creation. Any operation creates a new string.

```python
name = "Alice"
# name[0] = "B"  # ERROR! Strings are immutable

# Instead, create a new string
name = "B" + name[1:]  # "Blice"
```

## String Concatenation and Repetition

```python
# Concatenation with +
first = "Hello"
second = "World"
result = first + " " + second  # "Hello World"

# Repetition with *
laugh = "Ha" * 3  # "HaHaHa"
line = "-" * 20   # "--------------------"
```', 1),

('c1000000-0000-0000-0000-000000000003', 'String Methods',
'# String Methods

Python strings come with many built-in methods for manipulation.

## Case Methods

```python
text = "Hello World"

print(text.upper())      # HELLO WORLD
print(text.lower())      # hello world
print(text.capitalize()) # Hello world
print(text.title())      # Hello World
print(text.swapcase())   # hELLO wORLD
```

## Search Methods

```python
text = "Hello World, Hello Python"

# Find position of substring
print(text.find("World"))     # 6 (first occurrence)
print(text.find("xyz"))       # -1 (not found)
print(text.rfind("Hello"))    # 13 (last occurrence)

# Count occurrences
print(text.count("Hello"))    # 2

# Check if starts/ends with
print(text.startswith("Hello"))  # True
print(text.endswith("Python"))   # True

# Check if substring exists
print("World" in text)        # True
```

## Modification Methods

```python
text = "  Hello World  "

# Remove whitespace
print(text.strip())   # "Hello World"
print(text.lstrip())  # "Hello World  "
print(text.rstrip())  # "  Hello World"

# Replace substring
message = "Hello World"
print(message.replace("World", "Python"))  # Hello Python

# Split into list
sentence = "apple,banana,cherry"
fruits = sentence.split(",")  # [''apple'', ''banana'', ''cherry'']

# Join list into string
words = ["Hello", "World"]
result = " ".join(words)  # "Hello World"
```

## Validation Methods

```python
# Check content type
"123".isdigit()      # True
"abc".isalpha()      # True
"abc123".isalnum()   # True
"   ".isspace()      # True
"Hello".isupper()    # False
"HELLO".isupper()    # True
"hello".islower()    # True
```

## String Formatting

```python
name = "Alice"
age = 25

# f-strings (recommended - Python 3.6+)
message = f"My name is {name} and I am {age} years old"

# format() method
message = "My name is {} and I am {} years old".format(name, age)

# Named placeholders
message = "My name is {n} and I am {a} years old".format(n=name, a=age)

# Formatting numbers
pi = 3.14159
print(f"Pi is approximately {pi:.2f}")  # Pi is approximately 3.14
print(f"Price: ${99.5:,.2f}")           # Price: $99.50
```', 2);

-- ============ CONCEPTS FOR LISTS ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000004', 'Introduction to Lists',
'# Python Lists

A **list** is an ordered, mutable collection of items. Lists can contain elements of different types and are one of the most versatile data structures in Python.

## Key Characteristics

- **Ordered**: Items maintain their insertion order
- **Mutable**: You can modify, add, or remove items after creation
- **Allows duplicates**: Lists can contain duplicate values
- **Indexed**: Access items by their position (0-based indexing)

## Creating Lists

```python
# Empty list
empty_list = []
also_empty = list()

# List with elements
fruits = ["apple", "banana", "cherry"]
numbers = [1, 2, 3, 4, 5]

# Mixed types (allowed but not recommended)
mixed = [1, "hello", 3.14, True, None]

# Using list() constructor
chars = list("hello")  # [''h'', ''e'', ''l'', ''l'', ''o'']
nums = list(range(5))  # [0, 1, 2, 3, 4]

# Nested lists
matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
]
```

## Accessing Elements

```python
fruits = ["apple", "banana", "cherry", "date", "elderberry"]
#          0        1         2         3        4
#         -5       -4        -3        -2       -1

# Positive indexing (from start)
print(fruits[0])   # apple (first element)
print(fruits[2])   # cherry (third element)

# Negative indexing (from end)
print(fruits[-1])  # elderberry (last element)
print(fruits[-2])  # date (second to last)

# Accessing nested lists
matrix = [[1, 2], [3, 4], [5, 6]]
print(matrix[0])      # [1, 2]
print(matrix[0][1])   # 2
print(matrix[1][0])   # 3
```

## Checking List Length

```python
fruits = ["apple", "banana", "cherry"]
print(len(fruits))  # 3

# Check if list is empty
if len(fruits) == 0:
    print("List is empty")

# Pythonic way to check if empty
if not fruits:
    print("List is empty")
```', 1),

('c1000000-0000-0000-0000-000000000004', 'List Slicing',
'# List Slicing

Slicing allows you to extract a portion of a list using the syntax `list[start:stop:step]`.

## Basic Slicing Syntax

```python
list[start:stop:step]
```

- **start**: Starting index (inclusive, default 0)
- **stop**: Ending index (exclusive, default end of list)
- **step**: Step size (default 1)

## Examples

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Basic slicing
print(numbers[2:5])    # [2, 3, 4] - index 2 to 4
print(numbers[0:3])    # [0, 1, 2] - first 3 elements
print(numbers[5:8])    # [5, 6, 7] - index 5 to 7

# Omitting start or stop
print(numbers[:4])     # [0, 1, 2, 3] - from start to index 3
print(numbers[6:])     # [6, 7, 8, 9] - from index 6 to end
print(numbers[:])      # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9] - copy all
```

## Using Step

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Every second element
print(numbers[::2])    # [0, 2, 4, 6, 8]

# Every third element
print(numbers[::3])    # [0, 3, 6, 9]

# Every second, starting from index 1
print(numbers[1::2])   # [1, 3, 5, 7, 9]

# Reverse the list
print(numbers[::-1])   # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]

# Every second element, reversed
print(numbers[::-2])   # [9, 7, 5, 3, 1]
```

## Negative Indices in Slicing

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Last 3 elements
print(numbers[-3:])    # [7, 8, 9]

# All except last 2
print(numbers[:-2])    # [0, 1, 2, 3, 4, 5, 6, 7]

# From third-to-last to second-to-last
print(numbers[-3:-1])  # [7, 8]
```

## Slice Assignment

You can modify multiple elements at once using slice assignment:

```python
numbers = [0, 1, 2, 3, 4, 5]

# Replace a slice
numbers[1:4] = [10, 20, 30]
print(numbers)  # [0, 10, 20, 30, 4, 5]

# Insert elements (replace with more)
numbers[1:2] = [100, 200, 300]
print(numbers)  # [0, 100, 200, 300, 20, 30, 4, 5]

# Delete elements (replace with empty)
numbers[1:4] = []
print(numbers)  # [0, 20, 30, 4, 5]
```', 2),

('c1000000-0000-0000-0000-000000000004', 'List Methods',
'# List Methods

Python lists come with many built-in methods for manipulation.

## Adding Elements

### append() - Add to End
```python
fruits = ["apple", "banana"]
fruits.append("cherry")
print(fruits)  # [''apple'', ''banana'', ''cherry'']

# append() adds the item as-is
fruits.append(["date", "elderberry"])
print(fruits)  # [''apple'', ''banana'', ''cherry'', [''date'', ''elderberry'']]
```

### extend() - Add Multiple Elements
```python
fruits = ["apple", "banana"]
fruits.extend(["cherry", "date"])
print(fruits)  # [''apple'', ''banana'', ''cherry'', ''date'']

# extend() iterates and adds each element
more = ["elderberry", "fig"]
fruits.extend(more)
print(fruits)  # [''apple'', ''banana'', ''cherry'', ''date'', ''elderberry'', ''fig'']
```

### insert() - Add at Specific Position
```python
fruits = ["apple", "cherry"]
fruits.insert(1, "banana")  # Insert at index 1
print(fruits)  # [''apple'', ''banana'', ''cherry'']

fruits.insert(0, "first")   # Insert at beginning
print(fruits)  # [''first'', ''apple'', ''banana'', ''cherry'']
```

## Removing Elements

### remove() - Remove by Value
```python
fruits = ["apple", "banana", "cherry", "banana"]
fruits.remove("banana")  # Removes FIRST occurrence
print(fruits)  # [''apple'', ''cherry'', ''banana'']

# Raises ValueError if not found
# fruits.remove("grape")  # ValueError!
```

### pop() - Remove by Index
```python
fruits = ["apple", "banana", "cherry"]

# Remove and return last element
last = fruits.pop()
print(last)    # cherry
print(fruits)  # [''apple'', ''banana'']

# Remove and return at specific index
first = fruits.pop(0)
print(first)   # apple
print(fruits)  # [''banana'']
```

### clear() - Remove All Elements
```python
fruits = ["apple", "banana", "cherry"]
fruits.clear()
print(fruits)  # []
```

### del - Delete by Index or Slice
```python
fruits = ["apple", "banana", "cherry", "date"]

del fruits[1]      # Delete at index 1
print(fruits)      # [''apple'', ''cherry'', ''date'']

del fruits[0:2]    # Delete a slice
print(fruits)      # [''date'']
```

## Searching and Counting

```python
fruits = ["apple", "banana", "cherry", "banana", "date"]

# Find index of element
print(fruits.index("banana"))  # 1 (first occurrence)
print(fruits.index("cherry"))  # 2

# Count occurrences
print(fruits.count("banana"))  # 2
print(fruits.count("grape"))   # 0

# Check if element exists
print("apple" in fruits)       # True
print("grape" in fruits)       # False
```

## Sorting and Reversing

```python
numbers = [3, 1, 4, 1, 5, 9, 2, 6]

# Sort in place (modifies original)
numbers.sort()
print(numbers)  # [1, 1, 2, 3, 4, 5, 6, 9]

# Sort in descending order
numbers.sort(reverse=True)
print(numbers)  # [9, 6, 5, 4, 3, 2, 1, 1]

# Reverse in place
numbers.reverse()
print(numbers)  # [1, 1, 2, 3, 4, 5, 6, 9]

# sorted() returns new list (original unchanged)
original = [3, 1, 4]
new_sorted = sorted(original)
print(original)    # [3, 1, 4]
print(new_sorted)  # [1, 3, 4]
```

## Copying Lists

```python
original = [1, 2, 3]

# These create references (NOT copies!)
reference = original
reference[0] = 99
print(original)  # [99, 2, 3] - Original changed!

# Correct ways to copy
copy1 = original.copy()
copy2 = original[:]
copy3 = list(original)

copy1[0] = 100
print(original)  # [99, 2, 3] - Original unchanged
print(copy1)     # [100, 2, 3]
```', 3);

-- ============ CONCEPTS FOR LOOPS ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000007', 'For Loops',
'# For Loops in Python

A **for loop** is used to iterate over a sequence (list, tuple, string, range, etc.) and execute a block of code for each item.

## Basic Syntax

```python
for item in sequence:
    # Code to execute for each item
    print(item)
```

## Iterating Over Lists

```python
fruits = ["apple", "banana", "cherry"]

for fruit in fruits:
    print(fruit)

# Output:
# apple
# banana
# cherry
```

## Iterating Over Strings

```python
word = "Python"

for char in word:
    print(char)

# Output:
# P
# y
# t
# h
# o
# n
```

## Using range()

The `range()` function generates a sequence of numbers.

```python
# range(stop) - 0 to stop-1
for i in range(5):
    print(i)  # 0, 1, 2, 3, 4

# range(start, stop) - start to stop-1
for i in range(2, 6):
    print(i)  # 2, 3, 4, 5

# range(start, stop, step)
for i in range(0, 10, 2):
    print(i)  # 0, 2, 4, 6, 8

# Counting backwards
for i in range(5, 0, -1):
    print(i)  # 5, 4, 3, 2, 1
```

## Enumerate - Get Index and Value

```python
fruits = ["apple", "banana", "cherry"]

for index, fruit in enumerate(fruits):
    print(f"{index}: {fruit}")

# Output:
# 0: apple
# 1: banana
# 2: cherry

# Start from different index
for index, fruit in enumerate(fruits, start=1):
    print(f"{index}: {fruit}")

# Output:
# 1: apple
# 2: banana
# 3: cherry
```

## Iterating Over Dictionaries

```python
person = {"name": "Alice", "age": 25, "city": "NYC"}

# Iterate over keys (default)
for key in person:
    print(key)  # name, age, city

# Iterate over values
for value in person.values():
    print(value)  # Alice, 25, NYC

# Iterate over key-value pairs
for key, value in person.items():
    print(f"{key}: {value}")
```

## Nested Loops

```python
# Multiplication table
for i in range(1, 4):
    for j in range(1, 4):
        print(f"{i} x {j} = {i*j}")
    print("---")

# Iterate over 2D list
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]

for row in matrix:
    for num in row:
        print(num, end=" ")
    print()  # New line after each row
```', 1),

('c1000000-0000-0000-0000-000000000007', 'While Loops',
'# While Loops in Python

A **while loop** repeatedly executes a block of code as long as a condition is True.

## Basic Syntax

```python
while condition:
    # Code to execute while condition is True
    # Make sure to update condition to avoid infinite loop!
```

## Simple Example

```python
count = 0

while count < 5:
    print(count)
    count += 1  # Don''t forget this!

# Output: 0, 1, 2, 3, 4
```

## User Input Loop

```python
# Keep asking until valid input
while True:
    password = input("Enter password: ")
    if password == "secret":
        print("Access granted!")
        break
    else:
        print("Wrong password, try again.")
```

## Sentinel Value Pattern

```python
# Process items until sentinel value
total = 0

while True:
    num = int(input("Enter number (-1 to stop): "))
    if num == -1:
        break
    total += num

print(f"Total: {total}")
```

## While with Else

The `else` block runs when the condition becomes False (not when `break` is used).

```python
count = 0

while count < 3:
    print(count)
    count += 1
else:
    print("Loop completed normally")

# Output: 0, 1, 2, Loop completed normally
```

## Common While Loop Patterns

### Countdown
```python
countdown = 5
while countdown > 0:
    print(countdown)
    countdown -= 1
print("Blast off!")
```

### Finding in List
```python
numbers = [4, 7, 2, 9, 1, 5]
target = 9
index = 0

while index < len(numbers):
    if numbers[index] == target:
        print(f"Found {target} at index {index}")
        break
    index += 1
else:
    print(f"{target} not found")
```

### Processing Queue
```python
tasks = ["task1", "task2", "task3"]

while tasks:  # While list is not empty
    current = tasks.pop(0)
    print(f"Processing: {current}")

# Output:
# Processing: task1
# Processing: task2
# Processing: task3
```', 2),

('c1000000-0000-0000-0000-000000000007', 'Loop Control Statements',
'# Loop Control Statements

Python provides three statements to control the flow of loops: `break`, `continue`, and `pass`.

## break - Exit the Loop

The `break` statement immediately terminates the loop and continues with the next statement after the loop.

```python
# Stop when we find the target
numbers = [1, 3, 5, 7, 9, 11]

for num in numbers:
    if num == 7:
        print("Found 7!")
        break
    print(num)

# Output: 1, 3, 5, Found 7!
# Note: 9 and 11 are not printed
```

### Break in Nested Loops
`break` only exits the innermost loop:

```python
for i in range(3):
    for j in range(3):
        if j == 1:
            break  # Only breaks inner loop
        print(f"i={i}, j={j}")

# Output:
# i=0, j=0
# i=1, j=0
# i=2, j=0
```

## continue - Skip to Next Iteration

The `continue` statement skips the rest of the current iteration and moves to the next one.

```python
# Print only odd numbers
for num in range(10):
    if num % 2 == 0:  # If even
        continue       # Skip to next iteration
    print(num)

# Output: 1, 3, 5, 7, 9
```

### Practical Example
```python
# Process only valid data
data = [10, -5, 20, None, 30, -15, 40]

total = 0
for value in data:
    if value is None or value < 0:
        continue  # Skip invalid/negative values
    total += value

print(f"Total: {total}")  # Total: 100
```

## pass - Do Nothing

The `pass` statement is a placeholder that does nothing. It''s used when syntax requires a statement but you don''t want any action.

```python
# Placeholder for future code
for i in range(5):
    if i == 3:
        pass  # TODO: Handle special case
    else:
        print(i)

# Empty function or class
def future_function():
    pass

class FutureClass:
    pass
```

## Combining Control Statements

```python
# Find first valid even number greater than 5
numbers = [1, 3, 4, 7, 8, 11, 12]

for num in numbers:
    # Skip odd numbers
    if num % 2 != 0:
        continue

    # Skip small even numbers
    if num <= 5:
        continue

    # Found it!
    print(f"First valid number: {num}")
    break
else:
    print("No valid number found")

# Output: First valid number: 8
```

## Loop with else

Both `for` and `while` loops can have an `else` clause that runs when the loop completes normally (without `break`).

```python
# Search with else
def find_item(items, target):
    for item in items:
        if item == target:
            print(f"Found: {target}")
            break
    else:
        print(f"Not found: {target}")

find_item([1, 2, 3, 4, 5], 3)  # Found: 3
find_item([1, 2, 3, 4, 5], 9)  # Not found: 9
```', 3);

-- ============ CONCEPTS FOR FUNCTIONS ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000009', 'Defining Functions',
'# Python Functions

A **function** is a reusable block of code that performs a specific task. Functions help organize code, make it reusable, and easier to understand.

## Why Use Functions?

- **Reusability**: Write once, use many times
- **Organization**: Break complex problems into smaller pieces
- **Readability**: Give meaningful names to code blocks
- **Maintainability**: Fix bugs in one place

## Basic Syntax

```python
def function_name(parameters):
    """Docstring: Describe what the function does"""
    # Function body
    # Code to execute
    return result  # Optional
```

## Simple Examples

```python
# Function with no parameters
def greet():
    print("Hello, World!")

greet()  # Call the function
# Output: Hello, World!

# Function with one parameter
def greet_person(name):
    print(f"Hello, {name}!")

greet_person("Alice")  # Hello, Alice!
greet_person("Bob")    # Hello, Bob!

# Function with multiple parameters
def add(a, b):
    return a + b

result = add(3, 5)
print(result)  # 8
```

## Return Statement

Functions can return values using the `return` statement.

```python
# Single return value
def square(n):
    return n ** 2

result = square(4)  # 16

# Multiple return values (as tuple)
def get_stats(numbers):
    return min(numbers), max(numbers), sum(numbers)

minimum, maximum, total = get_stats([1, 2, 3, 4, 5])
print(minimum)  # 1
print(maximum)  # 5
print(total)    # 15

# Early return
def divide(a, b):
    if b == 0:
        return None  # Return early if division by zero
    return a / b

print(divide(10, 2))  # 5.0
print(divide(10, 0))  # None
```

## Functions Without Return

If no `return` statement, the function returns `None`.

```python
def print_message(msg):
    print(msg)
    # No return statement

result = print_message("Hello")
print(result)  # None
```

## Docstrings

Document your functions with docstrings:

```python
def calculate_area(length, width):
    """
    Calculate the area of a rectangle.

    Args:
        length: The length of the rectangle
        width: The width of the rectangle

    Returns:
        The area of the rectangle
    """
    return length * width

# Access docstring
print(calculate_area.__doc__)
```', 1),

('c1000000-0000-0000-0000-000000000009', 'Function Parameters',
'# Function Parameters and Arguments

Python offers flexible ways to pass data to functions.

## Positional Arguments

Arguments are matched to parameters by position.

```python
def describe_pet(animal, name):
    print(f"I have a {animal} named {name}")

describe_pet("dog", "Buddy")     # I have a dog named Buddy
describe_pet("cat", "Whiskers")  # I have a cat named Whiskers

# Order matters!
describe_pet("Buddy", "dog")  # I have a Buddy named dog (wrong!)
```

## Keyword Arguments

Arguments are matched by parameter name.

```python
def describe_pet(animal, name):
    print(f"I have a {animal} named {name}")

# Order doesn''t matter with keyword arguments
describe_pet(name="Buddy", animal="dog")  # I have a dog named Buddy
describe_pet(animal="cat", name="Whiskers")  # I have a cat named Whiskers

# Mix positional and keyword (positional first!)
describe_pet("dog", name="Buddy")  # OK
# describe_pet(animal="dog", "Buddy")  # SyntaxError!
```

## Default Parameter Values

Provide default values for optional parameters.

```python
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")              # Hello, Alice!
greet("Bob", "Hi")          # Hi, Bob!
greet("Charlie", greeting="Hey")  # Hey, Charlie!
```

### Important: Default Values Position

Parameters with defaults must come after those without.

```python
# Correct
def function(required, optional="default"):
    pass

# Error!
# def function(optional="default", required):
#     pass
```

### Mutable Default Values (Gotcha!)

Never use mutable objects (lists, dicts) as default values!

```python
# WRONG - Mutable default
def add_item(item, items=[]):
    items.append(item)
    return items

print(add_item("a"))  # [''a'']
print(add_item("b"))  # [''a'', ''b''] - Unexpected!

# CORRECT - Use None
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

## *args - Variable Positional Arguments

Accept any number of positional arguments as a tuple.

```python
def sum_all(*numbers):
    return sum(numbers)

print(sum_all(1, 2))           # 3
print(sum_all(1, 2, 3, 4, 5))  # 15
print(sum_all())               # 0

# Combine with regular parameters
def greet_all(greeting, *names):
    for name in names:
        print(f"{greeting}, {name}!")

greet_all("Hello", "Alice", "Bob", "Charlie")
# Hello, Alice!
# Hello, Bob!
# Hello, Charlie!
```

## **kwargs - Variable Keyword Arguments

Accept any number of keyword arguments as a dictionary.

```python
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=25, city="NYC")
# name: Alice
# age: 25
# city: NYC

# Combine all argument types
def example(pos1, pos2, *args, default=10, **kwargs):
    print(f"pos1: {pos1}")
    print(f"pos2: {pos2}")
    print(f"args: {args}")
    print(f"default: {default}")
    print(f"kwargs: {kwargs}")

example(1, 2, 3, 4, 5, default=20, x=100, y=200)
```

## Unpacking Arguments

Use `*` and `**` to unpack sequences and dictionaries as arguments.

```python
def add(a, b, c):
    return a + b + c

# Unpack list/tuple
numbers = [1, 2, 3]
print(add(*numbers))  # 6

# Unpack dictionary
params = {"a": 1, "b": 2, "c": 3}
print(add(**params))  # 6
```', 2),

('c1000000-0000-0000-0000-000000000009', 'Lambda Functions',
'# Lambda Functions

A **lambda function** is a small anonymous function defined in a single line.

## Basic Syntax

```python
lambda arguments: expression
```

## Simple Examples

```python
# Regular function
def add(x, y):
    return x + y

# Equivalent lambda
add = lambda x, y: x + y

print(add(3, 5))  # 8

# More examples
square = lambda x: x ** 2
print(square(4))  # 16

greet = lambda name: f"Hello, {name}!"
print(greet("Alice"))  # Hello, Alice!
```

## Lambda with Built-in Functions

Lambdas are commonly used with `map()`, `filter()`, and `sorted()`.

### With map()

```python
numbers = [1, 2, 3, 4, 5]

# Square each number
squares = list(map(lambda x: x ** 2, numbers))
print(squares)  # [1, 4, 9, 16, 25]

# Convert to strings
strings = list(map(lambda x: str(x), numbers))
print(strings)  # [''1'', ''2'', ''3'', ''4'', ''5'']
```

### With filter()

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

# Filter even numbers
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6, 8, 10]

# Filter numbers greater than 5
big = list(filter(lambda x: x > 5, numbers))
print(big)  # [6, 7, 8, 9, 10]
```

### With sorted()

```python
# Sort by custom key
students = [
    {"name": "Alice", "grade": 85},
    {"name": "Bob", "grade": 92},
    {"name": "Charlie", "grade": 78}
]

# Sort by grade
by_grade = sorted(students, key=lambda s: s["grade"])
print(by_grade)
# [{''name'': ''Charlie'', ...}, {''name'': ''Alice'', ...}, {''name'': ''Bob'', ...}]

# Sort strings by length
words = ["apple", "pie", "banana", "kiwi"]
by_length = sorted(words, key=lambda w: len(w))
print(by_length)  # [''pie'', ''kiwi'', ''apple'', ''banana'']
```

## Lambda vs Regular Functions

### Use Lambda When:
- Function is simple (single expression)
- Used once or as an argument
- No need for documentation

### Use Regular Function When:
- Logic is complex (multiple lines)
- Function is reused
- Need docstring or type hints

```python
# Good use of lambda
sorted(items, key=lambda x: x.price)

# Better as regular function
def calculate_tax(income, rate, deductions):
    """Calculate tax with deductions."""
    taxable = income - deductions
    if taxable < 0:
        return 0
    return taxable * rate
```

## Immediately Invoked Lambda

```python
# Define and call immediately
result = (lambda x, y: x + y)(3, 5)
print(result)  # 8

# Useful for conditional expressions
value = (lambda: "yes" if condition else "no")()
```', 3);

-- ============ CONCEPTS FOR DICTIONARIES ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000006', 'Dictionary Basics',
'# Python Dictionaries

A **dictionary** is an unordered collection of key-value pairs. Dictionaries are mutable and provide fast lookups by key.

## Key Characteristics

- **Key-Value Pairs**: Each element has a key and a value
- **Keys Must Be Unique**: No duplicate keys allowed
- **Keys Must Be Immutable**: Strings, numbers, tuples (not lists)
- **Values Can Be Anything**: Any data type
- **Mutable**: Can add, remove, and modify items

## Creating Dictionaries

```python
# Empty dictionary
empty = {}
also_empty = dict()

# Dictionary with items
person = {
    "name": "Alice",
    "age": 25,
    "city": "New York"
}

# Using dict() constructor
person = dict(name="Alice", age=25, city="New York")

# From list of tuples
pairs = [("a", 1), ("b", 2), ("c", 3)]
letters = dict(pairs)  # {''a'': 1, ''b'': 2, ''c'': 3}
```

## Accessing Values

```python
person = {"name": "Alice", "age": 25, "city": "NYC"}

# Using square brackets
print(person["name"])  # Alice
# print(person["email"])  # KeyError!

# Using get() - safer, returns None if key missing
print(person.get("name"))   # Alice
print(person.get("email"))  # None
print(person.get("email", "N/A"))  # N/A (default value)
```

## Adding and Modifying Items

```python
person = {"name": "Alice", "age": 25}

# Add new key-value pair
person["email"] = "alice@example.com"

# Modify existing value
person["age"] = 26

print(person)
# {''name'': ''Alice'', ''age'': 26, ''email'': ''alice@example.com''}

# Update multiple at once
person.update({"age": 27, "city": "NYC"})
```

## Removing Items

```python
person = {"name": "Alice", "age": 25, "city": "NYC"}

# Remove and return value
age = person.pop("age")
print(age)     # 25
print(person)  # {''name'': ''Alice'', ''city'': ''NYC''}

# Remove with default if missing
email = person.pop("email", "No email")
print(email)  # No email

# Remove last inserted item
last = person.popitem()
print(last)  # (''city'', ''NYC'')

# Delete with del
del person["name"]

# Clear all items
person.clear()
```

## Checking Keys

```python
person = {"name": "Alice", "age": 25}

# Check if key exists
print("name" in person)   # True
print("email" in person)  # False

# Check if key not exists
print("email" not in person)  # True
```', 1),

('c1000000-0000-0000-0000-000000000006', 'Dictionary Methods & Iteration',
'# Dictionary Methods and Iteration

## Getting Keys, Values, and Items

```python
person = {"name": "Alice", "age": 25, "city": "NYC"}

# Get all keys
keys = person.keys()
print(list(keys))  # [''name'', ''age'', ''city'']

# Get all values
values = person.values()
print(list(values))  # [''Alice'', 25, ''NYC'']

# Get all key-value pairs as tuples
items = person.items()
print(list(items))  # [(''name'', ''Alice''), (''age'', 25), (''city'', ''NYC'')]
```

## Iterating Over Dictionaries

```python
person = {"name": "Alice", "age": 25, "city": "NYC"}

# Iterate over keys (default)
for key in person:
    print(key)

# Iterate over values
for value in person.values():
    print(value)

# Iterate over key-value pairs
for key, value in person.items():
    print(f"{key}: {value}")

# Output:
# name: Alice
# age: 25
# city: NYC
```

## Dictionary Comprehensions

Create dictionaries using a concise syntax.

```python
# Basic comprehension
squares = {x: x**2 for x in range(5)}
print(squares)  # {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# With condition
even_squares = {x: x**2 for x in range(10) if x % 2 == 0}
print(even_squares)  # {0: 0, 2: 4, 4: 16, 6: 36, 8: 64}

# Transform existing dict
prices = {"apple": 1.5, "banana": 0.75, "cherry": 2.0}
discounted = {k: v * 0.9 for k, v in prices.items()}
print(discounted)  # {''apple'': 1.35, ''banana'': 0.675, ''cherry'': 1.8}

# Swap keys and values
original = {"a": 1, "b": 2, "c": 3}
swapped = {v: k for k, v in original.items()}
print(swapped)  # {1: ''a'', 2: ''b'', 3: ''c''}
```

## Useful Dictionary Methods

```python
person = {"name": "Alice", "age": 25}

# setdefault() - get value or set default
email = person.setdefault("email", "unknown@example.com")
print(email)   # unknown@example.com
print(person)  # Now has email key

# fromkeys() - create dict with same value
keys = ["a", "b", "c"]
default_dict = dict.fromkeys(keys, 0)
print(default_dict)  # {''a'': 0, ''b'': 0, ''c'': 0}

# copy() - shallow copy
copy = person.copy()
```

## Nested Dictionaries

```python
# Dictionary of dictionaries
students = {
    "alice": {"age": 20, "grade": "A"},
    "bob": {"age": 21, "grade": "B"},
    "charlie": {"age": 19, "grade": "A"}
}

# Access nested values
print(students["alice"]["grade"])  # A

# Modify nested values
students["bob"]["grade"] = "A"

# Add new nested dictionary
students["diana"] = {"age": 22, "grade": "B"}

# Iterate over nested dict
for name, info in students.items():
    print(f"{name}: age {info[''age'']}, grade {info[''grade'']}")
```

## Merging Dictionaries

```python
dict1 = {"a": 1, "b": 2}
dict2 = {"c": 3, "d": 4}

# Using update() - modifies dict1
dict1.update(dict2)
print(dict1)  # {''a'': 1, ''b'': 2, ''c'': 3, ''d'': 4}

# Using | operator (Python 3.9+)
dict1 = {"a": 1, "b": 2}
dict2 = {"c": 3, "d": 4}
merged = dict1 | dict2
print(merged)  # {''a'': 1, ''b'': 2, ''c'': 3, ''d'': 4}

# Using ** unpacking
merged = {**dict1, **dict2}
print(merged)  # {''a'': 1, ''b'': 2, ''c'': 3, ''d'': 4}
```', 2);

-- ============ CONCEPTS FOR CONDITIONALS ============
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000008', 'If Statements',
'# Conditional Statements in Python

Conditional statements allow your program to make decisions and execute different code based on conditions.

## Basic if Statement

```python
age = 18

if age >= 18:
    print("You are an adult")
    print("You can vote")

# Output:
# You are an adult
# You can vote
```

## if-else Statement

```python
age = 15

if age >= 18:
    print("You are an adult")
else:
    print("You are a minor")

# Output: You are a minor
```

## if-elif-else Statement

Use `elif` (else if) to check multiple conditions.

```python
score = 85

if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 70:
    grade = "C"
elif score >= 60:
    grade = "D"
else:
    grade = "F"

print(f"Your grade is: {grade}")  # Your grade is: B
```

## Comparison Operators

```python
a = 10
b = 5

# Equal
print(a == b)   # False

# Not equal
print(a != b)   # True

# Greater than
print(a > b)    # True

# Less than
print(a < b)    # False

# Greater than or equal
print(a >= b)   # True

# Less than or equal
print(a <= b)   # False
```

## Logical Operators

Combine multiple conditions with `and`, `or`, `not`.

```python
age = 25
has_license = True

# and - both must be True
if age >= 18 and has_license:
    print("You can drive")

# or - at least one must be True
is_weekend = True
is_holiday = False

if is_weekend or is_holiday:
    print("No work today!")

# not - negates the condition
is_raining = False

if not is_raining:
    print("Nice weather!")
```

## Nested Conditionals

```python
age = 25
has_ticket = True

if age >= 18:
    if has_ticket:
        print("Welcome to the show!")
    else:
        print("Please buy a ticket")
else:
    print("Sorry, adults only")
```

## Truthy and Falsy Values

In Python, these values are considered **False** (falsy):
- `False`, `None`
- `0`, `0.0`
- `""` (empty string)
- `[]`, `()`, `{}` (empty collections)

Everything else is **True** (truthy).

```python
# Instead of checking if len(items) > 0
items = [1, 2, 3]

if items:  # Truthy check
    print("List has items")

# Instead of checking if name != ""
name = "Alice"

if name:  # Truthy check
    print(f"Hello, {name}")

# Instead of checking if value is not None
value = get_value()

if value:
    process(value)
```', 1),

('c1000000-0000-0000-0000-000000000008', 'Advanced Conditionals',
'# Advanced Conditional Techniques

## Ternary Operator (Conditional Expression)

Write simple if-else in one line.

```python
# Syntax: value_if_true if condition else value_if_false

age = 20
status = "adult" if age >= 18 else "minor"
print(status)  # adult

# Use in expressions
x = 10
result = "positive" if x > 0 else "zero or negative"

# Nested ternary (avoid if complex)
score = 85
grade = "A" if score >= 90 else "B" if score >= 80 else "C" if score >= 70 else "F"
```

## Multiple Conditions with in

```python
# Instead of multiple == checks
day = "Saturday"

# Verbose way
if day == "Saturday" or day == "Sunday":
    print("Weekend!")

# Better way using in
if day in ["Saturday", "Sunday"]:
    print("Weekend!")

# Works with any sequence
vowels = "aeiou"
char = "e"

if char in vowels:
    print(f"{char} is a vowel")
```

## Chained Comparisons

Python allows chaining comparisons naturally.

```python
age = 25

# Instead of this
if age >= 18 and age < 65:
    print("Working age")

# Use chained comparison
if 18 <= age < 65:
    print("Working age")

# Another example
x = 5

if 0 < x < 10:
    print("x is between 0 and 10")

# Multiple chains
if 1 < a < b < c < 10:
    print("In sequence and within range")
```

## Match Statement (Python 3.10+)

Pattern matching similar to switch-case in other languages.

```python
def get_day_type(day):
    match day:
        case "Saturday" | "Sunday":
            return "Weekend"
        case "Monday":
            return "Start of work week"
        case "Friday":
            return "End of work week"
        case _:  # Default case (underscore)
            return "Weekday"

print(get_day_type("Saturday"))  # Weekend
print(get_day_type("Wednesday"))  # Weekday

# Pattern matching with values
def describe_point(point):
    match point:
        case (0, 0):
            return "Origin"
        case (0, y):
            return f"On Y-axis at y={y}"
        case (x, 0):
            return f"On X-axis at x={x}"
        case (x, y):
            return f"Point at ({x}, {y})"

print(describe_point((0, 0)))   # Origin
print(describe_point((5, 0)))   # On X-axis at x=5
print(describe_point((3, 4)))   # Point at (3, 4)
```

## Short-Circuit Evaluation

Python stops evaluating as soon as the result is determined.

```python
# With and - stops at first False
x = 0
if x != 0 and (10 / x) > 1:  # Safe! Doesn''t divide by zero
    print("Yes")

# With or - stops at first True
name = ""
display = name or "Anonymous"  # If name is falsy, use "Anonymous"
print(display)  # Anonymous

# Common pattern: default values
def greet(name=None):
    name = name or "Guest"
    print(f"Hello, {name}!")

greet()         # Hello, Guest!
greet("Alice")  # Hello, Alice!
```

## Guard Clauses

Handle edge cases early to reduce nesting.

```python
# Deeply nested (hard to read)
def process_data(data):
    if data:
        if len(data) > 0:
            if is_valid(data):
                # Process data
                return result
            else:
                return "Invalid data"
        else:
            return "Empty data"
    else:
        return "No data"

# With guard clauses (cleaner)
def process_data(data):
    if not data:
        return "No data"

    if len(data) == 0:
        return "Empty data"

    if not is_valid(data):
        return "Invalid data"

    # Process data (happy path)
    return result
```', 2);
