-- PyDeck NumPy Seed Data: Path, Topics, Subtopics, Concepts
-- Run this in Supabase SQL Editor BEFORE seed_numpy_quizzes.sql

-- ============ PATH ============
INSERT INTO paths (id, name, description, icon, display_order) VALUES
  ('a1000000-0000-0000-0000-000000000005', 'NumPy', 'Master numerical computing with NumPy — the foundation of Python data science', 'Hash', 5)
ON CONFLICT (id) DO NOTHING;

-- ============ TOPICS ============
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b5000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000005', 'Introduction to NumPy', 'BookOpen', 1),
  ('b5000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000005', 'NumPy Arrays', 'Grid', 2),
  ('b5000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000005', 'Array Operations', 'Scissors', 3),
  ('b5000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000005', 'Math & Statistics', 'BarChart2', 4),
  ('b5000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000005', 'Advanced NumPy', 'Zap', 5)
ON CONFLICT (id) DO NOTHING;

-- ============ SUBTOPICS ============

-- Topic 1: Introduction to NumPy
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('e1000000-0000-0000-0000-000000000001', 'b5000000-0000-0000-0000-000000000001', 'What is NumPy & Why Use It', 1),
  ('e1000000-0000-0000-0000-000000000002', 'b5000000-0000-0000-0000-000000000001', 'Installing & Importing NumPy', 2),
  ('e1000000-0000-0000-0000-000000000003', 'b5000000-0000-0000-0000-000000000001', 'NumPy vs Python Lists', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 2: NumPy Arrays
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('e2000000-0000-0000-0000-000000000001', 'b5000000-0000-0000-0000-000000000002', 'Creating Arrays', 1),
  ('e2000000-0000-0000-0000-000000000002', 'b5000000-0000-0000-0000-000000000002', 'Array Properties', 2),
  ('e2000000-0000-0000-0000-000000000003', 'b5000000-0000-0000-0000-000000000002', 'Array Data Types', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 3: Array Operations
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('e3000000-0000-0000-0000-000000000001', 'b5000000-0000-0000-0000-000000000003', 'Indexing & Slicing', 1),
  ('e3000000-0000-0000-0000-000000000002', 'b5000000-0000-0000-0000-000000000003', 'Reshaping & Flattening', 2),
  ('e3000000-0000-0000-0000-000000000003', 'b5000000-0000-0000-0000-000000000003', 'Stacking & Splitting', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 4: Math & Statistics
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('e4000000-0000-0000-0000-000000000001', 'b5000000-0000-0000-0000-000000000004', 'Arithmetic Operations', 1),
  ('e4000000-0000-0000-0000-000000000002', 'b5000000-0000-0000-0000-000000000004', 'Statistical Functions', 2),
  ('e4000000-0000-0000-0000-000000000003', 'b5000000-0000-0000-0000-000000000004', 'Math Functions', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 5: Advanced NumPy
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('e5000000-0000-0000-0000-000000000001', 'b5000000-0000-0000-0000-000000000005', 'Broadcasting', 1),
  ('e5000000-0000-0000-0000-000000000002', 'b5000000-0000-0000-0000-000000000005', 'Vectorization & Performance', 2),
  ('e5000000-0000-0000-0000-000000000003', 'b5000000-0000-0000-0000-000000000005', 'Linear Algebra', 3),
  ('e5000000-0000-0000-0000-000000000004', 'b5000000-0000-0000-0000-000000000005', 'Random Module', 4)
ON CONFLICT (id) DO NOTHING;

-- ============ CONCEPTS ============

-- ---- SUBTOPIC 1: What is NumPy & Why Use It ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000001',
 'e1000000-0000-0000-0000-000000000001',
 'Introduction to NumPy',
 '## What is NumPy?

NumPy (Numerical Python) is an open-source Python library that provides support for large, multi-dimensional arrays and matrices, along with a huge collection of mathematical functions to operate on them.

**Why was it created?**
Python lists are flexible but painfully slow for numerical operations. Every Python list element is a full Python object stored in scattered memory locations. NumPy solves this by:
- Storing data in **contiguous memory blocks** (like C arrays)
- Running operations using **optimized C and Fortran code** under the hood
- Enabling **vectorized operations** — applying math to entire arrays without Python loops

**Where is NumPy used?**
- **Data Science** — analyzing datasets, cleaning data
- **Machine Learning** — model weights, feature arrays (TensorFlow, PyTorch, scikit-learn all use NumPy internally)
- **Image Processing** — every image is just a 2D or 3D array of pixel values
- **Finance** — stock price analysis, risk modeling
- **Physics & Engineering** — simulations, signal processing
- **Computer Vision** — matrix transformations

NumPy is the **foundation** of the entire Python scientific computing ecosystem.',
 'import numpy as np

# The problem NumPy solves:
# Without NumPy — you need a loop
python_list = [1, 2, 3, 4, 5]
result = [x * 2 for x in python_list]
print(result)  # [2, 4, 6, 8, 10]  <- slow loop

# With NumPy — instant, no loop needed
arr = np.array([1, 2, 3, 4, 5])
result = arr * 2          # operates on entire array at once!
print(result)             # [2 4 6 8 10]  <- blazing fast

# Real-world example: image pixels
# An image is just an array of RGB values
image = np.array([[255, 128, 0],
                  [100, 200, 50]])
brighter = image * 1.2    # Brighten every pixel instantly
print(brighter)
# [[306. 153.6   0.]
#  [120. 240.  60.]]',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000002',
 'e1000000-0000-0000-0000-000000000001',
 'NumPy''s Role in the Python Ecosystem',
 '## NumPy is the Foundation

Almost every major Python data science library is built ON TOP of NumPy. Understanding NumPy means you understand the core of data science in Python.

**Libraries built on NumPy:**
| Library | What it does | Uses NumPy for |
|---------|-------------|----------------|
| **pandas** | Data analysis, DataFrames | Arrays under the hood |
| **scikit-learn** | Machine learning | Model inputs/outputs |
| **TensorFlow** | Deep learning | Tensor operations |
| **PyTorch** | Deep learning | Tensor operations |
| **Matplotlib** | Data visualization | Plotting arrays |
| **SciPy** | Scientific computing | Advanced math |
| **OpenCV** | Computer vision | Image arrays |

**When should YOU use NumPy directly?**
- When doing raw mathematical computations
- When working with matrices and linear algebra
- When you need maximum speed on numerical data
- When building your own data pipeline
- When you need to pass arrays to ML libraries

**NumPy vs doing it yourself:**
A task like "multiply every element in a 1 million item list by 2" takes ~150ms with a Python loop. NumPy does it in ~2ms — **75x faster**.',
 'import numpy as np
import time

# Speed comparison: Python list vs NumPy
size = 1_000_000

# Python list approach
python_list = list(range(size))
start = time.time()
squared = [x ** 2 for x in python_list]
python_time = time.time() - start

# NumPy approach
numpy_arr = np.arange(size)
start = time.time()
squared = numpy_arr ** 2
numpy_time = time.time() - start

print(f"Python list: {python_time:.3f}s")   # ~0.15s
print(f"NumPy array: {numpy_time:.3f}s")    # ~0.002s
print(f"NumPy is {python_time/numpy_time:.0f}x faster!")

# NumPy is what pandas uses under the hood
import pandas as pd
df = pd.DataFrame({"scores": [85, 92, 78, 96]})
# df.values is actually a NumPy array!
print(type(df.values))   # <class "numpy.ndarray">',
 2);

-- ---- SUBTOPIC 2: Installing & Importing NumPy ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000003',
 'e1000000-0000-0000-0000-000000000002',
 'Installing NumPy',
 '## How to Install NumPy

NumPy is installed using pip (Python''s package manager) or conda (Anaconda''s package manager).

**Using pip (standard Python):**
```
pip install numpy
```

**Using conda (Anaconda/Miniconda):**
```
conda install numpy
```

**Upgrade existing installation:**
```
pip install --upgrade numpy
```

**Check version after installing:**
```
python -c "import numpy; print(numpy.__version__)"
```

**Already pre-installed in:**
- Google Colab ✅
- Jupyter Notebook (Anaconda) ✅
- Most data science environments ✅

**Typical version you will see:** 1.24.x, 1.25.x, or 1.26.x

**Why does version matter?**
Some NumPy functions were added in newer versions. NumPy 2.0 introduced breaking changes, so older code may behave differently.',
 'import numpy as np

# Check your NumPy version
print(np.__version__)         # e.g., 1.26.4

# Check detailed build info
# np.show_config()            # Shows BLAS/LAPACK libraries

# Verify it works
test = np.array([1, 2, 3])
print(test)                   # [1 2 3]
print("NumPy is working!")

# Check available functions (optional)
# print(dir(np))              # Lists all NumPy functions',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000004',
 'e1000000-0000-0000-0000-000000000002',
 'Importing NumPy — The Right Way',
 '## Standard Import Convention

The universal way to import NumPy is with the alias `np`. This convention is followed everywhere — every tutorial, book, documentation, and professional codebase uses it.

**The three ways to import (and which to use):**

| Import Style | Example Usage | Verdict |
|-------------|---------------|---------|
| `import numpy as np` | `np.array([1,2,3])` | ✅ **Best — use always** |
| `import numpy` | `numpy.array([1,2,3])` | ❌ Too verbose |
| `from numpy import *` | `array([1,2,3])` | ❌ Pollutes namespace |
| `from numpy import array` | `array([1,2,3])` | ⚠️ Only for very specific use |

**Why `np` specifically?**
- You will write `np.something` hundreds of times — brevity matters
- Anyone reading your code instantly recognizes `np` as NumPy
- It is the official convention recommended by NumPy docs themselves
- All documentation and Stack Overflow answers use `np`

**Why avoid `from numpy import *`?**
It imports everything into your global namespace. If another library also has an `array` function, there is a conflict and bugs become very hard to track.',
 'import numpy as np    # ALWAYS do this — the standard

# Good usage with np alias
arr = np.array([10, 20, 30])
zeros = np.zeros(5)
ones = np.ones((3, 3))

print(arr)    # [10 20 30]
print(zeros)  # [0. 0. 0. 0. 0.]
print(ones)
# [[1. 1. 1.]
#  [1. 1. 1.]
#  [1. 1. 1.]]

# What NOT to do:
# import numpy             # too verbose: numpy.array(...)
# from numpy import *      # dangerous namespace pollution

# Acceptable for single imports in scripts:
from numpy import pi
print(pi)    # 3.141592653589793',
 2);

-- ---- SUBTOPIC 3: NumPy vs Python Lists ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000005',
 'e1000000-0000-0000-0000-000000000003',
 'Key Differences: Lists vs NumPy Arrays',
 '## Python Lists vs NumPy Arrays

They look similar, but they are fundamentally different data structures.

| Feature | Python List | NumPy Array |
|---------|------------|-------------|
| **Data types** | Can mix (int, str, bool) | Single type only (homogeneous) |
| **Memory** | Scattered (each element is a Python object) | Contiguous block (packed bytes) |
| **Speed** | Slow for math | Very fast (C-level) |
| **Operations** | Need explicit loops | Vectorized (no loops) |
| **Size** | Dynamic (can append/remove) | Fixed at creation |
| **Dimensions** | Nested lists for 2D | Native N-dimensional |
| **Memory usage** | High overhead per element | Compact |

**When to use a Python list:**
- Storing mixed types (`[1, "hello", True, 3.14]`)
- Frequently adding/removing elements
- General-purpose collections, not numerical

**When to use NumPy:**
- Any numerical computation
- Matrix operations
- Large datasets
- Passing data to ML/data libraries',
 'import numpy as np

# Python list — mixed types allowed
py_list = [1, "hello", 3.14, True]
print(py_list)              # [1, "hello", 3.14, True]  — works!

# NumPy array — forces single type
np_arr = np.array([1, 2, 3, 4])
print(np_arr)               # [1 2 3 4]
print(np_arr.dtype)         # int64

# What happens with mixed types in NumPy?
mixed = np.array([1, "hello", 3.14])
print(mixed)                # ["1" "hello" "3.14"] — all become strings!
print(mixed.dtype)          # <U32 (Unicode string)

# Memory comparison
import sys
py = [0] * 1000
np_a = np.zeros(1000)
print(f"List size: {sys.getsizeof(py)} bytes")       # ~8056 bytes
print(f"NumPy size: {np_a.nbytes} bytes")             # 8000 bytes (more compact)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000006',
 'e1000000-0000-0000-0000-000000000003',
 'Vectorized Operations — The Real Power',
 '## Why NumPy is Faster: Vectorization

**Vectorization** means applying an operation to an entire array at once, without writing a Python loop. NumPy sends the operation to compiled C/Fortran code which executes it at hardware speed.

**Alternative syntax comparison:**
For element-wise multiplication, you have two options:
- `arr * 2` → operator syntax ✅ **preferred** (Pythonic, readable)
- `np.multiply(arr, 2)` → explicit function ⚠️ (more verbose, same result)

**Which is better?**
Use `arr * 2` — it is shorter, more readable, and follows Python conventions. Use `np.multiply()` only when you need advanced options like specifying an output array for memory efficiency.

**The key insight:**
In Python, `arr * 2` would only work element-wise if you override `__mul__`. NumPy''s ndarray does exactly that — every operator (+, -, *, /, **) works element-wise on the whole array.',
 'import numpy as np

scores = np.array([75, 82, 91, 68, 95, 73, 88])

# Vectorized — no loops needed!
curved    = scores + 5          # Add 5 to every score
doubled   = scores * 2          # Double every score
normalized = scores / 100       # Divide every score by 100
passed    = scores >= 70        # Boolean mask (True/False per element)

print(curved)       # [80 87 96 73 100 78 93]
print(passed)       # [ True  True  True False  True  True  True]

# Filter using boolean mask
failed_scores = scores[scores < 70]
print(f"Students who failed: {failed_scores}")   # [68]

# Alternative syntax comparison
result1 = scores * 2              # PREFERRED — clean, Pythonic
result2 = np.multiply(scores, 2)  # Same result, more verbose
print(result1)  # [150 164 182 136 190 146 176]
print(result2)  # [150 164 182 136 190 146 176]

# With Python lists — you would need a loop:
py_scores = [75, 82, 91, 68, 95]
curved_list = [s + 5 for s in py_scores]   # loop required, slow',
 2);

-- ---- SUBTOPIC 4: Creating Arrays ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000007',
 'e2000000-0000-0000-0000-000000000001',
 'Creating Arrays from Existing Data',
 '## np.array() — The Basic Building Block

The most fundamental way to create a NumPy array is by converting an existing Python list or tuple using `np.array()`.

**What it does:** Takes any sequence (list, tuple, nested list) and converts it into a NumPy ndarray.

**Key parameter — dtype:**
By default NumPy infers the data type. You can force a specific type:
- `np.array([1, 2, 3], dtype=float)` → converts to float
- `np.array([1.5, 2.7], dtype=int)` → truncates to int

**1D, 2D, 3D arrays:**
- 1D: a flat list `[1, 2, 3]` → like a row of data
- 2D: nested lists `[[1,2],[3,4]]` → like a table/matrix
- 3D: double-nested → like a stack of matrices (used in images: height×width×channels)',
 'import numpy as np

# 1D array (from list)
arr1d = np.array([10, 20, 30, 40, 50])
print(arr1d)           # [10 20 30 40 50]
print(arr1d.ndim)      # 1

# 1D array (from tuple)
arr_tuple = np.array((1, 2, 3))
print(arr_tuple)       # [1 2 3]

# 2D array (matrix) — from nested list
arr2d = np.array([[1, 2, 3],
                  [4, 5, 6],
                  [7, 8, 9]])
print(arr2d)
# [[1 2 3]
#  [4 5 6]
#  [7 8 9]]
print(arr2d.shape)     # (3, 3) — 3 rows, 3 columns

# 3D array (e.g., a small image: 2 frames, 3 rows, 3 cols)
arr3d = np.array([[[1,2,3],[4,5,6],[7,8,9]],
                  [[9,8,7],[6,5,4],[3,2,1]]])
print(arr3d.shape)     # (2, 3, 3)

# Force specific data type
float_arr = np.array([1, 2, 3], dtype=float)
print(float_arr)       # [1. 2. 3.]
print(float_arr.dtype) # float64',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000008',
 'e2000000-0000-0000-0000-000000000001',
 'Built-in Array Creation Functions',
 '## Creating Arrays Without Existing Data

NumPy has many functions to create arrays directly — no need to write out each value.

| Function | What it creates | Example |
|----------|----------------|---------|
| `np.zeros(n)` | Array of zeros | `[0. 0. 0.]` |
| `np.ones(n)` | Array of ones | `[1. 1. 1.]` |
| `np.full(n, val)` | Array filled with val | `[7 7 7]` |
| `np.arange(start, stop, step)` | Range of values | `[0 2 4 6 8]` |
| `np.linspace(start, stop, n)` | n evenly spaced values | `[0. 0.5 1.]` |
| `np.eye(n)` | Identity matrix | diagonal 1s |
| `np.empty(n)` | Uninitialized array | random garbage |

**`np.arange` vs `np.linspace` — which to use?**
- Use `np.arange` when you know the **step size** (like Python range)
- Use `np.linspace` when you know the **number of points** you want
- `np.linspace` is preferred in scientific work (guarantees exact endpoint)',
 'import numpy as np

# Zeros and ones — useful for initializing
zeros = np.zeros(5)
print(zeros)              # [0. 0. 0. 0. 0.]

ones_2d = np.ones((3, 4))
print(ones_2d.shape)      # (3, 4)

# Full — fill with a specific value
full = np.full((2, 3), 42)
print(full)
# [[42 42 42]
#  [42 42 42]]

# arange — like Python range but returns array
arr = np.arange(0, 10, 2)  # start=0, stop=10, step=2
print(arr)                  # [0 2 4 6 8]

# linspace — n evenly spaced points between start and stop
line = np.linspace(0, 1, 5)  # 5 points from 0 to 1 inclusive
print(line)                   # [0.   0.25 0.5  0.75 1.  ]

# arange vs linspace comparison:
# np.arange(0, 1, 0.25)  — you specify the step
# np.linspace(0, 1, 5)   — you specify how many points (PREFERRED for scientific use)

# Identity matrix (1s on diagonal, 0s elsewhere)
identity = np.eye(3)
print(identity)
# [[1. 0. 0.]
#  [0. 1. 0.]
#  [0. 0. 1.]]

# Empty — fast but uninitialized (contains garbage values, use for speed)
empty = np.empty(3)   # Do NOT rely on these values!',
 2);

