import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Clock, Bell, Check } from 'lucide-react'
import { motion } from 'framer-motion'

const KEY_TIME    = 'pydeck_reminder_time'
const KEY_ENABLED = 'pydeck_reminder_on'

const PRESETS = [
  { label: 'Morning',   time: '08:00', emoji: '🌅' },
  { label: 'Afternoon', time: '13:00', emoji: '☀️' },
  { label: 'Evening',   time: '18:00', emoji: '🌆' },
  { label: 'Night',     time: '21:00', emoji: '🌙' },
]

export default function StudyReminder() {
  const navigate = useNavigate()
  const [enabled, setEnabled] = useState(() => localStorage.getItem(KEY_ENABLED) === 'true')
  const [time, setTime]       = useState(() => localStorage.getItem(KEY_TIME) || '08:00')
  const [saved, setSaved]     = useState(false)

  function handleToggle() {
    const next = !enabled
    setEnabled(next)
    localStorage.setItem(KEY_ENABLED, String(next))
  }

  function handlePreset(t) {
    setTime(t)
    localStorage.setItem(KEY_TIME, t)
  }

  function handleSave() {
    localStorage.setItem(KEY_TIME, time)
    localStorage.setItem(KEY_ENABLED, String(enabled))
    setSaved(true)
    setTimeout(() => setSaved(false), 2000)
  }

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <div>
          <h1 className="text-white font-bold text-lg">Study Reminder</h1>
          <p className="text-gray-500 text-xs">Get a daily nudge to keep your streak</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28 flex flex-col gap-4">

        {/* Enable toggle */}
        <div className="rounded-2xl border border-white/10 overflow-hidden" style={{ background: '#0d1525' }}>
          <div className="flex items-center justify-between px-5 py-4">
            <div className="flex items-center gap-3">
              <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow-lg"
                style={{ background: 'linear-gradient(135deg, #f59e0b, #d97706)' }}>
                <Bell size={17} color="white" />
              </div>
              <div>
                <p className="text-white text-sm font-semibold">Daily Reminder</p>
                <p className="text-gray-500 text-xs">{enabled ? `Reminder set for ${time}` : 'Reminder is off'}</p>
              </div>
            </div>
            <button onClick={handleToggle}
              className={`relative w-12 h-6 rounded-full transition-colors duration-300 ${enabled ? 'bg-cyan-500' : 'bg-white/20'}`}>
              <motion.div className="absolute top-0.5 w-5 h-5 bg-white rounded-full shadow"
                animate={{ left: enabled ? '26px' : '2px' }}
                transition={{ type: 'spring', stiffness: 500, damping: 30 }} />
            </button>
          </div>
        </div>

        {enabled && (
          <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} className="flex flex-col gap-4">

            {/* Time picker */}
            <div className="rounded-2xl border border-white/10 overflow-hidden" style={{ background: '#0d1525' }}>
              <div className="px-5 py-3 border-b border-white/10 flex items-center gap-2">
                <Clock size={14} className="text-gray-500" />
                <p className="text-gray-500 text-xs font-semibold uppercase tracking-wider">Custom Time</p>
              </div>
              <div className="px-5 py-4 flex items-center justify-between">
                <p className="text-white text-sm font-medium">Select time</p>
                <input
                  type="time"
                  value={time}
                  onChange={e => setTime(e.target.value)}
                  className="bg-white/5 border border-white/10 rounded-xl px-3 py-2 text-white text-sm outline-none focus:border-cyan-500/50"
                />
              </div>
            </div>

            {/* Presets */}
            <div>
              <p className="text-gray-500 text-xs font-semibold uppercase tracking-widest px-2 mb-2">Quick Presets</p>
              <div className="grid grid-cols-2 gap-3">
                {PRESETS.map((p, i) => (
                  <motion.button key={p.time}
                    initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: i * 0.05 }}
                    whileTap={{ scale: 0.95 }}
                    onClick={() => handlePreset(p.time)}
                    className={`flex items-center gap-3 px-4 py-3 rounded-2xl border transition-colors ${
                      time === p.time ? 'bg-cyan-500/10 border-cyan-500/40' : 'border-white/10 hover:bg-white/5'
                    }`}
                    style={{ background: time === p.time ? undefined : '#0d1525' }}
                  >
                    <span className="text-xl">{p.emoji}</span>
                    <div className="text-left">
                      <p className={`text-sm font-semibold ${time === p.time ? 'text-cyan-400' : 'text-white'}`}>{p.label}</p>
                      <p className="text-gray-500 text-xs">{p.time}</p>
                    </div>
                    {time === p.time && <Check size={14} className="text-cyan-400 ml-auto" strokeWidth={3} />}
                  </motion.button>
                ))}
              </div>
            </div>

            <button onClick={handleSave}
              className="w-full py-3.5 rounded-xl bg-cyan-500/20 border border-cyan-500/40 text-cyan-400 font-semibold text-sm hover:bg-cyan-500/30 transition-colors flex items-center justify-center gap-2">
              {saved ? <><Check size={16} strokeWidth={3} /> Saved!</> : 'Save Reminder'}
            </button>
          </motion.div>
        )}
      </div>
    </div>
  )
}
