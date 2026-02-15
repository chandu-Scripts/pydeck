-- PyDeck: Missing Flashcards for Python Basics Subtopics
-- Run this in Supabase SQL Editor AFTER migration.sql and seed_subtopics.sql
-- Phase 1: Python Basics only

-- Subtopic IDs (from seed_subtopics.sql):
--   Operators:    c1000000-0000-0000-0000-000000000002
--   Tuples:       c1000000-0000-0000-0000-000000000005
--   Dictionaries: c1000000-0000-0000-0000-000000000006
--   Conditionals: c1000000-0000-0000-0000-000000000008
--   Functions:    c1000000-0000-0000-0000-000000000009
--   Sets (NEW):   c1000000-0000-0000-0000-000000000010
-- Topic ID (Python Basics): b1000000-0000-0000-0000-000000000001


-- ================================================================
-- 0. ADD SETS SUBTOPIC (missing from original seed_subtopics.sql)
-- ================================================================
INSERT INTO subtopics (id, topic_id, name, icon, display_order) VALUES
  ('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001', 'Sets', 'CircleDot', 10)
ON CONFLICT (id) DO NOTHING;


-- ================================================================
-- 1. OPERATORS - Concept Flashcards (~10 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What is an operator in Python?',
 'A special symbol that performs operations on values',
 'An operator is like a tool in a workshop — just as a hammer drives nails and a saw cuts wood, operators perform specific actions on data. For example, + adds two numbers, * multiplies them. Python has arithmetic, comparison, logical, assignment, membership, identity, and bitwise operators.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operators in Python are +, -, *, /, //, %, and **.',
 'arithmetic',
 'Arithmetic operators work on numbers like a calculator. + adds, - subtracts, * multiplies, / divides (returns float), // floor divides (returns int), % gives remainder, ** raises to power. Example: If Chandu has 17 chocolates and shares among 5 friends, 17 // 5 = 3 each, 17 % 5 = 2 leftover.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The // operator performs ____ division, returning only the whole number part.',
 'floor',
 'Floor division drops the decimal part. 17 / 5 = 3.4 but 17 // 5 = 3. Think of it like distributing sweets equally — if Chandu has 17 sweets for 5 friends, each gets 3 whole sweets (17 // 5 = 3).',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The % operator is called ____ and returns the remainder of a division.',
 'modulo (mod)',
 'Modulo gives the leftover after division. 17 % 5 = 2 because 5 goes into 17 three times (15) with 2 remaining. Useful to check if a number is even: num % 2 == 0 means even.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The ** operator is used for ____ (raising a number to a power).',
 'exponentiation',
 '2 ** 3 = 8 (2 raised to the power 3 = 2 × 2 × 2). Think of it like compound growth — if Chandu doubles his savings every year for 3 years, he has 2 ** 3 = 8 times the original amount.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'Comparison operators like ==, !=, >, <, >=, <= return ____ values.',
 'Boolean (True/False)',
 'Comparison operators compare two values and return True or False. Like a judge comparing scores: 85 > 70 is True, 50 == 60 is False, 100 != 99 is True. Remember: == checks equality, = is assignment!',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The logical operators in Python are ____, ____, and ____.',
 'and, or, not',
 '''and'' returns True only if BOTH conditions are True. ''or'' returns True if AT LEAST ONE is True. ''not'' flips True to False and vice versa. Example: If Chandu needs both a ticket AND an ID to enter a movie, both must be True.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operator (+=) adds a value to a variable and assigns the result back.',
 'augmented assignment',
 'score += 10 is shorthand for score = score + 10. Similarly: -= subtracts, *= multiplies, /= divides, //= floor divides, %= modulo, **= power. Saves typing and is more readable!',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operators (in, not in) check if a value exists in a sequence.',
 'membership',
 '''in'' checks if an item exists in a list, string, tuple, etc. Like checking if a name is in a guest list: "Chandu" in ["Chandu", "Ravi", "Priya"] returns True. "not in" returns True if the item is NOT found.',
 'concept'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operators (is, is not) check if two variables refer to the same object in memory.',
 'identity',
 '''is'' checks if two variables point to the exact same object, not just equal values. a = [1, 2]; b = [1, 2]; a == b is True (same value) but a is b is False (different objects). Use ''is'' mainly with None: if x is None.',
 'concept');


-- ================================================================
-- 2. OPERATORS - Quiz Flashcards (MCQ, ~6 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What is the result of 17 // 5 in Python?',
 '3',
 '// is floor division — it divides and drops the decimal. 17 / 5 = 3.4, but 17 // 5 = 3. It always rounds down to the nearest whole number.',
 '3.4', '3', '2', '4', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What does the % operator return?',
 'The remainder of a division',
 'The modulo operator (%) returns the remainder after division. For example, 17 % 5 = 2 because 5 × 3 = 15, and 17 - 15 = 2.',
 'The quotient', 'The remainder of a division', 'The floor value', 'The power', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: print(2 ** 4)?',
 '16',
 '** is the exponentiation operator. 2 ** 4 means 2 raised to the power 4 = 2 × 2 × 2 × 2 = 16.',
 '8', '6', '16', '24', 'c', 'quiz'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What does the ''in'' operator do?',
 'Checks if a value exists in a sequence',
 'The ''in'' operator is a membership operator. It returns True if a value is found in a sequence (list, string, tuple, etc.). Example: "a" in "Chandu" returns True.',
 'Assigns a value', 'Checks if a value exists in a sequence', 'Compares two objects', 'Performs division', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'Which operator should you use to check if a variable is None?',
 'is',
 'Use the identity operator ''is'' to check for None: if x is None. Never use == for None checks, because ''is'' checks identity (same object) while == checks equality (can be overridden).',
 '==', 'is', 'in', 'not', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000001',
 'What is the result of: True and False or True?',
 'True',
 'Python evaluates ''and'' before ''or'' (higher precedence). Step 1: True and False = False. Step 2: False or True = True. So the result is True.',
 'True', 'False', 'None', 'Error', 'a', 'quiz');


-- ================================================================
-- 3. TUPLES - Concept Flashcards (~10 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'What is a tuple in Python?',
 'An ordered, immutable collection of items',
 'A tuple is like a sealed package — once you pack items in it, you cannot add, remove, or change them. It is written with round brackets: (1, 2, 3). Tuples are faster than lists and can be used as dictionary keys because they are immutable.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuples are ____, meaning their elements cannot be changed after creation.',
 'immutable',
 'Once a tuple is created, you cannot modify it — no adding, removing, or changing elements. Think of it like a printed receipt: the items are fixed. If Chandu creates t = (10, 20, 30), doing t[0] = 99 will raise a TypeError.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuples are created using ____ brackets, or the tuple() constructor.',
 'round (parentheses)',
 'Use () to create tuples: colors = ("red", "green", "blue"). You can also use tuple(): tuple([1, 2, 3]) converts a list to a tuple. Even without brackets, comma-separated values create a tuple: x = 1, 2, 3.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'To create a tuple with a single element, you must include a trailing ____.',
 'comma',
 'A common gotcha! (5) is just the number 5 in parentheses, NOT a tuple. To make a single-element tuple, write (5,) with a trailing comma. Without the comma, Python treats it as a grouped expression. type((5)) is int, but type((5,)) is tuple.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuple ____ assigns each element of a tuple to a separate variable in one line.',
 'unpacking',
 'Unpacking is like opening a package and sorting items into labeled boxes. If coordinates = (10, 20, 30), you can write x, y, z = coordinates and now x=10, y=20, z=30. The number of variables must match the number of elements!',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuple ____ is the reverse of unpacking — combining multiple values into a tuple.',
 'packing',
 'When you write coordinates = 10, 20, 30, Python automatically packs these values into a tuple (10, 20, 30). Packing and unpacking together enable elegant swaps: a, b = b, a swaps two variables without a temp variable!',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'The two built-in tuple methods are ____ and ____.',
 'count() and index()',
 'Since tuples are immutable, they have only 2 methods. count(x) returns how many times x appears: (1, 2, 2, 3).count(2) returns 2. index(x) returns the position of first occurrence: (10, 20, 30).index(20) returns 1.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuples can be used as dictionary ____ because they are immutable.',
 'keys',
 'Dictionary keys must be immutable (hashable). Lists cannot be keys because they can change, but tuples can! Example: locations = {("Mumbai", "MH"): "Western India", ("Delhi", "DL"): "North India"}. This is useful for composite keys.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Tuples are ____ than lists because of their immutability.',
 'faster',
 'Since Python knows a tuple cannot change, it can optimize memory and access. Iteration over a tuple is slightly faster than a list. Use tuples for fixed collections like days of the week, RGB colors, or coordinates that should not change.',
 'concept'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'The * operator in tuple unpacking captures ____ elements into a list.',
 'remaining',
 'Use * to capture extra elements: first, *rest = (1, 2, 3, 4, 5) gives first=1, rest=[2, 3, 4, 5]. Works at any position: first, *middle, last = (1, 2, 3, 4, 5) gives first=1, middle=[2, 3, 4], last=5.',
 'concept');


-- ================================================================
-- 4. TUPLES - Quiz Flashcards (MCQ, ~6 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Which of the following correctly creates a single-element tuple?',
 '(5,)',
 'A trailing comma is required for single-element tuples. (5) is just the integer 5 in parentheses, not a tuple. (5,) or tuple([5]) creates a proper tuple.',
 '(5)', '[5]', '(5,)', 'tuple(5)', 'c', 'quiz'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'What happens when you try t[0] = 99 on a tuple t = (10, 20, 30)?',
 'TypeError',
 'Tuples are immutable — you cannot change, add, or remove elements after creation. Attempting to modify a tuple element raises a TypeError.',
 'It changes to (99, 20, 30)', 'TypeError', 'IndexError', 'It creates a new tuple', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: x, y, z = (10, 20, 30); print(y)?',
 '20',
 'This is tuple unpacking — each value is assigned to the corresponding variable in order. x=10, y=20, z=30. So print(y) outputs 20.',
 '10', '20', '30', '(10, 20, 30)', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'How many built-in methods do tuples have?',
 '2 (count and index)',
 'Because tuples are immutable, they only have 2 methods: count() to count occurrences of a value, and index() to find the position of a value.',
 '0', '2 (count and index)', '5', 'Same as lists', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'Can tuples be used as dictionary keys?',
 'Yes, because they are immutable',
 'Dictionary keys must be hashable (immutable). Tuples qualify because they cannot change. Lists cannot be keys because they are mutable.',
 'No, only strings can be keys', 'Yes, because they are immutable', 'Yes, but only if they contain numbers', 'No, only lists can be keys', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000001',
 'What does first, *rest = (1, 2, 3, 4) give for rest?',
 '[2, 3, 4]',
 'The * operator in unpacking captures remaining elements into a list (not a tuple!). first gets 1, and *rest captures the remaining values [2, 3, 4].',
 '(2, 3, 4)', '[2, 3, 4]', '2, 3, 4', 'Error', 'b', 'quiz');


-- ================================================================
-- 5. DICTIONARIES - Quiz Flashcards (MCQ, ~6 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'What happens when you access a key that does not exist using dict["key"]?',
 'KeyError',
 'Using square brackets to access a missing key raises a KeyError. To avoid this, use dict.get("key") which returns None (or a default value) if the key is missing.',
 'Returns None', 'Returns 0', 'KeyError', 'Creates the key with None value', 'c', 'quiz'),

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: d = {"name": "Chandu", "age": 22}; print(d.get("city", "Unknown"))?',
 'Unknown',
 'The get() method returns the value for a key if it exists. If the key is missing, it returns the default value provided (second argument). Since "city" is not in the dictionary, it returns "Unknown".',
 'None', 'KeyError', 'Unknown', 'city', 'c', 'quiz'),

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'Which method returns all key-value pairs as a list of tuples?',
 'items()',
 'dict.items() returns key-value pairs as tuples: {"a": 1, "b": 2}.items() gives dict_items([(''a'', 1), (''b'', 2)]). keys() returns only keys, values() returns only values.',
 'keys()', 'values()', 'items()', 'pairs()', 'c', 'quiz'),

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'Can a Python list be used as a dictionary key?',
 'No, because lists are mutable',
 'Dictionary keys must be immutable (hashable). Lists can change, so they cannot be keys. Use tuples instead: d = {(1, 2): "point"} is valid, but d = {[1, 2]: "point"} raises TypeError.',
 'Yes, always', 'No, because lists are mutable', 'Yes, but only if it contains strings', 'Yes, but it converts to tuple first', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'What does the pop() method do on a dictionary?',
 'Removes the key and returns its value',
 'dict.pop("key") removes the key from the dictionary and returns its value. If the key does not exist, it raises KeyError (unless a default is provided). Example: d.pop("name") removes "name" and returns its value.',
 'Returns the last item', 'Removes the key and returns its value', 'Adds a new key', 'Returns all values', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: len({"name": "Chandu", "age": 22, "city": "Hyderabad"})?',
 '3',
 'len() on a dictionary returns the number of key-value pairs. This dictionary has 3 keys: "name", "age", and "city", so len() returns 3.',
 '6', '3', '9', 'Error', 'b', 'quiz');


-- ================================================================
-- 6. CONDITIONALS - Quiz Flashcards (MCQ, ~6 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: x = 10; print("Big" if x > 5 else "Small")?',
 'Big',
 'This is a ternary (conditional) expression. Since x = 10 and 10 > 5 is True, it prints "Big". The syntax is: value_if_true if condition else value_if_false.',
 'Small', 'Big', 'True', 'Error', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'Which keyword is used to add an additional condition check after if?',
 'elif',
 'elif (short for "else if") lets you check multiple conditions in sequence. Python checks if first, then each elif in order, and finally else. Only the first True condition''s block runs.',
 'else if', 'elif', 'elseif', 'otherwise', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'What is the result of: bool(0)?',
 'False',
 'In Python, 0 is a falsy value. bool(0) returns False. Other falsy values include: None, "" (empty string), [], (), {}, 0.0. Everything else is truthy.',
 'True', 'False', '0', 'None', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'Chandu writes: if score >= 90: grade = "A" / elif score >= 80: grade = "B" / else: grade = "C". If score = 85, what is grade?',
 'B',
 'Python checks conditions top to bottom. score = 85: Is 85 >= 90? No. Is 85 >= 80? Yes! So grade = "B". The else block is skipped because an elif matched.',
 'A', 'B', 'C', 'Error', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'Which of these is a valid way to check multiple conditions at once?',
 'if 18 <= age < 65',
 'Python supports chained comparisons. 18 <= age < 65 is equivalent to age >= 18 and age < 65, but more readable. This is a unique Python feature not available in most other languages.',
 'if 18 <= age < 65', 'if age between 18 and 65', 'if 18 < age > 65', 'if age in range(18, 65)', 'a', 'quiz'),

('c1000000-0000-0000-0000-000000000008', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: print(not True and False)?',
 'False',
 '''not'' has higher precedence than ''and''. So: not True = False, then False and False = False. Operator precedence: not > and > or.',
 'True', 'False', 'None', 'Error', 'b', 'quiz');