-- ---- SUBTOPIC 5: Array Properties ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000009',
 'e2000000-0000-0000-0000-000000000002',
 'Understanding ndarray Properties',
 '## What Information Can You Get From an Array?

Every NumPy array (called an **ndarray**) carries metadata about itself. You access these as attributes (no parentheses needed).

| Attribute | What it tells you | Example |
|-----------|------------------|---------|
| `.shape` | Tuple of dimensions | `(3, 4)` = 3 rows, 4 cols |
| `.ndim` | Number of dimensions | `2` for a matrix |
| `.size` | Total number of elements | `12` for a 3×4 array |
| `.dtype` | Data type of elements | `int64`, `float32` |
| `.itemsize` | Bytes per element | `8` for float64 |
| `.nbytes` | Total bytes used | `shape.size * itemsize` |

**Why do these matter?**
- `.shape` tells you if your matrix is the right size for operations
- `.dtype` tells you if you have precision issues (float32 vs float64)
- `.nbytes` tells you memory usage — important for large datasets
- `.ndim` tells you if your data is 1D, 2D, or 3D',
 'import numpy as np

arr = np.array([[1, 2, 3, 4],
                [5, 6, 7, 8],
                [9, 10, 11, 12]])

print(arr.shape)     # (3, 4)  — 3 rows, 4 columns
print(arr.ndim)      # 2       — 2D array (matrix)
print(arr.size)      # 12      — total elements (3*4)
print(arr.dtype)     # int64   — data type
print(arr.itemsize)  # 8       — bytes per element (64-bit = 8 bytes)
print(arr.nbytes)    # 96      — total bytes (12 elements * 8 bytes)

