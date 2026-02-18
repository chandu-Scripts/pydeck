-- PyDeck Pandas Seed Data: Path, Topics, Subtopics, Concepts
-- Run this in Supabase SQL Editor

-- ============ PATH ============
INSERT INTO paths (id, name, description, icon, display_order) VALUES
  ('a1000000-0000-0000-0000-000000000006', 'Pandas', 'Master data analysis and manipulation with Pandas — Python''s most powerful data library', 'Table', 6)
ON CONFLICT (id) DO NOTHING;

-- ============ TOPICS ============
INSERT INTO topics (id, path_id, name, icon, display_order) VALUES
  ('b6000000-0000-0000-0000-000000000001', 'a1000000-0000-0000-0000-000000000006', 'Introduction to Pandas', 'BookOpen', 1),
  ('b6000000-0000-0000-0000-000000000002', 'a1000000-0000-0000-0000-000000000006', 'Series', 'List', 2),
  ('b6000000-0000-0000-0000-000000000003', 'a1000000-0000-0000-0000-000000000006', 'DataFrames', 'Grid', 3),
  ('b6000000-0000-0000-0000-000000000004', 'a1000000-0000-0000-0000-000000000006', 'Data Cleaning & Manipulation', 'Scissors', 4),
  ('b6000000-0000-0000-0000-000000000005', 'a1000000-0000-0000-0000-000000000006', 'GroupBy, Merge & Advanced', 'Zap', 5)
ON CONFLICT (id) DO NOTHING;

-- ============ SUBTOPICS ============

-- Topic 1: Introduction to Pandas
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f1000000-0000-0000-0000-000000000001', 'b6000000-0000-0000-0000-000000000001', 'What is Pandas & Why Use It', 1),
  ('f1000000-0000-0000-0000-000000000002', 'b6000000-0000-0000-0000-000000000001', 'Installing & Importing Pandas', 2),
  ('f1000000-0000-0000-0000-000000000003', 'b6000000-0000-0000-0000-000000000001', 'Pandas Data Structures Overview', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 2: Series
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f2000000-0000-0000-0000-000000000001', 'b6000000-0000-0000-0000-000000000002', 'Creating a Series', 1),
  ('f2000000-0000-0000-0000-000000000002', 'b6000000-0000-0000-0000-000000000002', 'Series Indexing & Slicing', 2),
  ('f2000000-0000-0000-0000-000000000003', 'b6000000-0000-0000-0000-000000000002', 'Series Operations', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 3: DataFrames
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f3000000-0000-0000-0000-000000000001', 'b6000000-0000-0000-0000-000000000003', 'Creating DataFrames', 1),
  ('f3000000-0000-0000-0000-000000000002', 'b6000000-0000-0000-0000-000000000003', 'Selecting & Filtering Data', 2),
  ('f3000000-0000-0000-0000-000000000003', 'b6000000-0000-0000-0000-000000000003', 'Adding & Removing Columns and Rows', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 4: Data Cleaning & Manipulation
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f4000000-0000-0000-0000-000000000001', 'b6000000-0000-0000-0000-000000000004', 'Handling Missing Data', 1),
  ('f4000000-0000-0000-0000-000000000002', 'b6000000-0000-0000-0000-000000000004', 'Data Types & Conversion', 2),
  ('f4000000-0000-0000-0000-000000000003', 'b6000000-0000-0000-0000-000000000004', 'Sorting & Ranking', 3)
ON CONFLICT (id) DO NOTHING;

-- Topic 5: GroupBy, Merge & Advanced
INSERT INTO subtopics (id, topic_id, name, display_order) VALUES
  ('f5000000-0000-0000-0000-000000000001', 'b6000000-0000-0000-0000-000000000005', 'GroupBy Operations', 1),
  ('f5000000-0000-0000-0000-000000000002', 'b6000000-0000-0000-0000-000000000005', 'Merging & Joining DataFrames', 2),
  ('f5000000-0000-0000-0000-000000000003', 'b6000000-0000-0000-0000-000000000005', 'Apply, Map & Transform', 3),
  ('f5000000-0000-0000-0000-000000000004', 'b6000000-0000-0000-0000-000000000005', 'Reading & Writing Files', 4)
ON CONFLICT (id) DO NOTHING;

-- ============ CONCEPTS ============

-- ---- SUBTOPIC 1: What is Pandas & Why Use It ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000001',
 'f1000000-0000-0000-0000-000000000001',
 'Introduction to Pandas',
 '## What is Pandas?

Pandas is an open-source Python library for **data analysis and manipulation**. The name comes from "Panel Data" — an econometrics term for multi-dimensional structured data.

**What problem does it solve?**
Raw data in the real world comes in tables — spreadsheets, CSVs, databases. Python lists and NumPy arrays are great for math, but they have no concept of column names, labeled rows, missing values, or data types per column. Pandas adds all of this.

**The two core data structures:**
- **Series** — a 1D labeled array (like a single column)
- **DataFrame** — a 2D labeled table (like a spreadsheet or SQL table)

**Where is Pandas used?**
- **Data Analysis** — exploring and summarizing datasets
- **Data Cleaning** — handling missing values, duplicates, wrong types
- **Finance** — stock prices, portfolio analysis, backtesting
- **Machine Learning Prep** — feature engineering, data preprocessing
- **Business Intelligence** — sales reports, KPI dashboards
- **Scientific Research** — experiment data, statistical analysis
- **Journalism** — investigative data reporting

Pandas is the **go-to tool** whenever you work with tabular data in Python.',
 'import pandas as pd
import numpy as np

# The problem Pandas solves:
# Without Pandas — you lose all context
data = [[25, "Alice", 85000],
        [30, "Bob", 92000],
        [28, "Carol", 78000]]

# With Pandas — data has labels, types, and structure
df = pd.DataFrame(data,
                  columns=["Age", "Name", "Salary"])
print(df)
#    Age   Name  Salary
# 0   25  Alice   85000
# 1   30    Bob   92000
# 2   28  Carol   78000

# Instantly get insights
print(df["Salary"].mean())      # 85000.0
print(df[df["Age"] < 29])       # Filter: only employees under 29
print(df.describe())             # Statistical summary of all columns',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000002',
 'f1000000-0000-0000-0000-000000000001',
 'Pandas vs NumPy vs Python Lists',
 '## Choosing the Right Tool

Understanding when to use Pandas vs NumPy vs Python lists is fundamental to writing efficient data code.

| Feature | Python List | NumPy Array | Pandas DataFrame |
|---------|------------|-------------|-----------------|
| **Data types** | Mixed | Single type | Per-column types |
| **Labels** | No | No | Yes (rows + cols) |
| **Missing values** | Manual | Awkward | Built-in (NaN) |
| **Column names** | No | No | Yes |
| **SQL-like ops** | No | No | Yes (groupby, merge) |
| **Speed** | Slow | Very fast | Fast (NumPy under hood) |
| **File I/O** | Manual | Limited | CSV, Excel, SQL, JSON |

**Rule of thumb:**
- Raw numbers + math → **NumPy**
- Tabular data + labels + mixed types → **Pandas**
- Simple collections + non-numeric → **Python list**

**Important:** Pandas is built ON TOP of NumPy. Every DataFrame column is a NumPy array underneath.',
 'import pandas as pd
import numpy as np

# NumPy — pure numerical, no labels
prices = np.array([10.5, 20.3, 15.8, 12.1])
print(prices.mean())    # 14.675

# Pandas — tabular, labeled, mixed types
stock_data = pd.DataFrame({
    "ticker": ["AAPL", "GOOG", "MSFT", "AMZN"],
    "price":  [182.5, 141.2, 415.3, 178.9],
    "volume": [55_000_000, 22_000_000, 19_000_000, 45_000_000],
    "up_today": [True, False, True, True]
})

print(stock_data)
#   ticker   price    volume  up_today
# 0   AAPL   182.5  55000000      True
# 1   GOOG   141.2  22000000     False
# 2   MSFT   415.3  19000000      True
# 3   AMZN   178.9  45000000      True

# Can''t do this with NumPy — mixed types and labels
print(stock_data[stock_data["up_today"]]["ticker"].tolist())
# [''AAPL'', ''MSFT'', ''AMZN'']  — stocks that went up

# Pandas column IS a NumPy array
print(type(stock_data["price"].values))  # <class ''numpy.ndarray''>',
 2);

-- ---- SUBTOPIC 2: Installing & Importing Pandas ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000003',
 'f1000000-0000-0000-0000-000000000002',
 'Installing and Importing Pandas',
 '## Getting Started with Pandas

**Installation:**
```
pip install pandas
```

**With conda:**
```
conda install pandas
```

**Already included in:**
- Google Colab ✅
- Anaconda distribution ✅
- Most Jupyter environments ✅

**The standard import convention:**
```python
import pandas as pd
```

The alias `pd` is universal — every tutorial, documentation, and professional codebase uses it. Never use `import pandas` (too verbose) or `from pandas import *` (pollutes namespace).

**Check your version:**
```python
pd.__version__
```

**Commonly installed together:**
Pandas works best alongside NumPy, Matplotlib, and Seaborn:
```
pip install pandas numpy matplotlib seaborn
```',
 'import pandas as pd       # ALWAYS use pd alias — universal convention
import numpy as np        # Almost always needed alongside pandas

# Check versions
print(pd.__version__)     # e.g., 2.1.4
print(np.__version__)     # e.g., 1.26.4

# Quick sanity check
df = pd.DataFrame({"a": [1, 2, 3], "b": [4, 5, 6]})
print(df)
#    a  b
# 0  1  4
# 1  2  5
# 2  3  6

print("Pandas is working!")

# What NOT to do:
# import pandas               # too verbose: pandas.DataFrame(...)
# from pandas import *        # dangerous — pollutes your namespace
# from pandas import DataFrame  # only acceptable in very specific scripts',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000004',
 'f1000000-0000-0000-0000-000000000002',
 'Display Settings and Configuration',
 '## Customizing How Pandas Shows Data

By default, Pandas truncates output for large DataFrames. You can control exactly how much data is shown using `pd.set_option()`.

**Most useful display options:**
| Option | What it controls |
|--------|-----------------|
| `display.max_rows` | Max rows shown (default 60) |
| `display.max_columns` | Max columns shown (default 20) |
| `display.max_colwidth` | Max characters per cell |
| `display.float_format` | How floats are displayed |
| `display.width` | Console width |

**Two equivalent syntaxes:**
- `pd.set_option("display.max_rows", 100)` → string key ✅ **preferred**
- `pd.options.display.max_rows = 100` → attribute access ✅ also fine

Both do the same thing. Use `pd.set_option()` — it is more explicit and easier to search for in code.',
 'import pandas as pd

# Default — pandas truncates large DataFrames
# You see "..." when there are many rows/columns

# Show more rows
pd.set_option("display.max_rows", 100)

# Show all columns (None = unlimited)
pd.set_option("display.max_columns", None)

# Control float decimal places
pd.set_option("display.float_format", "{:.2f}".format)

# Alternative syntax (attribute style) — same effect
pd.options.display.max_rows = 100
pd.options.display.float_format = "{:.2f}".format

# Reset to defaults
pd.reset_option("display.max_rows")
pd.reset_option("all")   # reset everything

# Context manager — temporarily change settings
with pd.option_context("display.max_rows", 5,
                        "display.max_columns", 3):
    print(df)   # shows at most 5 rows, 3 cols inside this block
# Settings revert automatically outside the block',
 2);

-- ---- SUBTOPIC 3: Pandas Data Structures Overview ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000005',
 'f1000000-0000-0000-0000-000000000003',
 'Series vs DataFrame — The Two Pillars',
 '## Understanding Pandas'' Core Data Structures

Pandas has two primary data structures that you will use constantly:

**Series:**
- 1-dimensional labeled array
- Like a single column in a spreadsheet
- Has an **index** (row labels) and **values**
- Can hold any dtype: int, float, str, bool, datetime

**DataFrame:**
- 2-dimensional labeled table
- Like a full spreadsheet or SQL table
- Has row **index** and column **names**
- Each column is a Series
- Columns can have different dtypes

**Relationship:**
```
DataFrame = dict of Series (one per column)
Series = labeled NumPy array
```

**When to use which:**
- Single column or 1D data → **Series**
- Multiple columns / table structure → **DataFrame**
- Most real-world work → **DataFrame**',
 'import pandas as pd

# Series — one column, one dtype
temperatures = pd.Series([22.5, 19.3, 25.1, 21.8, 28.4],
                          index=["Mon", "Tue", "Wed", "Thu", "Fri"],
                          name="Temperature (°C)")
print(temperatures)
# Mon    22.5
# Tue    19.3
# Wed    25.1
# Thu    21.8
# Fri    28.4
# Name: Temperature (°C), dtype: float64

# DataFrame — multiple columns, mixed dtypes
weather = pd.DataFrame({
    "temp_c":   [22.5, 19.3, 25.1, 21.8, 28.4],
    "humidity": [65, 80, 55, 70, 45],
    "sunny":    [True, False, True, True, True]
}, index=["Mon", "Tue", "Wed", "Thu", "Fri"])

print(weather)
#      temp_c  humidity  sunny
# Mon    22.5        65   True
# Tue    19.3        80  False
# Wed    25.1        55   True
# Thu    21.8        70   True
# Fri    28.4        45   True

# Each column is a Series
print(type(weather["temp_c"]))        # <class ''pandas.core.series.Series''>
print(weather["temp_c"].dtype)        # float64',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000006',
 'f1000000-0000-0000-0000-000000000003',
 'The Index — Pandas'' Superpower',
 '## Understanding Labels and Indexes

The **index** is what makes Pandas different from NumPy. It is a set of labels attached to every row (and column) of your data.

**Why the index matters:**
- Allows meaningful labels instead of just position numbers
- Enables alignment — when you add two Series, Pandas aligns by index label
- Enables fast lookups by label
- Datetime indexes unlock time-series operations

**Default index:** If you do not specify one, Pandas creates a RangeIndex (0, 1, 2, ...) automatically.

**Types of indexes:**
- `RangeIndex` — default integer range
- `Int64Index` — custom integers
- `Index` — string labels
- `DatetimeIndex` — for time-series data
- `MultiIndex` — hierarchical (multiple levels)',
 'import pandas as pd

# Default RangeIndex (0, 1, 2...)
s1 = pd.Series([10, 20, 30])
print(s1.index)    # RangeIndex(start=0, stop=3, step=1)

# Custom string index
s2 = pd.Series([10, 20, 30], index=["a", "b", "c"])
print(s2["b"])     # 20 — access by label

# Index alignment — Pandas matches by label, not position!
s3 = pd.Series([1, 2, 3], index=["a", "b", "c"])
s4 = pd.Series([10, 20, 30], index=["b", "c", "d"])

result = s3 + s4
print(result)
# a     NaN   — "a" only in s3
# b    12.0   — 2 + 10
# c    23.0   — 3 + 20
# d     NaN   — "d" only in s4

# Datetime index — unlocks time-series magic
dates = pd.date_range("2024-01-01", periods=5, freq="D")
prices = pd.Series([100, 102, 98, 105, 103], index=dates)
print(prices["2024-01-03"])   # 98
print(prices["2024-01"])      # all January prices

# Reset index back to default integers
df = pd.DataFrame({"val": [5, 10, 15]}, index=["x", "y", "z"])
df_reset = df.reset_index()   # moves old index to a column
print(df_reset)',
 2);

