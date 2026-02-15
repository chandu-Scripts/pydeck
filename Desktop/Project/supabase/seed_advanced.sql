-- PyDeck: Advanced Python - Subtopics, Concepts & Quiz Flashcards
-- Run AFTER migration.sql and seed_subtopics.sql

-- Advanced Python topic_id: b1000000-0000-0000-0000-000000000003

-- ============ CREATE SUBTOPICS FOR ADVANCED PYTHON ============
INSERT INTO subtopics (id, topic_id, name, icon, display_order) VALUES
  ('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003', 'Decorators', 'Wand2', 1),
  ('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003', 'Generators & Iterators', 'Repeat', 2),
  ('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003', 'Context Managers', 'ShieldCheck', 3),
  ('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003', 'Regular Expressions', 'Search', 4),
  ('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003', 'Multithreading', 'Cpu', 5),
  ('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003', 'Type Hints', 'Tag', 6)
ON CONFLICT (id) DO NOTHING;


-- ================================================================
-- ======================== DECORATORS ============================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'What is a decorator in Python?',
 'A function that takes another function and extends its behavior without modifying it',
 'A decorator is like gift wrapping — the gift (original function) stays the same, but the wrapper adds extra features. @decorator_name is placed above a function to wrap it automatically.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'The ____ syntax is used to apply a decorator to a function.',
 '@ (at symbol)',
 '@my_decorator above def my_function(): is syntactic sugar for my_function = my_decorator(my_function). The @ symbol makes it cleaner and more readable.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'A decorator function typically defines an inner ____ function that wraps the original.',
 'wrapper',
 'The pattern: def decorator(func): defines outer, def wrapper(*args, **kwargs): defines inner, calls func() inside, and returns wrapper. The wrapper adds behavior before/after the original function.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'The @____ decorator makes a method accessible like an attribute without calling ().',
 'property',
 '@property turns a method into a getter. Instead of chandu.get_age(), you write chandu.age. Use @name.setter to define how to set the value. Provides controlled access to attributes.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'The @____ decorator defines a method that belongs to the class, not an instance.',
 'staticmethod',
 '@staticmethod does not receive self or cls. It is a utility function that lives inside the class namespace. Like a calculator function inside a Math class — it does not need any instance data.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'The @____ decorator receives the class itself as the first argument instead of an instance.',
 'classmethod',
 '@classmethod receives cls (the class) instead of self (instance). Used for factory methods — alternative constructors. Example: Student.from_string("Chandu,22") creates a Student without calling __init__ directly.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'The functools.____ decorator preserves the original function''s name and docstring when wrapped.',
 'wraps',
 'Without @wraps, the wrapped function loses its __name__ and __doc__. from functools import wraps, then @wraps(func) inside your decorator''s wrapper function preserves metadata.',
 'concept'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'You can stack multiple decorators on a single function by placing them ____.',
 'one above another',
 '@decorator1 @decorator2 def func(): ... applies decorator2 first, then decorator1. It is like wrapping a gift in paper, then putting it in a box — inner wrapper first.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'What does @property do in Python?',
 'Turns a method into a read-only attribute',
 '@property allows you to access a method like an attribute without parentheses. chandu.full_name instead of chandu.full_name(). You can add @name.setter to allow setting.',
 'Makes a function faster', 'Turns a method into a read-only attribute', 'Makes a method static', 'Creates a new property file', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'What is @staticmethod used for?',
 'Defining a method that does not need self or cls',
 'Static methods are utility functions that logically belong to a class but do not access instance or class data. They cannot modify object state.',
 'Making methods faster', 'Defining a method that does not need self or cls', 'Creating class variables', 'Preventing method overriding', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'In @decorator1 @decorator2 def func():, which decorator is applied first?',
 'decorator2 (bottom to top)',
 'Decorators are applied from bottom to top. decorator2 wraps func first, then decorator1 wraps the result. Think of it as func = decorator1(decorator2(func)).',
 'decorator1 (top to bottom)', 'decorator2 (bottom to top)', 'Both at the same time', 'Random order', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'What does @classmethod receive as its first parameter?',
 'cls (the class itself)',
 'While regular methods receive self (instance), class methods receive cls (the class). This allows creating factory methods and accessing class-level attributes.',
 'self', 'cls (the class itself)', 'args', 'Nothing', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'What problem does functools.wraps solve?',
 'Preserves the original function name and docstring',
 'Without @wraps, a decorated function loses its __name__ and __doc__, making debugging harder. @wraps(func) copies metadata from the original to the wrapper.',
 'Makes decorators faster', 'Prevents errors', 'Preserves the original function name and docstring', 'Allows multiple decorators', 'c', 'quiz'),

