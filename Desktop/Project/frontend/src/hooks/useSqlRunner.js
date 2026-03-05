import { useState, useRef, useEffect } from 'react'

const SAMPLE_SETUP = `
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
`

export function useSqlRunner() {
  const [output, setOutput] = useState('')
  const [columns, setColumns] = useState([])
  const [rows, setRows] = useState([])
  const [running, setRunning] = useState(false)
  const [error, setError] = useState(false)
  const [dbReady, setDbReady] = useState(false)
  const dbRef = useRef(null)

  useEffect(() => {
    async function initDb() {
      try {
        const initSqlJs = (await import('sql.js')).default
        const SQL = await initSqlJs({
          locateFile: file => `/${file}`
        })
        const db = new SQL.Database()
        db.run(SAMPLE_SETUP)
        dbRef.current = db
        setDbReady(true)
      } catch (e) {
        setOutput('Failed to load SQL engine: ' + e.message)
        setError(true)
      }
    }
    initDb()
  }, [])

  function run(sql) {
    if (!sql.trim() || !dbRef.current) return
    setRunning(true)
    setError(false)
    setOutput('')
    setColumns([])
    setRows([])

    try {
      const results = dbRef.current.exec(sql)
      if (results.length === 0) {
        setOutput('Query executed successfully. (no rows returned)')
      } else {
        setColumns(results[0].columns)
        setRows(results[0].values)
      }
    } catch (e) {
      setOutput(e.message)
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
    if (!dbRef.current) return
    dbRef.current.run('DROP TABLE IF EXISTS students; DROP TABLE IF EXISTS courses; DROP TABLE IF EXISTS enrollments; DROP TABLE IF EXISTS products; DROP TABLE IF EXISTS orders;')
    dbRef.current.run(SAMPLE_SETUP)
    clear()
  }

  return { run, output, columns, rows, running, error, dbReady, clear, resetDb }
}
