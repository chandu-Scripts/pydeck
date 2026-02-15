-- PyDeck: Data Structures & Algorithms - Subtopics, Concepts & Quiz Flashcards
-- Run AFTER migration.sql and seed_subtopics.sql

-- DSA topic_id: b1000000-0000-0000-0000-000000000004

-- ============ CREATE SUBTOPICS FOR DSA ============
INSERT INTO subtopics (id, topic_id, name, icon, display_order) VALUES
  ('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004', 'Arrays & Strings', 'List', 1),
  ('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004', 'Linked Lists', 'Link', 2),
  ('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004', 'Stacks & Queues', 'Layers', 3),
  ('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004', 'Trees', 'GitBranch', 4),
  ('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004', 'Sorting Algorithms', 'ArrowUpDown', 5),
  ('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004', 'Searching & Recursion', 'Search', 6)
ON CONFLICT (id) DO NOTHING;


-- ================================================================
-- =================== ARRAYS & STRINGS ===========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'What is an array?',
 'A collection of elements stored in contiguous (continuous) memory locations',
 'An array is like a row of lockers numbered 0, 1, 2... — each locker holds one item and you can instantly access any locker by its number. In Python, lists work as dynamic arrays.',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'Accessing an element by index in an array has ____ time complexity.',
 'O(1) — constant time',
 'Because elements are in contiguous memory, Python can jump directly to any position. arr[5] takes the same time whether the array has 10 or 10 million elements. Like finding locker #5 — just go straight there.',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'Inserting an element at the beginning of an array takes ____ time.',
 'O(n) — linear time',
 'Every existing element must shift right by one position to make room. If Chandu inserts at index 0 of a 1000-element array, all 1000 elements must move. Appending at the end is O(1) — no shifting needed.',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'The two-pointer technique uses ____ pointers moving towards each other or in the same direction.',
 'two',
 'Two pointers start at different positions (often start and end) and move towards each other. Used to find pairs in sorted arrays, reverse strings, or detect palindromes. Avoids nested loops — O(n) instead of O(n²).',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'A ____ window technique maintains a subset of elements as it slides through an array.',
 'sliding',
 'Sliding window moves a fixed-size or variable-size window across the array. Like looking through a viewfinder that slides along a filmstrip. Used for finding max sum subarray, longest substring, etc.',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'Strings in Python are ____ — they cannot be changed after creation.',
 'immutable',
 'When you "modify" a string, Python creates a new one. s = "hello"; s[0] = "H" raises TypeError. For many modifications, convert to list first: chars = list(s), modify, then join back.',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'String concatenation in a loop has ____ time complexity.',
 'O(n²)',
 'Each s += char creates a new string and copies all previous characters. For n iterations, total work is 1+2+3+...+n = O(n²). Use "".join(list) instead — it is O(n).',
 'concept'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'A ____ is a sequence that reads the same forwards and backwards.',
 'palindrome',
 '"madam" reversed is "madam" — a palindrome. Check with: s == s[::-1]. Or use two pointers: compare characters from both ends moving inward. Common interview question.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of accessing arr[i]?',
 'O(1)',
 'Array access by index is constant time — the position is calculated directly from the base address. It does not matter how large the array is.',
 'O(n)', 'O(log n)', 'O(1)', 'O(n²)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'Why is "".join(list) preferred over += for building strings?',
 'join() is O(n) while += in a loop is O(n²)',
 'Each += creates a new string and copies everything. join() allocates memory once and copies all strings in one pass. For 10000 strings, join() is dramatically faster.',
 'join() is more readable', 'join() is O(n) while += in a loop is O(n²)', 'join() uses less memory', '+= does not work with strings', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of inserting at the beginning of a list?',
 'O(n)',
 'All existing elements must be shifted right by one position. For a list with n elements, n elements need to move. Appending at the end is O(1) amortized.',
 'O(1)', 'O(n)', 'O(log n)', 'O(n²)', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'How does the two-pointer technique help check if a string is a palindrome?',
 'One pointer starts at the beginning, one at the end, both move inward comparing characters',
 'Left pointer starts at index 0, right at index -1. Compare characters — if they match, move both inward. If any mismatch, it is not a palindrome. O(n) time, O(1) space.',
 'It reverses the string first', 'One pointer starts at the beginning, one at the end, both move inward comparing characters', 'It sorts the characters', 'It counts character frequencies', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'What does the sliding window technique do?',
 'Maintains a moving window over a sequence to solve subarray/substring problems',
 'Instead of checking every possible subarray (O(n²)), a window slides across maintaining a running result. Used for max sum subarray, minimum window substring, etc.',
 'Sorts the array in a window', 'Maintains a moving window over a sequence to solve subarray/substring problems', 'Splits the array into windows', 'Reverses elements in a window', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000001', 'b1000000-0000-0000-0000-000000000004',
 'What is "racecar"[::-1]?',
 '"racecar"',
 '[::-1] reverses a string. "racecar" reversed is "racecar" — it is a palindrome! This is the simplest palindrome check in Python: s == s[::-1].',
 '"raceca"', '"racecar"', '"racar"', 'Error', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000001', 'Arrays in Python',
'# Arrays (Lists) in Python

In Python, lists serve as dynamic arrays — the most fundamental data structure.

## Time Complexities

| Operation | Time | Example |
|-----------|------|---------|
| Access by index | O(1) | arr[5] |
| Append | O(1) | arr.append(x) |
| Insert at index | O(n) | arr.insert(0, x) |
| Delete by index | O(n) | arr.pop(0) |
| Search (unsorted) | O(n) | x in arr |
| Search (sorted) | O(log n) | bisect |
| Sort | O(n log n) | arr.sort() |

## Common Array Patterns

### Two-Pointer Technique

