import { useState } from 'react'

export function usePythonRunner() {
  const [output, setOutput] = useState('')
  const [running, setRunning] = useState(false)
  const [error, setError] = useState(false)

  async function run(code) {
    if (!code.trim()) return
    setRunning(true)
    setError(false)
    setOutput('')

    try {
      const res = await fetch('https://emkc.org/api/v2/piston/execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          language: 'python',
          version: '3.10.0',
          files: [{ name: 'main.py', content: code }],
        }),
      })

      if (!res.ok) {
        setOutput(`Error: Server returned ${res.status}`)
        setError(true)
        return
      }

      const data = await res.json()

      // Piston returns data.run.output which combines stdout + stderr
      const out = data.run?.output?.trim() || data.run?.stdout?.trim() || data.run?.stderr?.trim() || ''
      setOutput(out || '(no output)')
      if (data.run?.stderr?.trim()) setError(true)
    } catch (e) {
      setOutput('Network error — could not reach the code runner.\n' + e.message)
      setError(true)
    } finally {
      setRunning(false)
    }
  }

  function clear() {
    setOutput('')
    setError(false)
  }

  return { run, output, running, error, clear }
}