# 1D array
v = np.array([1, 2, 3, 4, 5])
print(v.shape)       # (5,)  — note the comma! tuple with one element
print(v.ndim)        # 1

# 3D array (e.g., a color image: height x width x channels)
img = np.zeros((480, 640, 3))  # 480 rows, 640 cols, 3 color channels
print(img.shape)     # (480, 640, 3)
print(img.ndim)      # 3
print(img.nbytes)    # 921600 bytes = ~0.9 MB',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000010',
 'e2000000-0000-0000-0000-000000000002',
 'Understanding Shape and Axes',
 '## Shape, Axes, and Dimensions Explained

The **shape** of an array tells you how many elements are in each dimension. Understanding axes is crucial for operations like sum, mean, etc.

**Reading shape tuples:**
- `(5,)` → 1D array with 5 elements (a vector)
- `(3, 4)` → 2D array: 3 rows, 4 columns (a matrix)
- `(2, 3, 4)` → 3D array: 2 "layers", each 3 rows × 4 cols

**What are axes?**
- `axis=0` → operates **down rows** (column-wise)
- `axis=1` → operates **across columns** (row-wise)

This is one of the most confusing parts for beginners! Think of it as:
- `axis=0` collapses the rows → gives one result per column
- `axis=1` collapses the columns → gives one result per row

**Changing shape (not the data):**
`arr.reshape(rows, cols)` changes how you VIEW the data, without copying it.',
 'import numpy as np

arr = np.array([[10, 20, 30],
                [40, 50, 60]])
print(arr.shape)         # (2, 3)  — 2 rows, 3 columns

# axis=0 → collapse rows (result has 1 value per COLUMN)
print(np.sum(arr, axis=0))   # [50 70 90]   (10+40, 20+50, 30+60)

# axis=1 → collapse columns (result has 1 value per ROW)
print(np.sum(arr, axis=1))   # [60 150]     (10+20+30, 40+50+60)

# No axis — sum everything
print(np.sum(arr))            # 210

# Shape inspection pattern — always check before operations
matrix_a = np.ones((3, 4))
matrix_b = np.ones((4, 5))
# matrix_a @ matrix_b is valid: (3,4) @ (4,5) → (3,5)
result = matrix_a @ matrix_b
print(result.shape)           # (3, 5)

# Reshape example
flat = np.arange(12)           # [0,1,2,...,11]
matrix = flat.reshape(3, 4)   # reshape to 3 rows, 4 cols
print(matrix)
# [[ 0  1  2  3]
#  [ 4  5  6  7]
#  [ 8  9 10 11]]',
 2);

-- ---- SUBTOPIC 6: Array Data Types ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000011',
 'e2000000-0000-0000-0000-000000000003',
 'NumPy Data Types (dtype)',
 '## What is dtype?

Every NumPy array has a **dtype** (data type) that determines what kind of data it stores and how much memory each element uses. Unlike Python, NumPy gives you fine-grained control over precision.

**Common dtypes:**
| dtype | Description | Size | Range |
|-------|-------------|------|-------|
| `int32` | 32-bit integer | 4 bytes | ±2 billion |
| `int64` | 64-bit integer | 8 bytes | ±9 quintillion |
| `float32` | 32-bit float | 4 bytes | ~7 decimal digits |
| `float64` | 64-bit float | 8 bytes | ~15 decimal digits |
| `bool` | True/False | 1 byte | True or False |
| `complex128` | Complex number | 16 bytes | real + imaginary |
| `str` | Unicode string | varies | text |

**Default behavior:**
- Integer lists → `int64` by default
- Float lists → `float64` by default

**Why does dtype matter?**
- `float32` uses half the memory of `float64` — important for large ML models
- Using wrong dtype can cause overflow or precision errors
- Some GPU operations only work with `float32`',
 'import numpy as np

# Default types
int_arr = np.array([1, 2, 3])
float_arr = np.array([1.0, 2.5, 3.7])
bool_arr = np.array([True, False, True])

print(int_arr.dtype)    # int64
print(float_arr.dtype)  # float64
print(bool_arr.dtype)   # bool

# Specify dtype explicitly
arr32 = np.array([1.5, 2.7, 3.9], dtype=np.float32)
print(arr32.dtype)      # float32
print(arr32.nbytes)     # 12 bytes (3 elements × 4 bytes each)

arr64 = np.array([1.5, 2.7, 3.9], dtype=np.float64)
print(arr64.nbytes)     # 24 bytes (3 elements × 8 bytes each)

# float32 vs float64 — memory trade-off
big_float32 = np.zeros(1_000_000, dtype=np.float32)
big_float64 = np.zeros(1_000_000, dtype=np.float64)
print(f"float32: {big_float32.nbytes / 1e6:.0f} MB")  # 4 MB
print(f"float64: {big_float64.nbytes / 1e6:.0f} MB")  # 8 MB',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000012',
 'e2000000-0000-0000-0000-000000000003',
 'Type Conversion with astype()',
 '## Changing Data Types

After creating an array, you can convert its dtype using `.astype()`. This always creates a **new** array (the original is unchanged).

**Alternative syntax:**
- `arr.astype(np.float32)` → method style ✅ **preferred**
- `np.array(arr, dtype=np.float32)` → creates new from existing ✅ also fine

**Which is better?**
Use `.astype()` for converting existing arrays — it is cleaner and more explicit. Use `dtype=` in `np.array()` when creating from scratch.

**Precision loss warning:**
Converting from float to int **truncates** (does not round). `3.9` becomes `3`, not `4`.

**When do you need type conversion?**
- ML models often need `float32` (saves GPU memory)
- Image pixel values need `uint8` (0-255 range)
- After loading CSV data, strings may need converting to int/float',
 'import numpy as np

# Basic type conversion with astype()
arr = np.array([1.7, 2.5, 3.9, 4.1])
print(arr.dtype)          # float64

# Convert to int — TRUNCATES (does not round!)
int_arr = arr.astype(int)
print(int_arr)            # [1 2 3 4]  <-- 1.7→1, 3.9→3 (truncated!)