-- ---- SUBTOPIC 4: Creating a Series ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000007',
 'f2000000-0000-0000-0000-000000000001',
 'Creating a Pandas Series',
 '## All the Ways to Create a Series

A **Series** is a one-dimensional labeled array. You can create one from almost any Python data source.

**Creation methods:**
| Source | Example |
|--------|---------|
| Python list | `pd.Series([1, 2, 3])` |
| Python dict | `pd.Series({"a": 1, "b": 2})` |
| NumPy array | `pd.Series(np.array([1, 2, 3]))` |
| Scalar value | `pd.Series(5, index=[0,1,2])` |
| Range | `pd.Series(range(5))` |

**Key parameters:**
- `data` → the values
- `index` → labels for each value
- `name` → name of the Series (becomes column name when added to DataFrame)
- `dtype` → force a specific data type

**Dict → Series:**
When you create a Series from a dict, the **keys become the index** automatically. This is a very common and clean pattern.',
 'import pandas as pd
import numpy as np

# From a list (default RangeIndex: 0, 1, 2...)
s1 = pd.Series([10, 20, 30, 40, 50])
print(s1)
# 0    10
# 1    20
# 2    30
# 3    40
# 4    50

# From a list with custom index
s2 = pd.Series([10, 20, 30], index=["Mon", "Tue", "Wed"], name="Sales")
print(s2)
# Mon    10
# Tue    20
# Wed    30
# Name: Sales, dtype: int64

# From a dict — keys become index (very Pythonic)
grades = pd.Series({"Alice": 92, "Bob": 78, "Carol": 88, "Dave": 95})
print(grades)
# Alice    92
# Bob      78
# Carol    88
# Dave     95

# From NumPy array
arr = np.arange(1, 6) ** 2   # [1, 4, 9, 16, 25]
s3 = pd.Series(arr, name="Squares")
print(s3)

# Scalar — same value repeated across all index positions
s4 = pd.Series(0.0, index=["a", "b", "c", "d"])
print(s4)    # a   0.0  b   0.0  c   0.0  d   0.0',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000008',
 'f2000000-0000-0000-0000-000000000001',
 'Series Attributes and Inspection',
 '## Getting Information About a Series

After creating a Series, these attributes tell you everything about it:

| Attribute | What it returns |
|-----------|----------------|
| `.index` | The index labels |
| `.values` | NumPy array of values |
| `.dtype` | Data type |
| `.name` | Name of the Series |
| `.shape` | Tuple like `(5,)` |
| `.size` | Total number of elements |
| `.count()` | Non-null element count |
| `.head(n)` | First n elements (default 5) |
| `.tail(n)` | Last n elements (default 5) |
| `.describe()` | Statistical summary |
| `.unique()` | Unique values |
| `.value_counts()` | Frequency of each value |',
 'import pandas as pd

scores = pd.Series([85, 92, 78, 92, 65, 78, 88, 92, 71, 88],
                   index=["Alice", "Bob", "Carol", "Dave", "Eve",
                          "Frank", "Grace", "Hank", "Ivy", "Jack"],
                   name="Exam Score")

print(scores.index)      # Index([''Alice'', ''Bob'', ...])
print(scores.values)     # [85 92 78 92 65 78 88 92 71 88]
print(scores.dtype)      # int64
print(scores.name)       # Exam Score
print(scores.shape)      # (10,)
print(scores.size)       # 10

# Top and bottom
print(scores.head(3))    # Alice 85, Bob 92, Carol 78
print(scores.tail(2))    # Ivy 71, Jack 88

# Statistics
print(scores.describe())
# count    10.000000
# mean     82.900000
# std       9.144...
# min      65.000000
# 25%      78.250000
# 50%      88.000000
# 75%      91.000000
# max      92.000000

# Unique values and frequency
print(scores.unique())          # [85 92 78 65 88 71]
print(scores.value_counts())    # 92 → 3, 78 → 2, 88 → 2, ...',
 2);

-- ---- SUBTOPIC 5: Series Indexing & Slicing ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000009',
 'f2000000-0000-0000-0000-000000000002',
 'loc vs iloc — Label vs Position',
 '## The Two Ways to Access Series Data

This is one of the most important distinctions in Pandas:

**`.loc[]` — Label-based access:**
- Uses the **index labels** to select data
- Works with string, datetime, or any custom index
- Slice is **inclusive** on both ends

**`.iloc[]` — Integer position-based access:**
- Uses **integer position** (0, 1, 2...) regardless of index labels
- Works like Python list indexing
- Slice is **exclusive** on the right end (standard Python)

**Which to use?**
- When you know the label → use `.loc[]` ✅ (clear intent)
- When you know the position → use `.iloc[]` ✅ (clear intent)
- Avoid `s["label"]` directly — it is ambiguous and can raise warnings in newer Pandas

**Common mistake:** When index IS integers, `s[2]` is ambiguous. Always be explicit with `.loc[2]` or `.iloc[2]`.',
 'import pandas as pd

scores = pd.Series({"Alice": 85, "Bob": 92, "Carol": 78, "Dave": 88, "Eve": 71})

# .loc — access by LABEL (index name)
print(scores.loc["Bob"])         # 92
print(scores.loc["Alice":"Carol"])   # Alice 85, Bob 92, Carol 78  (INCLUSIVE)

# .iloc — access by POSITION (integer index)
print(scores.iloc[1])            # 92   (position 1 = Bob)
print(scores.iloc[0:3])          # Alice, Bob, Carol  (EXCLUSIVE on right)
print(scores.iloc[-1])           # 71   (Eve — last element)

# Multiple labels / positions at once
print(scores.loc[["Alice", "Eve"]])        # Alice 85, Eve 71
print(scores.iloc[[0, 4]])                 # Alice 85, Eve 71

# Boolean indexing — same as NumPy
print(scores[scores >= 85])
# Alice    85
# Bob      92
# Dave     88

# The ambiguity problem — when index is integers
int_idx = pd.Series([10, 20, 30], index=[5, 10, 15])
# int_idx[5] — is this position 5 or label 5? AMBIGUOUS
print(int_idx.loc[5])    # 10  — label 5 ✅ explicit
print(int_idx.iloc[0])   # 10  — position 0 ✅ explicit',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000010',
 'f2000000-0000-0000-0000-000000000002',
 'Boolean Indexing and Filtering Series',
 '## Filtering Series Data with Conditions

Boolean indexing lets you filter a Series by any condition. The condition creates a boolean Series (True/False per element), and you use it to select matching values.

**Combining conditions:**
- `&` → AND (both must be True)
- `|` → OR (at least one True)
- `~` → NOT (invert)

Always wrap individual conditions in parentheses `()` when combining.

**Useful filtering methods:**
- `.isin([list])` → check if values are in a list
- `.between(a, b)` → check if values are in range [a, b] (inclusive)
- `.str.contains("text")` → search within string values
- `.isna()` / `.notna()` → filter missing values',
 'import pandas as pd

scores = pd.Series({"Alice": 85, "Bob": 92, "Carol": 78,
                    "Dave": 88, "Eve": 71, "Frank": 55, "Grace": 92})

# Simple boolean filter
print(scores[scores >= 85])
# Alice    85
# Bob      92
# Dave     88
# Grace    92

# Combining conditions — use & and | NOT and/or
high_but_not_top = scores[(scores >= 80) & (scores < 92)]
print(high_but_not_top)
# Alice    85
# Dave     88

# .isin() — check against a list of values
top_scorers = scores[scores.isin([92, 88])]
print(top_scorers)
# Bob      92
# Dave     88
# Grace    92

# .between() — inclusive range filter
mid_range = scores[scores.between(75, 90)]
print(mid_range)
# Alice    85
# Carol    78
# Dave     88

# ~ (NOT) — inverse of a condition
not_failing = scores[~(scores < 60)]
print(not_failing)    # everyone with 60 or above

# String Series filtering
names = pd.Series(["Alice Smith", "Bob Jones", "Alice Brown", "Carol White"])
alice_entries = names[names.str.contains("Alice")]
print(alice_entries)
# 0    Alice Smith
# 2    Alice Brown',
 2);

-- ---- SUBTOPIC 6: Series Operations ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000011',
 'f2000000-0000-0000-0000-000000000003',
 'Arithmetic and Statistical Operations on Series',
 '## Computing with Series

Pandas Series supports vectorized arithmetic (like NumPy), plus rich statistical methods built-in.

**Arithmetic:**
- Standard operators (+, -, *, /) work element-wise
- When operating on two Series, Pandas **aligns by index label** before computing
- Missing alignments produce `NaN`

**Statistical methods:**
All work as methods on the Series — `.mean()`, `.sum()`, `.std()`, etc.

**Two equivalent styles:**
- `s.mean()` → method style ✅ **preferred**
- `pd.Series.mean(s)` → unbound method — never use this

Always use the method style — it is concise and Pythonic.',
 'import pandas as pd

revenue = pd.Series({"Jan": 45000, "Feb": 52000, "Mar": 48000,
                     "Apr": 61000, "May": 55000, "Jun": 70000})

# Arithmetic operations
print(revenue * 1.1)           # Apply 10% increase to every month
print(revenue - revenue.mean())  # Deviation from average

# Statistical methods
print(f"Total:  {revenue.sum():,.0f}")    # 331,000
print(f"Mean:   {revenue.mean():,.0f}")   # 55,167
print(f"Median: {revenue.median():,.0f}") # 53,500
print(f"Max:    {revenue.max():,.0f}")    # 70,000
print(f"Std:    {revenue.std():,.0f}")    # 9,016
print(f"Best month: {revenue.idxmax()}")  # Jun

# Index alignment in arithmetic
q1 = pd.Series({"Jan": 45000, "Feb": 52000, "Mar": 48000})
q2 = pd.Series({"Apr": 61000, "Jan": 55000, "Mar": 58000})  # different order!

combined = q1 + q2   # aligns by label
print(combined)
# Apr         NaN   — only in q2
# Feb         NaN   — only in q1
# Jan     100000.0  — in both
# Mar     106000.0  — in both

# Use fill_value to handle NaN in alignment
combined2 = q1.add(q2, fill_value=0)
print(combined2)    # NaN replaced with 0 before adding

# Cumulative operations
print(revenue.cumsum())    # running total month by month',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000012',
 'f2000000-0000-0000-0000-000000000003',
 'Series String Methods and Apply',
 '## Working with String Data in a Series

Pandas provides a `.str` accessor for string Series — gives you vectorized string operations without loops.

**`.str` methods mirror Python string methods:**
- `.str.lower()` / `.str.upper()`
- `.str.strip()` → remove whitespace
- `.str.replace(old, new)`
- `.str.contains("pattern")`
- `.str.split("sep")`
- `.str.len()` → length of each string

**`.apply()` — custom function on every element:**
When no built-in method exists for your transformation, use `.apply(func)` to apply any function element-wise.

**apply() vs map() vs vectorized:**
- Vectorized `.str.*` → fastest ✅ use first
- `.map(dict)` → replace values using a dict ✅ clean for mapping
- `.apply(func)` → most flexible ✅ use for complex logic',
 'import pandas as pd

names = pd.Series(["  alice smith  ", "BOB JONES", "carol White", "  DAVE Brown"])

