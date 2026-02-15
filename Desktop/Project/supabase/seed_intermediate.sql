-- PyDeck: Intermediate Python - Concepts & Quiz Flashcards
-- Run AFTER migration.sql and seed_subtopics.sql
-- Subtopics already exist in seed_subtopics.sql

-- Intermediate Python topic_id: b1000000-0000-0000-0000-000000000002
-- Subtopic IDs:
--   File Handling:        c2000000-0000-0000-0000-000000000001
--   Exception Handling:   c2000000-0000-0000-0000-000000000002
--   Classes & Objects:    c2000000-0000-0000-0000-000000000003
--   List Comprehensions:  c2000000-0000-0000-0000-000000000004
--   Lambda Functions:     c2000000-0000-0000-0000-000000000005
--   Modules & Packages:   c2000000-0000-0000-0000-000000000006


-- ================================================================
-- ===================== FILE HANDLING =============================
-- ================================================================

-- FILE HANDLING - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'What is file handling in Python?',
 'The ability to read from and write to files on disk',
 'File handling is like Chandu opening a notebook to read notes or write new ones. Python can open text files, CSV files, JSON files, etc. using the built-in open() function. Always close files after use to free up resources.',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The ____ function is used to open a file in Python.',
 'open()',
 'open(filename, mode) opens a file and returns a file object. Common modes: "r" (read), "w" (write — overwrites), "a" (append), "r+" (read and write). If Chandu uses "w" on an existing file, all previous content is erased!',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The ____ statement is the recommended way to open files because it auto-closes them.',
 'with',
 'The with statement is like a responsible librarian — it opens the book, lets you read, and always puts it back. Syntax: with open("data.txt", "r") as f: data = f.read(). Even if an error occurs, the file is properly closed.',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The ____ method reads the entire file content as a single string.',
 'read()',
 'f.read() returns everything in the file as one string. f.readline() reads one line at a time. f.readlines() returns a list of all lines. For large files, reading line by line is better for memory.',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The file mode ____ writes to a file and erases all previous content.',
 '"w" (write)',
 'Dangerous! "w" mode deletes everything in the file before writing. If Pavan uses open("notes.txt", "w"), all old notes are gone. Use "a" (append) to add to existing content without erasing.',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The file mode ____ adds new content to the end of a file without erasing.',
 '"a" (append)',
 'Append mode is like adding new entries to a diary — old entries stay. If Aswini wants to add today''s log to a file: with open("log.txt", "a") as f: f.write("Day 5: Learned Python\\n").',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'The ____ method writes a string to a file.',
 'write()',
 'f.write("Hello") writes the string to the file. It does NOT add a newline automatically — you must include \\n yourself. f.writelines(list) writes a list of strings without adding newlines between them.',
 'concept'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'To read a file line by line in a memory-efficient way, use a ____ loop.',
 'for',
 'Iterating with a for loop reads one line at a time: for line in f: print(line). This is memory-efficient for large files because it does not load the entire file at once. Each line includes the trailing newline character.',
 'concept');

-- FILE HANDLING - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'What does the "with" statement do when working with files?',
 'Automatically closes the file when done',
 'The with statement creates a context manager that ensures the file is properly closed after the block executes, even if an error occurs inside the block.',
 'Opens file faster', 'Automatically closes the file when done', 'Encrypts the file', 'Creates a backup', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'What happens if you open an existing file in "w" mode?',
 'All existing content is erased',
 '"w" (write) mode truncates the file — all previous content is deleted before writing new content. Use "a" (append) mode to add without erasing.',
 'Content is preserved', 'All existing content is erased', 'An error is raised', 'A backup is created', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'Which method reads all lines of a file into a list?',
 'readlines()',
 'readlines() returns a list where each element is a line from the file. read() returns everything as one string. readline() returns just one line.',
 'read()', 'readline()', 'readlines()', 'lines()', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'What is the default file mode when no mode is specified in open()?',
 '"r" (read)',
 'If you call open("file.txt") without a mode, Python defaults to "r" (read mode). If the file does not exist, it raises a FileNotFoundError.',
 '"w" (write)', '"r" (read)', '"a" (append)', '"x" (create)', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'Neha writes: f = open("data.txt"); data = f.read(); f.close(). What is wrong with this approach?',
 'If an error occurs before f.close(), the file stays open',
 'If f.read() raises an error, f.close() never executes and the file remains open. Using "with open(...) as f:" ensures the file is always closed, even if errors occur.',
 'Nothing is wrong', 'If an error occurs before f.close(), the file stays open', 'read() does not work this way', 'close() is not needed', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000002',
 'Which file mode opens a file for both reading and writing?',
 '"r+"',
 '"r+" allows both reading and writing without truncating the file. "w+" also allows both but erases existing content first. "a+" allows reading and appending.',
 '"rw"', '"r+"', '"read_write"', '"both"', 'b', 'quiz');

-- FILE HANDLING - Concepts (detailed pages)
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000001', 'Opening and Reading Files',
'# File Handling in Python

File handling lets your program read data from files and write data to files — like Chandu opening his notebook to read or write notes.

## Opening Files

```python
# Basic syntax
file = open("filename.txt", "mode")

# Modes:
# "r"  - Read (default). Error if file does not exist
# "w"  - Write. Creates file or ERASES existing content
# "a"  - Append. Creates file or adds to end
# "r+" - Read and Write
# "x"  - Create. Error if file already exists
```

## The with Statement (Recommended)

Always use `with` — it automatically closes the file:

```python
# GOOD — file closes automatically
with open("scores.txt", "r") as f:
    content = f.read()
    print(content)
# File is closed here, even if error occurred

# BAD — if error happens, file stays open
f = open("scores.txt", "r")
content = f.read()  # If this fails...
f.close()           # ...this never runs!
```

## Reading Files

```python
# Read entire file as one string
with open("message.txt", "r") as f:
    all_text = f.read()
    print(all_text)

# Read one line at a time
with open("names.txt", "r") as f:
    first_line = f.readline()   # "Chandu\n"
    second_line = f.readline()  # "Pavan\n"

# Read all lines into a list
with open("names.txt", "r") as f:
    all_lines = f.readlines()
    # ["Chandu\n", "Pavan\n", "Neha\n"]

# Best way: iterate line by line (memory efficient)
with open("names.txt", "r") as f:
    for line in f:
        name = line.strip()  # Remove \n
        print(f"Hello, {name}!")
```