# Convert to float32 (useful for ML)
f32 = arr.astype(np.float32)
print(f32.dtype)          # float32
print(f32)                # [1.7 2.5 3.9 4.1]

# Convert int array to float
counts = np.array([10, 20, 30])
ratios = counts.astype(float) / 100
print(ratios)             # [0.1 0.2 0.3]

# Image pixel example — pixels are uint8 (0-255)
image = np.array([255, 128, 64, 0], dtype=np.uint8)
print(image.dtype)        # uint8

# Normalize to 0.0-1.0 range for ML
normalized = image.astype(np.float32) / 255.0
print(normalized)         # [1.   0.502 0.251 0.   ]

# astype() vs changing at creation — preferred styles:
arr1 = np.array([1,2,3]).astype(float)   # convert existing  ✅
arr2 = np.array([1,2,3], dtype=float)    # create as float   ✅',
 2);

-- ---- SUBTOPIC 7: Indexing & Slicing ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000013',
 'e3000000-0000-0000-0000-000000000001',
 'Basic Indexing in NumPy',
 '## Accessing Elements by Position

NumPy indexing works similarly to Python lists, but extends to multiple dimensions naturally.

**1D indexing:**
- `arr[0]` → first element
- `arr[-1]` → last element
- `arr[-2]` → second to last

**2D indexing:**
- `arr[row, col]` → preferred ✅ (NumPy style)
- `arr[row][col]` → also works ⚠️ (slower, creates intermediate array)

**Which is better for 2D?**
Always use `arr[row, col]` — it is faster (one lookup) and is the NumPy convention. Using `arr[row][col]` creates an intermediate 1D array and then indexes it — wasteful.

**Negative indexing:**
Works the same as Python lists — counts from the end.',
 'import numpy as np

# 1D indexing
arr = np.array([10, 20, 30, 40, 50])
print(arr[0])    # 10   — first
print(arr[-1])   # 50   — last
print(arr[-2])   # 40   — second to last

# 2D indexing
matrix = np.array([[1, 2, 3],
                   [4, 5, 6],
                   [7, 8, 9]])

# PREFERRED: single bracket with comma
print(matrix[0, 0])   # 1   — row 0, col 0
print(matrix[1, 2])   # 6   — row 1, col 2
print(matrix[-1, -1]) # 9   — last row, last col

# Also works but slower:
print(matrix[0][0])   # 1   — creates intermediate array, avoid

# Get entire row
print(matrix[0])      # [1 2 3]  — first row

# Get entire column
print(matrix[:, 1])   # [2 5 8]  — second column (all rows, col 1)

# Modify via index
matrix[0, 0] = 99
print(matrix[0])      # [99  2  3]',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000014',
 'e3000000-0000-0000-0000-000000000001',
 'Slicing and Boolean Indexing',
 '## Extracting Subsets of Arrays

**Slicing** extracts a range of elements using `start:stop:step` syntax — same as Python lists, but works on multiple dimensions simultaneously.

**Boolean indexing (fancy indexing):**
Pass a boolean array or condition as the index. NumPy returns only elements where the condition is True. This is incredibly powerful for data filtering.

**Key difference from Python list slicing:**
NumPy slices are **views** (not copies) — modifying the slice modifies the original! To get an independent copy, use `.copy()`.

**Alternative syntax for boolean indexing:**
- `arr[arr > 5]` → inline condition ✅ **preferred** (concise)
- `mask = arr > 5; arr[mask]` → named mask ✅ also good (more readable for complex conditions)',
 'import numpy as np

arr = np.array([10, 20, 30, 40, 50, 60, 70])

# Basic slicing [start:stop:step] — stop is exclusive
print(arr[1:4])    # [20 30 40]   — index 1,2,3
print(arr[::2])    # [10 30 50 70] — every 2nd element
print(arr[::-1])   # [70 60 50 40 30 20 10] — reversed

# 2D slicing
matrix = np.array([[1, 2, 3, 4],
                   [5, 6, 7, 8],
                   [9,10,11,12]])

print(matrix[0:2, 1:3])
# [[2 3]
#  [6 7]]  — rows 0-1, columns 1-2

# IMPORTANT: slices are VIEWS (not copies)
sub = arr[1:4]
sub[0] = 999
print(arr)    # [10 999 30 40 50 60 70] — original changed!

# To avoid this, use .copy()
sub2 = arr[1:4].copy()
sub2[0] = 0
print(arr)    # unchanged

# Boolean indexing — filter by condition
scores = np.array([45, 82, 91, 55, 73, 88, 60])

# Preferred: inline condition
passed = scores[scores >= 70]
print(passed)     # [82 91 73 88]

# Named mask (better for complex conditions)
mask = (scores >= 60) & (scores < 80)
print(scores[mask])  # [73 60]',
 2);

-- ---- SUBTOPIC 8: Reshaping & Flattening ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000015',
 'e3000000-0000-0000-0000-000000000002',
 'Reshaping Arrays',
 '## Changing the Shape Without Changing the Data

`reshape()` changes how you VIEW an array without changing its data. The total number of elements must remain the same.

**Two equivalent syntaxes:**
- `arr.reshape(3, 4)` → method on array ✅ **preferred**
- `np.reshape(arr, (3, 4))` → standalone function ✅ also fine

**Which is better?**
`arr.reshape(3, 4)` — it is more Pythonic (object-oriented style) and reads naturally as "reshape this array to 3×4". Both produce identical results.

**The -1 trick:**
You can use `-1` for one dimension to let NumPy calculate it automatically:
- `arr.reshape(3, -1)` → 3 rows, NumPy figures out columns
- `arr.reshape(-1)` → flatten to 1D (equivalent to ravel)

**Important:** By default, `reshape` returns a **view** if possible, not a copy.',
 'import numpy as np

flat = np.arange(12)       # [0 1 2 3 4 5 6 7 8 9 10 11]
print(flat.shape)          # (12,)

# Reshape to 2D matrix — PREFERRED style
matrix = flat.reshape(3, 4)
print(matrix)
# [[ 0  1  2  3]
#  [ 4  5  6  7]
#  [ 8  9 10 11]]

# Reshape to 3D
tensor = flat.reshape(2, 2, 3)
print(tensor.shape)        # (2, 2, 3)

# The -1 trick: let NumPy figure out one dimension
matrix2 = flat.reshape(4, -1)   # 4 rows, NumPy calculates cols = 3
print(matrix2.shape)             # (4, 3)

matrix3 = flat.reshape(-1, 6)   # NumPy calculates rows = 2, 6 cols
print(matrix3.shape)             # (2, 6)

# Alternative syntax (less common)
matrix4 = np.reshape(flat, (3, 4))   # same result
print(matrix4.shape)                  # (3, 4)

# Reshape fails if sizes don''t match
try:
    flat.reshape(3, 5)  # 3*5=15, but we have 12 elements
except ValueError as e:
    print(e)  # cannot reshape array of size 12 into shape (3,5)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000016',
 'e3000000-0000-0000-0000-000000000002',
 'Flattening Arrays',
 '## Converting Multi-Dimensional Arrays to 1D

Sometimes you need to convert a 2D or 3D array into a flat 1D array. NumPy provides two main ways: `flatten()` and `ravel()`.

**flatten() vs ravel() — which is better?**

| | `flatten()` | `ravel()` |
|--|-------------|-----------|
| Returns | Always a copy | View if possible (copy if needed) |
| Memory | Uses more memory | More memory efficient |
| Speed | Slightly slower | Faster |
| Safe to modify | Yes (copy) | Only if it''s a copy |

**Which to use?**
- Use `ravel()` when you just need to read the data ✅ (faster, less memory)
- Use `flatten()` when you plan to modify the result and don''t want to affect the original ✅ (safer)

**Both produce identical values** — the difference is only about whether you get a view or a copy.',
 'import numpy as np

matrix = np.array([[1, 2, 3],
                   [4, 5, 6],
                   [7, 8, 9]])

# flatten() — always returns a COPY
flat1 = matrix.flatten()
print(flat1)      # [1 2 3 4 5 6 7 8 9]

flat1[0] = 999    # modify the copy
print(matrix[0])  # [1 2 3] — original UNCHANGED (flatten = copy)

# ravel() — returns a VIEW when possible (faster)
flat2 = matrix.ravel()
print(flat2)      # [1 2 3 4 5 6 7 8 9]

flat2[0] = 999    # modify the view
print(matrix[0])  # [999 2 3] — original CHANGED (ravel = view)

# Reset
matrix[0, 0] = 1

# Summary:
# Reading data only?  → use ravel() (faster)
# Modifying result?   → use flatten() (safer, independent copy)

# Real-world use: preparing data for ML model
image = np.random.randint(0, 256, (28, 28))  # 28x28 image
flat_image = image.ravel()    # flatten for input to neural network
print(flat_image.shape)       # (784,)  = 28*28',
 2);

