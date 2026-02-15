-- PyDeck Seed Data: Subtopics, Concepts, and MCQ Flashcards
-- Run this AFTER migration.sql in Supabase SQL Editor

-- ============ SUBTOPICS FOR PYTHON BASICS ============
INSERT INTO subtopics (id, topic_id, name, icon, display_order) VALUES
  ('c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001', 'Variables & Data Types', 'Variable', 1),
  ('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001', 'Operators', 'Calculator', 2),
  ('c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001', 'Strings', 'Type', 3),
  ('c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001', 'Lists', 'List', 4),
  ('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001', 'Tuples', 'Package', 5),
  ('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001', 'Dictionaries', 'BookOpen', 6),
  ('c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001', 'Loops', 'Repeat', 7),
  ('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001', 'Conditionals', 'GitBranch', 8),
  ('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001', 'Functions', 'FunctionSquare', 9);

-- ============ SUBTOPICS FOR INTERMEDIATE PYTHON ============
INSERT INTO subtopics (id, topic_id, name, icon, display_order) VALUES
  ('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002', 'File Handling', 'File', 1),
  ('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002', 'Exception Handling', 'AlertTriangle', 2),
  ('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002', 'Classes & Objects', 'Box', 3),
  ('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002', 'List Comprehensions', 'Layers', 4),
  ('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002', 'Lambda Functions', 'Zap', 5),
  ('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002', 'Modules & Packages', 'Package', 6);

