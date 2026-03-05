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
  const onTimeoutRef = useRef(onTimeout)

  // Always keep ref current without triggering re-renders
  useEffect(() => {
    onTimeoutRef.current = onTimeout
  }, [onTimeout])

  const resetTimer = useCallback(() => {
    clearTimeout(warningTimer.current)
    clearTimeout(logoutTimer.current)
    setShowWarning(false)

    warningTimer.current = setTimeout(() => {
      setShowWarning(true)
    }, warningMs)

    logoutTimer.current = setTimeout(() => {
      setShowWarning(false)
      onTimeoutRef.current?.()
    }, timeoutMs)
  }, [warningMs, timeoutMs])

  useEffect(() => {
    resetTimer()
    EVENTS.forEach(event => window.addEventListener(event, resetTimer, { passive: true }))
    return () => {
      clearTimeout(warningTimer.current)
      clearTimeout(logoutTimer.current)
      EVENTS.forEach(event => window.removeEventListener(event, resetTimer))
    }
  }, [resetTimer])

  return { showWarning, resetTimer }
}