-- ---- SUBTOPIC 9: Stacking & Splitting ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000017',
 'e3000000-0000-0000-0000-000000000003',
 'Stacking Arrays Together',
 '## Combining Multiple Arrays

Stacking joins arrays along an axis. Think of it like stacking sheets of paper (vertically or horizontally).

**Main functions:**
| Function | What it does | Use when |
|----------|-------------|----------|
| `np.vstack()` | Stack vertically (row-wise) | Same number of columns |
| `np.hstack()` | Stack horizontally (column-wise) | Same number of rows |
| `np.concatenate()` | General purpose | Specify axis explicitly |
| `np.stack()` | Creates NEW axis | Creating batches |

**vstack vs hstack — which to use?**
- For combining rows: `np.vstack()` ✅ more readable
- For combining columns: `np.hstack()` ✅ more readable
- For general/complex stacking: `np.concatenate(axis=)` ✅ most flexible

`np.concatenate` is the most general and is what vstack/hstack use internally. Prefer named functions (vstack/hstack) when the intent is clear.',
 'import numpy as np

a = np.array([1, 2, 3])
b = np.array([4, 5, 6])

# hstack — join horizontally (side by side)
h = np.hstack([a, b])
print(h)    # [1 2 3 4 5 6]

# For 2D arrays
m1 = np.array([[1, 2], [3, 4]])
m2 = np.array([[5, 6], [7, 8]])

# vstack — stack vertically (top and bottom)
v = np.vstack([m1, m2])
print(v)
# [[1 2]
#  [3 4]
#  [5 6]
#  [7 8]]

# hstack 2D — join columns
h2 = np.hstack([m1, m2])
print(h2)
# [[1 2 5 6]
#  [3 4 7 8]]

# concatenate — explicit axis control
c0 = np.concatenate([m1, m2], axis=0)  # same as vstack
c1 = np.concatenate([m1, m2], axis=1)  # same as hstack
print(c0.shape)   # (4, 2)
print(c1.shape)   # (2, 4)

# stack — creates a NEW dimension (useful for batches)
batch = np.stack([m1, m2])   # stack along new axis 0
print(batch.shape)  # (2, 2, 2) — 2 matrices of shape (2,2)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000018',
 'e3000000-0000-0000-0000-000000000003',
 'Splitting Arrays',
 '## Dividing One Array into Multiple Parts

The inverse of stacking — splitting breaks one array into multiple smaller arrays.

**Main functions:**
| Function | What it does |
|----------|-------------|
| `np.split(arr, n)` | Split into n equal parts |
| `np.vsplit(arr, n)` | Split vertically (row-wise) |
| `np.hsplit(arr, n)` | Split horizontally (column-wise) |
| `np.array_split(arr, n)` | Like split, but allows unequal sizes |

**split vs array_split:**
- `np.split()` → requires the array to divide evenly, raises error if not ✅ use when you know sizes match
- `np.array_split()` → allows unequal chunks ✅ use for flexibility

**Where is splitting used?**
- Splitting data into train/validation/test sets in ML
- Processing large arrays in chunks
- Dividing image tiles for parallel processing',
 'import numpy as np

arr = np.array([10, 20, 30, 40, 50, 60])

# Split into 3 equal parts
parts = np.split(arr, 3)
print(parts[0])   # [10 20]
print(parts[1])   # [30 40]
print(parts[2])   # [50 60]

# Split at specific indices
parts2 = np.split(arr, [2, 4])  # split at index 2 and 4
print(parts2[0])   # [10 20]     — elements 0,1
print(parts2[1])   # [30 40]     — elements 2,3
print(parts2[2])   # [50 60]     — elements 4,5

# array_split — allows unequal chunks
arr2 = np.arange(10)  # 10 elements
chunks = np.array_split(arr2, 3)  # 10/3 doesn''t divide evenly
print(chunks[0])   # [0 1 2 3]   — 4 elements
print(chunks[1])   # [4 5 6]     — 3 elements
print(chunks[2])   # [7 8 9]     — 3 elements

# 2D splitting
matrix = np.arange(1, 13).reshape(4, 3)  # 4 rows, 3 cols
top, bottom = np.vsplit(matrix, 2)        # split rows in half
print(top.shape)      # (2, 3)
print(bottom.shape)   # (2, 3)

left, right = np.hsplit(matrix, 3)        # split into 3 column groups
print(left.shape)     # (4, 1)',
 2);

-- ---- SUBTOPIC 10: Arithmetic Operations ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000019',
 'e4000000-0000-0000-0000-000000000001',
 'Element-wise Arithmetic',
 '## Math on Arrays Without Loops

NumPy applies arithmetic operators element-wise across the entire array. No loops, no list comprehensions — just clean math syntax.

**All standard operators work element-wise:**
- `+`, `-`, `*`, `/` → add, subtract, multiply, divide
- `//` → floor division
- `%` → modulo (remainder)
- `**` → power/exponent
- `==`, `<`, `>`, etc. → comparison (returns boolean array)

**With scalar (single value):** applies to every element
**With another array:** applies element-by-element (must be same shape or broadcast-compatible)

**Operator vs np.function:**
Both `arr + arr2` and `np.add(arr, arr2)` give the same result.
Use operators (`+`, `*`, etc.) — they are cleaner and more readable.
Use `np.add(out=result)` only if you need to write the result into a pre-allocated output array (memory optimization).',
 'import numpy as np

a = np.array([10, 20, 30, 40, 50])
b = np.array([1, 2, 3, 4, 5])

# Element-wise operations
print(a + b)    # [11 22 33 44 55]
print(a - b)    # [ 9 18 27 36 45]
print(a * b)    # [ 10  40  90 160 250]
print(a / b)    # [10. 10. 10. 10. 10.]
print(a ** 2)   # [ 100  400  900 1600 2500]
print(a % 3)    # [1 2 0 1 2]  (remainder when divided by 3)

# Scalar operations — applies to every element
print(a + 100)   # [110 120 130 140 150]
print(a * 0.5)   # [ 5. 10. 15. 20. 25.]
print(a > 25)    # [False False  True  True  True]

# Operator vs function — identical results
result1 = a * b              # PREFERRED — clean syntax
result2 = np.multiply(a, b)  # same result, more verbose
print(result1)   # [ 10  40  90 160 250]
print(result2)   # [ 10  40  90 160 250]

# Real-world: normalize test scores to 0-1
scores = np.array([75, 82, 91, 68, 95])
normalized = (scores - scores.min()) / (scores.max() - scores.min())
print(normalized.round(2))  # [0.26 0.52 0.85 0.   1.  ]',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000020',
 'e4000000-0000-0000-0000-000000000001',
 'Comparison and Logical Operations',
 '## Boolean Operations on Arrays

Comparison operators on NumPy arrays produce **boolean arrays** — arrays of True/False values. These are the foundation of filtering and masking.

**Combining conditions:**
- `&` → element-wise AND (use instead of `and`)
- `|` → element-wise OR (use instead of `or`)
- `~` → element-wise NOT (use instead of `not`)

**Why not use Python''s `and`/`or`?**
Python''s `and`/`or` work on single values. With arrays, you MUST use `&`, `|`, `~`. Using `and` with arrays raises a ValueError.

**np.where() — vectorized if-else:**
`np.where(condition, value_if_true, value_if_false)` applies a conditional across an entire array without any loop.',
 'import numpy as np

scores = np.array([45, 82, 91, 55, 73, 88, 60, 95])

# Comparison → boolean array
print(scores >= 70)
# [False  True  True False  True  True False  True]

# Filter using boolean mask
print(scores[scores >= 70])  # [82 91 73 88 95]

# Combining conditions — use & and | NOT and/or
passed_well = scores[(scores >= 70) & (scores < 90)]
print(passed_well)           # [82 73 88]

# NOT operator
failed = scores[~(scores >= 70)]
print(failed)                # [45 55 60]

# np.where — vectorized if-else (no loop!)
# np.where(condition, value_if_true, value_if_false)
grades = np.where(scores >= 70, "Pass", "Fail")
print(grades)
# ["Fail" "Pass" "Pass" "Fail" "Pass" "Pass" "Fail" "Pass"]

# Multi-level grades with chained np.where
letter = np.where(scores >= 90, "A",
         np.where(scores >= 80, "B",
         np.where(scores >= 70, "C", "F")))
print(letter)  # ["F" "B" "A" "F" "C" "B" "F" "A"]',
 2);

-- ---- SUBTOPIC 11: Statistical Functions ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000021',
 'e4000000-0000-0000-0000-000000000002',
 'Basic Statistics with NumPy',
 '## Descriptive Statistics at Your Fingertips

NumPy provides all fundamental statistical functions optimized for arrays. No loops, no manual calculation.