## Practical Example

```python
# Chandu reads a CSV-like file of student scores
with open("scores.txt", "r") as f:
    for line in f:
        parts = line.strip().split(",")
        name = parts[0]
        score = int(parts[1])
        print(f"{name} scored {score}")
```', 1),

('c2000000-0000-0000-0000-000000000001', 'Writing Files',
'# Writing to Files

## Write Mode ("w") — Overwrites Everything

```python
# Creates file if it does not exist
# ERASES content if file exists!
with open("output.txt", "w") as f:
    f.write("Hello from Chandu!\n")
    f.write("This is line 2\n")
```

## Append Mode ("a") — Adds to End

```python
# Adds to end without erasing
with open("diary.txt", "a") as f:
    f.write("Day 1: Learned Python basics\n")

# Next time
with open("diary.txt", "a") as f:
    f.write("Day 2: Learned file handling\n")

# diary.txt now has both lines
```

## Writing Multiple Lines

```python
students = ["Chandu", "Pavan", "Aswini", "Neha"]

with open("students.txt", "w") as f:
    for name in students:
        f.write(name + "\n")

# Or use writelines (does NOT add newlines)
with open("students.txt", "w") as f:
    lines = [name + "\n" for name in students]
    f.writelines(lines)
```

## Practical Example: Log File

```python
from datetime import datetime

def log_activity(activity):
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    with open("activity_log.txt", "a") as f:
        f.write(f"[{timestamp}] {activity}\n")

log_activity("Chandu logged in")
log_activity("Chandu completed Python quiz")
log_activity("Pavan submitted assignment")
```

## Working with File Paths

```python
import os

# Check if file exists
if os.path.exists("data.txt"):
    print("File found!")
else:
    print("File not found!")

# Get file size
size = os.path.getsize("data.txt")
print(f"File size: {size} bytes")

# Join paths (works on all OS)
path = os.path.join("data", "students", "scores.txt")
```

## Reading and Writing JSON

```python
import json

# Write dictionary to JSON file
student = {"name": "Chandu", "age": 22, "scores": [85, 92, 78]}

with open("student.json", "w") as f:
    json.dump(student, f, indent=2)

# Read JSON file back to dictionary
with open("student.json", "r") as f:
    data = json.load(f)
    print(data["name"])  # Chandu
```', 2);


-- ================================================================
-- =================== EXCEPTION HANDLING =========================
-- ================================================================

-- EXCEPTION HANDLING - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'What is an exception in Python?',
 'An error that occurs during program execution and disrupts normal flow',
 'An exception is like a speed bump on a road — it interrupts the normal flow. When Chandu divides by zero or accesses a missing key, Python raises an exception. Without handling, the program crashes.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'The ____ block contains code that might raise an exception.',
 'try',
 'try is like saying "let me attempt this risky task." Code inside try runs normally until an exception occurs. If no exception, the except block is skipped entirely.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'The ____ block runs when an exception occurs inside the try block.',
 'except',
 'except catches the error and handles it gracefully. Instead of crashing, Pavan can show a friendly message: except ValueError: print("Please enter a valid number"). You can catch specific or general exceptions.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'The ____ block always runs, whether an exception occurred or not.',
 'finally',
 'finally is like a cleanup crew — it runs no matter what. Use it to close files, release resources, or run essential cleanup code. Even if an exception is raised and not caught, finally still executes.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'The ____ keyword is used to manually trigger an exception.',
 'raise',
 'raise lets you throw exceptions on purpose. Like a teacher raising a red flag: if age < 0: raise ValueError("Age cannot be negative"). This forces the caller to handle the error.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'The ____ block runs only if no exception occurred in the try block.',
 'else',
 'The else block after try/except runs when everything went smoothly — no errors. try: risky_code() except: handle_error() else: success_code(). It separates normal logic from error handling.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'You can create custom exceptions by inheriting from the ____ class.',
 'Exception',
 'Custom exceptions let you define your own error types. class InsufficientFundsError(Exception): pass. Aswini can then raise InsufficientFundsError("Not enough balance") in her banking app.',
 'concept'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'Catching a bare ____ without specifying the exception type is bad practice.',
 'except',
 'A bare except: catches ALL exceptions, including KeyboardInterrupt and SystemExit. This hides bugs! Always catch specific exceptions: except ValueError: or except (TypeError, KeyError):.',
 'concept');

-- EXCEPTION HANDLING - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'What is the correct order of try/except/else/finally blocks?',
 'try → except → else → finally',
 'try runs first, except handles errors, else runs if no error, finally always runs. The else block is optional and must come after all except blocks.',
 'try → else → except → finally', 'try → except → else → finally', 'try → finally → except → else', 'except → try → else → finally', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'What exception is raised when you divide by zero?',
 'ZeroDivisionError',
 'Dividing any number by zero raises ZeroDivisionError. For example: 10 / 0 or 10 // 0 or 10 % 0 all raise this error.',
 'ValueError', 'TypeError', 'ZeroDivisionError', 'ArithmeticError', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'When does the finally block execute?',
 'Always, whether an exception occurs or not',
 'finally always runs — it does not matter if the try block succeeded, an exception was caught, or even if a return statement was reached. It is used for cleanup operations.',
 'Only when an exception occurs', 'Only when no exception occurs', 'Always, whether an exception occurs or not', 'Only if except is not present', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'What exception does int("hello") raise?',
 'ValueError',
 'int() raises ValueError when the string cannot be converted to an integer. "hello" is not a valid number. int("42") works fine, but int("42.5") also raises ValueError (use float() first).',
 'TypeError', 'ValueError', 'SyntaxError', 'NameError', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'How does Chandu create a custom exception?',
 'class MyError(Exception): pass',
 'Custom exceptions inherit from Exception (or a subclass). The simplest form is: class MyError(Exception): pass. You can add custom messages and attributes.',
 'def MyError(): raise', 'error MyError = Exception()', 'class MyError(Exception): pass', 'raise new Exception("MyError")', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000002',
 'What happens if an exception is not caught by any except block?',
 'The program crashes with a traceback',
 'If no except block catches the exception, it propagates up the call stack. If no handler is found anywhere, Python prints a traceback and terminates the program.',
 'Python ignores it', 'The program crashes with a traceback', 'The finally block catches it', 'It is logged automatically', 'b', 'quiz');

-- EXCEPTION HANDLING - Concepts
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000002', 'Try, Except, and Finally',
'# Exception Handling in Python