-- ============ CONCEPTS FOR LISTS SUBTOPIC ============
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
  ('d1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000004', 'Introduction to Lists',
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

# List with elements
fruits = ["apple", "banana", "cherry"]

# Mixed types
mixed = [1, "hello", 3.14, True]

# Using list() constructor
numbers = list(range(1, 6))  # [1, 2, 3, 4, 5]
```

## Accessing Elements

```python
fruits = ["apple", "banana", "cherry", "date"]

# Positive indexing (from start)
print(fruits[0])   # apple
print(fruits[2])   # cherry

# Negative indexing (from end)
print(fruits[-1])  # date
print(fruits[-2])  # cherry
```',
'[{"title": "Creating Lists", "code": "fruits = [\"apple\", \"banana\", \"cherry\"]\nnumbers = list(range(1, 6))\nprint(fruits)  # [''apple'', ''banana'', ''cherry'']"}, {"title": "Accessing Elements", "code": "fruits = [\"apple\", \"banana\", \"cherry\"]\nprint(fruits[0])   # apple\nprint(fruits[-1])  # cherry"}]',
1),

  ('d1000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000004', 'List Methods',
'# List Methods

Python lists come with many built-in methods for manipulation.

## Adding Elements

### append()
Adds a single element to the end of the list.

```python
fruits = ["apple", "banana"]
fruits.append("cherry")
print(fruits)  # [''apple'', ''banana'', ''cherry'']
```

### extend()
Adds multiple elements from an iterable to the end.

```python
fruits = ["apple", "banana"]
fruits.extend(["cherry", "date"])
print(fruits)  # [''apple'', ''banana'', ''cherry'', ''date'']
```

### insert()
Inserts an element at a specific position.

```python
fruits = ["apple", "cherry"]
fruits.insert(1, "banana")
print(fruits)  # [''apple'', ''banana'', ''cherry'']
```

## Removing Elements

### remove()
Removes the first occurrence of a value.

```python
fruits = ["apple", "banana", "cherry"]
fruits.remove("banana")
print(fruits)  # [''apple'', ''cherry'']
```

### pop()
Removes and returns an element at a given index (default: last).

```python
fruits = ["apple", "banana", "cherry"]
removed = fruits.pop()      # removes ''cherry''
removed = fruits.pop(0)     # removes ''apple''
```

### clear()
Removes all elements from the list.

```python
fruits = ["apple", "banana"]
fruits.clear()
print(fruits)  # []
```',
'[{"title": "append vs extend", "code": "list1 = [1, 2]\nlist1.append([3, 4])    # [1, 2, [3, 4]]\n\nlist2 = [1, 2]\nlist2.extend([3, 4])    # [1, 2, 3, 4]"}, {"title": "pop() returns value", "code": "stack = [1, 2, 3]\nlast = stack.pop()  # last = 3\nprint(stack)        # [1, 2]"}]',
2),

  ('d1000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000004', 'List Slicing',
'# List Slicing

Slicing allows you to extract a portion of a list using the syntax `list[start:stop:step]`.

## Basic Slicing

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Get elements from index 2 to 5 (exclusive)
print(numbers[2:5])    # [2, 3, 4]

# From start to index 4
print(numbers[:4])     # [0, 1, 2, 3]

# From index 5 to end
print(numbers[5:])     # [5, 6, 7, 8, 9]

# Copy entire list
print(numbers[:])      # [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

## Using Step

```python
numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

# Every second element
print(numbers[::2])    # [0, 2, 4, 6, 8]

# Every third element starting from index 1
print(numbers[1::3])   # [1, 4, 7]

# Reverse the list
print(numbers[::-1])   # [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
```

## Negative Indices in Slicing

```python
numbers = [0, 1, 2, 3, 4, 5]

# Last 3 elements
print(numbers[-3:])    # [3, 4, 5]

# All except last 2
print(numbers[:-2])    # [0, 1, 2, 3]
```',
'[{"title": "Common Patterns", "code": "data = [1, 2, 3, 4, 5]\nfirst_three = data[:3]     # [1, 2, 3]\nlast_two = data[-2:]       # [4, 5]\nreversed_list = data[::-1] # [5, 4, 3, 2, 1]"}]',
3);

-- ============ CONCEPTS FOR FUNCTIONS SUBTOPIC ============
INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
  ('d2000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000009', 'Defining Functions',
'# Python Functions

Functions are reusable blocks of code that perform a specific task.

## Basic Syntax

```python
def function_name(parameters):
    """Docstring describing the function"""
    # Function body
    return result
```

## Simple Examples

```python
def greet():
    print("Hello, World!")

def greet_person(name):
    print(f"Hello, {name}!")

def add(a, b):
    return a + b
```

## Calling Functions

```python
greet()                    # Hello, World!
greet_person("Alice")      # Hello, Alice!
result = add(3, 5)         # result = 8
```

## Return Values

A function can return a value using the `return` statement. If no return statement is used, the function returns `None`.

```python
def square(n):
    return n ** 2

def get_stats(numbers):
    return min(numbers), max(numbers), sum(numbers)

# Multiple return values
minimum, maximum, total = get_stats([1, 2, 3, 4, 5])
```',
'[{"title": "Basic Function", "code": "def multiply(a, b):\n    return a * b\n\nresult = multiply(4, 5)\nprint(result)  # 20"}]',
1),

  ('d2000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000009', 'Function Arguments',
'# Function Arguments

Python supports various types of function arguments for flexibility.

## Positional Arguments

Arguments matched by position in the function call.

```python
def describe_pet(animal, name):
    print(f"I have a {animal} named {name}")

describe_pet("dog", "Buddy")  # I have a dog named Buddy
```

## Keyword Arguments

Arguments specified by parameter name.

```python
describe_pet(name="Whiskers", animal="cat")
# I have a cat named Whiskers
```

## Default Values

Parameters can have default values.

```python
def greet(name, greeting="Hello"):
    print(f"{greeting}, {name}!")

greet("Alice")              # Hello, Alice!
greet("Bob", "Hi")          # Hi, Bob!
```

## *args and **kwargs

### *args - Variable Positional Arguments

```python
def sum_all(*numbers):
    return sum(numbers)

print(sum_all(1, 2, 3))      # 6
print(sum_all(1, 2, 3, 4, 5)) # 15
```

### **kwargs - Variable Keyword Arguments

```python
def print_info(**kwargs):
    for key, value in kwargs.items():
        print(f"{key}: {value}")

print_info(name="Alice", age=25, city="NYC")
# name: Alice
# age: 25
# city: NYC
```',
'[{"title": "Combining All Argument Types", "code": "def example(pos, *args, default=10, **kwargs):\n    print(f\"pos={pos}\")\n    print(f\"args={args}\")\n    print(f\"default={default}\")\n    print(f\"kwargs={kwargs}\")\n\nexample(1, 2, 3, default=20, x=100, y=200)"}]',
2);

-- ============ MCQ FLASHCARDS FOR LISTS SUBTOPIC ============
INSERT INTO flashcards (id, subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option) VALUES
  ('e1000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'Which method adds an element to the end of a list?',
   'append()',
   'append() adds a single element to the end of the list. insert() adds at a specific index, extend() adds multiple elements, and push() does not exist in Python lists.',
   'add()', 'append()', 'insert()', 'push()', 'b'),

  ('e1000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'What is the output of: fruits = ["a", "b", "c"]; print(fruits[-1])?',
   'c',
   'Negative indexing starts from the end of the list. -1 refers to the last element, which is "c".',
   'a', 'b', 'c', 'Error', 'c'),

  ('e1000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'Which statement correctly creates an empty list?',
   'Both [] and list()',
   'In Python, you can create an empty list using square brackets [] or the list() constructor. Both are valid and produce the same result.',
   '[] only', 'list() only', 'Both [] and list()', 'Neither', 'c'),

  ('e1000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'What does nums[1:4] return if nums = [0, 1, 2, 3, 4, 5]?',
   '[1, 2, 3]',
   'Slicing with [1:4] returns elements from index 1 up to (but not including) index 4. So we get elements at indices 1, 2, and 3.',
   '[1, 2, 3, 4]', '[0, 1, 2, 3]', '[1, 2, 3]', '[2, 3, 4]', 'c'),

  ('e1000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'What is the difference between append() and extend()?',
   'append() adds one element, extend() adds multiple',
   'append() adds its argument as a single element. extend() iterates over its argument and adds each element individually.',
   'No difference', 'append() adds one element, extend() adds multiple', 'extend() adds one element, append() adds multiple', 'append() is faster', 'b'),

  ('e1000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'How do you reverse a list in Python?',
   'All of the above',
   'list.reverse() reverses in place, list[::-1] creates a reversed copy, and reversed() returns an iterator that can be converted to a list.',
   'list.reverse()', 'list[::-1]', 'reversed(list)', 'All of the above', 'd'),

  ('e1000000-0000-0000-0000-000000000007', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'What does pop() return when called on a list?',
   'The removed element',
   'pop() removes and returns the element at the given index (last element by default). This is useful when you need to use the removed value.',
   'None', 'True', 'The removed element', 'The new list length', 'c'),

  ('e1000000-0000-0000-0000-000000000008', 'c1000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000001',
   'Are Python lists mutable or immutable?',
   'Mutable',
   'Lists are mutable, meaning you can change their contents after creation. You can add, remove, or modify elements.',
   'Immutable', 'Mutable', 'Neither', 'Depends on contents', 'b');

-- ============ MCQ FLASHCARDS FOR FUNCTIONS SUBTOPIC ============
INSERT INTO flashcards (id, subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option) VALUES
  ('e2000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'Which keyword is used to define a function in Python?',
   'def',
   'The def keyword is used to define functions in Python. It is followed by the function name and parentheses.',
   'function', 'def', 'func', 'define', 'b'),

  ('e2000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'What does a function return if no return statement is specified?',
   'None',
   'If a function does not have a return statement, or has a return statement without a value, it returns None by default.',
   '0', 'Empty string', 'None', 'Error', 'c'),

  ('e2000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'What does *args allow in a function definition?',
   'Variable number of positional arguments',
   '*args collects extra positional arguments into a tuple, allowing the function to accept any number of positional arguments.',
   'Variable number of keyword arguments', 'Variable number of positional arguments', 'Required arguments', 'Default arguments', 'b'),

  ('e2000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'What does **kwargs allow in a function definition?',
   'Variable number of keyword arguments',
   '**kwargs collects extra keyword arguments into a dictionary, allowing the function to accept any number of keyword arguments.',
   'Variable number of positional arguments', 'Variable number of keyword arguments', 'Required arguments', 'Two arguments only', 'b'),

  ('e2000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'What is the correct way to call a function with default parameters?',
   'Both with and without the argument',
   'When a function has default parameters, you can call it with or without providing values for those parameters.',
   'Must provide all arguments', 'Both with and without the argument', 'Cannot have default parameters', 'Must omit default arguments', 'b'),

  ('e2000000-0000-0000-0000-000000000006', 'c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
   'Where should parameters with default values be placed?',
   'After parameters without defaults',
   'Parameters with default values must come after parameters without defaults in the function definition.',
   'Before parameters without defaults', 'After parameters without defaults', 'Anywhere in the parameter list', 'Must be the only parameters', 'b');

-- ============ MCQ FLASHCARDS FOR VARIABLES SUBTOPIC ============
INSERT INTO flashcards (id, subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option) VALUES
  ('e3000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'What function is used to check the data type of a variable?',
   'type()',
   'The type() function returns the type/class of an object. For example, type(42) returns <class ''int''>.',
   'typeof()', 'type()', 'dtype()', 'gettype()', 'b'),

  ('e3000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'Which of these is a valid variable name in Python?',
   '_my_var',
   'Variable names can start with a letter or underscore, not a number. They cannot contain special characters like @ or be reserved keywords.',
   '2myvar', 'my-var', '_my_var', 'my@var', 'c'),

  ('e3000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'What is Python''s typing system called?',
   'Dynamic typing',
   'Python uses dynamic typing, meaning variable types are determined at runtime and can change during execution.',
   'Static typing', 'Dynamic typing', 'Strong typing', 'Weak typing', 'b'),

  ('e3000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000001',
   'What value represents "nothing" or "no value" in Python?',
   'None',
   'None is a special constant in Python that represents the absence of a value or a null value.',
   'null', 'undefined', 'None', 'void', 'c');

-- ============ MCQ FLASHCARDS FOR LOOPS SUBTOPIC ============
INSERT INTO flashcards (id, subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option) VALUES
  ('e4000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
   'What statement skips to the next iteration of a loop?',
   'continue',
   'The continue statement skips the rest of the current iteration and moves to the next iteration of the loop.',
   'break', 'continue', 'pass', 'skip', 'b'),

  ('e4000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
   'What statement exits a loop completely?',
   'break',
   'The break statement terminates the loop entirely and continues with the next statement after the loop.',
   'break', 'continue', 'exit', 'stop', 'a'),

  ('e4000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
   'What does range(5) generate?',
   '0, 1, 2, 3, 4',
   'range(5) generates numbers from 0 up to (but not including) 5, so it produces 0, 1, 2, 3, 4.',
   '1, 2, 3, 4, 5', '0, 1, 2, 3, 4', '0, 1, 2, 3, 4, 5', '1, 2, 3, 4', 'b'),

  ('e4000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
   'What does range(2, 8, 2) generate?',
   '2, 4, 6',
   'range(2, 8, 2) starts at 2, ends before 8, and steps by 2. So it generates 2, 4, 6.',
   '2, 4, 6, 8', '2, 4, 6', '2, 3, 4, 5, 6, 7', '0, 2, 4, 6', 'b'),

  ('e4000000-0000-0000-0000-000000000005', 'c1000000-0000-0000-0000-000000000007', 'b1000000-0000-0000-0000-000000000001',
   'Which loop is best for iterating a known number of times?',
   'for loop',
   'A for loop is typically used when you know how many times you want to iterate. While loops are better for unknown iterations.',
   'while loop', 'for loop', 'do-while loop', 'repeat loop', 'b');

-- ============ MCQ FLASHCARDS FOR STRINGS SUBTOPIC ============
INSERT INTO flashcards (id, subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option) VALUES
  ('e5000000-0000-0000-0000-000000000001', 'c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001',
   'Are strings in Python mutable or immutable?',
   'Immutable',
   'Strings in Python are immutable, meaning once created, their contents cannot be changed. Any operation that appears to modify a string actually creates a new string.',
   'Mutable', 'Immutable', 'Semi-mutable', 'Depends on length', 'b'),

  ('e5000000-0000-0000-0000-000000000002', 'c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001',
   'What method converts a string to uppercase?',
   'upper()',
   'The upper() method returns a new string with all characters converted to uppercase.',
   'uppercase()', 'toUpper()', 'upper()', 'capitalize()', 'c'),

  ('e5000000-0000-0000-0000-000000000003', 'c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001',
   'What is the result of "hello" + " " + "world"?',
   'hello world',
   'The + operator concatenates strings, joining them together into a single string.',
   'helloworld', 'hello world', 'hello + world', 'Error', 'b'),

  ('e5000000-0000-0000-0000-000000000004', 'c1000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000001',
   'What does "python".find("th") return?',
   '2',
   'The find() method returns the index of the first occurrence of the substring. "th" starts at index 2 in "python".',
   '0', '1', '2', '3', 'c');
