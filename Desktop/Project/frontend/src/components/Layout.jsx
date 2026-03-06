import { useState, useEffect, useCallback } from 'react'
import { Outlet, useLocation, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import BottomNav from './BottomNav'
import { useAuth } from '../contexts/AuthContext'
import { useInactivityTimer } from '../hooks/useInactivityTimer'
import { useOnlineStatus } from '../hooks/useOnlineStatus'
import { useFontSize } from '../hooks/useFontSize'

function InactivityWarningModal({ onStay, countdown }) {
  return (
    <div className="fixed inset-0 z-[100] flex items-center justify-center p-5 bg-black/70 backdrop-blur-sm">
      <motion.div
        className="bg-gradient-to-b from-navy-700 to-navy-800 border border-orange-500/30 rounded-2xl p-6 max-w-sm w-full shadow-2xl"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        exit={{ opacity: 0, scale: 0.9 }}
      >
        <div className="flex flex-col items-center text-center gap-4">
          <div className="w-16 h-16 rounded-full bg-orange-500/20 border border-orange-500/30 flex items-center justify-center">
            <span className="text-3xl font-bold text-orange-400">{countdown}</span>
          </div>
          <div>
            <h3 className="text-white text-xl font-bold mb-1">Still there?</h3>
            <p className="text-gray-400 text-sm">
              You've been inactive for a while. Signing out in {countdown}s...
            </p>
          </div>
          <motion.button
            onClick={onStay}
            className="w-full py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/40 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors"
            whileTap={{ scale: 0.97 }}
          >
            Stay Signed In
          </motion.button>
        </div>
      </motion.div>
    </div>
  )
}

export default function Layout() {
  const location = useLocation()
  const navigate = useNavigate()
  const { signOut } = useAuth()
  const hideNav = location.pathname.startsWith('/study/')
  const isOnline = useOnlineStatus()
  useFontSize() // applies saved font size on every page
  const [countdown, setCountdown] = useState(60)

  const handleTimeout = useCallback(async () => {
    await signOut()
    navigate('/login')
  }, [signOut, navigate])

  const { showWarning, resetTimer } = useInactivityTimer({
    timeoutMs: 30 * 60 * 1000,
    warningMs: 29 * 60 * 1000,
    onTimeout: handleTimeout,
  })

  // Countdown when warning is showing
  useEffect(() => {
    if (!showWarning) {
      setCountdown(60)
      return
    }
    setCountdown(60)
    const interval = setInterval(() => {
      setCountdown(prev => {
        if (prev <= 1) {
          clearInterval(interval)
          return 0
        }
        return prev - 1
      })
    }, 1000)
    return () => clearInterval(interval)
  }, [showWarning])

  return (
    <div className="min-h-screen bg-navy-900 relative">
      {/* Offline banner */}
      <AnimatePresence>
        {!isOnline && (
          <motion.div
            className="fixed top-0 left-0 right-0 z-[200] bg-orange-500 text-white text-center py-2 text-xs font-semibold"
            initial={{ y: -40 }}
            animate={{ y: 0 }}
            exit={{ y: -40 }}
          >
            You're offline — showing cached content
          </motion.div>
        )}
      </AnimatePresence>
      <div className="absolute inset-0 bg-gradient-to-br from-navy-900 via-navy-800 to-[#0d1a2e] pointer-events-none" />
      <div className="relative z-10 pb-20 lg:pb-0 lg:pl-64">
        <div className="max-w-2xl mx-auto lg:max-w-5xl">
          <Outlet />
        </div>
      </div>
      {!hideNav && <BottomNav />}

      <AnimatePresence>
        {showWarning && (
          <InactivityWarningModal
            onStay={resetTimer}
            countdown={countdown}
          />
        )}
      </AnimatePresence>
    </div>
  )
}