**Core statistical functions:**
| Function | What it computes |
|----------|-----------------|
| `np.mean(arr)` | Arithmetic average |
| `np.median(arr)` | Middle value |
| `np.std(arr)` | Standard deviation |
| `np.var(arr)` | Variance |
| `np.sum(arr)` | Sum of all elements |
| `np.min(arr)` | Minimum value |
| `np.max(arr)` | Maximum value |
| `np.percentile(arr, q)` | q-th percentile |
| `np.cumsum(arr)` | Cumulative sum |

**Method vs function syntax:**
- `arr.mean()` → method on array ✅ **preferred** (more Pythonic)
- `np.mean(arr)` → standalone function ✅ also fine

Both give identical results. Use `arr.mean()` for brevity. Use `np.mean(arr)` when passing complex expressions.',
 'import numpy as np

data = np.array([72, 85, 91, 68, 74, 88, 95, 61, 79, 83])

# Method style (preferred) — concise
print(f"Mean:   {data.mean():.2f}")    # 79.60
print(f"Median: {np.median(data):.2f}") # 81.00
print(f"Std:    {data.std():.2f}")     # 10.44
print(f"Var:    {data.var():.2f}")     # 108.84
print(f"Min:    {data.min()}")          # 61
print(f"Max:    {data.max()}")          # 95
print(f"Sum:    {data.sum()}")          # 796

# Indices of min and max
print(f"Min at index: {data.argmin()}")  # 7 (value 61)
print(f"Max at index: {data.argmax()}")  # 6 (value 95)

# Percentiles
p25 = np.percentile(data, 25)   # 25th percentile
p75 = np.percentile(data, 75)   # 75th percentile
iqr = p75 - p25                  # interquartile range
print(f"25th percentile: {p25}")  # 72.75
print(f"75th percentile: {p75}")  # 88.25
print(f"IQR: {iqr}")             # 15.5

# Cumulative sum
daily_sales = np.array([100, 150, 200, 80, 120])
running_total = np.cumsum(daily_sales)
print(running_total)  # [100 250 450 530 650]',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000022',
 'e4000000-0000-0000-0000-000000000002',
 'Statistics Along Axes',
 '## Computing Stats Row-wise or Column-wise

For 2D arrays, you often want statistics per row or per column — not over the whole array. Use the `axis` parameter.

**axis parameter:**
- `axis=0` → collapse rows → one result per **column** (column stats)
- `axis=1` → collapse columns → one result per **row** (row stats)
- No axis → single result over the whole array

**Real-world analogy:**
Imagine a 2D array where rows = students, columns = exam scores.
- `axis=0` → average score for each exam (across all students)
- `axis=1` → average score for each student (across all exams)',
 'import numpy as np

# Rows = students, Columns = exam scores
scores = np.array([[85, 92, 78, 90],   # Student A
                   [70, 68, 75, 80],   # Student B
                   [95, 88, 91, 97]])  # Student C

# No axis — overall stats
print(f"Overall mean: {scores.mean():.2f}")  # 84.08

# axis=0 — stats per COLUMN (per exam)
print("Mean per exam:", scores.mean(axis=0))
# [83.33 82.67 81.33 89.  ]
# Exam 1 avg: 83.33, Exam 2 avg: 82.67, etc.

# axis=1 — stats per ROW (per student)
print("Mean per student:", scores.mean(axis=1))
# [86.25 73.25 92.75]
# Student A avg: 86.25, Student B: 73.25, Student C: 92.75

# Min/max per student
print("Best score per student:", scores.max(axis=1))
# [92 80 97]

print("Worst score per student:", scores.min(axis=1))
# [78 68 88]

# keepdims=True — preserves 2D shape of result (useful for broadcasting)
mean_per_student = scores.mean(axis=1, keepdims=True)
print(mean_per_student.shape)  # (3, 1) — not (3,)
# Useful for: scores - mean_per_student  (broadcasts correctly)',
 2);

-- ---- SUBTOPIC 12: Math Functions ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000023',
 'e4000000-0000-0000-0000-000000000003',
 'Universal Functions (ufuncs)',
 '## Fast Element-wise Math Functions

NumPy''s **universal functions (ufuncs)** are vectorized mathematical functions that operate element-wise on arrays at C speed. They are the NumPy replacements for Python''s `math` module functions.

**Why use np.sqrt instead of math.sqrt?**
- `math.sqrt(x)` → only works on a single number
- `np.sqrt(arr)` → works on an entire array in one call (vectorized)

**Common ufuncs:**
| Function | What it does |
|----------|-------------|
| `np.sqrt(arr)` | Square root |
| `np.exp(arr)` | e^x (exponential) |
| `np.log(arr)` | Natural log (ln) |
| `np.log2(arr)` | Log base 2 |
| `np.log10(arr)` | Log base 10 |
| `np.abs(arr)` | Absolute value |
| `np.sign(arr)` | Sign (-1, 0, or 1) |
| `np.power(arr, n)` | Raise to power n |

**arr.method() vs np.function(arr):**
For ufuncs, use `np.sqrt(arr)` style — most of these don''t have method equivalents.',
 'import numpy as np

arr = np.array([1, 4, 9, 16, 25, 36])

# Square root
print(np.sqrt(arr))   # [1. 2. 3. 4. 5. 6.]

# vs Python math module — only works on single values
import math
# math.sqrt(arr)  # ERROR — math module can''t handle arrays

# Exponential and logarithm
x = np.array([0, 1, 2, 3])
print(np.exp(x))    # [1.    2.718 7.389 20.086]  (e^x)
print(np.log(np.exp(x)))  # [0. 1. 2. 3.]  (natural log undoes exp)

# Absolute value
neg = np.array([-3, -1, 0, 2, -5])
print(np.abs(neg))   # [3 1 0 2 5]

# Power
print(np.power(arr, 2))  # [ 1  16  81 256 625 1296]  (same as arr**2)

# Real-world: compute distance formula
x1, y1 = np.array([0, 3, 6]), np.array([0, 4, 8])
x2, y2 = np.array([3, 0, 0]), np.array([4, 0, 0])

distances = np.sqrt((x2-x1)**2 + (y2-y1)**2)
print(distances)     # [5. 5. 10.]',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000024',
 'e4000000-0000-0000-0000-000000000003',
 'Trigonometric and Rounding Functions',
 '## Trig, Rounding, and Clipping

**Trigonometric functions:**
NumPy includes all standard trig functions. They work in **radians** by default.

**Converting degrees ↔ radians:**
- `np.deg2rad(degrees)` → degrees to radians
- `np.rad2deg(radians)` → radians to degrees

**Rounding functions:**
| Function | What it does |
|----------|-------------|
| `np.round(arr, n)` | Round to n decimal places |
| `np.floor(arr)` | Round DOWN to nearest integer |
| `np.ceil(arr)` | Round UP to nearest integer |
| `np.trunc(arr)` | Truncate (remove decimal part) |
| `np.clip(arr, min, max)` | Clamp values to [min, max] range |

**round vs floor vs trunc:**
- `round(2.5)` → 2 (Python banker''s rounding)
- `floor(2.5)` → 2 (always rounds down)
- `trunc(2.5)` → 2 (removes decimal, positive)
- `floor(-2.5)` → -3 (rounds down toward -infinity)
- `trunc(-2.5)` → -2 (removes decimal, toward zero)',
 'import numpy as np

# Trigonometry — inputs in radians
angles_deg = np.array([0, 30, 45, 60, 90])
angles_rad = np.deg2rad(angles_deg)

print(np.sin(angles_rad).round(4))  # [0.     0.5    0.7071 0.866  1.    ]
print(np.cos(angles_rad).round(4))  # [1.     0.866  0.7071 0.5    0.    ]
print(np.tan(np.deg2rad(45)))       # 0.9999999999999999 (~1.0)

# pi constant
print(np.pi)        # 3.141592653589793
print(np.sin(np.pi))  # ~1.2e-16 (approximately 0, float precision)

# Rounding
arr = np.array([1.23, 2.567, -1.8, 3.5])

print(np.round(arr, 1))  # [ 1.2  2.6 -1.8  3.5]
print(np.floor(arr))     # [ 1.  2. -2.  3.]  — always rounds DOWN
print(np.ceil(arr))      # [ 2.  3. -1.  4.]  — always rounds UP
print(np.trunc(arr))     # [ 1.  2. -1.  3.]  — remove decimal

# clip — clamp values within a range (very useful in data preprocessing)
raw_data = np.array([-5, 0, 3, 8, 15, 200])
clipped = np.clip(raw_data, 0, 10)   # keep values between 0 and 10
print(clipped)   # [ 0  0  3  8 10 10]',
 2);

-- ---- SUBTOPIC 13: Broadcasting ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000025',
 'e5000000-0000-0000-0000-000000000001',
 'What is Broadcasting?',
 '## NumPy''s Most Powerful Feature

