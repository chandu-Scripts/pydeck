import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Check } from 'lucide-react'
import { motion } from 'framer-motion'
import { useTheme, THEMES } from '../hooks/useTheme'

export default function ThemeColor() {
  const navigate = useNavigate()
  const { accent, setAccent } = useTheme()

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
          <h1 className="text-white font-bold text-lg">Theme Color</h1>
          <p className="text-gray-500 text-xs">Choose your accent color</p>
        </div>
      </div>

      {/* Color Grid */}
      <div className="flex-1 overflow-y-auto px-5 py-5">
        <div className="grid grid-cols-4 gap-3">
          {THEMES.map(theme => {
            const isActive = accent === theme.id
            return (
              <button
                key={theme.id}
                onClick={() => setAccent(theme.id)}
                className="flex flex-col items-center gap-1.5 active:scale-95 transition-transform"
              >
                <div
                  className="w-14 h-14 rounded-2xl flex items-center justify-center shadow-md"
                  style={{
                    background: `linear-gradient(135deg, ${theme.c400}, ${theme.c600})`,
                    outline: isActive ? `3px solid ${theme.c400}` : '3px solid transparent',
                    outlineOffset: '2px',
                  }}
                >
                  {isActive && (
                    <motion.div
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      transition={{ type: 'spring', stiffness: 400, damping: 20 }}
                    >
                      <Check size={18} className="text-white" strokeWidth={3} />
                    </motion.div>
                  )}
                </div>
                <span className={`text-[11px] font-medium ${isActive ? 'text-white' : 'text-gray-500'}`}>
                  {theme.label}
                </span>
              </button>
            )
          })}
        </div>
      </div>
    </div>
  )
}
