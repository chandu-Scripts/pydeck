import { useEffect, useRef, useState, useCallback } from 'react'

const EVENTS = ['mousemove', 'mousedown', 'keydown', 'touchstart', 'scroll', 'click']

export function useInactivityTimer({
  timeoutMs = 30 * 60 * 1000,
  warningMs = 29 * 60 * 1000,
  onTimeout,
} = {}) {
  const [showWarning, setShowWarning] = useState(false)
  const warningTimer = useRef(null)
  const logoutTimer = useRef(null)

  const clearTimers = useCallback(() => {
    clearTimeout(warningTimer.current)
    clearTimeout(logoutTimer.current)
  }, [])

  const resetTimer = useCallback(() => {
    clearTimers()
    setShowWarning(false)

    warningTimer.current = setTimeout(() => {
      setShowWarning(true)
    }, warningMs)

    logoutTimer.current = setTimeout(() => {
      setShowWarning(false)
      onTimeout?.()
    }, timeoutMs)
  }, [warningMs, timeoutMs, onTimeout, clearTimers])

  useEffect(() => {
    resetTimer()

    EVENTS.forEach(event => window.addEventListener(event, resetTimer, { passive: true }))

    return () => {
      clearTimers()
      EVENTS.forEach(event => window.removeEventListener(event, resetTimer))
    }
  }, [resetTimer, clearTimers])

  return { showWarning, resetTimer }
}
