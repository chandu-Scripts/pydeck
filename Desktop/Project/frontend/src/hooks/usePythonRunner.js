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
          files: [{ content: code }],
        }),
      })
      const data = await res.json()
      const stdout = data.run?.stdout ?? ''
      const stderr = data.run?.stderr ?? ''
      const out = (stdout + stderr).trim()
      setOutput(out || '(no output)')
      if (stderr) setError(true)
    } catch {
      setOutput('Network error — could not reach the code runner.')
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