Exceptions are errors that occur during execution. Instead of crashing, Python lets you catch and handle them gracefully.

## Basic try/except

```python
# Without exception handling — program crashes
# result = 10 / 0  # ZeroDivisionError!

# With exception handling
try:
    result = 10 / 0
except ZeroDivisionError:
    print("Cannot divide by zero!")
# Output: Cannot divide by zero!
# Program continues normally
```

## Catching Specific Exceptions

```python
# Chandu builds a calculator
def divide(a, b):
    try:
        result = a / b
    except ZeroDivisionError:
        print("Error: Cannot divide by zero!")
        return None
    except TypeError:
        print("Error: Please provide numbers only!")
        return None
    return result

print(divide(10, 2))      # 5.0
print(divide(10, 0))      # Error message, returns None
print(divide("10", 2))    # Error message, returns None
```

## Multiple Exceptions in One Block

```python
try:
    value = int(input("Enter a number: "))
    result = 100 / value
except (ValueError, ZeroDivisionError) as e:
    print(f"Error: {e}")
```

## The else Block

Runs only if NO exception occurred:

```python
try:
    num = int(input("Enter number: "))
except ValueError:
    print("That is not a valid number!")
else:
    print(f"You entered: {num}")  # Only runs if no error
finally:
    print("Input attempt complete")  # Always runs
```

## The finally Block

Always executes — perfect for cleanup:

```python
def read_student_file(filename):
    f = None
    try:
        f = open(filename, "r")
        data = f.read()
        return data
    except FileNotFoundError:
        print(f"File {filename} not found!")
        return None
    finally:
        if f:
            f.close()
            print("File closed")
```

## Common Exception Types

| Exception | When it happens |
|-----------|----------------|
| ValueError | Wrong value (int("hello")) |
| TypeError | Wrong type (1 + "2") |
| KeyError | Missing dict key |
| IndexError | List index out of range |
| FileNotFoundError | File does not exist |
| ZeroDivisionError | Division by zero |
| AttributeError | Missing attribute/method |
| ImportError | Module not found |', 1),

('c2000000-0000-0000-0000-000000000002', 'Raising Exceptions and Custom Exceptions',
'# Raising and Custom Exceptions

## Raising Exceptions

Use `raise` to throw exceptions intentionally:

```python
def set_age(age):
    if age < 0:
        raise ValueError("Age cannot be negative!")
    if age > 150:
        raise ValueError("Age seems unrealistic!")
    return age

# Usage
try:
    set_age(-5)
except ValueError as e:
    print(f"Invalid: {e}")
# Output: Invalid: Age cannot be negative!
```

## Re-raising Exceptions

```python
def process_payment(amount):
    try:
        if amount <= 0:
            raise ValueError("Amount must be positive")
        # Process payment...
        print(f"Paid ₹{amount}")
    except ValueError:
        print("Logging error...")
        raise  # Re-raise the same exception
```

## Custom Exceptions

Create your own exception types:

```python
class InsufficientBalanceError(Exception):
    """Raised when account balance is too low"""
    def __init__(self, balance, amount):
        self.balance = balance
        self.amount = amount
        self.deficit = amount - balance
        super().__init__(
            f"Cannot withdraw ₹{amount}. "
            f"Balance: ₹{balance}. "
            f"Short by: ₹{self.deficit}"
        )

class BankAccount:
    def __init__(self, name, balance=0):
        self.name = name
        self.balance = balance

    def withdraw(self, amount):
        if amount > self.balance:
            raise InsufficientBalanceError(self.balance, amount)
        self.balance -= amount
        return self.balance

# Usage
chandu_account = BankAccount("Chandu", 5000)

try:
    chandu_account.withdraw(8000)
except InsufficientBalanceError as e:
    print(e)
# Cannot withdraw ₹8000. Balance: ₹5000. Short by: ₹3000
```

## Exception Hierarchy

```
BaseException
├── SystemExit
├── KeyboardInterrupt
├── Exception
│   ├── ValueError
│   ├── TypeError
│   ├── KeyError
│   ├── IndexError
│   ├── FileNotFoundError
│   ├── ZeroDivisionError
│   └── YourCustomException
```

## Best Practices

```python
# BAD — catches everything, hides bugs
try:
    do_something()
except:
    pass

# GOOD — catch specific exceptions
try:
    do_something()
except ValueError as e:
    print(f"Value error: {e}")
except KeyError as e:
    print(f"Missing key: {e}")

# GOOD — use else for success logic
try:
    data = load_data()
except FileNotFoundError:
    data = default_data()
else:
    print("Data loaded successfully!")
```', 2);


-- ================================================================
-- =================== CLASSES & OBJECTS ==========================
-- ================================================================

-- CLASSES & OBJECTS - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What is a class in Python?',
 'A blueprint for creating objects with shared attributes and methods',
 'A class is like a cookie cutter — it defines the shape, and each cookie (object) made from it has the same structure. class Student: defines a template with attributes like name, age and methods like study().',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What is an object in Python?',
 'An instance of a class with its own data',
 'An object is a specific item created from a class. If Student is the class, then chandu = Student("Chandu", 22) creates an object. Each object has its own data but shares methods defined in the class.',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'The ____ method is the constructor that runs automatically when an object is created.',
 '__init__',
 '__init__(self) is called when you create an object: chandu = Student("Chandu"). It initializes the object''s attributes. self refers to the object being created. Every class typically has an __init__ method.',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'The ____ parameter refers to the current instance of the class.',
 'self',
 'self is like saying "my own" — self.name means "this object''s name." When Chandu calls chandu.greet(), Python automatically passes chandu as self. It must be the first parameter of every instance method.',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 '____ allows a child class to inherit attributes and methods from a parent class.',
 'Inheritance',
 'Inheritance is like a child inheriting traits from parents. class Dog(Animal): means Dog inherits everything from Animal. Dog can add new methods or override existing ones. Reduces code duplication.',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'The ____ function calls a method from the parent class.',
 'super()',
 'super() lets the child class use the parent''s methods. In __init__, use super().__init__() to call the parent constructor first, then add child-specific attributes. Avoids hardcoding parent class name.',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'The ____ method defines the string representation of an object.',
 '__str__',
 'Without __str__, printing an object shows something like <Student object at 0x...>. With __str__, you control what print(chandu) shows: def __str__(self): return f"Student: {self.name}".',
 'concept'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 '____ is when a child class provides a new implementation for a method inherited from the parent.',
 'Method overriding',
 'Like Pavan inheriting his father''s business but running it differently. class Animal has speak() returning "...". class Dog(Animal) overrides speak() to return "Woof!". The child''s version replaces the parent''s.',
 'concept');

