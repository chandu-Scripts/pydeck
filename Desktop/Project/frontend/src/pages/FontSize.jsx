import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Check } from 'lucide-react'
import { motion } from 'framer-motion'
import { useFontSize } from '../hooks/useFontSize'

const OPTIONS = [
  { key: 'normal', label: 'A',   name: 'Default',   desc: 'Standard reading size', px: 14 },
  { key: 'large',  label: 'A+',  name: 'Large',     desc: 'Comfortable for longer sessions', px: 17 },
  { key: 'xlarge', label: 'A++', name: 'Extra Large', desc: 'Maximum readability', px: 20 },
]

export default function FontSize() {
  const navigate = useNavigate()
  const { size, setSize } = useFontSize()

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
          <h1 className="text-white font-bold text-lg">Font Size</h1>
          <p className="text-gray-500 text-xs">Choose your preferred text size</p>
        </div>
      </div>

      {/* Preview */}
      <div className="mx-5 mt-5 rounded-2xl border border-white/10 p-5" style={{ background: '#0d1525' }}>
        <p className="text-gray-500 text-xs font-semibold uppercase tracking-wider mb-3">Preview</p>
        <p className="text-white font-semibold mb-1" style={{ fontSize: size === 'normal' ? 14 : size === 'large' ? 17 : 20 }}>
          The quick brown fox jumps over the lazy dog
        </p>
        <p className="text-gray-400" style={{ fontSize: size === 'normal' ? 12 : size === 'large' ? 14 : 16 }}>
          Python is a high-level, general-purpose programming language.
        </p>
      </div>

      {/* Options */}
      <div className="flex-1 overflow-y-auto px-5 py-4 flex flex-col gap-3">
        {OPTIONS.map(opt => {
          const isActive = size === opt.key
          return (
            <button
              key={opt.key}
              onClick={() => setSize(opt.key)}
              className={`w-full flex items-center justify-between px-5 py-4 rounded-2xl border transition-colors ${
                isActive
                  ? 'bg-cyan-500/10 border-cyan-500/40'
                  : 'border-white/10 hover:bg-white/5'
              }`}
              style={{ background: isActive ? undefined : '#0d1525' }}
            >
              <div className="flex items-center gap-4">
                <span
                  className={`font-bold w-10 text-left ${isActive ? 'text-cyan-400' : 'text-gray-400'}`}
                  style={{ fontSize: opt.px }}
                >
                  {opt.label}
                </span>
                <div className="text-left">
                  <p className={`font-semibold text-sm ${isActive ? 'text-white' : 'text-gray-300'}`}>{opt.name}</p>
                  <p className="text-gray-500 text-xs">{opt.desc}</p>
                </div>
              </div>
              {isActive && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ type: 'spring', stiffness: 400, damping: 20 }}
                  className="w-6 h-6 rounded-full bg-cyan-500/20 flex items-center justify-center"
                >
                  <Check size={14} className="text-cyan-400" strokeWidth={3} />
                </motion.div>
              )}
            </button>
          )
        })}
      </div>
    </div>
  )
}