('c3000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000003',
 'Chandu writes a timer decorator. Where should he measure time — inside the wrapper or outside?',
 'Inside the wrapper function',
 'The wrapper runs each time the decorated function is called. Time measurement (start before func(), end after) must be inside the wrapper to measure each call.',
 'Inside the decorator', 'Inside the wrapper function', 'Outside both', 'In __init__', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000001', 'Understanding Decorators',
'# Decorators in Python

A decorator wraps a function to add extra behavior — like adding toppings to a pizza without changing the base.

## Basic Decorator Pattern

```python
def my_decorator(func):
    def wrapper(*args, **kwargs):
        print("Before the function runs")
        result = func(*args, **kwargs)
        print("After the function runs")
        return result
    return wrapper

@my_decorator
def greet(name):
    print(f"Hello, {name}!")

greet("Chandu")
# Before the function runs
# Hello, Chandu!
# After the function runs
```

## Practical Example: Timer Decorator

```python
import time
from functools import wraps

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@timer
def process_data(n):
    total = sum(range(n))
    return total

process_data(1000000)
# process_data took 0.0312 seconds
```

## Practical Example: Login Required

```python
from functools import wraps

def login_required(func):
    @wraps(func)
    def wrapper(user, *args, **kwargs):
        if not user.get("is_logged_in"):
            print(f"{user[''name'']}, please log in first!")
            return None
        return func(user, *args, **kwargs)
    return wrapper

@login_required
def view_dashboard(user):
    print(f"Welcome to dashboard, {user[''name'']}!")

chandu = {"name": "Chandu", "is_logged_in": True}
pavan = {"name": "Pavan", "is_logged_in": False}

view_dashboard(chandu)  # Welcome to dashboard, Chandu!
view_dashboard(pavan)   # Pavan, please log in first!
```', 1),

('c3000000-0000-0000-0000-000000000001', 'Property, Static & Class Methods',
'# @property, @staticmethod, @classmethod

## @property — Method as Attribute

```python
class Student:
    def __init__(self, first, last, marks):
        self.first = first
        self.last = last
        self._marks = marks

    @property
    def full_name(self):
        return f"{self.first} {self.last}"

    @property
    def grade(self):
        if self._marks >= 90: return "A"
        if self._marks >= 75: return "B"
        return "C"

    @property
    def marks(self):
        return self._marks

    @marks.setter
    def marks(self, value):
        if value < 0 or value > 100:
            raise ValueError("Marks must be 0-100")
        self._marks = value

chandu = Student("Chandu", "Kumar", 85)
print(chandu.full_name)  # Chandu Kumar (no parentheses!)
print(chandu.grade)      # B
chandu.marks = 95        # Uses setter
print(chandu.grade)      # A
```

## @staticmethod — No self or cls

```python
class MathUtils:
    @staticmethod
    def is_even(n):
        return n % 2 == 0

    @staticmethod
    def factorial(n):
        if n <= 1: return 1
        return n * MathUtils.factorial(n - 1)

# Call without creating an object
print(MathUtils.is_even(4))    # True
print(MathUtils.factorial(5))  # 120
```

## @classmethod — Factory Methods

```python
class Student:
    count = 0

    def __init__(self, name, age):
        self.name = name
        self.age = age
        Student.count += 1

    @classmethod
    def from_string(cls, data_string):
        """Create Student from ''name,age'' string"""
        name, age = data_string.split(",")
        return cls(name, int(age))

    @classmethod
    def get_count(cls):
        return f"Total students: {cls.count}"

# Normal creation
chandu = Student("Chandu", 22)

# Factory method creation
neha = Student.from_string("Neha,21")
pavan = Student.from_string("Pavan,23")

print(Student.get_count())  # Total students: 3
```', 2);


-- ================================================================
-- =================== GENERATORS & ITERATORS =====================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What is an iterator in Python?',
 'An object that can be iterated over, returning one element at a time',
 'An iterator is like a ticket dispenser — it gives you the next ticket each time you press the button. It implements __iter__() and __next__() methods. Lists, strings, tuples are all iterable (can create iterators).',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What is a generator in Python?',
 'A function that returns an iterator using the yield keyword',
 'A generator is like a factory that produces items on demand — it does not make all items at once. Uses yield instead of return. Each call to next() resumes where it left off. Memory efficient for large data.',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'The ____ keyword pauses a function and sends a value back, remembering its state.',
 'yield',
 'yield is like a bookmark — it pauses the function, returns a value, and remembers where it stopped. Next time next() is called, it continues from the bookmark. return exits permanently, yield pauses temporarily.',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'The ____ function retrieves the next value from an iterator.',
 'next()',
 'next(iterator) gets the next value. When no more values exist, it raises StopIteration. In a for loop, Python calls next() automatically and handles StopIteration for you.',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'Generators are memory efficient because they produce values ____.',
 'lazily (one at a time, on demand)',
 'A list [x**2 for x in range(1000000)] stores all 1 million values in memory. A generator (x**2 for x in range(1000000)) computes each value only when needed — uses almost no memory.',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'The ____ function converts an iterable to an iterator object.',
 'iter()',
 'iter([1,2,3]) creates an iterator from the list. Then use next() to get values. Python does this automatically in for loops: for x in [1,2,3]: internally calls iter() then next() repeatedly.',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'The ____ exception is raised when an iterator has no more values.',
 'StopIteration',
 'When next() is called on an exhausted iterator, StopIteration is raised. for loops catch this automatically. Generators raise it when the function ends (no more yield statements).',
 'concept'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'yield from is used to ____ from another generator or iterable.',
 'delegate (yield values)',
 'yield from sub_generator() passes all values from the sub-generator. Instead of: for x in sub(): yield x, write: yield from sub(). Cleaner for chaining generators.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What is the key difference between yield and return?',
 'yield pauses and remembers state, return exits permanently',
 'return ends the function and forgets everything. yield pauses the function and saves its state — when next() is called again, it continues from where it left off.',
 'No difference', 'yield is faster', 'yield pauses and remembers state, return exits permanently', 'return can be used multiple times', 'c', 'quiz'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What happens when you call a generator function?',
 'It returns a generator object (does not execute the function body)',
 'Calling a generator function does NOT run the code inside. It returns a generator object. The code only runs when you call next() or iterate over it.',
 'It runs immediately', 'It returns a generator object (does not execute the function body)', 'It returns a list', 'It raises an error', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'Why are generators more memory efficient than lists?',
 'They generate values one at a time instead of storing all in memory',
 'A list stores every element in memory. A generator computes and yields one value at a time. For 10 million items, a list uses gigabytes while a generator uses bytes.',
 'They compress data', 'They generate values one at a time instead of storing all in memory', 'They use a faster algorithm', 'They skip duplicate values', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What exception signals that an iterator is exhausted?',
 'StopIteration',
 'When there are no more values to yield, Python raises StopIteration. for loops handle this automatically by stopping. If you use next() manually, you need to catch it.',
 'EndOfIterator', 'StopIteration', 'IteratorError', 'GeneratorExit', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'Can a generator be iterated over more than once?',
 'No, generators are single-use',
 'Once a generator is exhausted, it cannot be restarted. You need to create a new generator object. Lists can be iterated multiple times, but generators cannot.',
 'Yes, unlimited times', 'No, generators are single-use', 'Yes, up to 3 times', 'Only with reset()', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000003',
 'What does (x**2 for x in range(5)) create?',
 'A generator expression',
 'Round brackets with comprehension syntax create a generator expression. It is lazy — values are computed on demand. Square brackets [x**2 for x in range(5)] creates a list (all in memory).',
 'A tuple', 'A list', 'A generator expression', 'A set', 'c', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000002', 'Iterators',
'# Iterators in Python

An iterator produces values one at a time — like a vending machine dispensing items one by one.

## How Iteration Works

```python
# Every for loop secretly uses iterators
names = ["Chandu", "Pavan", "Neha"]

# This:
for name in names:
    print(name)

# Is actually doing this:
iterator = iter(names)      # Create iterator
print(next(iterator))       # Chandu
print(next(iterator))       # Pavan
print(next(iterator))       # Neha
# next(iterator)            # StopIteration!
```

## Creating a Custom Iterator

```python
class Countdown:
    def __init__(self, start):
        self.current = start

    def __iter__(self):
        return self

    def __next__(self):
        if self.current <= 0:
            raise StopIteration
        value = self.current
        self.current -= 1
        return value

# Usage
for num in Countdown(5):
    print(num)
# 5, 4, 3, 2, 1
```

## Built-in Iterator Functions

```python
# enumerate — index + value
names = ["Chandu", "Pavan", "Neha"]
for i, name in enumerate(names, start=1):
    print(f"{i}. {name}")
# 1. Chandu, 2. Pavan, 3. Neha

# zip — pair elements from multiple iterables
names = ["Chandu", "Pavan", "Neha"]
scores = [85, 92, 78]
for name, score in zip(names, scores):
    print(f"{name}: {score}")

# reversed — iterate backwards
for name in reversed(names):
    print(name)
# Neha, Pavan, Chandu
```', 1),

('c3000000-0000-0000-0000-000000000002', 'Generators',
'# Generators in Python

Generators are functions that produce values lazily using `yield` — they are memory-efficient iterators.

## Basic Generator

```python
def count_up_to(n):
    i = 1
    while i <= n:
        yield i
        i += 1

# Usage
counter = count_up_to(5)
print(next(counter))  # 1
print(next(counter))  # 2

for num in count_up_to(5):
    print(num)  # 1, 2, 3, 4, 5
```

## Generator vs List — Memory Comparison

```python
import sys

# List — stores ALL values in memory
big_list = [x ** 2 for x in range(100000)]
print(sys.getsizeof(big_list))  # ~824456 bytes

# Generator — stores ONE value at a time
big_gen = (x ** 2 for x in range(100000))
print(sys.getsizeof(big_gen))   # ~112 bytes!
```

## Practical Examples

```python
# Read large file line by line
def read_large_file(filepath):
    with open(filepath, "r") as f:
        for line in f:
            yield line.strip()

# Process without loading entire file
for line in read_large_file("big_data.txt"):
    if "Chandu" in line:
        print(line)

# Fibonacci generator (infinite!)
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Get first 10 Fibonacci numbers
fib = fibonacci()
first_10 = [next(fib) for _ in range(10)]
print(first_10)  # [0, 1, 1, 2, 3, 5, 8, 13, 21, 34]

# Pipeline of generators
def numbers(n):
    for i in range(n):
        yield i

def squared(nums):
    for n in nums:
        yield n ** 2

def evens_only(nums):
    for n in nums:
        if n % 2 == 0:
            yield n

# Chain them — no intermediate lists!
pipeline = evens_only(squared(numbers(10)))
print(list(pipeline))  # [0, 4, 16, 36, 64]
```

## yield from — Delegating

```python
def gen1():
    yield from range(3)     # 0, 1, 2

def gen2():
    yield from range(3, 6)  # 3, 4, 5

def combined():
    yield from gen1()
    yield from gen2()

print(list(combined()))  # [0, 1, 2, 3, 4, 5]
```', 2);


-- ================================================================
-- =================== CONTEXT MANAGERS ===========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'What is a context manager in Python?',
 'An object that manages resources by defining setup and cleanup actions',
 'A context manager is like a hotel check-in/check-out system — it handles setup (check-in) and cleanup (check-out) automatically. Used with the "with" statement to ensure resources are properly released.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'Context managers implement the ____ and __exit__ methods.',
 '__enter__',
 '__enter__ runs when entering the with block (setup). __exit__ runs when leaving (cleanup). __exit__ receives exception info and always runs, even if an error occurs inside the block.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'The ____ statement is used to work with context managers.',
 'with',
 'with open("file.txt") as f: — the with statement calls __enter__ at the start and __exit__ at the end. The "as" variable holds the value returned by __enter__.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'The @contextmanager decorator from ____ module lets you create context managers using generators.',
 'contextlib',
 'Instead of writing a class with __enter__/__exit__, use @contextmanager with yield: everything before yield is setup, everything after is cleanup. Much simpler for basic use cases.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'The __exit__ method receives exception information and returns True to ____ the exception.',
 'suppress (swallow)',
 'If __exit__ returns True, the exception is suppressed. If False (default), the exception propagates. Usually you want exceptions to propagate — suppressing hides bugs.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'Context managers are commonly used for managing files, database connections, and ____.',
 'locks (thread synchronization)',
 'Any resource that needs cleanup benefits from context managers: files (close), DB connections (disconnect), locks (release), network connections (close), temporary directories (delete).',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'You can use multiple context managers in a single ____ statement.',
 'with',
 'with open("input.txt") as fin, open("output.txt", "w") as fout: manages both files. Both are guaranteed to close. Python 3.10+ allows parentheses for multi-line with statements.',
 'concept'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'The contextlib.suppress() context manager silently ignores specified ____.',
 'exceptions',
 'with suppress(FileNotFoundError): os.remove("temp.txt") — if the file does not exist, the error is silently ignored. Cleaner than try/except/pass for simple cases.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'Which two methods must a context manager class implement?',
 '__enter__ and __exit__',
 '__enter__ handles setup (called at with start), __exit__ handles cleanup (called at with end). Together they ensure resources are properly managed.',
 '__init__ and __del__', '__enter__ and __exit__', '__open__ and __close__', '__start__ and __stop__', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'When does __exit__ run?',
 'Always, when leaving the with block (even if an error occurs)',
 '__exit__ is guaranteed to run — whether the block completes normally or an exception is raised. This makes it reliable for cleanup operations.',
 'Only when no error occurs', 'Always, when leaving the with block (even if an error occurs)', 'Only when an error occurs', 'Only when explicitly called', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'How does @contextmanager simplify creating context managers?',
 'Uses a generator with yield instead of a class',
 'With @contextmanager, code before yield is __enter__, code after yield is __exit__. No need to write a full class with two dunder methods.',
 'It runs faster', 'Uses a generator with yield instead of a class', 'It auto-generates documentation', 'It prevents all exceptions', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'What does "with open(f) as fin, open(g, \"w\") as fout:" do?',
 'Opens two files and ensures both are closed',
 'Multiple context managers in one with statement. Both files are managed — if an error occurs while reading, both files are still properly closed.',
 'Opens one file', 'Opens two files and ensures both are closed', 'Copies one file to another', 'Raises an error', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'What is the most common use of context managers?',
 'File handling with the with statement',
 'with open("file.txt") as f: is the most common context manager usage. It ensures the file is closed even if an error occurs during reading/writing.',
 'Loop optimization', 'File handling with the with statement', 'Variable declaration', 'Function definition', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000003',
 'What does contextlib.suppress(FileNotFoundError) do?',
 'Silently ignores FileNotFoundError if it occurs',
 'suppress() catches and ignores specified exceptions. Cleaner than writing try/except/pass for cases where the exception is expected and harmless.',
 'Prevents the file from being deleted', 'Silently ignores FileNotFoundError if it occurs', 'Creates the file if missing', 'Logs the error', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000003', 'Using Context Managers',
'# Context Managers

Context managers handle setup and cleanup automatically — like a librarian who checks out books and always returns them.

## The with Statement

```python
# Most common: file handling
with open("notes.txt", "w") as f:
    f.write("Chandu''s Python Notes\n")
    f.write("Context managers are awesome!\n")
# File is automatically closed here

# Without with — risky!
f = open("notes.txt", "w")
f.write("data")
# If error occurs here, file stays open!
f.close()
```

## Creating with a Class

```python
class DatabaseConnection:
    def __init__(self, db_name):
        self.db_name = db_name

    def __enter__(self):
        print(f"Connecting to {self.db_name}...")
        self.connection = f"Connection({self.db_name})"
        return self.connection

    def __exit__(self, exc_type, exc_val, exc_tb):
        print(f"Closing connection to {self.db_name}")
        # exc_type/val/tb contain exception info if error occurred
        return False  # Do not suppress exceptions

with DatabaseConnection("students_db") as conn:
    print(f"Using {conn}")
# Connecting to students_db...
# Using Connection(students_db)
# Closing connection to students_db
```

## Creating with @contextmanager

```python
from contextlib import contextmanager

@contextmanager
def timer(label):
    import time
    start = time.time()
    print(f"Starting: {label}")
    yield  # Everything above = __enter__, below = __exit__
    elapsed = time.time() - start
    print(f"Finished: {label} in {elapsed:.4f}s")

with timer("Processing Chandu''s data"):
    total = sum(range(1000000))
# Starting: Processing Chandu''s data
# Finished: Processing Chandu''s data in 0.0234s
```', 1),

('c3000000-0000-0000-0000-000000000003', 'Advanced Context Manager Patterns',
'# Advanced Context Manager Patterns

## Multiple Context Managers

```python
# Copy contents from one file to another
with open("source.txt", "r") as src, open("dest.txt", "w") as dst:
    for line in src:
        dst.write(line.upper())
```

## Suppress Exceptions

```python
from contextlib import suppress
import os

# Without suppress
try:
    os.remove("temp_file.txt")
except FileNotFoundError:
    pass

# With suppress (cleaner)
with suppress(FileNotFoundError):
    os.remove("temp_file.txt")
```

## Practical: Temporary Directory

```python
from contextlib import contextmanager
import os
import shutil

@contextmanager
def temp_directory(path):
    os.makedirs(path, exist_ok=True)
    print(f"Created temp dir: {path}")
    try:
        yield path
    finally:
        shutil.rmtree(path)
        print(f"Cleaned up: {path}")

with temp_directory("temp_data") as tmpdir:
    # Write temp files
    with open(os.path.join(tmpdir, "data.txt"), "w") as f:
        f.write("Temporary data for Pavan''s analysis")
# Directory is automatically deleted after with block
```', 2);


-- ================================================================
-- ================== REGULAR EXPRESSIONS =========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What is a regular expression (regex)?',
 'A pattern used to search, match, and manipulate text',
 'Regex is like a search template with superpowers. Instead of searching for exact text, you describe a pattern. Like finding all phone numbers in a document — regex matches the pattern "10 digits" regardless of the actual numbers.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'The ____ module in Python provides regular expression support.',
 're',
 'import re gives access to regex functions. re.search() finds a match, re.findall() finds all matches, re.sub() replaces matches. Always import re before using regex.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 're.____() searches for the first match anywhere in the string.',
 'search',
 're.search(pattern, string) scans the entire string and returns the first match (or None). Unlike re.match() which only checks the beginning of the string.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 're.____() returns a list of all non-overlapping matches in a string.',
 'findall',
 're.findall(r"\\d+", "Chandu scored 85 and Pavan scored 92") returns ["85", "92"]. It finds every occurrence, not just the first one.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'The \\d pattern matches any ____, and \\w matches any word character.',
 'digit (0-9)',
 '\\d matches 0-9, \\w matches letters, digits, underscore (a-z, A-Z, 0-9, _). \\s matches whitespace (space, tab, newline). Capital versions (\\D, \\W, \\S) match the opposite.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'The + quantifier matches ____ or more occurrences of the previous pattern.',
 'one',
 '\\d+ matches one or more digits: "85" matches, "" does not. * matches zero or more, ? matches zero or one. {n} matches exactly n times, {n,m} matches n to m times.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'The r prefix before a regex string creates a ____ string that treats backslashes literally.',
 'raw',
 'r"\\d+" tells Python not to interpret \\d as an escape sequence. Without r, you would need "\\\\d+". Always use raw strings for regex patterns to avoid escaping issues.',
 'concept'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 're.____() replaces all matches of a pattern with a replacement string.',
 'sub',
 're.sub(r"\\d+", "X", "Chandu is 22 and Neha is 21") gives "Chandu is X and Neha is X". It replaces all occurrences. Use count parameter to limit replacements.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What does \\d+ match in regex?',
 'One or more digits',
 '\\d matches a single digit (0-9), + means one or more. So \\d+ matches sequences like "42", "100", "7". It will not match empty strings or letters.',
 'Exactly one digit', 'One or more digits', 'Zero or more digits', 'Only the digit 0', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What does re.findall(r"\\d+", "Chandu 85, Pavan 92") return?',
 '["85", "92"]',
 'findall() returns all matches as a list of strings. \\d+ matches one or more digits. It finds "85" and "92" in the text.',
 '["Chandu", "Pavan"]', '["85", "92"]', '[85, 92]', '["8", "5", "9", "2"]', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What is the difference between re.match() and re.search()?',
 'match() checks only the beginning, search() checks anywhere',
 're.match() only looks at the start of the string. re.search() scans the entire string. For "Hello 123", re.match(r"\\d+") returns None, but re.search(r"\\d+") finds "123".',
 'No difference', 'match() checks only the beginning, search() checks anywhere', 'search() is faster', 'match() finds all, search() finds one', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What does the . (dot) match in regex?',
 'Any single character except newline',
 'The dot is a wildcard — it matches any character (letter, digit, symbol) except \\n. To match a literal dot, escape it: \\. For example, r"\\d\\.\\d" matches "3.14".',
 'Only a period', 'Any single character except newline', 'Any digit', 'Whitespace', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'What does re.sub(r"\\s+", "-", "Chandu Kumar Reddy") return?',
 '"Chandu-Kumar-Reddy"',
 're.sub() replaces matches. \\s+ matches one or more whitespace characters. Each space is replaced with a hyphen.',
 '"ChanduKumarReddy"', '"Chandu-Kumar-Reddy"', '"Chandu Kumar Reddy"', '"C-h-a-n-d-u"', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000003',
 'Why should you use r"pattern" (raw strings) for regex?',
 'To prevent Python from interpreting backslashes as escape sequences',
 'Without r, \\d becomes an escape sequence. r"\\d+" keeps the backslash literal for regex. Without r, you would need to write "\\\\d+" which is harder to read.',
 'It makes regex faster', 'To prevent Python from interpreting backslashes as escape sequences', 'It is required by Python', 'To enable multiline mode', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000004', 'Regex Basics',
'# Regular Expressions (Regex)

Pattern matching for text — like a smart search with wildcards.

## Getting Started

```python
import re

text = "Chandu scored 85 in Python and 92 in SQL"

# Find first number
match = re.search(r"\d+", text)
print(match.group())  # 85

# Find all numbers
numbers = re.findall(r"\d+", text)
print(numbers)  # ["85", "92"]

# Replace numbers with X
censored = re.sub(r"\d+", "XX", text)
print(censored)  # Chandu scored XX in Python and XX in SQL
```

## Common Patterns

| Pattern | Matches | Example |
|---------|---------|---------|
| `\d` | One digit | 5 |
| `\d+` | One or more digits | 123 |
| `\w` | Word character (a-z, 0-9, _) | a |
| `\w+` | One or more word chars | hello |
| `\s` | Whitespace | space/tab |
| `.` | Any char (except \\n) | a, 1, @ |
| `^` | Start of string | ^Hello |
| `$` | End of string | world$ |

## Quantifiers

```python
import re

# + means one or more
re.findall(r"\d+", "a1bb22ccc333")  # ["1", "22", "333"]

# * means zero or more
re.findall(r"\d*", "a1b")  # ["", "1", "", ""]

# ? means zero or one
re.findall(r"colou?r", "color and colour")  # ["color", "colour"]

# {n} means exactly n times
re.findall(r"\d{3}", "12 345 6789")  # ["345", "678"]

# {n,m} means n to m times
re.findall(r"\d{2,4}", "1 22 333 4444 55555")  # ["22", "333", "4444", "5555"]
```', 1),

('c3000000-0000-0000-0000-000000000004', 'Practical Regex Patterns',
'# Practical Regex Patterns

## Validating Email

```python
import re

def is_valid_email(email):
    pattern = r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
    return bool(re.match(pattern, email))

print(is_valid_email("chandu@gmail.com"))    # True
print(is_valid_email("invalid@"))            # False
```

## Extracting Phone Numbers

```python
text = "Call Chandu at 9876543210 or Pavan at 8765432109"
phones = re.findall(r"\d{10}", text)
print(phones)  # ["9876543210", "8765432109"]
```

## Groups — Capturing Parts

```python
# Extract name and score
text = "Chandu:85, Neha:92, Pavan:78"
results = re.findall(r"(\w+):(\d+)", text)
print(results)  # [("Chandu", "85"), ("Neha", "92"), ("Pavan", "78")]

for name, score in results:
    print(f"{name} scored {score}")
```

## Character Classes

```python
# [abc] — matches a, b, or c
re.findall(r"[aeiou]", "Chandu")  # ["a", "u"]

# [^abc] — matches anything NOT a, b, c
re.findall(r"[^aeiou ]", "Chandu loves Python")
# ["C", "h", "n", "d", "l", "v", "s", "P", "y", "t", "h", "n"]

# [a-z] — range
re.findall(r"[A-Z]", "Chandu Kumar")  # ["C", "K"]
```

## Splitting with Regex

```python
text = "Chandu, Pavan;  Neha | Aswini"
names = re.split(r"[,;|]\s*", text)
print(names)  # ["Chandu", "Pavan", "Neha", "Aswini"]
```

## Flags

```python
# re.IGNORECASE — case-insensitive
re.findall(r"python", "Python PYTHON python", re.IGNORECASE)
# ["Python", "PYTHON", "python"]

# re.MULTILINE — ^ and $ match line boundaries
text = "Line 1\nLine 2\nLine 3"
re.findall(r"^Line \d", text, re.MULTILINE)
# ["Line 1", "Line 2", "Line 3"]
```', 2);


-- ================================================================
-- ===================== MULTITHREADING ===========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'What is multithreading?',
 'Running multiple threads (tasks) concurrently within a single process',
 'Multithreading is like Chandu cooking and doing laundry at the same time — while the washing machine runs, he can stir the pot. Multiple threads share the same memory space and run concurrently.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'The ____ module provides threading support in Python.',
 'threading',
 'import threading gives access to Thread class and synchronization tools. Create threads with threading.Thread(target=function). Use .start() to begin and .join() to wait for completion.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'The GIL (Global Interpreter Lock) prevents multiple threads from executing Python ____ simultaneously.',
 'bytecode',
 'The GIL is Python''s limitation — only one thread runs Python code at a time. This means threading does NOT speed up CPU-bound tasks. But it works great for I/O-bound tasks (file reading, network requests).',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'Threading is best for ____-bound tasks, while multiprocessing is best for CPU-bound tasks.',
 'I/O',
 'I/O-bound tasks spend time waiting: network requests, file reading, database queries. While one thread waits for a response, another can work. CPU-bound tasks (math, image processing) need multiprocessing to use multiple cores.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'The .____() method waits for a thread to complete before continuing.',
 'join',
 'thread.join() blocks the main program until that thread finishes. Without join(), the main program might end before threads complete their work.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'A ____ is used to prevent multiple threads from modifying shared data simultaneously.',
 'Lock',
 'threading.Lock() creates a lock. lock.acquire() locks it (only one thread at a time), lock.release() unlocks. Use with lock: for automatic acquire/release. Prevents race conditions.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'The ____ module provides true parallelism by using separate processes.',
 'multiprocessing',
 'Unlike threading (limited by GIL), multiprocessing creates separate processes with their own memory. Each process can use a different CPU core. Ideal for CPU-heavy calculations.',
 'concept'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'concurrent.futures provides ____ and ProcessPoolExecutor for managing thread/process pools.',
 'ThreadPoolExecutor',
 'Pool executors manage a pool of workers. ThreadPoolExecutor(max_workers=5) creates 5 threads. Use executor.submit(func, args) or executor.map(func, iterable) to run tasks. Cleaner than manual threading.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'Why does threading NOT speed up CPU-bound tasks in Python?',
 'Because of the GIL (Global Interpreter Lock)',
 'The GIL allows only one thread to execute Python bytecode at a time. Even with 8 threads, only one runs at any moment. For CPU-bound work, use multiprocessing instead.',
 'Python threads are slow', 'Because of the GIL (Global Interpreter Lock)', 'Threads share memory', 'Python does not support threads', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'Which type of task benefits most from threading?',
 'I/O-bound tasks (file read, network requests)',
 'When a thread waits for I/O (network response, file read), other threads can run. Threading shines for tasks that spend most time waiting, not computing.',
 'Math calculations', 'I/O-bound tasks (file read, network requests)', 'Image processing', 'Sorting algorithms', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'What does thread.join() do?',
 'Waits for the thread to finish before continuing',
 'join() blocks the calling thread until the target thread completes. Without it, the main program might exit while threads are still running.',
 'Starts the thread', 'Waits for the thread to finish before continuing', 'Merges two threads', 'Cancels the thread', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'What is a race condition?',
 'When multiple threads modify shared data simultaneously, causing unpredictable results',
 'If Chandu and Pavan both try to update a counter at the same time, one update might be lost. Use Lock to ensure only one thread modifies shared data at a time.',
 'A thread running too fast', 'When multiple threads modify shared data simultaneously, causing unpredictable results', 'A thread that never finishes', 'Two threads starting at the same time', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'What is the advantage of multiprocessing over threading?',
 'True parallelism — each process uses a separate CPU core',
 'multiprocessing bypasses the GIL by creating separate processes. Each process has its own Python interpreter and memory. Perfect for CPU-intensive tasks.',
 'Uses less memory', 'True parallelism — each process uses a separate CPU core', 'Simpler code', 'Faster for I/O tasks', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000003',
 'Which class provides an easy way to manage a pool of threads?',
 'ThreadPoolExecutor',
 'concurrent.futures.ThreadPoolExecutor manages a pool of threads. Use with ThreadPoolExecutor(max_workers=5) as executor: for clean resource management.',
 'ThreadManager', 'ThreadPoolExecutor', 'ThreadGroup', 'WorkerPool', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000005', 'Threading Basics',
'# Multithreading in Python

Run multiple tasks concurrently — like Chandu downloading files while processing data.

## Basic Threading

```python
import threading
import time

def download_file(filename):
    print(f"Downloading {filename}...")
    time.sleep(2)  # Simulate download
    print(f"Finished {filename}")

# Without threading — sequential (slow)
# download_file("file1.pdf")  # 2 seconds
# download_file("file2.pdf")  # 2 more seconds = 4 total

# With threading — concurrent (fast)
t1 = threading.Thread(target=download_file, args=("file1.pdf",))
t2 = threading.Thread(target=download_file, args=("file2.pdf",))

t1.start()
t2.start()

t1.join()  # Wait for t1 to finish
t2.join()  # Wait for t2 to finish
print("All downloads complete!")
# Both run concurrently — about 2 seconds total!
```

## The GIL Problem

```python
# Threading does NOT help with CPU-bound tasks!
# This will NOT be faster with threads:
def cpu_heavy(n):
    return sum(i*i for i in range(n))

# For CPU-bound work, use multiprocessing instead
from multiprocessing import Pool

with Pool(4) as p:
    results = p.map(cpu_heavy, [10**6, 10**6, 10**6, 10**6])
```

## When to Use What

| Task Type | Use | Example |
|-----------|-----|---------|
| I/O-bound | threading | File download, API calls |
| CPU-bound | multiprocessing | Math, image processing |
| Simple async | asyncio | Web servers, many connections |', 1),

('c3000000-0000-0000-0000-000000000005', 'Thread Safety and Pools',
'# Thread Safety and Thread Pools

## Race Condition Problem

```python
import threading

counter = 0

def increment():
    global counter
    for _ in range(100000):
        counter += 1  # NOT thread-safe!

t1 = threading.Thread(target=increment)
t2 = threading.Thread(target=increment)
t1.start(); t2.start()
t1.join(); t2.join()
print(counter)  # Expected 200000, but might be 150000!
```

## Fix with Lock

```python
import threading

counter = 0
lock = threading.Lock()

def safe_increment():
    global counter
    for _ in range(100000):
        with lock:  # Only one thread at a time
            counter += 1

t1 = threading.Thread(target=safe_increment)
t2 = threading.Thread(target=safe_increment)
t1.start(); t2.start()
t1.join(); t2.join()
print(counter)  # Always 200000!
```

## ThreadPoolExecutor (Recommended)

```python
from concurrent.futures import ThreadPoolExecutor
import time

def fetch_data(url):
    print(f"Fetching {url}...")
    time.sleep(1)  # Simulate network
    return f"Data from {url}"

urls = [
    "api.example.com/chandu",
    "api.example.com/pavan",
    "api.example.com/neha",
    "api.example.com/aswini"
]

# Manage pool of 3 threads
with ThreadPoolExecutor(max_workers=3) as executor:
    results = executor.map(fetch_data, urls)

for result in results:
    print(result)
# All 4 URLs fetched in ~2 seconds (not 4)
```', 2);


-- ================================================================
-- ====================== TYPE HINTS ==============================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'What are type hints in Python?',
 'Optional annotations that specify expected types for variables, parameters, and return values',
 'Type hints are like labels on containers — they tell you what should go inside. def greet(name: str) -> str: tells readers and tools that name should be a string and the function returns a string. Python does not enforce them at runtime.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'Type hints use ____ syntax for parameters and -> for return types.',
 'colon (:)',
 'def add(a: int, b: int) -> int: — the colon after each parameter specifies its type, the arrow -> specifies the return type. Python ignores these at runtime, but tools like mypy check them.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'Type hints are ____ — Python does not enforce them at runtime.',
 'optional (not enforced)',
 'Type hints are for humans and tools, not for Python itself. def add(a: int, b: int): return a + b — calling add("hello", "world") still works! Use mypy to catch type errors before running.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'The ____ type from typing module indicates a value can be one of several types.',
 'Union',
 'Union[int, str] means the value can be int OR str. Since Python 3.10+, you can use int | str instead. Example: def process(value: int | str) -> str:.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'Optional[X] is shorthand for Union[X, ____].',
 'None',
 'Optional[str] means the value can be a str or None. Used for parameters with None defaults: def find(name: str) -> Optional[str]:. Since 3.10+, write str | None.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'For collections, use list[int], dict[str, int], and tuple[str, ...] for type hints (Python ____+).',
 '3.9',
 'Python 3.9+ allows built-in types for hints: list[int], dict[str, int]. Before 3.9, you needed from typing import List, Dict. list[int] means a list of integers.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'The ____ tool is used to check type hints without running the code.',
 'mypy',
 'mypy is a static type checker. Run mypy script.py to find type errors before execution. It reads type hints and catches mismatches like passing str where int is expected.',
 'concept'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'The ____ type hint indicates a function does not return anything.',
 'None (-> None)',
 'def greet(name: str) -> None: means the function returns nothing (like void in other languages). print() functions typically return None.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'Does Python enforce type hints at runtime?',
 'No, they are ignored at runtime',
 'Type hints are purely informational. Python does not check or enforce them. add(a: int, b: int) still accepts strings. Use mypy for static checking.',
 'Yes, always', 'No, they are ignored at runtime', 'Only in strict mode', 'Only for return types', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'What does def greet(name: str) -> str: mean?',
 'name should be a string and the function returns a string',
 ': str after name means name is expected to be a string. -> str means the function returns a string. These are hints for developers and tools.',
 'name must be a string', 'name should be a string and the function returns a string', 'The function converts name to string', 'The function only works with strings', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'What does Optional[str] mean?',
 'The value can be str or None',
 'Optional[str] = Union[str, None]. Used when a value might not exist. Common for function returns that might fail: def find_user(id) -> Optional[User]:.',
 'The parameter is optional', 'The value can be str or None', 'The string is empty', 'The type is unknown', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'How do you type hint a list of integers in Python 3.9+?',
 'list[int]',
 'Python 3.9+ allows lowercase built-in types for hints. list[int] means a list containing integers. Before 3.9, you needed from typing import List; List[int].',
 'List[int]', 'list[int]', 'int[]', 'list(int)', 'b', 'quiz'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'Which tool checks type hints without running the code?',
 'mypy',
 'mypy is a static type checker. It reads your type hints and reports errors like "expected int, got str" without executing the code.',
 'pytest', 'pylint', 'mypy', 'black', 'c', 'quiz'),

('c3000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000003',
 'What does -> None indicate in a function signature?',
 'The function does not return a value',
 '-> None means the function returns nothing (implicitly returns None). Functions like print_message() that only have side effects use -> None.',
 'The function returns 0', 'The function does not return a value', 'The function raises an error', 'The function is empty', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c3000000-0000-0000-0000-000000000006', 'Type Hints Basics',
'# Type Hints in Python

Type hints are like labels — they tell you what type of data goes where, making code clearer and easier to debug.

## Basic Syntax

```python
# Variable type hints
name: str = "Chandu"
age: int = 22
height: float = 5.8
is_student: bool = True

# Function type hints
def greet(name: str) -> str:
    return f"Hello, {name}!"

def add(a: int, b: int) -> int:
    return a + b

def print_info(name: str, age: int) -> None:
    print(f"{name} is {age} years old")
```

## Collection Types (Python 3.9+)

```python
# List of integers
scores: list[int] = [85, 92, 78]

# Dictionary with string keys and int values
student_ages: dict[str, int] = {
    "Chandu": 22,
    "Pavan": 25,
    "Neha": 21
}

# Tuple with specific types
coordinates: tuple[float, float] = (10.5, 20.3)

# Set of strings
names: set[str] = {"Chandu", "Pavan", "Neha"}

# Function using collections
def average(scores: list[int]) -> float:
    return sum(scores) / len(scores)

def get_student(data: dict[str, int], name: str) -> int:
    return data[name]
```

## NOT Enforced at Runtime

```python
def add(a: int, b: int) -> int:
    return a + b

# These all work — Python ignores type hints!
print(add(3, 5))           # 8 (correct types)
print(add("hello", " "))   # "hello " (wrong types, still runs!)
print(add(3.5, 2.5))       # 6.0 (float, not int, still runs!)
```', 1),

('c3000000-0000-0000-0000-000000000006', 'Advanced Type Hints',
'# Advanced Type Hints

## Optional and Union

```python
from typing import Optional, Union

# Optional — value or None
def find_student(name: str) -> Optional[dict]:
    students = {"Chandu": {"age": 22}, "Neha": {"age": 21}}
    return students.get(name)  # Returns dict or None

# Union — one of multiple types
def process(value: Union[int, str]) -> str:
    return str(value)

# Python 3.10+ syntax (simpler)
def process(value: int | str) -> str:
    return str(value)

def find_student(name: str) -> dict | None:
    ...
```

## Callable Types

```python
from typing import Callable

# Function that takes a function as argument
def apply_operation(
    x: int,
    y: int,
    operation: Callable[[int, int], int]
) -> int:
    return operation(x, y)

result = apply_operation(5, 3, lambda a, b: a + b)
print(result)  # 8
```

## Type Aliases

```python
# Create readable type aliases
StudentScore = dict[str, int]
StudentList = list[StudentScore]

def get_top_students(students: StudentList) -> StudentList:
    return [s for s in students if list(s.values())[0] > 80]

data: StudentList = [
    {"Chandu": 85},
    {"Pavan": 72},
    {"Neha": 92}
]
```

## Practical Example

```python
from typing import Optional

class StudentDatabase:
    def __init__(self) -> None:
        self.students: dict[str, dict[str, int | str]] = {}

    def add_student(
        self,
        name: str,
        age: int,
        branch: str
    ) -> None:
        self.students[name] = {"age": age, "branch": branch}

    def get_student(self, name: str) -> Optional[dict[str, int | str]]:
        return self.students.get(name)

    def get_all_names(self) -> list[str]:
        return list(self.students.keys())

db = StudentDatabase()
db.add_student("Chandu", 22, "CSE")
db.add_student("Aswini", 21, "ECE")
print(db.get_all_names())  # ["Chandu", "Aswini"]
```', 2);