# String cleaning — vectorized, no loops!
cleaned = names.str.strip().str.title()
print(cleaned)
# 0    Alice Smith
# 1      Bob Jones
# 2    Carol White
# 3     Dave Brown

# String operations
print(names.str.len())         # length including whitespace
print(names.str.contains("BOB"))  # [False, True, False, False]
print(names.str.replace("  ", "", regex=False).str.upper())

# Split strings
emails = pd.Series(["alice@gmail.com", "bob@yahoo.com", "carol@gmail.com"])
domains = emails.str.split("@").str[1]  # get part after @
print(domains)
# 0    gmail.com
# 1    yahoo.com
# 2    gmail.com

# apply() — custom function per element
scores = pd.Series([45, 72, 88, 55, 91, 68])

def grade(score):
    if score >= 90: return "A"
    elif score >= 80: return "B"
    elif score >= 70: return "C"
    else: return "F"

print(scores.apply(grade))   # [F, C, B, F, A, F]

# map() — replace using a dictionary
status = pd.Series([1, 0, 1, 1, 0])
labels = status.map({1: "Active", 0: "Inactive"})
print(labels)   # Active, Inactive, Active, Active, Inactive',
 2);

-- ---- SUBTOPIC 7: Creating DataFrames ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000013',
 'f3000000-0000-0000-0000-000000000001',
 'Creating DataFrames',
 '## All the Ways to Create a DataFrame

A **DataFrame** is a 2D table with labeled rows (index) and labeled columns.

**Creation methods:**
| Source | When to use |
|--------|-------------|
| Dict of lists | Most common — column per key |
| List of dicts | Row-oriented data (e.g., JSON records) |
| NumPy array | When you have existing numeric data |
| Another DataFrame | Copying/subsetting |
| CSV/Excel file | Most common in practice |
| Supabase/API result | Real-world data fetching |

**Dict of lists** is the most common way to create a DataFrame manually. Each key becomes a column name, each list becomes the column values.',
 'import pandas as pd
import numpy as np

# Method 1: Dict of lists — MOST COMMON
df1 = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave"],
    "age":    [25, 30, 28, 35],
    "salary": [75000, 92000, 68000, 105000],
    "dept":   ["Engineering", "Marketing", "Engineering", "Finance"]
})
print(df1)

# Method 2: List of dicts (row-oriented — like JSON records)
records = [
    {"name": "Alice", "age": 25, "score": 88},
    {"name": "Bob",   "age": 30, "score": 92},
    {"name": "Carol", "age": 28, "score": 75},
]
df2 = pd.DataFrame(records)
print(df2)

# Method 3: NumPy array — specify column names separately
arr = np.array([[1, 2, 3],
                [4, 5, 6],
                [7, 8, 9]])
df3 = pd.DataFrame(arr, columns=["A", "B", "C"])
print(df3)

# Custom index
df4 = pd.DataFrame({"temp": [22.5, 19.3, 25.1]},
                   index=["Mon", "Tue", "Wed"])
print(df4)

# DataFrame from Supabase (real-world pattern)
# response = supabase.from_("users").select("*").execute()
# df = pd.DataFrame(response.data)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000014',
 'f3000000-0000-0000-0000-000000000001',
 'Inspecting a DataFrame',
 '## Your First Steps With Any New DataFrame

Whenever you load or create a new DataFrame, run these inspection commands to understand what you have before doing anything else.

**Essential inspection methods:**
| Method | What it shows |
|--------|--------------|
| `df.head(n)` | First n rows (default 5) |
| `df.tail(n)` | Last n rows (default 5) |
| `df.shape` | (rows, columns) tuple |
| `df.info()` | Column names, types, null counts |
| `df.describe()` | Statistical summary of numeric cols |
| `df.dtypes` | Data type of each column |
| `df.columns` | Column names |
| `df.index` | Row index |
| `df.isnull().sum()` | Missing values per column |
| `df.nunique()` | Unique values per column |
| `df.sample(n)` | n random rows |

**`df.info()` is the most important inspection tool** — it shows you shape, column names, data types, and non-null counts all at once.',
 'import pandas as pd

df = pd.DataFrame({
    "name":    ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "age":     [25, 30, None, 35, 28],
    "salary":  [75000.0, 92000.0, 68000.0, 105000.0, None],
    "dept":    ["Engineering", "Marketing", "Engineering", "Finance", "Marketing"],
    "active":  [True, True, False, True, True]
})

# Shape — always check first
print(df.shape)      # (5, 5) — 5 rows, 5 columns

# Head and tail
print(df.head(3))
print(df.tail(2))

# info() — THE most useful inspection method
df.info()
# <class ''pandas.core.frame.DataFrame''>
# RangeIndex: 5 entries, 0 to 4
# Data columns (total 5 columns):
#  #   Column  Non-Null Count  Dtype
# ---  ------  --------------  -----
#  0   name    5 non-null      object
#  1   age     4 non-null      float64  <- has 1 null
#  2   salary  4 non-null      float64  <- has 1 null
#  3   dept    5 non-null      object
#  4   active  5 non-null      bool

# describe() — stats for numeric columns
print(df.describe())

# Missing values summary
print(df.isnull().sum())
# name      0
# age       1
# salary    1

# Unique values per column
print(df.nunique())
# name      5, age 4, salary 4, dept 2, active 2',
 2);

-- ---- SUBTOPIC 8: Selecting & Filtering Data ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000015',
 'f3000000-0000-0000-0000-000000000002',
 'Selecting Columns and Rows',
 '## Getting the Data You Need

Selecting data from a DataFrame is one of the most frequent operations. There are several ways, and knowing which to use matters.

**Selecting columns:**
- `df["col"]` → returns a **Series** ✅ standard
- `df[["col1", "col2"]]` → returns a **DataFrame** ✅ double brackets
- `df.col` → attribute access ⚠️ only for simple names, avoid

**Selecting rows:**
- `df.loc[label]` → by index label
- `df.iloc[n]` → by integer position
- `df.loc[start:end]` → label-based slice (inclusive)
- `df.iloc[start:end]` → position-based slice (exclusive end)

**Selecting both rows AND columns:**
- `df.loc[rows, cols]` → preferred ✅
- `df.iloc[row_pos, col_pos]` → by position ✅

**The golden rule:** Always use `.loc` or `.iloc` for row selection. Never use plain `df[n]` for rows — it raises an error.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "age":    [25, 30, 28, 35, 22],
    "salary": [75000, 92000, 68000, 105000, 58000],
    "dept":   ["Eng", "Mkt", "Eng", "Fin", "Mkt"]
})

# Select single column → Series
names = df["name"]
print(type(names))    # <class ''pandas.core.series.Series''>

# Select multiple columns → DataFrame
subset = df[["name", "salary"]]
print(type(subset))   # <class ''pandas.core.frame.DataFrame''>

# Select rows by position (iloc)
print(df.iloc[0])      # First row (as Series)
print(df.iloc[0:3])    # Rows 0, 1, 2 (exclusive end)
print(df.iloc[-1])     # Last row

# Select rows AND columns
print(df.iloc[0:3, 0:2])   # Rows 0-2, columns 0-1

# loc with row and column labels
print(df.loc[0:2, "name":"salary"])   # rows 0-2, cols name through salary (inclusive)

# Specific cell
print(df.loc[2, "name"])    # Carol
print(df.iloc[2, 0])        # Carol',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000016',
 'f3000000-0000-0000-0000-000000000002',
 'Filtering Rows with Conditions',
 '## Boolean Filtering in DataFrames

Filtering rows based on conditions is the most common DataFrame operation. It works like boolean indexing in NumPy but with column names.

**Pattern:**
```python
df[df["column"] condition]
```

**Combining conditions:**
- `&` → AND
- `|` → OR
- `~` → NOT
- Always wrap each condition in `()`

**Alternative: `.query()` method:**
`df.query("age > 25 and salary > 70000")` — more readable for complex conditions, uses string expressions.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "age":    [25, 30, 28, 35, 22],
    "salary": [75000, 92000, 68000, 105000, 58000],
    "dept":   ["Eng", "Mkt", "Eng", "Fin", "Mkt"]
})

# Single condition
print(df[df["age"] > 27])
#     name  age  salary dept
# 1    Bob   30   92000  Mkt
# 2  Carol   28   68000  Eng
# 3   Dave   35  105000  Fin

# Multiple conditions — use & and | (not and/or!)
print(df[(df["dept"] == "Eng") & (df["salary"] > 70000)])
#    name  age  salary dept
# 0  Alice   25   75000  Eng

# OR condition
print(df[(df["dept"] == "Fin") | (df["age"] < 25)])
#    name  age  salary dept
# 3  Dave   35  105000  Fin
# 4   Eve   22   58000  Mkt

# .isin() — filter against a list of values
print(df[df["dept"].isin(["Eng", "Fin"])])