-- CLASSES & OBJECTS - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What is the first parameter of every instance method in a class?',
 'self',
 'self refers to the instance calling the method. Python passes it automatically — you do not include it when calling. chandu.greet() internally becomes Student.greet(chandu).',
 'this', 'self', 'cls', 'init', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'When is the __init__ method called?',
 'When a new object is created',
 '__init__ is the constructor — it runs automatically when you create an object: chandu = Student("Chandu"). You never call __init__ directly.',
 'When the program starts', 'When a new object is created', 'When the object is deleted', 'When a method is called', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What does class Dog(Animal): mean?',
 'Dog inherits from Animal',
 'Putting a class name in parentheses means inheritance. Dog gets all attributes and methods from Animal. Dog can then add or override them.',
 'Dog contains Animal', 'Dog inherits from Animal', 'Dog replaces Animal', 'Dog is the same as Animal', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What does super().__init__() do in a child class?',
 'Calls the parent class constructor',
 'super() gives access to the parent class. super().__init__() runs the parent''s constructor to initialize inherited attributes before the child adds its own.',
 'Creates a new parent object', 'Calls the parent class constructor', 'Deletes the parent class', 'Overrides the parent method', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'Pavan creates: s = Student("Pavan"); print(s). What controls the output?',
 'The __str__ method',
 'When you print an object, Python calls its __str__ method. If not defined, it shows the default memory address. Define __str__ to return a human-readable string.',
 '__init__', '__str__', '__repr__', '__print__', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000002',
 'What is the difference between a class and an object?',
 'A class is a blueprint, an object is an instance created from it',
 'A class defines the structure (like an architectural plan). An object is a specific building made from that plan. You can create many objects from one class.',
 'They are the same thing', 'A class is a blueprint, an object is an instance created from it', 'An object is a blueprint, a class is an instance', 'Classes are for data, objects are for methods', 'b', 'quiz');

-- CLASSES & OBJECTS - Concepts
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000003', 'Classes, Objects, and Methods',
'# Classes and Objects in Python

## What is a Class?

A class is a blueprint — like an admission form template. Each filled form (object) has the same fields but different data.

```python
class Student:
    def __init__(self, name, age, branch):
        self.name = name       # Instance attribute
        self.age = age
        self.branch = branch

    def introduce(self):
        return f"Hi, I am {self.name}, {self.age} years old, {self.branch} branch"

# Creating objects (instances)
chandu = Student("Chandu", 22, "CSE")
neha = Student("Neha", 21, "ECE")

print(chandu.introduce())  # Hi, I am Chandu, 22 years old, CSE branch
print(neha.introduce())    # Hi, I am Neha, 21 years old, ECE branch
```

## The __init__ Method (Constructor)

```python
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance
        print(f"Account created for {owner}")

    def deposit(self, amount):
        self.balance += amount
        print(f"₹{amount} deposited. Balance: ₹{self.balance}")

    def withdraw(self, amount):
        if amount > self.balance:
            print("Insufficient balance!")
        else:
            self.balance -= amount
            print(f"₹{amount} withdrawn. Balance: ₹{self.balance}")

# Usage
pavan_acc = BankAccount("Pavan", 10000)
pavan_acc.deposit(5000)    # ₹5000 deposited. Balance: ₹15000
pavan_acc.withdraw(3000)   # ₹3000 withdrawn. Balance: ₹12000
```

## Class vs Instance Attributes

```python
class Student:
    school = "PyDeck Academy"  # Class attribute (shared by all)

    def __init__(self, name):
        self.name = name       # Instance attribute (unique to each)

chandu = Student("Chandu")
aswini = Student("Aswini")

print(chandu.school)  # PyDeck Academy (same for all)
print(aswini.school)  # PyDeck Academy
print(chandu.name)    # Chandu (unique)
print(aswini.name)    # Aswini (unique)
```

## The __str__ Method

```python
class Student:
    def __init__(self, name, grade):
        self.name = name
        self.grade = grade

    def __str__(self):
        return f"Student({self.name}, Grade: {self.grade})"

chandu = Student("Chandu", "A")
print(chandu)  # Student(Chandu, Grade: A)
```', 1),