**Broadcasting** is NumPy''s ability to perform operations on arrays with different shapes — without actually copying data or using loops.

**Why it exists:**
Without broadcasting, you could only do math between arrays of exactly the same shape. Broadcasting allows operations like "add a constant to every row" without creating extra copies.

**The Broadcasting Rules:**
NumPy compares array shapes from right to left. Dimensions are compatible if:
1. They are equal, OR
2. One of them is 1

If shapes are compatible, the dimension-1 array is "stretched" to match.

**Common patterns:**
- `(3, 4) + (4,)` → works! The (4,) is treated as (1, 4) then stretched to (3, 4)
- `(3, 1) + (1, 4)` → works! Produces (3, 4)
- `(3, 4) + (3,)` → ERROR! Right-to-left: 4≠3 and neither is 1',
 'import numpy as np

# Simple broadcasting: scalar
arr = np.array([1, 2, 3, 4, 5])
print(arr + 10)    # [11 12 13 14 15]  — 10 is "broadcast" to match arr shape

# Broadcasting with 2D arrays
matrix = np.array([[1, 2, 3],
                   [4, 5, 6],
                   [7, 8, 9]])

row_addition = np.array([10, 20, 30])   # shape (3,)

# Add row_addition to EVERY row of matrix
result = matrix + row_addition
print(result)
# [[11 22 33]
#  [14 25 36]
#  [17 28 39]]
# row_addition (3,) → treated as (1,3) → stretched to (3,3)

# Column-wise addition — need (3,1) shape
col_addition = np.array([[100],    # shape (3, 1)
                         [200],
                         [300]])
result2 = matrix + col_addition
print(result2)
# [[101 102 103]
#  [204 205 206]
#  [307 308 309]]

# Broadcasting failure example
arr_wrong = np.array([10, 20])   # shape (2,) — incompatible with (3,3)
try:
    matrix + arr_wrong
except ValueError as e:
    print(f"Error: {e}")  # operands could not be broadcast together',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000026',
 'e5000000-0000-0000-0000-000000000001',
 'Practical Broadcasting Use Cases',
 '## Broadcasting in Real Data Science

Broadcasting enables elegant, efficient solutions to common data operations.

**Most common use cases:**
1. **Normalizing data** — subtract mean, divide by std (zero-centering)
2. **Distance matrix computation** — pairwise distances without loops
3. **Outer product** — all combinations of two vectors
4. **Subtracting row or column means** from a matrix

**keepdims=True** is your friend here — keeps the shape compatible for broadcasting.',
 'import numpy as np

# Use case 1: Normalize each column to zero mean, unit std
data = np.array([[1.0, 200.0, 0.5],
                 [2.0, 150.0, 1.5],
                 [3.0, 100.0, 2.5]])

col_mean = data.mean(axis=0)           # shape (3,)
col_std  = data.std(axis=0)            # shape (3,)

normalized = (data - col_mean) / col_std  # broadcasting! (3,3)-(3,) / (3,)
print(normalized.round(2))

# Use case 2: Subtract each row''s mean from that row
row_mean = data.mean(axis=1, keepdims=True)  # shape (3, 1) — keepdims important!
row_centered = data - row_mean               # (3,3) - (3,1) → broadcasts to (3,3)
print(row_centered.round(2))

# Use case 3: Distance between all pairs of points
points = np.array([[0, 0],
                   [3, 4],
                   [1, 1]])   # shape (3, 2)

# Pairwise differences using broadcasting
diff = points[:, np.newaxis, :] - points[np.newaxis, :, :]
# Shape: (3, 1, 2) - (1, 3, 2) → (3, 3, 2)
distances = np.sqrt((diff**2).sum(axis=2))
print(distances.round(2))
# [[0.   5.   1.41]
#  [5.   0.   3.61]
#  [1.41 3.61 0.  ]]',
 2);

-- ---- SUBTOPIC 14: Vectorization & Performance ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000027',
 'e5000000-0000-0000-0000-000000000002',
 'Why Vectorization is Fast',
 '## The Secret Behind NumPy''s Speed

**Vectorization** means replacing Python loops with NumPy array operations that run in compiled C/Fortran code.

**Why Python loops are slow:**
Each iteration of a Python loop:
1. Looks up the variable name in a dictionary
2. Unpacks a Python integer object from the list
3. Executes the operation in Python bytecode
4. Creates a new Python object for the result
5. Stores it back

With 1 million elements, this happens 1 million times.

**Why NumPy is fast:**
- Data stored as raw bytes (no Python object overhead)
- Operations execute in compiled C/Fortran code
- No interpreter overhead per element
- Can use SIMD (CPU-level parallelism — processes multiple values in one clock cycle)
- BLAS/LAPACK libraries for linear algebra (hand-optimized by Intel/AMD)

**The rule: eliminate loops.**
Whenever you write a `for` loop over array elements in Python, ask: "Can NumPy do this?"',
 'import numpy as np
import time

n = 10_000_000

# Method 1: Python loop (slow)
py_list = list(range(n))
start = time.time()
result = [x * x for x in py_list]
loop_time = time.time() - start

# Method 2: NumPy vectorization (fast)
np_arr = np.arange(n)
start = time.time()
result = np_arr * np_arr
numpy_time = time.time() - start

print(f"Python loop: {loop_time:.3f}s")
print(f"NumPy vectorized: {numpy_time:.4f}s")
print(f"NumPy is ~{loop_time/numpy_time:.0f}x faster")
# NumPy is typically 50-100x faster

# Why: NumPy data layout
py_num = 42       # Python object: 28 bytes (type pointer, ref count, value)
np_arr = np.array([42], dtype=np.int32)
print(np_arr.itemsize)  # 4 bytes — just the raw 32-bit integer, no overhead

# NumPy uses contiguous memory — CPU cache loves it
# Python list stores pointers scattered across memory — cache misses everywhere',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000028',
 'e5000000-0000-0000-0000-000000000002',
 'Writing Vectorized Code',
 '## Replacing Loops with NumPy Operations

The key skill: look at every loop over array data and replace it with a NumPy operation.

**Common loop → NumPy translations:**
| Loop code | NumPy equivalent |
|-----------|-----------------|
| `[x**2 for x in arr]` | `arr ** 2` |
| `[x for x in arr if x > 0]` | `arr[arr > 0]` |
| `sum(arr)` | `arr.sum()` |
| `max(arr)` | `arr.max()` |
| `[a*b for a,b in zip(arr1,arr2)]` | `arr1 * arr2` |
| `[f(x) for x in arr]` | `np.vectorize(f)(arr)` |

**When you CANNOT vectorize:**
- Complex conditionals with side effects
- Sequential operations where each depends on previous
- Non-numeric data manipulation
In these cases, loops are fine.',
 'import numpy as np

data = np.array([3.5, -1.2, 4.8, -2.1, 7.3, -0.5, 6.2])

# BAD: Python loops (slow)
def process_slow(arr):
    result = []
    for x in arr:
        if x > 0:
            result.append(x ** 2)
        else:
            result.append(0)
    return result

# GOOD: Vectorized (fast)
def process_fast(arr):
    return np.where(arr > 0, arr ** 2, 0)

slow = process_slow(data)
fast = process_fast(data)
print(fast)   # [12.25  0.   23.04  0.   53.29  0.   38.44]

# Vectorizing custom functions with np.vectorize
def my_func(x):
    """Complex function that can''t easily be vectorized"""
    return x ** 2 + 2 * x + 1

vectorized_func = np.vectorize(my_func)
arr = np.array([1, 2, 3, 4, 5])
print(vectorized_func(arr))  # [ 4  9 16 25 36]
# Note: np.vectorize is a convenience wrapper — not as fast as true vectorization
# True vectorization: (arr ** 2 + 2 * arr + 1)  — always prefer this

# Practical example: compute sigmoid function (used in ML)
def sigmoid(x):
    return 1 / (1 + np.exp(-x))  # fully vectorized!

logits = np.array([-2.0, -1.0, 0.0, 1.0, 2.0])
print(sigmoid(logits).round(4))  # [0.1192 0.2689 0.5    0.7311 0.8808]',
 2);

-- ---- SUBTOPIC 15: Linear Algebra ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000029',
 'e5000000-0000-0000-0000-000000000003',
 'Matrix Operations',
 '## Linear Algebra with NumPy

Linear algebra is the math behind machine learning, computer graphics, and data transformations. NumPy makes it intuitive.

**Key operations:**
| Operation | NumPy syntax |
|-----------|-------------|
| Transpose | `arr.T` or `arr.transpose()` |
| Dot product | `np.dot(a, b)` or `a @ b` |
| Matrix multiply | `a @ b` or `np.matmul(a, b)` |
| Element-wise multiply | `a * b` |