-- ================================================================
-- 7. FUNCTIONS - Additional Concept Flashcards (arguments vs parameters)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
 'What is the difference between a parameter and an argument?',
 'A parameter is in the function definition, an argument is the actual value passed when calling',
 'Think of it like a restaurant menu: the parameter is the item name on the menu (placeholder), and the argument is the actual dish served. In def greet(name): name is a parameter. In greet("Chandu"): "Chandu" is an argument.',
 'concept'),

('c1000000-0000-0000-0000-000000000009', 'b1000000-0000-0000-0000-000000000001',
 'The four types of arguments in Python are positional, ____, default, and variable-length (*args/**kwargs).',
 'keyword',
 'Positional args are matched by position: greet("Chandu", 22). Keyword args are matched by name: greet(name="Chandu", age=22). Default args have preset values: def greet(name, greeting="Hello"). Variable-length args accept any number: def total(*nums).',
 'concept');


-- ================================================================
-- 8. OPERATORS - Concept content (for concepts table)
-- ================================================================
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000002', 'Introduction to Operators',
'# Python Operators

An **operator** is a special symbol that performs an operation on one or more values (called operands). Think of operators as tools — each one does a specific job on your data.

## Types of Operators

Python has 7 types of operators:
1. **Arithmetic** — math operations
2. **Comparison** — comparing values
3. **Logical** — combining conditions
4. **Assignment** — storing values
5. **Membership** — checking if value exists in a sequence
6. **Identity** — checking if objects are the same
7. **Bitwise** — operating on bits