('c2000000-0000-0000-0000-000000000003', 'Inheritance and Polymorphism',
'# Inheritance

Inheritance lets a child class reuse code from a parent class — like a child inheriting traits from parents.

```python
# Parent class
class Animal:
    def __init__(self, name, sound):
        self.name = name
        self.sound = sound

    def speak(self):
        return f"{self.name} says {self.sound}!"

    def info(self):
        return f"Animal: {self.name}"

# Child class
class Dog(Animal):
    def __init__(self, name, breed):
        super().__init__(name, "Woof")  # Call parent __init__
        self.breed = breed              # Add new attribute

    def fetch(self):                    # Add new method
        return f"{self.name} fetches the ball!"

# Usage
tommy = Dog("Tommy", "Labrador")
print(tommy.speak())   # Tommy says Woof! (inherited)
print(tommy.fetch())   # Tommy fetches the ball! (new)
print(tommy.breed)     # Labrador (new attribute)
```

## Method Overriding

```python
class Vehicle:
    def fuel_type(self):
        return "Petrol"

class ElectricCar(Vehicle):
    def fuel_type(self):       # Override parent method
        return "Electric"

car = ElectricCar()
print(car.fuel_type())  # Electric (child version runs)
```

## Practical Example: Employee System

```python
class Employee:
    def __init__(self, name, salary):
        self.name = name
        self.salary = salary

    def get_annual_salary(self):
        return self.salary * 12

    def __str__(self):
        return f"{self.name} - ₹{self.salary}/month"

class Manager(Employee):
    def __init__(self, name, salary, team_size):
        super().__init__(name, salary)
        self.team_size = team_size

    def get_annual_salary(self):
        bonus = 50000 if self.team_size > 5 else 20000
        return super().get_annual_salary() + bonus

class Intern(Employee):
    def __init__(self, name, stipend, college):
        super().__init__(name, stipend)
        self.college = college

# Usage
pavan = Manager("Pavan", 80000, 8)
neha = Intern("Neha", 15000, "IIT Hyderabad")

print(pavan)                      # Pavan - ₹80000/month
print(pavan.get_annual_salary())  # 1010000 (960000 + 50000 bonus)
print(neha.get_annual_salary())   # 180000
```

## isinstance() and issubclass()

```python
print(isinstance(pavan, Manager))    # True
print(isinstance(pavan, Employee))   # True (Manager IS an Employee)
print(isinstance(neha, Manager))     # False

print(issubclass(Manager, Employee)) # True
print(issubclass(Employee, Manager)) # False
```', 2);


-- ================================================================
-- ================== LIST COMPREHENSIONS =========================
-- ================================================================

-- LIST COMPREHENSIONS - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'What is a list comprehension?',
 'A concise way to create lists using a single line of code',
 'List comprehension is like a compact factory — instead of writing a for loop with append(), you create the entire list in one line. [x**2 for x in range(5)] gives [0, 1, 4, 9, 16].',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'The basic syntax of list comprehension is [expression for item in ____].',
 'iterable',
 'The iterable can be a list, range, string, etc. [x*2 for x in range(5)] creates [0, 2, 4, 6, 8]. Think of it as: "give me x*2 for each x in range(5)."',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'You can add an ____ clause to filter elements in a list comprehension.',
 'if',
 'Add a condition at the end: [x for x in range(10) if x % 2 == 0] gives only even numbers [0, 2, 4, 6, 8]. Only elements where the condition is True are included.',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'A ____ comprehension uses curly braces {} and creates a dictionary.',
 'dictionary',
 '{k: v for k, v in pairs} creates a dict. Example: {name: len(name) for name in ["Chandu", "Neha", "Pavan"]} gives {"Chandu": 6, "Neha": 4, "Pavan": 5}.',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'A ____ comprehension uses curly braces {} without key-value pairs and creates a set.',
 'set',
 '{x**2 for x in range(5)} creates {0, 1, 4, 9, 16}. It looks like a dict comprehension but without the colon. Results are unique and unordered.',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'A ____ expression is like a list comprehension but uses () and generates values lazily.',
 'generator',
 'gen = (x**2 for x in range(1000000)) does not create all values at once. It generates them one at a time, saving memory. Use when you do not need all values simultaneously.',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'Nested list comprehensions can replace ____ loops.',
 'nested for',
 '[i*j for i in range(1,4) for j in range(1,4)] creates [1,2,3,2,4,6,3,6,9]. The outer loop runs first, then the inner. Useful for flattening 2D lists.',
 'concept'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'You can use if-else in a list comprehension by placing it ____ the for clause.',
 'before',
 'With if-else: [x if x>0 else 0 for x in data]. Without else (filter only): [x for x in data if x>0]. The position of if changes its meaning — before for = transform, after for = filter.',
 'concept');

-- LIST COMPREHENSIONS - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'What is the output of: [x**2 for x in range(4)]?',
 '[0, 1, 4, 9]',
 'range(4) gives 0, 1, 2, 3. Squaring each: 0, 1, 4, 9. The list comprehension collects them into [0, 1, 4, 9].',
 '[1, 4, 9, 16]', '[0, 1, 4, 9]', '[0, 2, 4, 6]', '[1, 2, 3, 4]', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'What does [x for x in range(10) if x % 3 == 0] return?',
 '[0, 3, 6, 9]',
 'The if clause filters: only values where x % 3 == 0 (divisible by 3) are included. From 0-9, those are 0, 3, 6, 9.',
 '[3, 6, 9]', '[0, 3, 6, 9]', '[0, 3, 6, 9, 12]', '[1, 3, 6, 9]', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'Where does the if-else go in a list comprehension with both transform and condition?',
 'Before the for clause',
 'if-else for transforming: ["even" if x%2==0 else "odd" for x in range(5)]. Filter-only if goes after for: [x for x in range(5) if x%2==0].',
 'After the for clause', 'Before the for clause', 'At the end', 'Before the brackets', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'What type does {x: x**2 for x in range(3)} create?',
 'dict',
 'Curly braces with key:value syntax creates a dictionary comprehension. This gives {0: 0, 1: 1, 2: 4}.',
 'set', 'list', 'dict', 'tuple', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'What is the difference between (x for x in range(5)) and [x for x in range(5)]?',
 '() creates a generator, [] creates a list',
 'Round brackets create a generator expression (lazy, memory efficient). Square brackets create a list (all values in memory). Generators are better for large datasets.',
 'No difference', '() creates a tuple', '() creates a generator, [] creates a list', '() is faster', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000002',
 'Chandu has names = ["chandu", "pavan", "neha"]. What does [n.upper() for n in names] give?',
 '["CHANDU", "PAVAN", "NEHA"]',
 'The comprehension applies .upper() to each name. List comprehensions can call methods on each element to transform them.',
 '["Chandu", "Pavan", "Neha"]', '["CHANDU", "PAVAN", "NEHA"]', '["chandu", "pavan", "neha"]', 'Error', 'b', 'quiz');

-- LIST COMPREHENSIONS - Concepts
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000004', 'List Comprehension Basics',
'# List Comprehensions

A compact way to create lists — what takes 3-4 lines with a loop can be done in 1 line.

## Basic Syntax

```python
# Traditional loop
squares = []
for x in range(5):
    squares.append(x ** 2)
# [0, 1, 4, 9, 16]

# List comprehension (same result!)
squares = [x ** 2 for x in range(5)]
# [0, 1, 4, 9, 16]
```

## With Condition (Filter)

```python
# Only even numbers
evens = [x for x in range(10) if x % 2 == 0]
# [0, 2, 4, 6, 8]

# Only passing scores
scores = [85, 42, 91, 67, 38, 73]
passed = [s for s in scores if s >= 60]
# [85, 91, 67, 73]

# Names starting with specific letter
friends = ["Chandu", "Pavan", "Neha", "Priya", "Aswini"]
p_friends = [name for name in friends if name.startswith("P")]
# ["Pavan", "Priya"]
```

## With if-else (Transform)

```python
# if-else goes BEFORE for
scores = [85, 42, 91, 67, 38]
results = ["Pass" if s >= 60 else "Fail" for s in scores]
# ["Pass", "Fail", "Pass", "Pass", "Fail"]

# Replace negatives with 0
numbers = [5, -3, 8, -1, 4]
cleaned = [x if x >= 0 else 0 for x in numbers]
# [5, 0, 8, 0, 4]
```

