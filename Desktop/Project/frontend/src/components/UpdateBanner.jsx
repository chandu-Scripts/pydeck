import { useRegisterSW } from 'virtual:pwa-register/react'
import { motion, AnimatePresence } from 'framer-motion'
import { RefreshCw, X } from 'lucide-react'

export default function UpdateBanner() {
  const { needRefresh: [needRefresh, setNeedRefresh], updateServiceWorker } = useRegisterSW()

  if (!needRefresh) return null

  return (
    <AnimatePresence>
      <motion.div
        className="fixed bottom-24 lg:bottom-6 left-1/2 z-50 w-[calc(100%-2rem)] max-w-sm"
        style={{ transform: 'translateX(-50%)' }}
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        exit={{ opacity: 0, y: 40 }}
        transition={{ type: 'spring', stiffness: 300, damping: 25 }}
      >
        <div className="flex items-center gap-3 px-4 py-3 rounded-2xl bg-navy-700/95 border border-cyan-500/40 backdrop-blur-xl shadow-2xl"
          style={{ boxShadow: '0 0 30px rgba(6,182,212,0.25)' }}
        >
          <div className="w-8 h-8 rounded-full bg-cyan-500/20 flex items-center justify-center flex-shrink-0">
            <RefreshCw size={16} className="text-cyan-400" />
          </div>
          <p className="flex-1 text-sm text-white font-medium">
            New update available!
          </p>
          <button
            onClick={() => updateServiceWorker(true)}
            className="px-3 py-1.5 rounded-lg bg-cyan-500/20 border border-cyan-500/40 text-cyan-400 text-sm font-semibold hover:bg-cyan-500/30 transition-colors"
          >
            Refresh
          </button>
          <button
            onClick={() => setNeedRefresh(false)}
            className="text-gray-500 hover:text-white transition-colors"
          >
            <X size={16} />
          </button>
        </div>
      </motion.div>
    </AnimatePresence>
  )
}