```python
# Check if array has a pair that sums to target
def two_sum_sorted(arr, target):
    left, right = 0, len(arr) - 1

    while left < right:
        current_sum = arr[left] + arr[right]
        if current_sum == target:
            return (left, right)
        elif current_sum < target:
            left += 1
        else:
            right -= 1
    return None

nums = [1, 3, 5, 7, 9, 11]
print(two_sum_sorted(nums, 12))  # (1, 4) — 3 + 9 = 12
```

### Reverse an Array In-Place

```python
def reverse_array(arr):
    left, right = 0, len(arr) - 1
    while left < right:
        arr[left], arr[right] = arr[right], arr[left]
        left += 1
        right -= 1

names = ["Chandu", "Pavan", "Neha", "Aswini"]
reverse_array(names)
print(names)  # ["Aswini", "Neha", "Pavan", "Chandu"]
```

### Sliding Window

```python
# Find maximum sum of k consecutive elements
def max_sum_subarray(arr, k):
    window_sum = sum(arr[:k])
    max_sum = window_sum

    for i in range(k, len(arr)):
        window_sum += arr[i] - arr[i - k]
        max_sum = max(max_sum, window_sum)

    return max_sum

scores = [2, 1, 5, 1, 3, 2]
print(max_sum_subarray(scores, 3))  # 9 (5+1+3)
```', 1),