## String Operations

```python
names = ["chandu", "pavan", "neha"]

# Capitalize all names
capitalized = [name.capitalize() for name in names]
# ["Chandu", "Pavan", "Neha"]

# Get lengths
lengths = [len(name) for name in names]
# [6, 5, 4]

# Extract initials
full_names = ["Chandu Kumar", "Pavan Reddy", "Neha Sharma"]
initials = [name[0] for name in full_names]
# ["C", "P", "N"]
```', 1),

('c2000000-0000-0000-0000-000000000004', 'Advanced Comprehensions',
'# Advanced Comprehensions

## Nested List Comprehension

```python
# Flatten a 2D list
matrix = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
flat = [num for row in matrix for num in row]
# [1, 2, 3, 4, 5, 6, 7, 8, 9]

# Multiplication table
table = [[i * j for j in range(1, 6)] for i in range(1, 6)]
# [[1,2,3,4,5], [2,4,6,8,10], [3,6,9,12,15], ...]
```

## Dictionary Comprehension

```python
# Name to length mapping
names = ["Chandu", "Pavan", "Neha", "Aswini"]
name_lengths = {name: len(name) for name in names}
# {"Chandu": 6, "Pavan": 5, "Neha": 4, "Aswini": 6}

# Swap keys and values
original = {"a": 1, "b": 2, "c": 3}
swapped = {v: k for k, v in original.items()}
# {1: "a", 2: "b", 3: "c"}

# Filter dictionary
scores = {"Chandu": 85, "Pavan": 42, "Neha": 91, "Aswini": 67}
passed = {name: score for name, score in scores.items() if score >= 60}
# {"Chandu": 85, "Neha": 91, "Aswini": 67}
```

## Set Comprehension

```python
# Unique word lengths
words = ["hello", "world", "hi", "hey", "python"]
lengths = {len(w) for w in words}
# {2, 3, 5, 6}
```

## Generator Expression

```python
# Uses () instead of [] — generates values lazily
total = sum(x ** 2 for x in range(1000000))
# Does NOT create a list of 1 million items in memory!

# Compare memory usage
import sys
list_comp = [x for x in range(10000)]
gen_exp = (x for x in range(10000))

print(sys.getsizeof(list_comp))  # ~87624 bytes
print(sys.getsizeof(gen_exp))    # ~112 bytes (tiny!)
```

## When to Use What

| Syntax | Creates | Memory |
|--------|---------|--------|
| `[x for x in ...]` | list | All in memory |
| `{x for x in ...}` | set | All in memory |
| `{k:v for ...}` | dict | All in memory |
| `(x for x in ...)` | generator | One at a time |', 2);


-- ================================================================
-- ================== LAMBDA FUNCTIONS ============================
-- ================================================================

-- LAMBDA FUNCTIONS - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'What is a lambda function?',
 'A small anonymous function defined in one line using the lambda keyword',
 'Lambda is like a quick post-it note — for simple, throwaway functions that you don''t need to name. Instead of def square(x): return x**2, write lambda x: x**2. Best for short, one-time-use functions.',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'The syntax for a lambda function is lambda ____: expression.',
 'arguments',
 'lambda takes arguments before the colon and returns the expression after. Example: lambda x, y: x + y takes two arguments and returns their sum. No return keyword needed.',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'The ____ function applies a function to every item of an iterable.',
 'map()',
 'map(function, iterable) transforms each element. Like a factory assembly line — each item goes through the same process. map(lambda x: x*2, [1,2,3]) gives [2,4,6] (use list() to see results).',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'The ____ function returns items where the function returns True.',
 'filter()',
 'filter(function, iterable) keeps only elements that pass the test. Like a sieve — only items meeting the condition pass through. filter(lambda x: x>5, [3,7,2,9]) gives [7,9].',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'The ____ function reduces an iterable to a single value by applying a function cumulatively.',
 'reduce()',
 'reduce is from functools module. It combines elements: reduce(lambda a,b: a+b, [1,2,3,4]) computes ((1+2)+3)+4 = 10. Like folding a list into one value.',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'The ____ parameter of sorted() takes a function that extracts a comparison key.',
 'key',
 'sorted(students, key=lambda s: s["score"]) sorts by score. The key function is called on each element to determine sort order. Lambda is perfect here because the function is simple and used once.',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'Lambda functions are limited to a single ____.',
 'expression',
 'Lambda can only contain one expression — no statements, loops, or if blocks. If you need multiple lines or complex logic, use a regular def function instead. Lambda returns the expression result automatically.',
 'concept'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'Lambda functions are also called ____ functions because they have no name.',
 'anonymous',
 'Regular functions have names via def. Lambda functions are anonymous — they exist without a name. You can assign them to variables, but it is better practice to use def if you need a named function.',
 'concept');

-- LAMBDA FUNCTIONS - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'What is the output of: (lambda x, y: x + y)(3, 5)?',
 '8',
 'This creates a lambda that adds two numbers and immediately calls it with 3 and 5. Result: 3 + 5 = 8.',
 '35', '8', '(3, 5)', 'Error', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'What does list(map(lambda x: x.upper(), ["chandu", "neha"])) return?',
 '["CHANDU", "NEHA"]',
 'map() applies the lambda to each element. lambda x: x.upper() converts each string to uppercase. map returns an iterator, so list() converts it to a list.',
 '["Chandu", "Neha"]', '["CHANDU", "NEHA"]', '["chandu", "neha"]', 'Error', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'What does list(filter(lambda x: x > 5, [3, 7, 2, 9, 1])) return?',
 '[7, 9]',
 'filter() keeps only elements where the lambda returns True. Only 7 and 9 are greater than 5, so the result is [7, 9].',
 '[3, 2, 1]', '[7, 9]', '[3, 7, 2, 9, 1]', '[True, True]', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'Which is equivalent to: def square(x): return x ** 2?',
 'lambda x: x ** 2',
 'Lambda functions replace simple one-line functions. lambda x: x ** 2 takes one argument and returns its square, just like the def version.',
 'lambda x: x ** 2', 'lambda: x ** 2', 'lambda x = x ** 2', 'lambda(x): x ** 2', 'a', 'quiz'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'How do you sort a list of dicts by the "age" key using lambda?',
 'sorted(people, key=lambda p: p["age"])',
 'The key parameter takes a function that extracts the sort value. lambda p: p["age"] gets the age from each dict for comparison.',
 'sorted(people, lambda: "age")', 'sorted(people, key=lambda p: p["age"])', 'people.sort("age")', 'sort(people, by="age")', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000002',
 'Can a lambda function contain multiple statements?',
 'No, only a single expression',
 'Lambda is limited to one expression. You cannot use loops, multiple lines, or print statements inside lambda. For complex logic, use a regular def function.',
 'Yes, separated by semicolons', 'No, only a single expression', 'Yes, up to 3 lines', 'Yes, with indentation', 'b', 'quiz');