# .query() — string-based filtering (cleaner for complex conditions)
result = df.query("age > 25 and salary > 70000")
print(result)
# Bob    30  92000  Mkt
# Dave   35  105000 Fin

# query with variable — use @ prefix
min_salary = 80000
print(df.query("salary > @min_salary"))',
 2);

-- ---- SUBTOPIC 9: Adding & Removing Columns and Rows ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000017',
 'f3000000-0000-0000-0000-000000000003',
 'Adding and Modifying Columns',
 '## Transforming DataFrame Columns

Adding new columns is how you engineer features and transform your data.

**Adding a column:**
- `df["new_col"] = values` → direct assignment ✅ most common
- `df.assign(new_col=values)` → returns a new DataFrame ✅ good for chaining

**Which is better?**
- `df["new"] = ...` → modifies in-place ✅ use in scripts
- `df.assign(new=...)` → returns new DataFrame, does NOT modify original ✅ use in method chains and when you want to keep original

**Computed columns:**
You can derive a new column from existing columns using vectorized operations — no loop needed.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave"],
    "salary": [75000, 92000, 68000, 105000],
    "hours":  [40, 42, 38, 45]
})

# Add a simple new column
df["currency"] = "USD"
print(df)

# Add a computed column — derived from existing columns
df["hourly_rate"] = df["salary"] / (df["hours"] * 52)
df["hourly_rate"] = df["hourly_rate"].round(2)
print(df[["name", "hourly_rate"]])
# Alice: 36.06, Bob: 42.18, Carol: 34.43, Dave: 44.87

# Conditional column using np.where
import numpy as np
df["tier"] = np.where(df["salary"] >= 90000, "Senior", "Junior")
print(df[["name", "salary", "tier"]])

# .assign() — returns new DataFrame (original unchanged)
df2 = df.assign(
    bonus = df["salary"] * 0.10,
    total = df["salary"] * 1.10
)
print(df2[["name", "salary", "bonus", "total"]])

# Rename columns
df = df.rename(columns={"name": "employee_name", "salary": "base_salary"})
print(df.columns)

# Modify existing column (vectorized)
df["base_salary"] = df["base_salary"] * 1.05   # 5% raise for everyone',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000018',
 'f3000000-0000-0000-0000-000000000003',
 'Removing Columns and Rows',
 '## Dropping Data From a DataFrame

**Removing columns:**
- `df.drop("col", axis=1)` → drop by name, axis=1 means columns
- `df.drop(columns=["col1", "col2"])` → preferred ✅ (more readable)

**Removing rows:**
- `df.drop(index)` → drop by row index label
- `df.drop(index=[0, 2])` → drop multiple rows

**inplace parameter:**
- `df.drop(..., inplace=True)` → modifies df directly ⚠️ (can cause bugs)
- `df = df.drop(...)` → reassign ✅ **preferred** (explicit, safer)

**Why avoid inplace=True?**
It can cause unexpected behavior in method chains and makes code harder to debug. Always reassign: `df = df.drop(...)`.

**del keyword:**
`del df["col"]` → also works but is less Pandas-idiomatic. Stick with `.drop()`.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave"],
    "age":    [25, 30, 28, 35],
    "salary": [75000, 92000, 68000, 105000],
    "temp":   [1, 2, 3, 4],     # temporary column
    "notes":  ["ok", None, "ok", None]
})

# Drop a single column — PREFERRED style
df = df.drop(columns=["temp"])
print(df.columns)   # Index([''name'', ''age'', ''salary'', ''notes''])

# Drop multiple columns
df = df.drop(columns=["notes", "age"])
print(df.columns)   # Index([''name'', ''salary''])

# Drop by axis=1 (older style — same result)
# df = df.drop("temp", axis=1)

# Drop rows by index position
df = pd.DataFrame({"a": [1,2,3,4,5], "b": [6,7,8,9,10]})
df = df.drop(index=[0, 2])    # remove rows 0 and 2
print(df)
#    a   b
# 1  2   7
# 3  4   9
# 4  5  10

# Drop rows matching a condition
df2 = pd.DataFrame({
    "name": ["Alice", "Bob", "Carol"],
    "active": [True, False, True]
})
df2 = df2[df2["active"] == True]   # keep only active rows (preferred over drop)
print(df2)',
 2);

-- ---- SUBTOPIC 10: Handling Missing Data ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000019',
 'f4000000-0000-0000-0000-000000000001',
 'Detecting and Handling NaN Values',
 '## Missing Data in Pandas

Missing data is represented as `NaN` (Not a Number) in Pandas — a special float value from NumPy. Pandas also supports `pd.NA` (the pandas-native NA) and `None`.

**Key insight:** Pandas is designed to work with missing data gracefully. Most operations simply skip NaN values by default (e.g., `.mean()` ignores NaN).

**Detection:**
- `df.isnull()` → True where values are NaN
- `df.notnull()` → True where values are NOT NaN
- `df.isnull().sum()` → count of NaN per column
- `df.isnull().sum().sum()` → total NaN in entire DataFrame

**Handling strategies:**
1. **Drop** rows/columns with NaN → `df.dropna()`
2. **Fill** NaN with a value → `df.fillna(value)`
3. **Interpolate** → `df.interpolate()` (time-series)
4. **Leave as-is** → if algorithm handles NaN natively',
 'import pandas as pd
import numpy as np

df = pd.DataFrame({
    "name":   ["Alice", "Bob", None, "Dave", "Eve"],
    "age":    [25, np.nan, 28, 35, np.nan],
    "salary": [75000, 92000, 68000, None, 58000],
    "score":  [88, 91, np.nan, 78, 85]
})

# Detect missing values
print(df.isnull())
print(df.isnull().sum())
# name      1
# age       2
# salary    1
# score     1

print(f"Total missing: {df.isnull().sum().sum()}")   # 5

# Drop rows with ANY NaN
clean = df.dropna()
print(clean)   # only rows with no NaN at all

# Drop rows only if ALL values are NaN
df.dropna(how="all")

# Drop rows missing specific columns
df.dropna(subset=["name", "salary"])   # must have name AND salary

# Drop columns with too many NaN (thresh = min non-null required)
df.dropna(axis=1, thresh=4)   # keep cols with at least 4 non-null values

# Fill NaN with a constant value
df_filled = df.fillna(0)
print(df_filled)

# Fill with column-specific values
df_filled2 = df.fillna({
    "age": df["age"].median(),
    "salary": df["salary"].mean(),
    "score": 0
})
print(df_filled2)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000020',
 'f4000000-0000-0000-0000-000000000001',
 'Filling Strategies and Interpolation',
 '## Smart Ways to Handle Missing Values

Choosing the right fill strategy matters for data quality. The wrong fill can introduce bias.

**Common fill strategies:**
| Strategy | Method | Best for |
|----------|--------|---------|
| Constant value | `fillna(0)` | Counts, binary flags |
| Column mean | `fillna(df.mean())` | Normally distributed data |
| Column median | `fillna(df.median())` | Skewed data, outliers present |
| Mode (most common) | `fillna(df.mode().iloc[0])` | Categorical data |
| Forward fill | `ffill()` | Time-series (carry last known) |
| Backward fill | `bfill()` | Time-series (next known value) |
| Interpolate | `interpolate()` | Time-series, gradual change |

**ffill vs bfill:**
- `ffill()` → propagate last valid value **forward** (most common for stock prices)
- `bfill()` → propagate next valid value **backward**',
 'import pandas as pd
import numpy as np

# Time-series example
prices = pd.Series([100, np.nan, np.nan, 103, np.nan, 107],
                   index=pd.date_range("2024-01-01", periods=6, freq="D"))

print(prices)
# 2024-01-01    100.0
# 2024-01-02      NaN
# 2024-01-03      NaN
# 2024-01-04    103.0
# 2024-01-05      NaN
# 2024-01-06    107.0

# Forward fill — carry last known price
print(prices.ffill())
# 2024-01-01    100.0
# 2024-01-02    100.0   <- filled with previous
# 2024-01-03    100.0   <- filled with previous
# 2024-01-04    103.0
# 2024-01-05    103.0   <- filled with previous
# 2024-01-06    107.0

# Backward fill
print(prices.bfill())
# 2024-01-01    100.0
# 2024-01-02    103.0   <- filled with next valid
# 2024-01-03    103.0   <- filled with next valid

# Interpolate — linear interpolation between known values
print(prices.interpolate())
# 2024-01-01    100.0
# 2024-01-02    101.0   <- interpolated
# 2024-01-03    102.0   <- interpolated
# 2024-01-04    103.0
# 2024-01-05    105.0   <- interpolated
# 2024-01-06    107.0

# For DataFrames — fill per column
df = pd.DataFrame({"A": [1, np.nan, 3], "B": [np.nan, 5, 6]})
df = df.fillna(df.mean())    # fill each column with its own mean',
 2);

-- ---- SUBTOPIC 11: Data Types & Conversion ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000021',
 'f4000000-0000-0000-0000-000000000002',
 'Understanding and Converting Data Types',
 '## dtype Management in DataFrames