('c4000000-0000-0000-0000-000000000001', 'String Algorithms',
'# String Algorithms

## Palindrome Check

```python
# Simple check
def is_palindrome(s):
    s = s.lower().replace(" ", "")
    return s == s[::-1]

print(is_palindrome("madam"))       # True
print(is_palindrome("Racecar"))     # True
print(is_palindrome("Chandu"))      # False

# Two-pointer approach (more efficient)
def is_palindrome_efficient(s):
    s = s.lower()
    left, right = 0, len(s) - 1
    while left < right:
        if s[left] != s[right]:
            return False
        left += 1
        right -= 1
    return True
```

## Character Frequency Counter

```python
from collections import Counter

def char_frequency(s):
    return Counter(s)

freq = char_frequency("chandu")
print(freq)  # Counter({''c'': 1, ''h'': 1, ''a'': 1, ''n'': 1, ''d'': 1, ''u'': 1})

# Find most common character
name = "aswini"
most_common = Counter(name).most_common(1)[0]
print(f"Most common: ''{most_common[0]}'' appears {most_common[1]} times")
```

## Anagram Check

```python
# Two strings are anagrams if they have the same characters
def is_anagram(s1, s2):
    return sorted(s1.lower()) == sorted(s2.lower())

# Or using Counter
def is_anagram_v2(s1, s2):
    return Counter(s1.lower()) == Counter(s2.lower())

print(is_anagram("listen", "silent"))  # True
print(is_anagram("hello", "world"))    # False
```

## String Reversal (Word Level)

```python
def reverse_words(sentence):
    return " ".join(sentence.split()[::-1])

print(reverse_words("Chandu loves Python"))
# "Python loves Chandu"
```

## Efficient String Building

```python
# BAD — O(n²) due to string immutability
result = ""
for name in ["Chandu", "Pavan", "Neha"]:
    result += name + ", "  # Creates new string each time

# GOOD — O(n) with join
result = ", ".join(["Chandu", "Pavan", "Neha"])
print(result)  # "Chandu, Pavan, Neha"
```', 2);


-- ================================================================
-- ===================== LINKED LISTS =============================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'What is a linked list?',
 'A data structure where each element (node) contains data and a reference to the next node',
 'A linked list is like a treasure hunt — each clue (node) has a message (data) and points to the next clue (next pointer). Unlike arrays, elements are NOT stored in contiguous memory.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'Each element in a linked list is called a ____, containing data and a pointer to the next element.',
 'node',
 'A node has two parts: the data (value) and next (reference to the next node). The last node''s next points to None, marking the end of the list. The first node is called the head.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'Inserting at the beginning of a linked list takes ____ time.',
 'O(1) — constant time',
 'Just create a new node, point its next to the current head, and update head. No shifting needed! Compare to arrays where inserting at the beginning is O(n) because all elements must shift.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'Accessing an element by index in a linked list takes ____ time.',
 'O(n) — linear time',
 'You must traverse from the head, following each next pointer. To reach the 100th node, you must visit all 99 nodes before it. Arrays have O(1) access — a key trade-off.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'A ____ linked list has nodes pointing to both the next AND previous nodes.',
 'doubly',
 'Each node has prev and next pointers. Can traverse in both directions. Uses more memory (extra pointer per node) but allows O(1) deletion if you have the node reference. Python''s collections.deque uses this.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'A ____ linked list has the last node pointing back to the first node.',
 'circular',
 'In a circular linked list, the last node''s next points to the head instead of None. Like runners on a circular track — after the last position, you are back at the start. Used in round-robin scheduling.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'The ____ pointer technique uses two pointers moving at different speeds to detect cycles.',
 'fast and slow (tortoise and hare)',
 'The slow pointer moves one step, the fast moves two steps. If there is a cycle, they will eventually meet. If fast reaches None, there is no cycle. Named after the tortoise and hare fable.',
 'concept'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'Linked lists use ____ memory than arrays for the same number of elements.',
 'more',
 'Each node stores data PLUS a reference (pointer). An array stores only data. For n integers, an array uses n×4 bytes, but a linked list uses n×(4+8) bytes (data + pointer). But linked lists grow dynamically without reallocation.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of inserting at the beginning of a linked list?',
 'O(1)',
 'Just create a new node and point it to the current head. No elements need to shift. This is a major advantage over arrays.',
 'O(n)', 'O(log n)', 'O(1)', 'O(n²)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of accessing the nth element in a linked list?',
 'O(n)',
 'You must traverse from the head, visiting each node one by one. There is no direct index access like arrays. To reach node 100, you visit nodes 1 through 99 first.',
 'O(1)', 'O(n)', 'O(log n)', 'O(n²)', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'What does the last node in a singly linked list point to?',
 'None (null)',
 'The last node''s next pointer is None, signaling the end of the list. When traversing, you stop when current.next is None.',
 'The head node', 'None (null)', 'Itself', 'The second node', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'How does the fast-and-slow pointer technique detect a cycle?',
 'If fast and slow meet, there is a cycle',
 'Slow moves 1 step, fast moves 2 steps. In a cycle, fast will eventually catch up to slow (like a fast runner lapping a slow one on a circular track). If fast reaches None, no cycle.',
 'By counting nodes', 'If fast and slow meet, there is a cycle', 'By storing visited nodes', 'By reversing the list', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'What is the advantage of a doubly linked list over a singly linked list?',
 'Can traverse in both directions',
 'A doubly linked list has prev and next pointers, allowing backward traversal. Deletion is O(1) if you have the node reference. Trade-off: uses more memory per node.',
 'Faster access by index', 'Can traverse in both directions', 'Uses less memory', 'Faster sorting', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000002', 'b1000000-0000-0000-0000-000000000004',
 'When is a linked list better than an array?',
 'Frequent insertions/deletions at the beginning or middle',
 'Linked lists excel at insertions/deletions (O(1) at head) without shifting elements. Arrays are better for random access (O(1)) and when you know the size upfront.',
 'When you need fast random access', 'Frequent insertions/deletions at the beginning or middle', 'When sorting is needed', 'When memory is limited', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000002', 'Singly Linked List',
'# Linked Lists

A linked list is a chain of nodes where each node points to the next — like a train where each car connects to the next.

## Node and LinkedList Class

```python
class Node:
    def __init__(self, data):
        self.data = data
        self.next = None

class LinkedList:
    def __init__(self):
        self.head = None

    def insert_at_beginning(self, data):
        new_node = Node(data)
        new_node.next = self.head
        self.head = new_node

    def insert_at_end(self, data):
        new_node = Node(data)
        if not self.head:
            self.head = new_node
            return
        current = self.head
        while current.next:
            current = current.next
        current.next = new_node

    def delete(self, data):
        if not self.head:
            return
        if self.head.data == data:
            self.head = self.head.next
            return
        current = self.head
        while current.next:
            if current.next.data == data:
                current.next = current.next.next
                return
            current = current.next

    def display(self):
        elements = []
        current = self.head
        while current:
            elements.append(str(current.data))
            current = current.next
        print(" -> ".join(elements) + " -> None")

# Usage
friends = LinkedList()
friends.insert_at_end("Chandu")
friends.insert_at_end("Pavan")
friends.insert_at_end("Neha")
friends.insert_at_beginning("Aswini")
friends.display()
# Aswini -> Chandu -> Pavan -> Neha -> None

friends.delete("Pavan")
friends.display()
# Aswini -> Chandu -> Neha -> None
```

## Array vs Linked List

| Operation | Array | Linked List |
|-----------|-------|-------------|
| Access by index | O(1) | O(n) |
| Insert at start | O(n) | O(1) |
| Insert at end | O(1)* | O(n) |
| Delete at start | O(n) | O(1) |
| Search | O(n) | O(n) |
| Memory | Less | More (pointers) |', 1),

('c4000000-0000-0000-0000-000000000002', 'Linked List Algorithms',
'# Linked List Algorithms

## Reverse a Linked List

```python
def reverse(self):
    prev = None
    current = self.head
    while current:
        next_node = current.next  # Save next
        current.next = prev       # Reverse pointer
        prev = current            # Move prev forward
        current = next_node       # Move current forward
    self.head = prev

# Chandu -> Pavan -> Neha -> None
# becomes
# Neha -> Pavan -> Chandu -> None
```

## Detect Cycle (Floyd''s Algorithm)

```python
def has_cycle(self):
    slow = self.head
    fast = self.head
    while fast and fast.next:
        slow = slow.next          # 1 step
        fast = fast.next.next     # 2 steps
        if slow == fast:
            return True
    return False
```

## Find Middle Element

```python
def find_middle(self):
    slow = self.head
    fast = self.head
    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next
    return slow.data

# For: Chandu -> Pavan -> Neha -> Aswini -> None
# slow ends at Neha (middle)
```

## Merge Two Sorted Lists

```python
def merge_sorted(l1_head, l2_head):
    dummy = Node(0)
    current = dummy

    while l1_head and l2_head:
        if l1_head.data <= l2_head.data:
            current.next = l1_head
            l1_head = l1_head.next
        else:
            current.next = l2_head
            l2_head = l2_head.next
        current = current.next

    current.next = l1_head or l2_head
    return dummy.next
```', 2);


-- ================================================================
-- =================== STACKS & QUEUES ============================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'What is a stack?',
 'A data structure that follows Last In, First Out (LIFO) principle',
 'A stack is like a stack of plates — you add to the top and remove from the top. The last plate placed is the first one taken. Push adds, pop removes. Used in undo operations, function calls, and expression evaluation.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'What is a queue?',
 'A data structure that follows First In, First Out (FIFO) principle',
 'A queue is like a line at a chai stall — the first person in line is served first. Enqueue adds to the back, dequeue removes from the front. Used in task scheduling, print queues, BFS.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'The two main operations of a stack are ____ (add) and ____ (remove).',
 'push and pop',
 'push(item) adds to the top. pop() removes and returns the top item. peek() or top() views the top without removing. All three are O(1) operations.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'In Python, a list can be used as a stack with append() for push and ____ for pop.',
 'pop()',
 'list.append(x) pushes to the top, list.pop() removes from the top. Both are O(1). list[-1] peeks at the top. Simple and efficient for stack behavior.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'Python''s collections.____ provides an efficient double-ended queue.',
 'deque',
 'deque (double-ended queue) allows O(1) append and pop from both ends. from collections import deque. Use append/pop for right, appendleft/popleft for left. Much faster than list for queue operations.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Stacks are used to check for ____ parentheses in expressions.',
 'balanced (matching)',
 'Push opening brackets onto stack. For each closing bracket, pop and check if it matches. If stack is empty at the end, brackets are balanced. "{[()]}" is balanced, "{[(])}" is not.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'A ____ queue processes elements based on priority, not insertion order.',
 'priority',
 'Higher priority items are dequeued first regardless of when they arrived. Like an emergency room — critical patients are treated before walk-ins. In Python, use heapq module.',
 'concept'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'The function call ____ in Python uses a stack to track active function calls.',
 'stack (call stack)',
 'When Chandu calls function A which calls B which calls C, they are pushed onto the call stack. C finishes and pops, then B pops, then A. Too many nested calls cause StackOverflow (RecursionError).',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Which principle does a stack follow?',
 'LIFO (Last In, First Out)',
 'The last element added is the first one removed — like a stack of books. You take from the top, add to the top.',
 'FIFO', 'LIFO', 'LILO', 'Random', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Which principle does a queue follow?',
 'FIFO (First In, First Out)',
 'The first element added is the first one removed — like a line at a ticket counter. First person in line gets served first.',
 'LIFO', 'FIFO', 'LILO', 'Priority', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Chandu pushes 1, 2, 3 onto a stack, then pops twice. What is left?',
 '[1]',
 'Push: stack = [1], then [1,2], then [1,2,3]. Pop: removes 3 → [1,2]. Pop: removes 2 → [1]. LIFO — last pushed (3) is first popped.',
 '[3]', '[1]', '[1, 2]', '[2, 3]', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Which Python module provides an efficient double-ended queue?',
 'collections (deque)',
 'collections.deque provides O(1) operations at both ends. Using list.pop(0) for a queue is O(n) because all elements shift. deque.popleft() is O(1).',
 'queue', 'collections (deque)', 'array', 'heapq', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'What real-world problem uses a stack?',
 'Undo/Redo in text editors',
 'Each action is pushed onto the undo stack. Pressing undo pops the last action. Browser back button, function calls, and balanced parentheses checking also use stacks.',
 'Task scheduling', 'Undo/Redo in text editors', 'Print queue', 'Network routing', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000003', 'b1000000-0000-0000-0000-000000000004',
 'Why is collections.deque better than list for implementing a queue?',
 'deque.popleft() is O(1) while list.pop(0) is O(n)',
 'Removing from the front of a list requires shifting all elements — O(n). deque uses a doubly linked list internally, so both ends are O(1).',
 'deque uses less memory', 'deque.popleft() is O(1) while list.pop(0) is O(n)', 'deque is built-in', 'deque has more methods', 'b', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000003', 'Stacks',
'# Stacks — LIFO

A stack is like a stack of plates — last placed, first removed.

## Stack Using Python List

```python
# Python list as stack
stack = []

# Push (add to top)
stack.append("Chandu")
stack.append("Pavan")
stack.append("Neha")
print(stack)  # ["Chandu", "Pavan", "Neha"]

# Peek (view top without removing)
print(stack[-1])  # Neha

# Pop (remove from top)
top = stack.pop()
print(top)    # Neha
print(stack)  # ["Chandu", "Pavan"]

# Check if empty
if not stack:
    print("Stack is empty")
```

## Classic Problem: Balanced Parentheses

```python
def is_balanced(expression):
    stack = []
    matching = {")": "(", "]": "[", "}": "{"}

    for char in expression:
        if char in "([{":
            stack.append(char)
        elif char in ")]}":
            if not stack or stack[-1] != matching[char]:
                return False
            stack.pop()

    return len(stack) == 0

print(is_balanced("{[()]}"))   # True
print(is_balanced("{[(])}"))   # False
print(is_balanced("((())"))    # False (unmatched)
```

## Reverse a String Using Stack

```python
def reverse_string(s):
    stack = list(s)
    result = ""
    while stack:
        result += stack.pop()
    return result

print(reverse_string("Chandu"))  # udnahC
```', 1),

('c4000000-0000-0000-0000-000000000003', 'Queues',
'# Queues — FIFO

A queue is like a line at a ticket counter — first in line, first served.

## Queue Using deque

```python
from collections import deque

queue = deque()

# Enqueue (add to back)
queue.append("Chandu")
queue.append("Pavan")
queue.append("Neha")
print(queue)  # deque(["Chandu", "Pavan", "Neha"])

# Dequeue (remove from front)
first = queue.popleft()
print(first)  # Chandu
print(queue)  # deque(["Pavan", "Neha"])

# Peek at front
print(queue[0])  # Pavan
```

## Priority Queue

```python
import heapq

# Min-heap (smallest priority first)
pq = []
heapq.heappush(pq, (3, "Pavan"))    # (priority, data)
heapq.heappush(pq, (1, "Chandu"))
heapq.heappush(pq, (2, "Neha"))

# Dequeue by priority
while pq:
    priority, name = heapq.heappop(pq)
    print(f"{name} (priority {priority})")
# Chandu (priority 1)
# Neha (priority 2)
# Pavan (priority 3)
```

## Stack vs Queue Summary

| Feature | Stack | Queue |
|---------|-------|-------|
| Principle | LIFO | FIFO |
| Add | push (top) | enqueue (back) |
| Remove | pop (top) | dequeue (front) |
| Python | list | collections.deque |
| Use cases | Undo, DFS, brackets | BFS, scheduling, buffers |', 2);


-- ================================================================
-- ========================= TREES ================================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'What is a tree data structure?',
 'A hierarchical structure with a root node and child nodes connected by edges',
 'A tree is like a family tree — one ancestor (root) at the top, with children branching below. Each node can have zero or more children. No cycles allowed.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'In a binary tree, each node has at most ____ children.',
 'two (left and right)',
 'Binary means two. Each node has a left child, a right child, or both, or none (leaf). Binary trees are the most common tree type and the basis for BSTs, heaps, and more.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'A Binary Search Tree (BST) maintains the property: left child < parent < ____.',
 'right child',
 'In a BST, all values in the left subtree are smaller, all in the right are larger. This makes searching O(log n) on average — cut the search space in half each step, like binary search.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'The three types of depth-first traversal are inorder, preorder, and ____.',
 'postorder',
 'Inorder (Left, Root, Right) gives sorted order in BST. Preorder (Root, Left, Right) is used for copying trees. Postorder (Left, Right, Root) is used for deleting trees.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 '____ traversal visits nodes level by level from top to bottom.',
 'Breadth-first (level-order)',
 'BFS visits all nodes at depth 0, then depth 1, then depth 2, etc. Uses a queue. Like reading a book page by page (level by level) instead of following one branch deep.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'A ____ node is a node with no children.',
 'leaf',
 'Leaf nodes are at the bottom of the tree — they have no left or right child. In a family tree analogy, they are the youngest generation with no children of their own.',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'The ____ of a tree is the number of edges on the longest path from root to a leaf.',
 'height',
 'A single-node tree has height 0. Height determines the worst-case operations. A balanced BST has height O(log n), giving efficient operations. An unbalanced BST can degrade to O(n).',
 'concept'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'Searching in a balanced BST takes ____ time.',
 'O(log n)',
 'At each node, you go left or right, eliminating half the remaining nodes. Like binary search but on a tree structure. An unbalanced BST (like a linked list) degrades to O(n).',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'What traversal gives sorted order in a BST?',
 'Inorder (Left, Root, Right)',
 'Inorder visits left subtree first (smaller values), then root, then right subtree (larger values). This naturally produces ascending order in a BST.',
 'Preorder', 'Inorder (Left, Root, Right)', 'Postorder', 'Level-order', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'What is the worst-case time complexity of searching in an unbalanced BST?',
 'O(n)',
 'An unbalanced BST can look like a linked list (each node has only one child). In this case, you must visit every node. Self-balancing trees (AVL, Red-Black) prevent this.',
 'O(1)', 'O(log n)', 'O(n)', 'O(n²)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'Which data structure is used for level-order (BFS) traversal of a tree?',
 'Queue',
 'BFS uses a queue: start with root, dequeue a node, enqueue its children. Process level by level. DFS (inorder/preorder/postorder) uses a stack or recursion.',
 'Stack', 'Queue', 'Linked List', 'Hash Table', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'In a BST, where is the minimum value located?',
 'The leftmost node',
 'In a BST, smaller values go left. The minimum is found by following left children until you reach a node with no left child. The maximum is the rightmost node.',
 'The root', 'The leftmost node', 'The rightmost node', 'Any leaf node', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'What is the maximum number of nodes in a binary tree of height h?',
 '2^(h+1) - 1',
 'A perfect binary tree of height h has 2^(h+1) - 1 nodes. Height 0 = 1 node, height 1 = 3 nodes, height 2 = 7 nodes, height 3 = 15 nodes.',
 'h + 1', '2h', '2^(h+1) - 1', 'h²', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000004', 'b1000000-0000-0000-0000-000000000004',
 'Which traversal visits: Root first, then Left, then Right?',
 'Preorder',
 'Preorder = Root, Left, Right. Used for creating a copy of the tree or prefix expression evaluation. Remember: "pre" means root comes first.',
 'Inorder', 'Postorder', 'Preorder', 'Level-order', 'c', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000004', 'Binary Trees and BST',
'# Trees

A hierarchical data structure — like an organizational chart.

## Binary Tree Implementation

```python
class TreeNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

# Build a simple tree
#       10
#      /  \
#     5    15
#    / \   / \
#   3   7 12  20

root = TreeNode(10)
root.left = TreeNode(5)
root.right = TreeNode(15)
root.left.left = TreeNode(3)
root.left.right = TreeNode(7)
root.right.left = TreeNode(12)
root.right.right = TreeNode(20)
```

## Tree Traversals

```python
# Inorder: Left -> Root -> Right (gives sorted order in BST)
def inorder(node):
    if node:
        inorder(node.left)
        print(node.value, end=" ")
        inorder(node.right)

inorder(root)  # 3 5 7 10 12 15 20

# Preorder: Root -> Left -> Right
def preorder(node):
    if node:
        print(node.value, end=" ")
        preorder(node.left)
        preorder(node.right)

preorder(root)  # 10 5 3 7 15 12 20

# Postorder: Left -> Right -> Root
def postorder(node):
    if node:
        postorder(node.left)
        postorder(node.right)
        print(node.value, end=" ")

postorder(root)  # 3 7 5 12 20 15 10
```

## Level-Order (BFS) Traversal

```python
from collections import deque

def level_order(root):
    if not root:
        return
    queue = deque([root])
    while queue:
        node = queue.popleft()
        print(node.value, end=" ")
        if node.left:
            queue.append(node.left)
        if node.right:
            queue.append(node.right)

level_order(root)  # 10 5 15 3 7 12 20
```', 1),

('c4000000-0000-0000-0000-000000000004', 'BST Operations',
'# Binary Search Tree Operations

## BST Insert

```python
def insert(root, value):
    if not root:
        return TreeNode(value)
    if value < root.value:
        root.left = insert(root.left, value)
    else:
        root.right = insert(root.right, value)
    return root

# Build BST from list
values = [50, 30, 70, 20, 40, 60, 80]
root = None
for v in values:
    root = insert(root, v)
```

## BST Search

```python
def search(root, target):
    if not root:
        return False
    if target == root.value:
        return True
    elif target < root.value:
        return search(root.left, target)
    else:
        return search(root.right, target)

print(search(root, 40))   # True
print(search(root, 45))   # False
```

## Find Min and Max

```python
def find_min(root):
    current = root
    while current.left:
        current = current.left
    return current.value

def find_max(root):
    current = root
    while current.right:
        current = current.right
    return current.value

print(find_min(root))  # 20
print(find_max(root))  # 80
```

## Tree Height

```python
def height(root):
    if not root:
        return -1
    return 1 + max(height(root.left), height(root.right))

print(height(root))  # 2
```

## Count Nodes

```python
def count_nodes(root):
    if not root:
        return 0
    return 1 + count_nodes(root.left) + count_nodes(root.right)

print(count_nodes(root))  # 7
```', 2);


-- ================================================================
-- ================== SORTING ALGORITHMS ==========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'What is sorting?',
 'Arranging elements in a specific order (ascending or descending)',
 'Sorting is like arranging books on a shelf alphabetically. Efficient sorting is crucial — searching a sorted array is O(log n) vs O(n) for unsorted. Different algorithms have different trade-offs.',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Bubble sort repeatedly compares ____ elements and swaps them if in wrong order.',
 'adjacent',
 'Bubble sort is like bubbles rising — larger elements "bubble up" to the end. Compare pairs, swap if needed, repeat. Simple but slow: O(n²). Not used in practice but good for learning.',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Selection sort finds the ____ element and places it in the correct position.',
 'minimum (or maximum)',
 'Like picking the shortest person from a group and placing them first, then the next shortest, etc. Finds minimum in unsorted portion, swaps it to the front. Always O(n²) regardless of input.',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Insertion sort builds the sorted array by ____ each element into its correct position.',
 'inserting',
 'Like sorting playing cards in your hand — pick up each card and insert it in the right spot among already-sorted cards. Best case O(n) for nearly sorted data. Good for small arrays.',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Merge sort uses the ____ and conquer strategy, splitting the array in half recursively.',
 'divide',
 'Split array into halves until single elements, then merge sorted halves back together. Always O(n log n). Stable sort (preserves order of equal elements). Uses O(n) extra space.',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Quick sort selects a ____ element and partitions the array around it.',
 'pivot',
 'Choose a pivot, put smaller elements left and larger right, then recursively sort both sides. Average O(n log n), worst O(n²) with bad pivot. In-place sorting (O(log n) space).',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Python''s built-in sort uses ____, a hybrid of merge sort and insertion sort.',
 'Timsort',
 'Timsort is optimized for real-world data. It detects already-sorted runs and merges them efficiently. O(n log n) worst case, O(n) best case for nearly sorted data. Used by sorted() and .sort().',
 'concept'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'A ____ sort preserves the relative order of equal elements.',
 'stable',
 'If Chandu and Pavan both scored 85, a stable sort keeps them in their original order. Merge sort and Timsort are stable. Quick sort and heap sort are NOT stable.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of bubble sort?',
 'O(n²)',
 'Bubble sort uses nested loops — comparing all pairs. For n elements, it does roughly n×n comparisons. Very slow for large datasets.',
 'O(n)', 'O(n log n)', 'O(n²)', 'O(log n)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'What is the average time complexity of merge sort?',
 'O(n log n)',
 'Merge sort divides (log n levels) and merges (O(n) per level). Total: O(n log n). It is always O(n log n) — even worst case. The trade-off is O(n) extra space.',
 'O(n)', 'O(n²)', 'O(n log n)', 'O(log n)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Which sorting algorithm is best for nearly sorted data?',
 'Insertion sort',
 'Insertion sort is O(n) for nearly sorted data — each element only needs to move a few positions. Bubble sort can also benefit but is still slower in practice.',
 'Bubble sort', 'Quick sort', 'Insertion sort', 'Selection sort', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'What is the worst-case time complexity of quick sort?',
 'O(n²)',
 'Quick sort degrades to O(n²) when the pivot is always the smallest or largest element (already sorted array with first element as pivot). Average case is O(n log n).',
 'O(n)', 'O(n log n)', 'O(n²)', 'O(2^n)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'What sorting algorithm does Python''s built-in sorted() use?',
 'Timsort',
 'Timsort is a hybrid of merge sort and insertion sort, designed for real-world data. It finds existing sorted runs and merges them. O(n log n) worst case.',
 'Quick sort', 'Merge sort', 'Timsort', 'Heap sort', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000005', 'b1000000-0000-0000-0000-000000000004',
 'Which sort is NOT stable?',
 'Quick sort',
 'Quick sort does not preserve the relative order of equal elements during partitioning. Merge sort, insertion sort, and Timsort are stable sorts.',
 'Merge sort', 'Insertion sort', 'Timsort', 'Quick sort', 'd', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000005', 'Basic Sorting Algorithms',
'# Sorting Algorithms

## Bubble Sort — O(n²)

Compare adjacent elements and swap if in wrong order. Repeat until sorted.

```python
def bubble_sort(arr):
    n = len(arr)
    for i in range(n):
        swapped = False
        for j in range(0, n - i - 1):
            if arr[j] > arr[j + 1]:
                arr[j], arr[j + 1] = arr[j + 1], arr[j]
                swapped = True
        if not swapped:  # Optimization: stop if already sorted
            break
    return arr

scores = [78, 92, 65, 85, 42]
print(bubble_sort(scores))  # [42, 65, 78, 85, 92]
```

## Selection Sort — O(n²)

Find the minimum and place it at the front, repeat for remaining.

```python
def selection_sort(arr):
    for i in range(len(arr)):
        min_idx = i
        for j in range(i + 1, len(arr)):
            if arr[j] < arr[min_idx]:
                min_idx = j
        arr[i], arr[min_idx] = arr[min_idx], arr[i]
    return arr

ages = [22, 19, 25, 21, 23]
print(selection_sort(ages))  # [19, 21, 22, 23, 25]
```

## Insertion Sort — O(n²), O(n) best case

Insert each element into its correct position in the sorted portion.

```python
def insertion_sort(arr):
    for i in range(1, len(arr)):
        key = arr[i]
        j = i - 1
        while j >= 0 and arr[j] > key:
            arr[j + 1] = arr[j]
            j -= 1
        arr[j + 1] = key
    return arr

marks = [85, 42, 91, 67, 38]
print(insertion_sort(marks))  # [38, 42, 67, 85, 91]
```

## Comparison

| Algorithm | Best | Average | Worst | Stable |
|-----------|------|---------|-------|--------|
| Bubble | O(n) | O(n²) | O(n²) | Yes |
| Selection | O(n²) | O(n²) | O(n²) | No |
| Insertion | O(n) | O(n²) | O(n²) | Yes |', 1),

('c4000000-0000-0000-0000-000000000005', 'Advanced Sorting Algorithms',
'# Merge Sort and Quick Sort

## Merge Sort — O(n log n)

Divide and conquer: split, sort halves, merge back.

```python
def merge_sort(arr):
    if len(arr) <= 1:
        return arr

    mid = len(arr) // 2
    left = merge_sort(arr[:mid])
    right = merge_sort(arr[mid:])

    return merge(left, right)

def merge(left, right):
    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result

scores = [38, 27, 43, 3, 9, 82, 10]
print(merge_sort(scores))  # [3, 9, 10, 27, 38, 43, 82]
```

## Quick Sort — O(n log n) average

Partition around a pivot, recursively sort both sides.

```python
def quick_sort(arr):
    if len(arr) <= 1:
        return arr

    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]

    return quick_sort(left) + middle + quick_sort(right)

ages = [22, 19, 25, 21, 23, 20]
print(quick_sort(ages))  # [19, 20, 21, 22, 23, 25]
```

## Python Built-in Sorting

```python
# sorted() returns new list
names = ["Chandu", "Pavan", "Neha", "Aswini"]
sorted_names = sorted(names)
print(sorted_names)  # ["Aswini", "Chandu", "Neha", "Pavan"]

# .sort() modifies in place
names.sort()

# Custom key
students = [("Chandu", 85), ("Pavan", 92), ("Neha", 78)]
students.sort(key=lambda s: s[1])  # Sort by score
# [("Neha", 78), ("Chandu", 85), ("Pavan", 92)]

# Reverse order
students.sort(key=lambda s: s[1], reverse=True)
# [("Pavan", 92), ("Chandu", 85), ("Neha", 78)]
```

## Big O Comparison

| Algorithm | Average | Worst | Space | Stable |
|-----------|---------|-------|-------|--------|
| Merge Sort | O(n log n) | O(n log n) | O(n) | Yes |
| Quick Sort | O(n log n) | O(n²) | O(log n) | No |
| Timsort | O(n log n) | O(n log n) | O(n) | Yes |', 2);


-- ================================================================
-- ================= SEARCHING & RECURSION ========================
-- ================================================================

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, card_type) VALUES

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is linear search?',
 'Checking each element one by one until the target is found',
 'Linear search is like looking for a name in an unsorted attendance list — you check each name from top to bottom. Works on any collection. Time: O(n). Simple but slow for large data.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is binary search?',
 'An efficient search on sorted data that halves the search space each step',
 'Binary search is like looking up a word in a dictionary — you open to the middle, decide if the word is before or after, and repeat with the correct half. Requires sorted data. Time: O(log n).',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'Binary search requires the data to be ____.',
 'sorted',
 'Binary search only works on sorted arrays/lists. If unsorted, sort first (O(n log n)) then search. For a single search, linear O(n) is faster. For many searches, sorting once + binary search pays off.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is recursion?',
 'A function calling itself to solve smaller instances of the same problem',
 'Recursion is like Russian nesting dolls — open one to find a smaller one inside, until the tiniest one (base case). factorial(5) calls factorial(4) which calls factorial(3)... until factorial(1) returns 1.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'Every recursive function must have a ____ case to stop recursion.',
 'base',
 'Without a base case, recursion goes infinitely until Python crashes with RecursionError (maximum recursion depth exceeded). The base case is the simplest version that can be solved directly.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'The maximum default recursion depth in Python is ____.',
 '1000',
 'Python limits recursion to 1000 calls by default to prevent stack overflow. Change with sys.setrecursionlimit(). But deep recursion is often a sign to use iteration instead.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'A hash table provides ____ average time for search, insert, and delete.',
 'O(1) — constant time',
 'Hash tables (Python dicts) use a hash function to compute the index directly. Like a phone book indexed by name — jump straight to the entry. Worst case O(n) with many collisions.',
 'concept'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 '____ is a technique of storing results of expensive function calls to avoid redundant computation.',
 'Memoization',
 'Memoization caches results: if fibonacci(10) was already computed, return the cached value instead of recalculating. Dramatically speeds up recursive solutions. Use @functools.lru_cache in Python.',
 'concept');

INSERT INTO flashcards (subtopic_id, topic_id, question, answer, explanation, option_a, option_b, option_c, option_d, correct_option, card_type) VALUES

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of binary search?',
 'O(log n)',
 'Each step halves the search space. For 1 million elements, binary search needs at most ~20 comparisons (log₂ 1000000 ≈ 20). Much faster than linear search''s O(n).',
 'O(n)', 'O(log n)', 'O(n²)', 'O(1)', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of linear search?',
 'O(n)',
 'In the worst case, you check every element. For n elements, that is n comparisons. Linear search works on unsorted data but is slow for large datasets.',
 'O(1)', 'O(log n)', 'O(n)', 'O(n²)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What happens if a recursive function has no base case?',
 'RecursionError (infinite recursion)',
 'Without a base case, the function calls itself forever until Python hits the recursion limit (default 1000) and raises RecursionError: maximum recursion depth exceeded.',
 'It returns None', 'RecursionError (infinite recursion)', 'It runs once and stops', 'It returns 0', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is the time complexity of looking up a key in a Python dictionary?',
 'O(1) average',
 'Python dicts use hash tables internally. The hash function computes the position directly, giving constant-time access on average. Worst case (many collisions) is O(n).',
 'O(n)', 'O(log n)', 'O(1) average', 'O(n²)', 'c', 'quiz'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'What is memoization?',
 'Caching function results to avoid repeated calculations',
 'If fibonacci(10) was computed before, return the stored result instead of recalculating. Turns exponential O(2^n) recursive fibonacci into O(n). Use @functools.lru_cache.',
 'A type of sorting', 'Caching function results to avoid repeated calculations', 'A memory management technique', 'A search algorithm', 'b', 'quiz'),

('c4000000-0000-0000-0000-000000000006', 'b1000000-0000-0000-0000-000000000004',
 'Binary search on a sorted array of 1 million elements needs at most how many comparisons?',
 'About 20',
 'log₂(1,000,000) ≈ 20. Each comparison halves the search space. 2^20 = 1,048,576 > 1,000,000. This is why binary search is so powerful.',
 'About 100', 'About 1000', 'About 20', 'About 500000', 'c', 'quiz');

INSERT INTO concepts (subtopic_id, title, content, display_order) VALUES
('c4000000-0000-0000-0000-000000000006', 'Searching Algorithms',
'# Searching Algorithms

## Linear Search — O(n)

```python
def linear_search(arr, target):
    for i, value in enumerate(arr):
        if value == target:
            return i
    return -1

names = ["Chandu", "Pavan", "Neha", "Aswini"]
print(linear_search(names, "Neha"))    # 2
print(linear_search(names, "Kiran"))   # -1
```

## Binary Search — O(log n)

Requires sorted array. Halves search space each step.

```python
def binary_search(arr, target):
    left, right = 0, len(arr) - 1

    while left <= right:
        mid = (left + right) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            left = mid + 1
        else:
            right = mid - 1
    return -1

scores = [38, 42, 65, 78, 85, 92]
print(binary_search(scores, 78))   # 3
print(binary_search(scores, 50))   # -1
```

## Binary Search (Recursive)

```python
def binary_search_recursive(arr, target, left, right):
    if left > right:
        return -1

    mid = (left + right) // 2
    if arr[mid] == target:
        return mid
    elif arr[mid] < target:
        return binary_search_recursive(arr, target, mid + 1, right)
    else:
        return binary_search_recursive(arr, target, left, mid - 1)

scores = [38, 42, 65, 78, 85, 92]
print(binary_search_recursive(scores, 85, 0, len(scores) - 1))  # 4
```

## Python bisect Module

```python
import bisect

sorted_scores = [42, 65, 78, 85, 92]

# Find insertion point
pos = bisect.bisect_left(sorted_scores, 78)
print(pos)  # 2

# Insert while maintaining sort order
bisect.insort(sorted_scores, 70)
print(sorted_scores)  # [42, 65, 70, 78, 85, 92]
```

## Search Comparison

| Algorithm | Time | Requires | Works On |
|-----------|------|----------|----------|
| Linear | O(n) | Nothing | Any data |
| Binary | O(log n) | Sorted data | Arrays |
| Hash (dict) | O(1) avg | Hash function | Key-value |', 1),

('c4000000-0000-0000-0000-000000000006', 'Recursion',
'# Recursion

A function calling itself to solve smaller versions of the same problem.

## Anatomy of Recursion

```python
def recursive_function(n):
    # 1. Base case — when to stop
    if n <= 0:
        return result

    # 2. Recursive case — call itself with smaller input
    return recursive_function(n - 1)
```

## Classic Examples

### Factorial

```python
def factorial(n):
    if n <= 1:         # Base case
        return 1
    return n * factorial(n - 1)  # Recursive case

print(factorial(5))  # 120
# 5 * factorial(4)
# 5 * 4 * factorial(3)
# 5 * 4 * 3 * factorial(2)
# 5 * 4 * 3 * 2 * factorial(1)
# 5 * 4 * 3 * 2 * 1 = 120
```

### Fibonacci

```python
# Simple (slow — O(2^n))
def fib(n):
    if n <= 1:
        return n
    return fib(n - 1) + fib(n - 2)

# With memoization (fast — O(n))
from functools import lru_cache

@lru_cache(maxsize=None)
def fib_fast(n):
    if n <= 1:
        return n
    return fib_fast(n - 1) + fib_fast(n - 2)

print(fib_fast(50))  # 12586269025 (instant!)
```

### Sum of List

```python
def recursive_sum(arr):
    if len(arr) == 0:
        return 0
    return arr[0] + recursive_sum(arr[1:])

print(recursive_sum([10, 20, 30, 40]))  # 100
```

### Power Function

```python
def power(base, exp):
    if exp == 0:
        return 1
    return base * power(base, exp - 1)

print(power(2, 10))  # 1024
```

## Recursion vs Iteration

```python
# Recursive factorial
def fact_recursive(n):
    if n <= 1: return 1
    return n * fact_recursive(n - 1)

# Iterative factorial
def fact_iterative(n):
    result = 1
    for i in range(2, n + 1):
        result *= i
    return result

# Both give same result, but iteration uses less memory
```

## When to Use Recursion

| Use Recursion | Use Iteration |
|---------------|--------------|
| Tree traversals | Simple loops |
| Divide and conquer | Large n (avoid stack overflow) |
| Backtracking | Performance critical |
| When code is clearer | When memory matters |', 2);
