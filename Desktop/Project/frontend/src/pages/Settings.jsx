import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, ChevronRight, Bell, Type, Globe, Lock, Mail, Target, Clock, Shield, Trash2, Users } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { useFontSize } from '../hooks/useFontSize'
import { useTheme, THEMES } from '../hooks/useTheme'
import { useAuth } from '../contexts/AuthContext'

function SectionLabel({ text, gradient }) {
  return (
    <span className="block px-2 mb-2 text-[11px] font-bold tracking-widest uppercase"
      style={{ background: gradient, WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
      {text}
    </span>
  )
}

function Row({ iconBg, icon, label, subtitle, onClick, delay = 0, danger }) {
  return (
    <motion.button
      onClick={onClick}
      initial={{ opacity: 0, x: -14 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay, duration: 0.28, ease: 'easeOut' }}
      whileTap={{ scale: 0.97 }}
      className={`w-full flex items-center gap-4 px-4 py-3.5 transition-colors ${danger ? 'hover:bg-red-500/5' : 'hover:bg-white/5'}`}
    >
      <div className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg" style={{ background: iconBg }}>
        {icon}
      </div>
      <div className="flex-1 text-left">
        <p className={`text-sm font-semibold ${danger ? 'text-red-400' : 'text-white'}`}>{label}</p>
        <p className="text-gray-500 text-xs mt-0.5">{subtitle}</p>
      </div>
      <ChevronRight size={15} className="text-gray-600" />
    </motion.button>
  )
}

function Card({ children }) {
  return (
    <div className="rounded-2xl overflow-hidden border border-white/8 divide-y divide-white/6" style={{ background: '#0d1525' }}>
      {children}
    </div>
  )
}

export default function Settings() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const { size } = useFontSize()
  const { accent } = useTheme()

  // Only show Change Password for email+password users (not Google/OTP)
  const provider = user?.app_metadata?.provider
  const hasPassword = provider === 'email' && !user?.app_metadata?.providers?.includes('google')
  const [showClearConfirm, setShowClearConfirm] = useState(false)
  const [cleared, setCleared] = useState(false)

  const currentTheme = THEMES.find(t => t.id === accent) || THEMES[0]
  const fontLabel  = size === 'normal' ? 'Default' : size === 'large' ? 'Large' : 'Extra Large'
  const pushOn     = localStorage.getItem('pydeck_notif_push') === 'true'
  const emailOn    = localStorage.getItem('pydeck_notif_email') !== 'false'
  const goalVal    = localStorage.getItem('pydeck_daily_goal') || '10'
  const reminderOn = localStorage.getItem('pydeck_reminder_on') === 'true'
  const leaderOn   = localStorage.getItem('pydeck_leaderboard') !== 'false'
  const lang       = 'English'

  function handleClearCache() {
    const keep = ['pydeck_theme', 'pydeck_accent', 'pydeck_font', 'pydeck_daily_goal', 'pydeck_reminder_time', 'pydeck_reminder_on', 'pydeck_leaderboard', 'pydeck_notif_email', 'pydeck_notif_push', 'pydeck_login_time']
    Object.keys(localStorage).forEach(k => { if (!keep.includes(k)) localStorage.removeItem(k) })
    setCleared(true)
    setShowClearConfirm(false)
    setTimeout(() => setCleared(false), 2000)
  }

  function handleLeaderboardToggle() {
    const next = !leaderOn
    localStorage.setItem('pydeck_leaderboard', String(next))
    // Force re-render
    window.dispatchEvent(new Event('storage'))
  }

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>

      {/* Header */}
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <h1 className="text-white font-bold text-lg">Settings</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28 flex flex-col gap-5">

        {/* Appearance */}
        <div>
          <SectionLabel text="Appearance" gradient="linear-gradient(90deg, #22d3ee, #818cf8)" />
          <Card>
            <Row delay={0.04} onClick={() => navigate('/settings/theme')}
              iconBg={`linear-gradient(135deg, ${currentTheme.c400}, ${currentTheme.c600})`}
              icon={<svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2.2" strokeLinecap="round"><circle cx="12" cy="12" r="4"/><path d="M12 2v2M12 20v2M4.93 4.93l1.41 1.41M17.66 17.66l1.41 1.41M2 12h2M20 12h2M4.93 19.07l1.41-1.41M17.66 6.34l1.41-1.41"/></svg>}
              label="Theme Color" subtitle={currentTheme.label} />
            <Row delay={0.07} onClick={() => navigate('/settings/font')}
              iconBg="linear-gradient(135deg, #3b82f6, #1d4ed8)"
              icon={<Type size={17} color="white" />}
              label="Font Size" subtitle={fontLabel} />
          </Card>
        </div>

        {/* Notifications */}
        <div>
          <SectionLabel text="Notifications" gradient="linear-gradient(90deg, #f43f5e, #fb923c)" />
          <Card>
            <Row delay={0.1} onClick={() => navigate('/settings/notifications')}
              iconBg="linear-gradient(135deg, #f43f5e, #be123c)"
              icon={<Bell size={17} color="white" />}
              label="Notifications" subtitle={pushOn || emailOn ? 'Some enabled' : 'All off'} />
          </Card>
        </div>

        {/* Account */}
        <div>
          <SectionLabel text="Account" gradient="linear-gradient(90deg, #a855f7, #6366f1)" />
          <Card>
            {hasPassword && (
              <Row delay={0.13} onClick={() => navigate('/settings/password')}
                iconBg="linear-gradient(135deg, #8b5cf6, #6d28d9)"
                icon={<Lock size={17} color="white" />}
                label="Change Password" subtitle="Update your password" />
            )}
            <Row delay={0.16} onClick={() => navigate('/settings/email')}
              iconBg="linear-gradient(135deg, #3b82f6, #1d4ed8)"
              icon={<Mail size={17} color="white" />}
              label="Change Email" subtitle="Update your email address" />
          </Card>
        </div>

        {/* App */}
        <div>
          <SectionLabel text="App" gradient="linear-gradient(90deg, #22c55e, #0891b2)" />
          <Card>
            <Row delay={0.19} onClick={() => navigate('/settings/language')}
              iconBg="linear-gradient(135deg, #22d3ee, #0891b2)"
              icon={<Globe size={17} color="white" />}
              label="Language" subtitle={lang} />

            {/* Clear Cache */}
            <motion.button
              initial={{ opacity: 0, x: -14 }} animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.22, duration: 0.28 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => setShowClearConfirm(true)}
              className="w-full flex items-center gap-4 px-4 py-3.5 hover:bg-white/5 transition-colors"
            >
              <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow-lg"
                style={{ background: 'linear-gradient(135deg, #f97316, #c2410c)' }}>
                <Trash2 size={17} color="white" />
              </div>
              <div className="flex-1 text-left">
                <p className="text-white text-sm font-semibold">Clear Cache</p>
                <p className="text-gray-500 text-xs">{cleared ? '✓ Cache cleared!' : 'Free up space, reset cached data'}</p>
              </div>
              <ChevronRight size={15} className="text-gray-600" />
            </motion.button>

            {/* App Version */}
            <motion.div
              initial={{ opacity: 0, x: -14 }} animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.25, duration: 0.28 }}
              className="flex items-center gap-4 px-4 py-3.5"
            >
              <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow-lg"
                style={{ background: 'linear-gradient(135deg, #64748b, #334155)' }}>
                <svg width="17" height="17" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round"><circle cx="12" cy="12" r="10"/><path d="M12 8v4l3 3"/></svg>
              </div>
              <div className="flex-1 text-left">
                <p className="text-white text-sm font-semibold">App Version</p>
                <p className="text-gray-500 text-xs">PyDeck v1.0.0</p>
              </div>
              <span className="text-xs text-gray-600 bg-white/5 px-2 py-0.5 rounded-full border border-white/8">Latest</span>
            </motion.div>
          </Card>
        </div>

        {/* Privacy */}
        <div>
          <SectionLabel text="Privacy" gradient="linear-gradient(90deg, #22c55e, #0d9488)" />
          <Card>
            {/* Show on Leaderboard toggle */}
            <motion.div initial={{ opacity: 0, x: -14 }} animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.28, duration: 0.28 }}
              className="flex items-center gap-4 px-4 py-3.5">
              <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow-lg"
                style={{ background: 'linear-gradient(135deg, #f59e0b, #b45309)' }}>
                <Users size={17} color="white" />
              </div>
              <div className="flex-1 text-left">
                <p className="text-white text-sm font-semibold">Show on Leaderboard</p>
                <p className="text-gray-500 text-xs">{leaderOn ? 'Visible to others' : 'Hidden from leaderboard'}</p>
              </div>
              <button onClick={handleLeaderboardToggle}
                className={`relative w-12 h-6 rounded-full transition-colors duration-300 ${leaderOn ? 'bg-cyan-500' : 'bg-white/20'}`}>
                <motion.div className="absolute top-0.5 w-5 h-5 bg-white rounded-full shadow"
                  animate={{ left: leaderOn ? '26px' : '2px' }}
                  transition={{ type: 'spring', stiffness: 500, damping: 30 }} />
              </button>
            </motion.div>

            <Row delay={0.31} onClick={() => navigate('/settings/privacy')}
              iconBg="linear-gradient(135deg, #22c55e, #15803d)"
              icon={<Shield size={17} color="white" />}
              label="Data & Privacy" subtitle="View your data, delete account" />
          </Card>
        </div>

        {/* Study */}
        <div>
          <SectionLabel text="Study" gradient="linear-gradient(90deg, #f59e0b, #ef4444)" />
          <Card>
            <Row delay={0.34} onClick={() => navigate('/settings/goal')}
              iconBg="linear-gradient(135deg, #ef4444, #dc2626)"
              icon={<Target size={17} color="white" />}
              label="Daily Goal" subtitle={`${goalVal} cards/day`} />
            <Row delay={0.37} onClick={() => navigate('/settings/reminder')}
              iconBg="linear-gradient(135deg, #f59e0b, #d97706)"
              icon={<Clock size={17} color="white" />}
              label="Study Reminder" subtitle={reminderOn ? `Reminder on · ${localStorage.getItem('pydeck_reminder_time') || '08:00'}` : 'No reminder set'} />
          </Card>
        </div>

      </div>

      {/* Clear Cache confirm */}
      <AnimatePresence>
        {showClearConfirm && (
          <motion.div className="fixed inset-0 z-[100] flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            onClick={() => setShowClearConfirm(false)}>
            <motion.div className="w-full max-w-sm rounded-2xl border border-white/10 p-5 shadow-2xl"
              style={{ background: '#0d1525' }}
              initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.9, opacity: 0 }}
              onClick={e => e.stopPropagation()}>
              <p className="text-white font-bold mb-1">Clear Cache?</p>
              <p className="text-gray-400 text-sm mb-5">This removes temporary data. Your progress and settings are safe.</p>
              <div className="flex gap-3">
                <button onClick={() => setShowClearConfirm(false)}
                  className="flex-1 py-3 rounded-xl bg-white/5 border border-white/10 text-gray-300 text-sm font-medium">Cancel</button>
                <button onClick={handleClearCache}
                  className="flex-1 py-3 rounded-xl bg-orange-500/20 border border-orange-500/40 text-orange-400 text-sm font-semibold">Clear</button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