**dot vs @ — which to use?**
- `a @ b` → **preferred** (Python 3.5+ operator, PEP 465, cleaner)
- `np.dot(a, b)` → older style, also fine for 2D
- `np.matmul(a, b)` → explicit, handles batches correctly

Use `@` for matrix multiplication — it''s the modern standard and reads clearly.

**Element-wise `*` vs matrix `@`:**
- `a * b` → multiplies element by element (same shape required)
- `a @ b` → true matrix multiplication (inner dimensions must match)',
 'import numpy as np

A = np.array([[1, 2],
              [3, 4]])
B = np.array([[5, 6],
              [7, 8]])

# Transpose
print(A.T)
# [[1 3]
#  [2 4]]

# Element-wise multiply — NOT matrix multiplication
print(A * B)
# [[ 5 12]
#  [21 32]]

# Matrix multiplication — PREFERRED: @ operator
print(A @ B)
# [[19 22]
#  [43 50]]

# np.dot — same result for 2D (older style)
print(np.dot(A, B))   # same as A @ B for 2D matrices

# Dot product of two vectors
v1 = np.array([1, 2, 3])
v2 = np.array([4, 5, 6])
print(np.dot(v1, v2))  # 32  (1*4 + 2*5 + 3*6)
print(v1 @ v2)          # 32  (same thing, preferred)

# Matrix chain
C = np.array([[1, 0],
              [0, 1]])   # identity matrix
print(A @ C)    # [[1 2] [3 4]] — same as A (multiplying by identity)

# Verify: (AB)^T = B^T A^T
left  = (A @ B).T
right = B.T @ A.T
print(np.allclose(left, right))  # True',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000030',
 'e5000000-0000-0000-0000-000000000003',
 'np.linalg — Linear Algebra Module',
 '## Advanced Linear Algebra Operations

`np.linalg` is NumPy''s dedicated linear algebra submodule with functions for solving systems of equations, computing determinants, inverses, and eigenvalues.

**Key functions in np.linalg:**
| Function | What it does |
|----------|-------------|
| `np.linalg.det(A)` | Determinant of matrix |
| `np.linalg.inv(A)` | Inverse of matrix |
| `np.linalg.solve(A, b)` | Solve Ax = b for x |
| `np.linalg.eig(A)` | Eigenvalues & eigenvectors |
| `np.linalg.norm(v)` | Euclidean norm (magnitude) |
| `np.linalg.rank(A)` | Rank of matrix |
| `np.linalg.svd(A)` | Singular Value Decomposition |

**solve vs inv:**
- `np.linalg.solve(A, b)` ✅ **preferred** for solving Ax=b (numerically stable)
- `np.linalg.inv(A) @ b` ⚠️ avoid — slower and less numerically stable

Always use `solve()` instead of computing the matrix inverse explicitly.',
 'import numpy as np

A = np.array([[2., 1.],
              [5., 3.]])

# Determinant
det = np.linalg.det(A)
print(f"det(A) = {det}")         # 1.0

# Inverse
A_inv = np.linalg.inv(A)
print(A_inv)
# [[ 3. -1.]
#  [-5.  2.]]

# Verify: A * A_inv = Identity
print(np.round(A @ A_inv, 10))
# [[1. 0.]
#  [0. 1.]]

# Solve linear system: Ax = b
# 2x + y = 8
# 5x + 3y = 21
b = np.array([8., 21.])
x = np.linalg.solve(A, b)         # PREFERRED over inv(A) @ b
print(f"x = {x[0]:.1f}, y = {x[1]:.1f}")  # x = 3.0, y = 2.0

# Verify: A @ x should equal b
print(np.allclose(A @ x, b))      # True

# Eigenvalues and eigenvectors
eigenvalues, eigenvectors = np.linalg.eig(A)
print(f"Eigenvalues: {eigenvalues.round(4)}")  # [0.7016 4.2984]

# Vector norm (magnitude / length)
v = np.array([3., 4.])
print(f"||v|| = {np.linalg.norm(v)}")   # 5.0  (3-4-5 triangle)',
 2);

-- ---- SUBTOPIC 16: Random Module ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000031',
 'e5000000-0000-0000-0000-000000000004',
 'Generating Random Arrays',
 '## NumPy''s Random Module

`np.random` generates arrays of random numbers. Essential for ML (weight initialization), simulations, sampling, and testing.

**Main random functions:**
| Function | Distribution | Range |
|----------|-------------|-------|
| `np.random.rand(n)` | Uniform | [0.0, 1.0) |
| `np.random.randn(n)` | Normal (Gaussian) | mean=0, std=1 |
| `np.random.randint(low, high, size)` | Integer | [low, high) |
| `np.random.uniform(low, high, size)` | Uniform | [low, high) |
| `np.random.normal(mean, std, size)` | Normal | custom mean/std |
| `np.random.choice(arr, size)` | Random selection | from array |
| `np.random.shuffle(arr)` | In-place shuffle | — |

**rand vs randn — which to use?**
- `np.random.rand()` → uniform [0,1) ✅ for probabilities, general randomness
- `np.random.randn()` → standard normal (bell curve) ✅ for ML weight init, simulations

**Modern style:** `np.random.default_rng()` (NumPy 1.17+) is preferred over the legacy `np.random.*` functions for new code — it is faster and has better statistical properties.',
 'import numpy as np

# Uniform random: values in [0.0, 1.0)
u = np.random.rand(5)
print(u)   # e.g., [0.374 0.951 0.732 0.598 0.156]

# Normal distribution: mean=0, std=1
n = np.random.randn(5)
print(n)   # e.g., [ 0.47  -1.23   0.82  -0.15   1.65]

# Random integers: [low, high)
dice = np.random.randint(1, 7, size=10)   # 10 dice rolls
print(dice)   # e.g., [3 1 6 2 5 4 3 6 1 2]

# Custom normal distribution
heights = np.random.normal(170, 10, size=1000)  # mean=170cm, std=10cm
print(f"Mean height: {heights.mean():.1f}cm")
print(f"Std height: {heights.std():.1f}cm")

# Random choice — sample from array
choices = np.random.choice(["rock", "paper", "scissors"], size=5)
print(choices)

# Shuffle (in-place)
arr = np.arange(10)
np.random.shuffle(arr)
print(arr)   # e.g., [7 2 5 1 9 0 3 8 4 6]

# Modern style (NumPy 1.17+ recommended)
rng = np.random.default_rng(seed=42)
arr = rng.integers(0, 100, size=5)
print(arr)   # [77 15 72 22 21] — reproducible with seed',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('ea000000-0000-0000-0000-000000000032',
 'e5000000-0000-0000-0000-000000000004',
 'Seeds and Reproducibility',
 '## Making Random Results Reproducible

Random numbers in NumPy are **pseudorandom** — generated by a deterministic algorithm starting from a **seed** value. The same seed always produces the same sequence.

**Why seeds matter:**
- Scientific experiments need reproducible results
- ML training: others should be able to reproduce your exact results
- Debugging: random failures are hard to debug without fixing the seed
- Testing: tests with random inputs should give predictable results

**Legacy vs Modern API:**
- `np.random.seed(42)` → legacy global seed ⚠️ (affects all random calls)
- `np.random.default_rng(42)` → modern Generator ✅ **preferred** (isolated, thread-safe)

**Which to use?**
Use `np.random.default_rng(seed)` for new code. It creates an isolated random number generator that does not interfere with other random calls. The legacy `np.random.seed()` is global state — risky in large programs.',
 'import numpy as np

# Legacy method — global seed (still widely used)
np.random.seed(42)
print(np.random.rand(3))   # [0.37454012 0.95071431 0.73199394]

np.random.seed(42)         # reset seed
print(np.random.rand(3))   # [0.37454012 0.95071431 0.73199394]  SAME!

# Modern method — isolated Generator (PREFERRED)
rng1 = np.random.default_rng(seed=42)
rng2 = np.random.default_rng(seed=42)

print(rng1.random(3))   # [0.77395605 0.43887844 0.85859792]
print(rng2.random(3))   # [0.77395605 0.43887844 0.85859792]  SAME!

# Generators are independent — no global state pollution
rng_a = np.random.default_rng(1)
rng_b = np.random.default_rng(2)

print(rng_a.integers(0, 10, 3))  # [5 4 0]  — from generator a
print(rng_b.integers(0, 10, 3))  # [8 9 5]  — from generator b, independent!

# Practical: reproducible ML train/test split
data = np.arange(100)
rng = np.random.default_rng(seed=42)

indices = rng.permutation(len(data))
train_idx = indices[:80]
test_idx  = indices[80:]

print(f"Train size: {len(train_idx)}")  # 80
print(f"Test size:  {len(test_idx)}")   # 20
print(f"First few train indices: {train_idx[:5]}")  # reproducible!',
 2);
