import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Target, Check } from 'lucide-react'
import { motion } from 'framer-motion'

const GOALS = [
  { value: 5,   label: 'Casual',   desc: '5 cards/day',   emoji: '🌱', color: '#22c55e' },
  { value: 10,  label: 'Regular',  desc: '10 cards/day',  emoji: '📚', color: '#3b82f6' },
  { value: 20,  label: 'Focused',  desc: '20 cards/day',  emoji: '🎯', color: '#f97316' },
  { value: 30,  label: 'Serious',  desc: '30 cards/day',  emoji: '🔥', color: '#ef4444' },
  { value: 50,  label: 'Intense',  desc: '50 cards/day',  emoji: '⚡', color: '#a855f7' },
  { value: 100, label: 'Beast',    desc: '100 cards/day', emoji: '🚀', color: '#ec4899' },
]

const KEY = 'pydeck_daily_goal'

export default function DailyGoal() {
  const navigate = useNavigate()
  const [goal, setGoal] = useState(() => parseInt(localStorage.getItem(KEY) || '10'))

  function handleSelect(value) {
    setGoal(value)
    localStorage.setItem(KEY, String(value))
  }

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <div>
          <h1 className="text-white font-bold text-lg">Daily Goal</h1>
          <p className="text-gray-500 text-xs">How many cards to study each day</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28 flex flex-col gap-3">
        {GOALS.map((g, i) => {
          const isActive = goal === g.value
          return (
            <motion.button
              key={g.value}
              initial={{ opacity: 0, y: 16 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.06, duration: 0.3 }}
              whileTap={{ scale: 0.97 }}
              onClick={() => handleSelect(g.value)}
              className={`w-full flex items-center gap-4 px-5 py-4 rounded-2xl border transition-all ${
                isActive ? 'border-opacity-40' : 'border-white/10 hover:bg-white/5'
              }`}
              style={{
                background: isActive ? `${g.color}15` : '#0d1525',
                borderColor: isActive ? g.color + '60' : undefined,
              }}
            >
              <span className="text-2xl">{g.emoji}</span>
              <div className="flex-1 text-left">
                <p className="text-white text-sm font-semibold">{g.label}</p>
                <p className="text-gray-500 text-xs">{g.desc}</p>
              </div>
              {isActive && (
                <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }}
                  transition={{ type: 'spring', stiffness: 400, damping: 20 }}
                  className="w-6 h-6 rounded-full flex items-center justify-center"
                  style={{ background: g.color + '30' }}>
                  <Check size={14} strokeWidth={3} style={{ color: g.color }} />
                </motion.div>
              )}
            </motion.button>
          )
        })}
      </div>
    </div>
  )
}