-- LAMBDA FUNCTIONS - Concepts
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000005', 'Lambda Basics',
'# Lambda Functions

A **lambda function** is a small, anonymous function written in one line.

## Syntax

```python
lambda arguments: expression
```

## Lambda vs Regular Function

```python
# Regular function
def add(x, y):
    return x + y

# Lambda equivalent
add = lambda x, y: x + y

# Both work the same
print(add(3, 5))  # 8
```

## Simple Examples

```python
# Square a number
square = lambda x: x ** 2
print(square(4))  # 16

# Check if even
is_even = lambda x: x % 2 == 0
print(is_even(4))   # True
print(is_even(7))   # False

# Greeting
greet = lambda name: f"Hello, {name}!"
print(greet("Chandu"))  # Hello, Chandu!

# Multiple arguments
full_name = lambda first, last: f"{first} {last}"
print(full_name("Pavan", "Kumar"))  # Pavan Kumar
```

## Immediately Invoked Lambda

```python
result = (lambda x, y: x * y)(4, 5)
print(result)  # 20
```

## When to Use Lambda

- Short, simple operations (one expression)
- As arguments to functions like sorted(), map(), filter()
- When you need a function only once

## When NOT to Use Lambda

- Complex logic (multiple steps)
- When you need a docstring
- When the function is reused (give it a name with def)
- When readability suffers', 1),

('c2000000-0000-0000-0000-000000000005', 'map(), filter(), and reduce()',
'# map(), filter(), and reduce()

## map() — Transform Each Element

```python
# Double each number
numbers = [1, 2, 3, 4, 5]
doubled = list(map(lambda x: x * 2, numbers))
print(doubled)  # [2, 4, 6, 8, 10]

# Convert marks to grades
marks = [85, 42, 91, 67, 38]
grades = list(map(lambda m: "Pass" if m >= 50 else "Fail", marks))
print(grades)  # ["Pass", "Fail", "Pass", "Pass", "Fail"]

# Apply to multiple iterables
names = ["Chandu", "Pavan", "Neha"]
ages = [22, 25, 21]
profiles = list(map(lambda n, a: f"{n} ({a})", names, ages))
print(profiles)  # ["Chandu (22)", "Pavan (25)", "Neha (21)"]
```

## filter() — Keep Only Matching Elements

```python
# Keep only passing marks
marks = [85, 42, 91, 67, 38, 73]
passed = list(filter(lambda m: m >= 60, marks))
print(passed)  # [85, 91, 67, 73]

# Keep only even numbers
numbers = [1, 2, 3, 4, 5, 6, 7, 8]
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)  # [2, 4, 6, 8]

# Remove empty strings
data = ["Chandu", "", "Pavan", "", "Neha"]
cleaned = list(filter(lambda x: x != "", data))
print(cleaned)  # ["Chandu", "Pavan", "Neha"]
```

## reduce() — Combine into Single Value

```python
from functools import reduce

# Sum all numbers
numbers = [1, 2, 3, 4, 5]
total = reduce(lambda a, b: a + b, numbers)
print(total)  # 15
# Steps: ((((1+2)+3)+4)+5) = 15

# Find maximum
maximum = reduce(lambda a, b: a if a > b else b, numbers)
print(maximum)  # 5

# Concatenate strings
words = ["Chandu", "loves", "Python"]
sentence = reduce(lambda a, b: a + " " + b, words)
print(sentence)  # "Chandu loves Python"
```

## sorted() with key

```python
students = [
    {"name": "Chandu", "score": 85},
    {"name": "Neha", "score": 92},
    {"name": "Pavan", "score": 78},
    {"name": "Aswini", "score": 88}
]

# Sort by score (ascending)
by_score = sorted(students, key=lambda s: s["score"])
# Pavan(78), Chandu(85), Aswini(88), Neha(92)

# Sort by score (descending)
top_first = sorted(students, key=lambda s: s["score"], reverse=True)
# Neha(92), Aswini(88), Chandu(85), Pavan(78)

# Sort strings by length
names = ["Chandu", "Pavan", "Neha", "Aswini"]
by_length = sorted(names, key=lambda n: len(n))
# ["Neha", "Pavan", "Chandu", "Aswini"]
```', 2);


-- ================================================================
-- ================== MODULES & PACKAGES ==========================
-- ================================================================

-- MODULES & PACKAGES - Concept Flashcards
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'What is a module in Python?',
 'A .py file containing Python code (functions, classes, variables) that can be imported',
 'A module is like a toolbox — instead of carrying every tool everywhere, you pick the toolbox you need. If Chandu writes helper functions in utils.py, he can import them anywhere with import utils.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'The ____ keyword is used to import a module in Python.',
 'import',
 'import math brings in the entire math module. Access functions with math.sqrt(16). You can also import specific items: from math import sqrt, then use sqrt(16) directly.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'The ____ keyword imports specific items from a module.',
 'from',
 'from math import sqrt, pi imports only sqrt and pi. No need to write math.sqrt() — just sqrt(). Cleaner but may cause name conflicts if two modules have the same function name.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'The ____ keyword gives a module or import an alias (short name).',
 'as',
 'import numpy as np lets you write np.array() instead of numpy.array(). from datetime import datetime as dt shortens long names. Makes code more concise.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'A ____ is a directory containing multiple modules and an __init__.py file.',
 'package',
 'A package organizes related modules in a folder. Like a department in a company: the analytics/ folder might contain stats.py, charts.py, reports.py. Import with from analytics import stats.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'The ____ variable equals "__main__" when a script is run directly.',
 '__name__',
 'if __name__ == "__main__": runs code only when the file is executed directly, not when imported. This lets a module work both as a script and a reusable module.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'The ____ command installs third-party packages from PyPI.',
 'pip install',
 'pip install requests downloads and installs the requests library. pip is Python''s package manager. PyPI (Python Package Index) has 400,000+ packages. Use pip list to see installed packages.',
 'concept'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'Common built-in modules include math, os, sys, json, datetime, and ____.',
 'random',
 'Python comes with 200+ built-in modules (the standard library). random generates random numbers, os interacts with the OS, json handles JSON data, datetime works with dates and times.',
 'concept');