Every column in a DataFrame has a dtype. Getting dtypes right is crucial — wrong types cause errors, wasted memory, and incorrect operations.

**Common Pandas dtypes:**
| dtype | What it stores | Notes |
|-------|---------------|-------|
| `int64` | Integers | Default for whole numbers |
| `float64` | Floats | Default if any NaN present |
| `object` | Strings / mixed | Python objects — slow |
| `bool` | True/False | Very memory efficient |
| `datetime64` | Dates and times | Enables time-series ops |
| `category` | Categorical | Great for low-cardinality strings |
| `Int64` (capital I) | Nullable integer | Allows NaN in int column |

**Why `object` dtype is problematic:**
When Pandas sees strings, it uses Python object dtype — each element is a full Python object. This is slow and memory-heavy. Convert to `category` for repeated values.',
 'import pandas as pd
import numpy as np

df = pd.DataFrame({
    "name":     ["Alice", "Bob", "Carol"],
    "age":      ["25", "30", "28"],      # strings, not ints!
    "salary":   [75000.0, 92000.0, 68000.0],
    "date_str": ["2024-01-15", "2024-02-20", "2024-03-10"],
    "dept":     ["Eng", "Mkt", "Eng"]
})

print(df.dtypes)
# name        object
# age         object   <- should be int!
# salary     float64
# date_str    object   <- should be datetime!
# dept        object   <- should be category!

# Convert string "age" to integer
df["age"] = df["age"].astype(int)

# Convert string column to datetime
df["date_str"] = pd.to_datetime(df["date_str"])
print(df["date_str"].dtype)   # datetime64[ns]

# Convert to category — better for low-cardinality strings
df["dept"] = df["dept"].astype("category")
print(df["dept"].dtype)       # category

# Convert float to int (if no NaN)
df["salary"] = df["salary"].astype(int)

# Memory comparison
df_obj  = pd.DataFrame({"dept": ["Eng", "Mkt", "Eng"] * 10000})
df_cat  = df_obj.copy()
df_cat["dept"] = df_cat["dept"].astype("category")

print(f"object:   {df_obj.memory_usage(deep=True).sum():,} bytes")
print(f"category: {df_cat.memory_usage(deep=True).sum():,} bytes")
# category uses ~10x less memory for repeated values!',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000022',
 'f4000000-0000-0000-0000-000000000002',
 'Working with Datetime Data',
 '## Time-Series Operations with Pandas

Pandas has exceptional support for dates and times. Once a column is `datetime64` dtype, you unlock a whole world of time-based operations.

**Creating datetime data:**
- `pd.to_datetime("2024-01-15")` → parse a string
- `pd.to_datetime(series)` → parse a whole column
- `pd.date_range(start, periods, freq)` → generate date ranges

**The `.dt` accessor:**
Like `.str` for strings, `.dt` gives you access to datetime components:
- `.dt.year`, `.dt.month`, `.dt.day`
- `.dt.hour`, `.dt.minute`
- `.dt.day_name()` → "Monday", "Tuesday", etc.
- `.dt.day_of_week` → 0=Monday, 6=Sunday
- `.dt.quarter` → 1, 2, 3, or 4',
 'import pandas as pd

# Parse dates from strings
df = pd.DataFrame({
    "sale_date": ["2024-01-15", "2024-03-22", "2024-07-04",
                  "2024-09-18", "2024-12-01"],
    "amount": [1500, 2200, 800, 3100, 1900]
})

df["sale_date"] = pd.to_datetime(df["sale_date"])

# Extract datetime components using .dt accessor
df["year"]    = df["sale_date"].dt.year
df["month"]   = df["sale_date"].dt.month
df["day"]     = df["sale_date"].dt.day
df["weekday"] = df["sale_date"].dt.day_name()
df["quarter"] = df["sale_date"].dt.quarter

print(df[["sale_date", "weekday", "quarter"]])
#   sale_date   weekday  quarter
# 0 2024-01-15   Monday        1
# 1 2024-03-22   Friday        1
# 2 2024-07-04 Thursday        3
# 3 2024-09-18Wednesday        3
# 4 2024-12-01   Sunday        4

# Filter by date
q1_sales = df[df["quarter"] == 1]
print(q1_sales)

# Date arithmetic
df["days_ago"] = (pd.Timestamp("today") - df["sale_date"]).dt.days
print(df["days_ago"])

# Generate a date range
dates = pd.date_range("2024-01-01", "2024-12-31", freq="ME")  # month end
print(dates[:3])
# DatetimeIndex([''2024-01-31'', ''2024-02-29'', ''2024-03-31''])',
 2);

-- ---- SUBTOPIC 12: Sorting & Ranking ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000023',
 'f4000000-0000-0000-0000-000000000003',
 'Sorting DataFrames',
 '## Ordering Your Data

Sorting lets you arrange data meaningfully — top performers, most recent records, alphabetical order.

**Two main sorting methods:**
- `df.sort_values(by="col")` → sort by column values ✅ most common
- `df.sort_index()` → sort by row index ✅ useful after groupby/merge

**Key parameters for sort_values:**
- `by` → column name or list of column names
- `ascending` → True (default, A→Z, 0→9) or False (Z→A, 9→0)
- `na_position` → "last" (default) or "first" — where NaN goes
- `ignore_index=True` → resets index to 0,1,2,... after sort

**Multi-column sort:**
`df.sort_values(by=["dept", "salary"])` → sort by dept first, then salary within each dept.',
 'import pandas as pd
import numpy as np

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "dept":   ["Eng", "Mkt", "Eng", "Fin", "Mkt"],
    "salary": [75000, 92000, 68000, 105000, np.nan],
    "score":  [88, 71, 95, 82, 78]
})

# Sort by a single column (ascending by default)
print(df.sort_values("salary"))
#     name dept   salary  score
# 2  Carol  Eng  68000.0     95
# 0  Alice  Eng  75000.0     88
# 1    Bob  Mkt  92000.0     71
# 3   Dave  Fin 105000.0     82
# 4    Eve  Mkt      NaN     78   <- NaN goes last by default

# Sort descending (highest salary first)
print(df.sort_values("salary", ascending=False))

# Multi-column sort: sort by dept, then by salary within each dept
print(df.sort_values(by=["dept", "salary"], ascending=[True, False]))

# NaN position control
print(df.sort_values("salary", na_position="first"))  # NaN at top

# Sort and reset index
df_sorted = df.sort_values("salary", ignore_index=True)
print(df_sorted.index)   # RangeIndex(0, 5) — clean 0,1,2,3,4

# Sort by index
df.sort_index()           # restore original order if index is meaningful',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000024',
 'f4000000-0000-0000-0000-000000000003',
 'Ranking and Deduplication',
 '## Ranking Values and Removing Duplicates

**Ranking:**
`df["col"].rank()` assigns a rank to each value (1=smallest by default). Useful for leaderboards, percentile calculations, and relative comparisons.

**Rank methods for ties:**
- `method="average"` → tied values get the average rank (default)
- `method="min"` → tied values get the lowest rank
- `method="max"` → tied values get the highest rank
- `method="dense"` → no gaps in ranking (1, 2, 2, 3 not 1, 2, 2, 4)
- `method="first"` → first occurrence gets lower rank

**Deduplication:**
- `df.duplicated()` → boolean mask of duplicate rows
- `df.drop_duplicates()` → remove duplicate rows
- `df.drop_duplicates(subset=["col"])` → deduplicate based on specific columns',
 'import pandas as pd

# Ranking
df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve", "Frank"],
    "score":  [88, 92, 88, 75, 92, 80]
})

# Default rank (ascending, average for ties)
df["rank"] = df["score"].rank(ascending=False, method="min")
print(df.sort_values("rank"))
#     name  score  rank
# 1    Bob     92   1.0   <- tied for 1st
# 4    Eve     92   1.0   <- tied for 1st
# 0  Alice     88   3.0   <- tied for 3rd
# 2  Carol     88   3.0   <- tied for 3rd
# 5  Frank     80   5.0
# 3   Dave     75   6.0

# Dense rank — no gaps
df["dense_rank"] = df["score"].rank(ascending=False, method="dense")
print(df[["name", "score", "dense_rank"]])
# Bob 92 → 1, Eve 92 → 1, Alice 88 → 2, Carol 88 → 2, Frank 80 → 3

# Deduplication
df2 = pd.DataFrame({
    "id":    [1, 2, 2, 3, 3],
    "name":  ["Alice", "Bob", "Bob", "Carol", "Carol"],
    "score": [88, 92, 92, 75, 75]
})

print(df2.duplicated())          # [False, False, True, False, True]
print(df2.drop_duplicates())     # removes exact duplicate rows

# Deduplicate based on specific columns (keep first occurrence)
print(df2.drop_duplicates(subset=["id"], keep="first"))
print(df2.drop_duplicates(subset=["name"], keep="last"))',
 2);

