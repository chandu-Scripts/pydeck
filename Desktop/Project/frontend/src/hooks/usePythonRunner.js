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
      // Piston v1 — no auth required
      const res = await fetch('https://emkc.org/api/v1/piston/execute', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          language: 'python3',
          source: code,
        }),
      })

      const data = await res.json()
      const out = (data.output || '').trim()
      setOutput(out || '(no output)')
      if (data.stderr) setError(true)
    } catch (e) {
      setOutput('Could not connect to code runner. Please try again.')
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