-- MODULES & PACKAGES - Quiz Flashcards (MCQ)
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'What does "from math import sqrt" do?',
 'Imports only the sqrt function from the math module',
 'This imports just sqrt, not the entire math module. You can use sqrt(16) directly instead of math.sqrt(16). Other math functions are not available.',
 'Imports the entire math module', 'Imports only the sqrt function from the math module', 'Creates a new function called sqrt', 'Renames the math module', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'What does "import pandas as pd" allow you to do?',
 'Use pd as a shorthand for pandas',
 'The as keyword creates an alias. Instead of writing pandas.DataFrame(), you can write pd.DataFrame(). This is a standard convention for popular libraries.',
 'Install pandas', 'Use pd as a shorthand for pandas', 'Rename the pandas library', 'Create a copy of pandas', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'When does the code inside if __name__ == "__main__": execute?',
 'Only when the file is run directly, not when imported',
 'When you run python script.py, __name__ is "__main__". When another file imports it, __name__ is the module name. This guard prevents code from running on import.',
 'Always', 'Only when imported', 'Only when the file is run directly, not when imported', 'Only in debug mode', 'c', 'quiz'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'What makes a directory a Python package?',
 'An __init__.py file inside it',
 'A package is a directory with an __init__.py file (can be empty). This tells Python the directory is a package that can be imported. Without it, Python won''t recognize it as a package.',
 'A setup.py file', 'An __init__.py file inside it', 'At least 3 .py files', 'A requirements.txt file', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'Why is "from module import *" considered bad practice?',
 'It imports everything and can cause name conflicts',
 'import * dumps all names into your namespace. If two modules have a function with the same name, one silently overwrites the other. It also makes code harder to understand — you cannot tell where a function came from.',
 'It is slower', 'It imports everything and can cause name conflicts', 'It does not work', 'It only works with built-in modules', 'b', 'quiz'),

('c2000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000002',
 'Which command installs the requests library?',
 'pip install requests',
 'pip is Python''s package manager. pip install <package> downloads from PyPI and installs it. Use pip install -r requirements.txt to install all dependencies from a file.',
 'python install requests', 'pip install requests', 'import requests --install', 'download requests', 'b', 'quiz');

-- MODULES & PACKAGES - Concepts
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c2000000-0000-0000-0000-000000000006', 'Importing Modules',
'# Modules in Python

A **module** is a .py file containing reusable code. Python has 200+ built-in modules, plus thousands of third-party packages.

## Import Styles

```python
# Import entire module
import math
print(math.sqrt(16))  # 4.0
print(math.pi)        # 3.14159...

# Import specific items
from math import sqrt, pi
print(sqrt(16))  # 4.0 (no math. prefix needed)

# Import with alias
import datetime as dt
today = dt.date.today()

# Import everything (avoid this!)
from math import *   # Bad practice — name conflicts possible
```

## Common Built-in Modules

```python
# math — mathematical functions
import math
print(math.ceil(4.2))    # 5
print(math.floor(4.8))   # 4
print(math.factorial(5)) # 120

# random — random numbers
import random
print(random.randint(1, 10))          # Random int 1-10
print(random.choice(["Chandu", "Pavan", "Neha"]))  # Random pick
random.shuffle([1, 2, 3, 4, 5])      # Shuffle in place

# os — operating system interaction
import os
print(os.getcwd())             # Current directory
print(os.path.exists("data"))  # Check if file/dir exists

# datetime — dates and times
from datetime import datetime, timedelta
now = datetime.now()
tomorrow = now + timedelta(days=1)
print(now.strftime("%d-%m-%Y"))  # 10-02-2026

# json — JSON handling
import json
data = {"name": "Chandu", "age": 22}
json_string = json.dumps(data)     # Dict to JSON string
back_to_dict = json.loads(json_string)  # JSON string to dict
```

## Creating Your Own Module

```python
# File: helpers.py
def greet(name):
    return f"Hello, {name}!"

def add(a, b):
    return a + b

PI = 3.14159

# File: main.py
import helpers

print(helpers.greet("Chandu"))  # Hello, Chandu!
print(helpers.add(3, 5))        # 8
print(helpers.PI)                # 3.14159
```', 1),

('c2000000-0000-0000-0000-000000000006', 'Packages and pip',
'# Packages and pip

## What is a Package?

A package is a directory containing modules and an `__init__.py` file:

```
my_project/
├── main.py
└── utils/              # This is a package
    ├── __init__.py      # Makes it a package (can be empty)
    ├── math_helpers.py
    ├── string_helpers.py
    └── file_helpers.py
```

```python
# Importing from a package
from utils import math_helpers
from utils.string_helpers import capitalize_name
```

## The __name__ == "__main__" Guard

```python
# File: calculator.py
def add(a, b):
    return a + b

def multiply(a, b):
    return a * b

# This code only runs when file is executed directly
if __name__ == "__main__":
    # Testing
    print(add(3, 5))       # 8
    print(multiply(4, 6))  # 24

# When imported elsewhere, only functions are available
# The test code does NOT run
```

## pip — Python Package Manager

```bash
# Install a package
pip install requests

# Install specific version
pip install requests==2.28.0

# Install from requirements file
pip install -r requirements.txt

# List installed packages
pip list

# Show package info
pip show requests

# Uninstall
pip uninstall requests

# Create requirements file
pip freeze > requirements.txt
```

## Popular Third-Party Packages

| Package | Purpose |
|---------|---------|
| requests | HTTP requests |
| flask | Web framework |
| django | Full web framework |
| pandas | Data analysis |
| numpy | Numerical computing |
| matplotlib | Plotting/charts |
| pytest | Testing |
| pillow | Image processing |

## Virtual Environments

```bash
# Create virtual environment
python -m venv myenv

# Activate (Windows)
myenv\\Scripts\\activate

# Activate (Mac/Linux)
source myenv/bin/activate

# Install packages (only in this env)
pip install requests

# Deactivate
deactivate
```

Virtual environments keep Chandu''s project dependencies separate. Project A might need requests 2.28 while Project B needs 2.31 — virtual environments solve this conflict.', 2);