-- ---- SUBTOPIC 13: GroupBy Operations ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000025',
 'f5000000-0000-0000-0000-000000000001',
 'GroupBy — Split, Apply, Combine',
 '## The Most Powerful Pandas Operation

`groupby()` is how you answer questions like "what is the average salary per department?" or "which product had the most sales each month?" It follows the **Split → Apply → Combine** pattern:

1. **Split** — divide data into groups based on a column
2. **Apply** — compute something on each group
3. **Combine** — merge results back into a single table

**Common aggregation functions:**
- `.sum()`, `.mean()`, `.median()`
- `.min()`, `.max()`, `.count()`
- `.std()`, `.var()`
- `.first()`, `.last()`
- `.agg(["mean", "std"])` → multiple at once

**as_index parameter:**
By default, group keys become the index. Use `as_index=False` to keep them as regular columns (often easier to work with).',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve", "Frank"],
    "dept":   ["Eng",   "Mkt", "Eng",   "Fin",  "Mkt", "Eng"],
    "salary": [75000, 92000, 68000, 105000, 58000, 82000],
    "score":  [88, 71, 95, 82, 78, 90]
})

# Basic groupby — average salary per department
avg_salary = df.groupby("dept")["salary"].mean()
print(avg_salary)
# dept
# Eng    75000.0
# Fin   105000.0
# Mkt    75000.0

# as_index=False — groups become regular columns (preferred for chaining)
result = df.groupby("dept", as_index=False)["salary"].mean()
print(result)
#   dept     salary
# 0  Eng  75000.000
# 1  Fin  105000.000
# 2  Mkt  75000.000

# Multiple aggregations at once
summary = df.groupby("dept")["salary"].agg(["mean", "min", "max", "count"])
print(summary)

# GroupBy multiple columns
df.groupby(["dept", "score"])["salary"].sum()

# Apply different functions to different columns
result2 = df.groupby("dept").agg(
    avg_salary=("salary", "mean"),
    top_score=("score", "max"),
    headcount=("name", "count")
)
print(result2)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000026',
 'f5000000-0000-0000-0000-000000000001',
 'GroupBy with Transform and Filter',
 '## Advanced GroupBy Operations

Beyond basic aggregation, GroupBy supports:

**`.transform()`** — applies a function to each group and returns a result with the **same shape as the original DataFrame**. Essential for adding group-level stats as new columns.

**`.filter()`** — keeps only groups that satisfy a condition.

**`.apply()`** — applies any custom function to each group. Most flexible but slower.

**transform vs agg:**
- `agg` → reduces: group of 5 rows → 1 summary row
- `transform` → preserves shape: group of 5 rows → 5 rows (same index)

Use `transform` when you want to add a group stat as a new column alongside original data.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve", "Frank"],
    "dept":   ["Eng",   "Mkt", "Eng",   "Fin",  "Mkt", "Eng"],
    "salary": [75000, 92000, 68000, 105000, 58000, 82000]
})

# transform — add group mean as new column (same shape as df)
df["dept_avg_salary"] = df.groupby("dept")["salary"].transform("mean")
print(df)
#     name dept  salary  dept_avg_salary
# 0  Alice  Eng   75000        75000.000
# 1    Bob  Mkt   92000        75000.000
# 2  Carol  Eng   68000        75000.000
# 3   Dave  Fin  105000       105000.000
# 4    Eve  Mkt   58000        75000.000
# 5  Frank  Eng   82000        75000.000

# Now we can compute salary vs department average
df["vs_avg"] = df["salary"] - df["dept_avg_salary"]
print(df[["name", "dept", "salary", "vs_avg"]])

# filter — keep only departments with headcount >= 2
large_depts = df.groupby("dept").filter(lambda g: len(g) >= 2)
print(large_depts)   # removes Fin (only 1 person)

# filter — keep only depts where average salary > 80000
high_pay_depts = df.groupby("dept").filter(
    lambda g: g["salary"].mean() > 80000
)
print(high_pay_depts)   # only Fin (avg 105000)

# apply — most flexible, returns custom result per group
def dept_summary(group):
    return pd.Series({
        "top_earner": group.loc[group["salary"].idxmax(), "name"],
        "avg_salary": group["salary"].mean()
    })

print(df.groupby("dept").apply(dept_summary))',
 2);

-- ---- SUBTOPIC 14: Merging & Joining DataFrames ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000027',
 'f5000000-0000-0000-0000-000000000002',
 'Merging DataFrames — SQL-style Joins',
 '## Combining Two DataFrames on a Common Key

`pd.merge()` works like SQL JOINs — it combines two DataFrames based on shared column values.

**Join types:**
| how= | What it does | SQL equivalent |
|------|-------------|----------------|
| `"inner"` | Only matching rows (default) | INNER JOIN |
| `"left"` | All rows from left, NaN for non-matches | LEFT JOIN |
| `"right"` | All rows from right, NaN for non-matches | RIGHT JOIN |
| `"outer"` | All rows from both, NaN for non-matches | FULL OUTER JOIN |

**pd.merge() vs df.join() vs df.merge():**
- `pd.merge(df1, df2, ...)` → standalone function ✅ **most flexible, preferred**
- `df1.merge(df2, ...)` → method on DataFrame ✅ same result, good for chaining
- `df1.join(df2)` → joins on **index** ⚠️ less common, specific use case',
 'import pandas as pd

employees = pd.DataFrame({
    "emp_id": [1, 2, 3, 4, 5],
    "name":   ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "dept_id": [10, 20, 10, 30, 20]
})

departments = pd.DataFrame({
    "dept_id":   [10, 20, 40],
    "dept_name": ["Engineering", "Marketing", "Finance"]
})

# Inner join — only employees with a matching department
inner = pd.merge(employees, departments, on="dept_id", how="inner")
print(inner)
#    emp_id   name  dept_id     dept_name
# 0       1  Alice       10   Engineering
# 1       3  Carol       10   Engineering
# 2       2    Bob       20     Marketing
# 3       5    Eve       20     Marketing
# Dave (dept_id=30) dropped — no match in departments

# Left join — keep ALL employees
left = pd.merge(employees, departments, on="dept_id", how="left")
print(left)
# Dave appears with NaN for dept_name (no dept 30 in departments)

# Outer join — keep everything from both
outer = pd.merge(employees, departments, on="dept_id", how="outer")
# Finance (dept_id=40) appears with NaN for emp columns

# Different column names in each DataFrame
orders = pd.DataFrame({"order_id": [1,2], "customer_id": [101, 102]})
customers = pd.DataFrame({"id": [101, 102], "name": ["Alice", "Bob"]})
merged = pd.merge(orders, customers, left_on="customer_id", right_on="id")',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000028',
 'f5000000-0000-0000-0000-000000000002',
 'Concatenating DataFrames',
 '## Stacking DataFrames Together

While `merge()` joins DataFrames horizontally on shared keys, `pd.concat()` stacks them vertically (rows) or horizontally (columns).

**When to use concat vs merge:**
- `concat` → combining same-structure DataFrames (e.g., monthly sales files, data from different years)
- `merge` → combining DataFrames that share a key column (e.g., employees + departments)

**Key parameters:**
- `axis=0` → stack vertically (add rows) — **default and most common**
- `axis=1` → stack horizontally (add columns)
- `ignore_index=True` → reset index to 0,1,2,...
- `keys=["q1","q2"]` → add a multi-level index to track source',
 'import pandas as pd

# Monthly sales data — same structure, different months
jan = pd.DataFrame({"product": ["A", "B", "C"], "sales": [100, 200, 150]})
feb = pd.DataFrame({"product": ["A", "B", "C"], "sales": [120, 180, 160]})
mar = pd.DataFrame({"product": ["A", "B", "C"], "sales": [140, 220, 175]})

# Stack vertically (most common use case)
all_months = pd.concat([jan, feb, mar], ignore_index=True)
print(all_months)
#   product  sales
# 0       A    100
# 1       B    200
# ...continues through 9

# Track which DataFrame each row came from
all_months_labeled = pd.concat(
    [jan, feb, mar],
    keys=["Jan", "Feb", "Mar"],
    ignore_index=False
)
print(all_months_labeled)
# Jan  0  A  100
#      1  B  200
# Feb  0  A  120
# ...

# Horizontal concat — add columns side by side
names = pd.DataFrame({"name": ["Alice", "Bob", "Carol"]})
scores = pd.DataFrame({"math": [88, 72, 95], "english": [76, 85, 91]})
combined = pd.concat([names, scores], axis=1)
print(combined)
#     name  math  english
# 0  Alice    88       76
# 1    Bob    72       85
# 2  Carol    95       91',
 2);

-- ---- SUBTOPIC 15: Apply, Map & Transform ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000029',
 'f5000000-0000-0000-0000-000000000003',
 'apply() — Custom Functions on DataFrames',
 '## Applying Functions Row-wise or Column-wise

`.apply()` applies a function across a DataFrame''s rows or columns. It is the "escape hatch" when no built-in vectorized function exists.

