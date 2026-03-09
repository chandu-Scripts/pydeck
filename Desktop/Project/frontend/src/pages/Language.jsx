import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Check, Globe } from 'lucide-react'
import { motion } from 'framer-motion'

const LANGUAGES = [
  { code: 'en', label: 'English', native: 'English', available: true },
  { code: 'hi', label: 'Hindi', native: 'हिन्दी', available: false },
  { code: 'ta', label: 'Tamil', native: 'தமிழ்', available: false },
  { code: 'te', label: 'Telugu', native: 'తెలుగు', available: false },
  { code: 'kn', label: 'Kannada', native: 'ಕನ್ನಡ', available: false },
  { code: 'ml', label: 'Malayalam', native: 'മലയാളം', available: false },
  { code: 'mr', label: 'Marathi', native: 'मराठी', available: false },
  { code: 'bn', label: 'Bengali', native: 'বাংলা', available: false },
  { code: 'fr', label: 'French', native: 'Français', available: false },
  { code: 'de', label: 'German', native: 'Deutsch', available: false },
  { code: 'es', label: 'Spanish', native: 'Español', available: false },
  { code: 'ja', label: 'Japanese', native: '日本語', available: false },
]

export default function Language() {
  const navigate = useNavigate()
  const [selected, setSelected] = useState('en')

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <div>
          <h1 className="text-white font-bold text-lg">Language</h1>
          <p className="text-gray-500 text-xs">More languages coming soon</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28">
        <div className="rounded-2xl border border-white/10 overflow-hidden divide-y divide-white/6" style={{ background: '#0d1525' }}>
          {LANGUAGES.map((lang, i) => (
            <motion.button
              key={lang.code}
              initial={{ opacity: 0, x: -12 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: i * 0.04, duration: 0.25 }}
              onClick={() => lang.available && setSelected(lang.code)}
              className={`w-full flex items-center justify-between px-5 py-4 transition-colors ${
                lang.available ? 'hover:bg-white/5' : 'opacity-40 cursor-not-allowed'
              }`}
            >
              <div className="flex items-center gap-4">
                <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow"
                  style={{ background: lang.available ? 'linear-gradient(135deg, #22d3ee, #0891b2)' : '#1a2234' }}>
                  <Globe size={16} color={lang.available ? 'white' : '#4b5563'} />
                </div>
                <div className="text-left">
                  <p className="text-white text-sm font-semibold">{lang.label}</p>
                  <p className="text-gray-500 text-xs">{lang.native}</p>
                </div>
              </div>
              <div className="flex items-center gap-2">
                {!lang.available && (
                  <span className="text-[10px] px-2 py-0.5 rounded-full bg-white/5 text-gray-500 border border-white/10">Soon</span>
                )}
                {selected === lang.code && (
                  <div className="w-5 h-5 rounded-full bg-cyan-500/20 flex items-center justify-center">
                    <Check size={12} className="text-cyan-400" strokeWidth={3} />
                  </div>
                )}
              </div>
            </motion.button>
          ))}
        </div>
      </div>
    </div>
  )
}
