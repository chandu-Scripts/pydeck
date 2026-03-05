import { useState } from 'react'

// Wraps SQL in Python sqlite3 to run via Piston v1
function wrapSqlInPython(sql) {
  return `
import sqlite3
conn = sqlite3.connect(':memory:')
c = conn.cursor()

# Create sample tables
c.executescript("""
CREATE TABLE students (id INTEGER PRIMARY KEY, name TEXT, age INTEGER, grade TEXT, marks INTEGER);
INSERT INTO students VALUES (1,'Alice',20,'A',95),(2,'Bob',21,'B',78),(3,'Charlie',19,'A',91),(4,'Diana',22,'C',65),(5,'Eve',20,'B',82),(6,'Frank',21,'A',88);

CREATE TABLE courses (id INTEGER PRIMARY KEY, name TEXT, instructor TEXT, credits INTEGER);
INSERT INTO courses VALUES (1,'Python Basics','Dr. Smith',3),(2,'MySQL','Dr. Jones',4),(3,'Flask','Prof. Lee',3),(4,'Django','Dr. Smith',4),(5,'NumPy','Prof. Ray',3);

CREATE TABLE enrollments (student_id INTEGER, course_id INTEGER, grade TEXT);
INSERT INTO enrollments VALUES (1,1,'A'),(1,2,'B'),(2,1,'B'),(2,3,'C'),(3,2,'A'),(3,4,'A'),(4,1,'C'),(5,2,'B'),(5,5,'A'),(6,3,'B');

CREATE TABLE products (id INTEGER PRIMARY KEY, name TEXT, price REAL, category TEXT, stock INTEGER);
INSERT INTO products VALUES (1,'Laptop',999.99,'Electronics',50),(2,'Phone',599.99,'Electronics',120),(3,'Desk',299.99,'Furniture',30),(4,'Chair',199.99,'Furniture',75),(5,'Monitor',349.99,'Electronics',60),(6,'Keyboard',79.99,'Electronics',200);

CREATE TABLE orders (id INTEGER PRIMARY KEY, product_id INTEGER, quantity INTEGER, total REAL, order_date TEXT);
INSERT INTO orders VALUES (1,1,2,1999.98,'2024-01-10'),(2,2,1,599.99,'2024-01-11'),(3,3,3,899.97,'2024-01-12'),(4,5,1,349.99,'2024-01-13'),(5,6,5,399.95,'2024-01-14'),(6,1,1,999.99,'2024-01-15');
""")

try:
    c.execute(${JSON.stringify(sql)})
    rows = c.fetchall()
    if rows:
        cols = [d[0] for d in c.description]
        print('|'.join(cols))
        print('-' * 40)
        for row in rows:
            print('|'.join(str(v) for v in row))
    else:
        print('Query executed successfully. (no rows returned)')
except Exception as e:
    print(f'Error: {e}')

conn.close()
`
}

export function useSqlRunner() {
  const [output, setOutput] = useState('')
  const [columns, setColumns] = useState([])
  const [rows, setRows] = useState([])
  const [running, setRunning] = useState(false)
  const [error, setError] = useState(false)
  const dbReady = true

  async function run(sql) {
    if (!sql.trim()) return
    setRunning(true)
    setError(false)
    setOutput('')
    setColumns([])
    setRows([])

    try {
      const pythonCode = wrapSqlInPython(sql.trim())
      const res = await fetch('https://emkc.org/api/v1/piston/execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ language: 'python3', source: pythonCode }),
      })
      const data = await res.json()
      const out = (data.output || '').trim()

      if (!out) {
        setOutput('(no output)')
        return
      }

      // Parse table output
      const lines = out.split('\n')
      if (lines.length >= 2 && lines[1].startsWith('---')) {
        const cols = lines[0].split('|')
        const dataRows = lines.slice(2).filter(l => l.trim()).map(l => l.split('|'))
        setColumns(cols)
        setRows(dataRows)
      } else {
        // Plain text output (INSERT, CREATE, errors etc.)
        setOutput(out)
        if (out.startsWith('Error:')) setError(true)
      }
    } catch {
      setOutput('Could not connect to code runner. Please try again.')
      setError(true)
    } finally {
      setRunning(false)
    }
  }

  function clear() {
    setOutput('')
    setColumns([])
    setRows([])
    setError(false)
  }

  function resetDb() {
    clear()
  }

  return { run, output, columns, rows, running, error, dbReady, clear, resetDb }
}