**On a Series:**
`series.apply(func)` → applies func to each element

**On a DataFrame:**
`df.apply(func, axis=0)` → applies func to each **column** (default)
`df.apply(func, axis=1)` → applies func to each **row**

**Performance hierarchy (fastest first):**
1. Vectorized NumPy/Pandas operations → always prefer
2. `.str.*` / `.dt.*` accessor methods
3. `np.where()` / `np.vectorize()`
4. `.apply()` → use only when nothing above works (it is a Python loop)

**When to use apply:**
- Custom complex logic on rows
- Calling external APIs or functions that do not work on arrays
- Transformations across multiple columns simultaneously',
 'import pandas as pd
import numpy as np

df = pd.DataFrame({
    "name":  ["Alice", "Bob", "Carol", "Dave"],
    "math":  [88, 72, 95, 61],
    "english": [76, 85, 91, 70],
    "science": [90, 68, 88, 75]
})

# apply on a column (Series)
def grade(score):
    if score >= 90: return "A"
    elif score >= 80: return "B"
    elif score >= 70: return "C"
    else: return "F"

df["math_grade"] = df["math"].apply(grade)
print(df[["name", "math", "math_grade"]])

# apply across columns (axis=0) — function receives each column as a Series
col_means = df[["math", "english", "science"]].apply(lambda col: col.mean())
print(col_means)   # mean of each subject

# apply across rows (axis=1) — function receives each row as a Series
df["avg_score"] = df[["math", "english", "science"]].apply(
    lambda row: row.mean(), axis=1
)

df["best_subject"] = df[["math", "english", "science"]].apply(
    lambda row: row.idxmax(), axis=1  # column name of highest score
)
print(df[["name", "avg_score", "best_subject"]])

# Lambda shorthand — good for simple one-liners
df["math_curved"] = df["math"].apply(lambda x: min(x + 5, 100))

# Prefer vectorized when possible!
df["avg_score_fast"] = df[["math","english","science"]].mean(axis=1)  # FASTER',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000030',
 'f5000000-0000-0000-0000-000000000003',
 'map() and replace() for Value Substitution',
 '## Replacing Values in a Series or DataFrame

When you need to substitute values based on a mapping (e.g., category codes to labels, abbreviations to full names), Pandas offers clean tools.

**For Series:**
- `series.map(dict)` → map values using a dict ✅ best for value substitution
- `series.map(func)` → apply function to each element ✅ flexible
- `series.replace(old, new)` → replace specific values ✅ simpler

**For DataFrame:**
- `df.replace(old, new)` → works across whole DataFrame
- `df["col"].map(dict)` → map one column

**map() vs apply() vs replace():**
- `.map(dict)` → cleanest for label encoding / category mapping ✅
- `.apply(func)` → most flexible for complex logic ✅
- `.replace()` → simplest for swapping specific values ✅

Values not found in the mapping dict become `NaN` with `.map()`. Use `.fillna()` afterwards if needed.',
 'import pandas as pd

df = pd.DataFrame({
    "name": ["Alice", "Bob", "Carol", "Dave", "Eve"],
    "dept_code": ["ENG", "MKT", "ENG", "FIN", "MKT"],
    "status":    [1, 0, 1, 1, 0],
    "grade":     ["A", "B", "A", "C", "B"]
})

# map() — replace using a dictionary (best for label encoding)
dept_full = {"ENG": "Engineering", "MKT": "Marketing", "FIN": "Finance"}
df["department"] = df["dept_code"].map(dept_full)
print(df[["name", "dept_code", "department"]])

# map() with missing key → NaN
df["dept2"] = df["dept_code"].map({"ENG": "Engineering"})
print(df["dept2"])   # MKT and FIN become NaN

# replace() — simpler syntax for direct substitution
df["status_label"] = df["status"].replace({1: "Active", 0: "Inactive"})
print(df[["name", "status", "status_label"]])

# replace() across whole DataFrame
df_clean = df.replace({"A": "Excellent", "B": "Good", "C": "Average"})

# Chained map + fillna — handle missing mappings gracefully
category_map = {"ENG": "Tech"}
df["category"] = df["dept_code"].map(category_map).fillna("Other")
print(df["category"])
# ENG→Tech, MKT→Other, FIN→Other',
 2);

-- ---- SUBTOPIC 16: Reading & Writing Files ----

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000031',
 'f5000000-0000-0000-0000-000000000004',
 'Reading Data — CSV, Excel, JSON',
 '## Loading Data Into Pandas

In real work, you rarely create DataFrames manually. You load them from files or databases.

**Common read functions:**
| Function | Format |
|----------|--------|
| `pd.read_csv("file.csv")` | CSV (most common) |
| `pd.read_excel("file.xlsx")` | Excel |
| `pd.read_json("file.json")` | JSON |
| `pd.read_sql(query, conn)` | SQL database |
| `pd.read_parquet("file.parquet")` | Parquet (efficient columnar) |
| `pd.read_html(url)` | Tables from web pages |

**Most important `read_csv` parameters:**
- `sep` → delimiter (default `,`, use `\t` for TSV)
- `header` → row number for column names (default 0)
- `index_col` → column to use as row index
- `parse_dates` → list of columns to parse as dates
- `na_values` → additional strings to treat as NaN
- `usecols` → only load specific columns (faster for large files)
- `nrows` → only load first n rows (useful for previewing)',
 'import pandas as pd

# Basic CSV read
df = pd.read_csv("data.csv")

# Read CSV with options
df = pd.read_csv(
    "sales_data.csv",
    sep=",",                       # delimiter
    header=0,                      # first row is header
    index_col="order_id",          # use this column as index
    parse_dates=["sale_date"],     # parse as datetime
    na_values=["N/A", "-", "?"],   # treat these as NaN
    usecols=["name", "amount", "sale_date"],  # only load these columns
    nrows=1000                     # only first 1000 rows
)

# Peek at the data immediately after loading
print(df.shape)
df.info()
print(df.head())
print(df.isnull().sum())

# Read Excel (requires openpyxl: pip install openpyxl)
df_excel = pd.read_excel("report.xlsx", sheet_name="Sheet1")

# Read JSON
df_json = pd.read_json("data.json")

# Read from URL (works with direct CSV links)
# df_web = pd.read_csv("https://example.com/data.csv")

# Read TSV (tab-separated)
df_tsv = pd.read_csv("data.tsv", sep="\t")

# Preview large file without loading all
df_preview = pd.read_csv("huge_file.csv", nrows=5)
print(df_preview)',
 1);

INSERT INTO concepts (id, subtopic_id, title, content, code_examples, display_order) VALUES
('fc000000-0000-0000-0000-000000000032',
 'f5000000-0000-0000-0000-000000000004',
 'Writing Data — Saving DataFrames to Files',
 '## Exporting Your Results

After cleaning and analyzing data, you often need to save the results.

**Common write functions:**
| Function | Format |
|----------|--------|
| `df.to_csv("file.csv")` | CSV |
| `df.to_excel("file.xlsx")` | Excel |
| `df.to_json("file.json")` | JSON |
| `df.to_parquet("file.parquet")` | Parquet (recommended for large data) |
| `df.to_sql(table, conn)` | SQL database |

**Most important `to_csv` parameters:**
- `index=False` → **always set this** to avoid saving the row index as a column
- `sep` → delimiter
- `encoding` → file encoding (default "utf-8")
- `float_format` → format floats (e.g., `"%.2f"`)

**Why Parquet?**
Parquet is a columnar format that is much faster to read/write and much smaller than CSV for large datasets. It also preserves dtypes. Use it for any file over ~100MB.',
 'import pandas as pd

df = pd.DataFrame({
    "name":   ["Alice", "Bob", "Carol"],
    "salary": [75000.5, 92000.25, 68000.75],
    "dept":   ["Eng", "Mkt", "Eng"]
})

# Write to CSV — ALWAYS use index=False to avoid extra index column
df.to_csv("output.csv", index=False)

# Read it back — should match original
df_back = pd.read_csv("output.csv")
print(df_back)

# Write with options
df.to_csv(
    "output_formatted.csv",
    index=False,
    sep=",",
    encoding="utf-8",
    float_format="%.2f"    # round floats to 2 decimal places
)

# Write to Excel (requires openpyxl)
df.to_excel("output.xlsx", index=False, sheet_name="Results")

# Write multiple sheets to one Excel file
with pd.ExcelWriter("report.xlsx") as writer:
    df.to_excel(writer, sheet_name="Data", index=False)
    df.describe().to_excel(writer, sheet_name="Summary")

# Write to JSON
df.to_json("output.json", orient="records", indent=2)
# orient="records" → list of dicts [{"name":"Alice",...}, ...]

# Write to Parquet (RECOMMENDED for large data — fast + preserves dtypes)
# df.to_parquet("data.parquet", index=False)
# df_back = pd.read_parquet("data.parquet")  # dtypes preserved!

print("Files saved successfully!")',
 2);