## Arithmetic Operators

These work like a calculator:

```python
a = 17
b = 5

print(a + b)   # 22  (Addition)
print(a - b)   # 12  (Subtraction)
print(a * b)   # 85  (Multiplication)
print(a / b)   # 3.4 (Division - always returns float)
print(a // b)  # 3   (Floor division - whole number only)
print(a % b)   # 2   (Modulo - remainder)
print(a ** b)  # 1419857 (Exponentiation - 17 to the power 5)
```

### Real-World Example
If Chandu has 17 chocolates and wants to share equally among 5 friends:
- Each friend gets: 17 // 5 = **3** chocolates
- Leftover: 17 % 5 = **2** chocolates

## Comparison Operators

Compare two values and return True or False:

```python
x = 10
y = 20

print(x == y)   # False (Equal to)
print(x != y)   # True  (Not equal to)
print(x > y)    # False (Greater than)
print(x < y)    # True  (Less than)
print(x >= 10)  # True  (Greater than or equal)
print(x <= 5)   # False (Less than or equal)
```

**Important:** `==` checks equality, `=` is assignment. Do not confuse them!', 1),

('c1000000-0000-0000-0000-000000000002', 'Logical, Assignment & Membership Operators',
'# Logical, Assignment & Membership Operators

## Logical Operators

Combine multiple conditions:

```python
age = 25
has_id = True

# and - Both must be True
if age >= 18 and has_id:
    print("Chandu can enter the event")  # This runs

# or - At least one must be True
is_vip = False
has_ticket = True

if is_vip or has_ticket:
    print("Chandu can watch the movie")  # This runs

# not - Flips True/False
is_raining = False

if not is_raining:
    print("Nice weather for cricket!")  # This runs
```

### Precedence: `not` > `and` > `or`

```python
# This:
result = True or False and not True
# Evaluates as:
# Step 1: not True → False
# Step 2: False and False → False
# Step 3: True or False → True
```

## Assignment Operators

Shorthand for updating variables:

```python
score = 100       # Basic assignment

score += 10       # score = score + 10 → 110
score -= 5        # score = score - 5 → 105
score *= 2        # score = score * 2 → 210
score /= 3        # score = score / 3 → 70.0
score //= 2       # score = score // 2 → 35.0
score %= 10       # score = score % 10 → 5.0
score **= 2       # score = score ** 2 → 25.0
```

## Membership Operators (in, not in)

Check if a value exists in a sequence:

```python
fruits = ["mango", "banana", "guava"]

print("mango" in fruits)      # True
print("apple" in fruits)      # False
print("apple" not in fruits)  # True

# Works with strings too
name = "Chandrakant"
print("Chandu" in name)       # False
print("Chandra" in name)      # True
```

## Identity Operators (is, is not)

Check if two variables point to the same object in memory:

```python
a = [1, 2, 3]
b = [1, 2, 3]
c = a

print(a == b)   # True  (same value)
print(a is b)   # False (different objects)
print(a is c)   # True  (same object)

# Most common use: checking for None
x = None
if x is None:
    print("x has no value")
```

### When to use `is` vs `==`
- Use `is` only for `None`, `True`, `False`
- Use `==` for comparing values', 2);


-- ================================================================
-- 9. TUPLES - Concept content (for concepts table)
-- ================================================================
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000005', 'Introduction to Tuples',
'# Python Tuples

A **tuple** is an ordered, immutable collection of items. Think of it as a sealed package — once you put items in, you cannot change, add, or remove them.

## Key Characteristics

- **Ordered**: Items maintain their position
- **Immutable**: Cannot be changed after creation
- **Allows duplicates**: Can have repeated values
- **Faster than lists**: Due to immutability, Python optimizes tuples

## Creating Tuples

```python
# Using parentheses
colors = ("red", "green", "blue")
coordinates = (10.5, 20.3)
mixed = (1, "Chandu", True, 3.14)

# Without parentheses (tuple packing)
point = 10, 20, 30
print(type(point))  # <class ''tuple''>

# Using tuple() constructor
nums = tuple([1, 2, 3])  # Convert list to tuple
chars = tuple("hello")   # (''h'', ''e'', ''l'', ''l'', ''o'')

# Empty tuple
empty = ()
also_empty = tuple()
```

## IMPORTANT: Single Element Tuple

```python
# This is NOT a tuple — it is just an integer
not_tuple = (5)
print(type(not_tuple))  # <class ''int''>

# This IS a tuple — note the trailing comma
is_tuple = (5,)
print(type(is_tuple))   # <class ''tuple''>
```

## Accessing Elements

```python
fruits = ("mango", "banana", "guava", "papaya")

# Positive indexing
print(fruits[0])    # mango
print(fruits[2])    # guava

# Negative indexing
print(fruits[-1])   # papaya
print(fruits[-2])   # guava

# Slicing
print(fruits[1:3])  # (''banana'', ''guava'')
print(fruits[:2])   # (''mango'', ''banana'')
print(fruits[::-1]) # (''papaya'', ''guava'', ''banana'', ''mango'')
```

## Immutability

```python
colors = ("red", "green", "blue")

# This will raise TypeError!
# colors[0] = "yellow"  # TypeError: ''tuple'' object does not support item assignment

# To "modify", create a new tuple
colors = ("yellow",) + colors[1:]
print(colors)  # (''yellow'', ''green'', ''blue'')
```', 1),

('c1000000-0000-0000-0000-000000000005', 'Tuple Operations and Methods',
'# Tuple Operations and Methods

## Tuple Packing and Unpacking

### Packing — combining values into a tuple
```python
# Python automatically packs comma-separated values into a tuple
coordinates = 10, 20, 30
print(coordinates)       # (10, 20, 30)
print(type(coordinates)) # <class ''tuple''>
```

### Unpacking — extracting values from a tuple
```python
point = (10, 20, 30)

# Assign each value to a variable
x, y, z = point
print(x)  # 10
print(y)  # 20
print(z)  # 30

# Swap two variables (uses packing/unpacking!)
a = "Chandu"
b = "Ravi"
a, b = b, a
print(a)  # Ravi
print(b)  # Chandu
```

### Extended Unpacking with *
```python
numbers = (1, 2, 3, 4, 5)

first, *middle, last = numbers
print(first)   # 1
print(middle)  # [2, 3, 4]  (a list, not tuple!)
print(last)    # 5

# Get first and rest
head, *tail = numbers
print(head)  # 1
print(tail)  # [2, 3, 4, 5]
```

## Tuple Methods

Tuples have only **2 methods** (because they are immutable):

```python
scores = (85, 92, 78, 92, 88, 92)

# count() — how many times a value appears
print(scores.count(92))   # 3
print(scores.count(100))  # 0

# index() — position of first occurrence
print(scores.index(92))   # 1 (first 92 is at index 1)
print(scores.index(78))   # 2
# scores.index(100)       # ValueError! Not found
```

## Tuple vs List

| Feature | Tuple | List |
|---------|-------|------|
| Syntax | () | [] |
| Mutable | No | Yes |
| Speed | Faster | Slower |
| Dict key | Yes | No |
| Methods | 2 | 11+ |
| Use for | Fixed data | Changing data |

```python
# Use tuple for things that should not change
days = ("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
rgb_red = (255, 0, 0)

# Use list for things that may change
shopping_cart = ["milk", "bread"]
shopping_cart.append("eggs")  # Can modify
```

## Tuple Operations

```python
# Concatenation
t1 = (1, 2)
t2 = (3, 4)
t3 = t1 + t2  # (1, 2, 3, 4)

# Repetition
t = ("ha",) * 3  # (''ha'', ''ha'', ''ha'')

# Membership
print(2 in (1, 2, 3))      # True
print(5 not in (1, 2, 3))  # True

# Length
print(len((1, 2, 3, 4)))   # 4

# Min, Max, Sum
nums = (10, 20, 5, 15)
print(min(nums))  # 5
print(max(nums))  # 20
print(sum(nums))  # 50
```

## Named Tuples

For tuples with named fields (like a lightweight class):

```python
from collections import namedtuple

Student = namedtuple("Student", ["name", "age", "grade"])

chandu = Student("Chandu", 22, "A")
print(chandu.name)   # Chandu
print(chandu.age)    # 22
print(chandu.grade)  # A

# Still a tuple — can unpack
name, age, grade = chandu
```', 2);


-- ================================================================
-- 10. SETS - Concept Flashcards (~10 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'What is a set in Python?',
 'An unordered collection of unique elements',
 'A set is like a bag of unique marbles — no duplicates allowed, and there is no fixed order. Sets are written with curly braces: {1, 2, 3}. If Chandu adds the same item twice, the set keeps only one copy.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'Sets automatically remove ____ elements.',
 'duplicate',
 'If you create a set with duplicates, Python keeps only unique values. Example: {1, 2, 2, 3, 3, 3} becomes {1, 2, 3}. This makes sets perfect for removing duplicates from a list: unique = set([1, 2, 2, 3]) gives {1, 2, 3}.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'Sets are ____, meaning they have no fixed position for elements.',
 'unordered',
 'Unlike lists and tuples, sets do not maintain insertion order. You cannot access set elements by index — s[0] will raise a TypeError. Think of it like a jar of mixed candies — you know what is inside, but not in what order.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'To create an empty set, you must use ____, not {}.',
 'set()',
 'This is a common gotcha! {} creates an empty dictionary, NOT an empty set. To create an empty set, use set(). Example: empty_set = set(). But {1, 2, 3} with values does create a set.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'The ____ method adds a single element to a set.',
 'add()',
 'Use add() to insert one element: fruits = {"mango", "banana"}; fruits.add("guava"). If the element already exists, nothing happens — no error, no duplicate. Unlike lists which use append(), sets use add().',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'The ____ method removes an element from a set without raising an error if missing.',
 'discard()',
 'discard() removes an element silently — if the element does not exist, nothing happens. remove() also removes but raises a KeyError if missing. Use discard() when you are not sure if the element exists.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operation returns elements that are in both sets.',
 'intersection (& or .intersection())',
 'Intersection finds common elements. Like finding friends Chandu and Ravi have in common: chandu_friends = {"Priya", "Amit", "Neha"}; ravi_friends = {"Amit", "Neha", "Kiran"}; common = chandu_friends & ravi_friends gives {"Amit", "Neha"}.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operation returns all elements from both sets combined.',
 'union (| or .union())',
 'Union merges two sets, keeping all unique elements. Like combining two guest lists: list1 = {"Chandu", "Ravi"}; list2 = {"Ravi", "Priya"}; all_guests = list1 | list2 gives {"Chandu", "Ravi", "Priya"}. Duplicates are automatically removed.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'The ____ operation returns elements in the first set but not in the second.',
 'difference (- or .difference())',
 'Difference finds what is unique to the first set. If Chandu has skills = {"Python", "SQL", "Excel"} and job_needs = {"Python", "Java"}, then skills - job_needs gives {"SQL", "Excel"} — skills Chandu has that the job does not need.',
 'concept'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'A ____ is an immutable version of a set that cannot be modified after creation.',
 'frozenset',
 'frozenset() creates a set that cannot be changed — no add, remove, or discard. Like a set sealed in glass. Useful when you need a set as a dictionary key or inside another set, since regular sets are mutable and unhashable.',
 'concept');


-- ================================================================
-- 11. SETS - Quiz Flashcards (MCQ, ~6 cards)
-- ================================================================
INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'What is the output of: print(len({1, 2, 2, 3, 3, 3}))?',
 '3',
 'Sets remove duplicates automatically. {1, 2, 2, 3, 3, 3} becomes {1, 2, 3}, which has 3 unique elements. So len() returns 3.',
 '6', '3', '1', 'Error', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'How do you create an empty set in Python?',
 'set()',
 'Using {} creates an empty dictionary, NOT a set. You must use set() for an empty set. This is a common Python gotcha that trips up many beginners.',
 '{}', 'set()', '[]', 'empty_set', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'What is {1, 2, 3} & {2, 3, 4} in Python?',
 '{2, 3}',
 'The & operator performs set intersection — it returns elements common to both sets. 2 and 3 appear in both sets, so the result is {2, 3}.',
 '{1, 2, 3, 4}', '{2, 3}', '{1, 4}', '{1}', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'What is the difference between remove() and discard() on a set?',
 'remove() raises KeyError if missing, discard() does not',
 'Both remove an element from a set. But if the element does not exist, remove() raises a KeyError while discard() silently does nothing. Use discard() when you are not sure the element exists.',
 'No difference', 'remove() raises KeyError if missing, discard() does not', 'discard() is faster', 'remove() returns the element', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'Can you access set elements by index like s[0]?',
 'No, sets are unordered',
 'Sets do not support indexing because they are unordered. s[0] raises a TypeError. To access elements, iterate with a for loop, or convert to a list first: list(my_set)[0].',
 'Yes, always', 'No, sets are unordered', 'Only with integers', 'Only with sorted()', 'b', 'quiz'),

('c1000000-0000-0000-0000-000000000010', 'b1000000-0000-0000-0000-000000000001',
 'What is {1, 2, 3} | {3, 4, 5} in Python?',
 '{1, 2, 3, 4, 5}',
 'The | operator performs set union — it combines all unique elements from both sets. The 3 appears in both but is included only once in the result.',
 '{3}', '{1, 2, 4, 5}', '{1, 2, 3, 4, 5}', '{1, 2, 3, 3, 4, 5}', 'c', 'quiz');


-- ================================================================
-- 12. SETS - Concept content (for concepts table)
-- ================================================================
INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c1000000-0000-0000-0000-000000000010', 'Introduction to Sets',
'# Python Sets

A **set** is an unordered collection of unique elements. Think of it like a bag of unique marbles — no duplicates allowed, and there is no fixed order.

## Key Characteristics

- **Unordered**: No fixed position, no indexing
- **Unique**: Duplicates are automatically removed
- **Mutable**: Can add and remove elements (but elements themselves must be immutable)
- **Fast lookups**: Checking if an item exists is very fast (O(1))

## Creating Sets

```python
# Using curly braces
fruits = {"mango", "banana", "guava"}
numbers = {1, 2, 3, 4, 5}

# Duplicates are removed automatically
nums = {1, 2, 2, 3, 3, 3}
print(nums)  # {1, 2, 3}

# Using set() constructor
from_list = set([1, 2, 2, 3])  # {1, 2, 3}
from_string = set("hello")     # {''h'', ''e'', ''l'', ''o''}

# IMPORTANT: Empty set
empty_set = set()       # Correct!
empty_dict = {}         # This is a DICTIONARY, not a set!
print(type(empty_set))  # <class ''set''>
print(type(empty_dict)) # <class ''dict''>
```

## Common Use: Removing Duplicates

```python
# Chandu has a list with duplicates
names = ["Ravi", "Priya", "Ravi", "Amit", "Priya", "Neha"]

# Convert to set to remove duplicates
unique_names = set(names)
print(unique_names)  # {''Ravi'', ''Priya'', ''Amit'', ''Neha''}

# Convert back to list if needed
unique_list = list(set(names))
print(unique_list)  # [''Ravi'', ''Priya'', ''Amit'', ''Neha''] (order may vary)
```

## Adding and Removing Elements

```python
colors = {"red", "green", "blue"}

# add() - Add one element
colors.add("yellow")
print(colors)  # {''red'', ''green'', ''blue'', ''yellow''}

# Adding duplicate does nothing
colors.add("red")
print(colors)  # Still {''red'', ''green'', ''blue'', ''yellow''}

# update() - Add multiple elements
colors.update(["orange", "purple"])
print(colors)  # Adds both orange and purple

# remove() - Raises KeyError if not found
colors.remove("red")
# colors.remove("pink")  # KeyError!

# discard() - No error if not found
colors.discard("pink")  # No error, nothing happens

# pop() - Remove and return an arbitrary element
item = colors.pop()
print(f"Removed: {item}")

# clear() - Remove all elements
colors.clear()
print(colors)  # set()
```

## Set Membership (in)

Checking if an element exists in a set is very fast:

```python
students = {"Chandu", "Ravi", "Priya", "Amit"}

print("Chandu" in students)   # True
print("Kiran" in students)    # False
print("Kiran" not in students) # True
```', 1),

('c1000000-0000-0000-0000-000000000010', 'Set Operations',
'# Set Operations

Sets support powerful mathematical operations like union, intersection, and difference.

## Union — Combine All Unique Elements

```python
# All friends from both groups
chandu_friends = {"Ravi", "Priya", "Amit"}
ravi_friends = {"Amit", "Neha", "Kiran"}

# Using | operator
all_friends = chandu_friends | ravi_friends
print(all_friends)  # {''Ravi'', ''Priya'', ''Amit'', ''Neha'', ''Kiran''}

# Using .union() method
all_friends = chandu_friends.union(ravi_friends)
```

## Intersection — Common Elements Only

```python
# Friends in common
common = chandu_friends & ravi_friends
print(common)  # {''Amit''}

# Using .intersection() method
common = chandu_friends.intersection(ravi_friends)
```

## Difference — Elements in First but Not Second

```python
# Friends only Chandu has (not in Ravi''s group)
only_chandu = chandu_friends - ravi_friends
print(only_chandu)  # {''Ravi'', ''Priya''}

# Friends only Ravi has
only_ravi = ravi_friends - chandu_friends
print(only_ravi)  # {''Neha'', ''Kiran''}

# Using .difference() method
only_chandu = chandu_friends.difference(ravi_friends)
```

## Symmetric Difference — Elements in Either but Not Both

```python
# Friends unique to each group (not shared)
exclusive = chandu_friends ^ ravi_friends
print(exclusive)  # {''Ravi'', ''Priya'', ''Neha'', ''Kiran''}

# Using .symmetric_difference() method
exclusive = chandu_friends.symmetric_difference(ravi_friends)
```

## Subset and Superset

```python
a = {1, 2, 3}
b = {1, 2, 3, 4, 5}

# Is a a subset of b? (All elements of a are in b)
print(a.issubset(b))    # True
print(a <= b)           # True

# Is b a superset of a? (b contains all elements of a)
print(b.issuperset(a))  # True
print(b >= a)           # True

# Are two sets disjoint? (No common elements)
c = {6, 7, 8}
print(a.isdisjoint(c))  # True (no overlap)
print(a.isdisjoint(b))  # False (they share elements)
```

## Set Comprehension

```python
# Create sets with comprehension syntax
squares = {x**2 for x in range(6)}
print(squares)  # {0, 1, 4, 9, 16, 25}

# Filter with condition
evens = {x for x in range(20) if x % 2 == 0}
print(evens)  # {0, 2, 4, 6, 8, 10, 12, 14, 16, 18}
```

## Frozenset — Immutable Set

```python
# Regular set — mutable
regular = {1, 2, 3}
regular.add(4)  # Works fine

# Frozenset — immutable (cannot be changed)
frozen = frozenset([1, 2, 3])
# frozen.add(4)  # AttributeError! Cannot modify

# Frozenset can be used as dictionary key or in another set
d = {frozenset({1, 2}): "pair"}
nested = {frozenset({1, 2}), frozenset({3, 4})}
```

## When to Use Sets vs Lists

| Use Set When | Use List When |
|---|---|
| Need unique values | Order matters |
| Fast membership checks | Need duplicates |
| Set math (union, etc.) | Need indexing |
| Removing duplicates | Need to maintain sequence |', 2);
