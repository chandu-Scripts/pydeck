import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Bell, Mail, AlertCircle } from 'lucide-react'
import { motion } from 'framer-motion'
import { useAuth } from '../contexts/AuthContext'
import { subscribeToPush } from '../hooks/usePushNotifications'

const KEYS = {
  email: 'pydeck_notif_email',
  push:  'pydeck_notif_push',
}

function Toggle({ enabled, onChange, disabled }) {
  return (
    <button
      onClick={onChange}
      disabled={disabled}
      className={`relative w-12 h-6 rounded-full transition-colors duration-300 flex-shrink-0 ${
        disabled ? 'opacity-40 cursor-not-allowed' : 'cursor-pointer'
      } ${enabled ? 'bg-cyan-500' : 'bg-white/20'}`}
    >
      <motion.div
        className="absolute top-0.5 w-5 h-5 bg-white rounded-full shadow"
        animate={{ left: enabled ? '26px' : '2px' }}
        transition={{ type: 'spring', stiffness: 500, damping: 30 }}
      />
    </button>
  )
}

function NotifRow({ iconBg, icon, label, subtitle, enabled, onToggle, loading, delay }) {
  return (
    <motion.div
      initial={{ opacity: 0, x: -16 }}
      animate={{ opacity: 1, x: 0 }}
      transition={{ delay, duration: 0.3, ease: 'easeOut' }}
      className="flex items-center gap-4 px-4 py-4"
    >
      <div
        className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 shadow-lg"
        style={{ background: iconBg }}
      >
        {icon}
      </div>
      <div className="flex-1 min-w-0">
        <p className="text-white text-sm font-semibold">{label}</p>
        <p className="text-gray-500 text-xs mt-0.5 truncate">{subtitle}</p>
      </div>
      {loading ? (
        <div className="w-5 h-5 border-2 border-cyan-500 border-t-transparent rounded-full animate-spin flex-shrink-0" />
      ) : (
        <Toggle enabled={enabled} onChange={onToggle} disabled={false} />
      )}
    </motion.div>
  )
}

export default function Notifications() {
  const navigate = useNavigate()
  const { user } = useAuth()

  const [emailEnabled, setEmailEnabled] = useState(() => localStorage.getItem(KEYS.email) !== 'false')
  const [pushEnabled, setPushEnabled]   = useState(() => localStorage.getItem(KEYS.push) === 'true')
  const [pushPermission, setPushPermission] = useState('default')
  const [pushLoading, setPushLoading]   = useState(false)
  const [pushComingSoon, setPushComingSoon]   = useState(false)
  const [emailComingSoon, setEmailComingSoon] = useState(false)

  useEffect(() => {
    if ('Notification' in window) setPushPermission(Notification.permission)
  }, [])

  function handleEmailToggle() {
    if (emailEnabled) {
      setEmailComingSoon(true)
      setTimeout(() => setEmailComingSoon(false), 2500)
      return
    }
    const next = !emailEnabled
    setEmailEnabled(next)
    localStorage.setItem(KEYS.email, String(next))
  }

  async function handlePushToggle() {
    if (pushLoading) return
    if (pushEnabled) {
      setPushComingSoon(true)
      setTimeout(() => setPushComingSoon(false), 2500)
      return
    }
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) return
    if (Notification.permission === 'denied') { setPushPermission('denied'); return }

    setPushLoading(true)
    const permission = await Notification.requestPermission()
    setPushPermission(permission)
    if (permission === 'granted') {
      await subscribeToPush(user?.id)
      setPushEnabled(true)
      localStorage.setItem(KEYS.push, 'true')
    }
    setPushLoading(false)
  }

  const pushDenied = pushPermission === 'denied'

  return (
    <div
      className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}
    >
      {/* Header */}
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button
          onClick={() => navigate(-1)}
          className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
        >
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <div>
          <h1 className="text-white font-bold text-lg">Notifications</h1>
          <p className="text-gray-500 text-xs">Manage how you receive updates</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28 flex flex-col gap-5">

        {/* App Notifications */}
        <div>
          <span className="block px-2 mb-2 text-[11px] font-bold tracking-widest uppercase"
            style={{ background: 'linear-gradient(90deg, #f43f5e, #fb923c)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
            App
          </span>
          <div className="rounded-2xl overflow-hidden border border-white/8" style={{ background: '#0d1525' }}>
            <NotifRow
              delay={0.05}
              iconBg="linear-gradient(135deg, #f43f5e, #be123c)"
              icon={<Bell size={17} color="white" />}
              label="Push Notifications"
              subtitle={pushDenied ? 'Blocked by browser' : pushEnabled ? 'You will receive app alerts' : 'Tap to enable'}
              enabled={pushEnabled}
              onToggle={handlePushToggle}
              loading={pushLoading}
            />

            {pushComingSoon && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                exit={{ opacity: 0, height: 0 }}
                className="mx-4 mb-4 flex items-center gap-2 px-4 py-3 rounded-xl bg-cyan-500/10 border border-cyan-500/20"
              >
                <Bell size={13} className="text-cyan-400 flex-shrink-0" />
                <p className="text-cyan-300 text-xs">Disabling notifications coming soon.</p>
              </motion.div>
            )}

            {pushDenied && (
              <div className="mx-4 mb-4 flex items-start gap-2 px-4 py-3 rounded-xl bg-orange-500/10 border border-orange-500/20">
                <AlertCircle size={14} className="text-orange-400 mt-0.5 flex-shrink-0" />
                <p className="text-orange-300 text-xs">
                  Notifications are blocked. Allow them in your browser settings, then try again.
                </p>
              </div>
            )}
          </div>
        </div>

        {/* Email Notifications */}
        <div>
          <span className="block px-2 mb-2 text-[11px] font-bold tracking-widest uppercase"
            style={{ background: 'linear-gradient(90deg, #3b82f6, #22d3ee)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
            Email
          </span>
          <div className="rounded-2xl overflow-hidden border border-white/8" style={{ background: '#0d1525' }}>
            <NotifRow
              delay={0.1}
              iconBg="linear-gradient(135deg, #3b82f6, #1d4ed8)"
              icon={<Mail size={17} color="white" />}
              label="Email Updates"
              subtitle={emailEnabled ? 'Receive updates to your email' : 'Email updates are off'}
              enabled={emailEnabled}
              onToggle={handleEmailToggle}
              loading={false}
            />

            {emailComingSoon && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                exit={{ opacity: 0, height: 0 }}
                className="mx-4 mb-4 flex items-center gap-2 px-4 py-3 rounded-xl bg-cyan-500/10 border border-cyan-500/20"
              >
                <Mail size={13} className="text-cyan-400 flex-shrink-0" />
                <p className="text-cyan-300 text-xs">Disabling email updates coming soon.</p>
              </motion.div>
            )}
          </div>
        </div>

      </div>
    </div>
  )
}
