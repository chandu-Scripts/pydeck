import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X, Search } from 'lucide-react'

export default function PathListModal({ isOpen, onClose, paths, pathIcons, iconColors, topicCounts, onPathClick }) {
  const [searchQuery, setSearchQuery] = useState('')

  // Reset search when modal closes
  useEffect(() => {
    if (!isOpen) {
      setSearchQuery('')
    }
  }, [isOpen])

  if (!isOpen) return null

  // Filter paths based on search query
  const filteredPaths = paths.filter(path =>
    path.name.toLowerCase().includes(searchQuery.toLowerCase())
  )

  return (
    <AnimatePresence>
      <motion.div
        className="fixed inset-0 z-50 flex items-center justify-center bg-black/80 backdrop-blur-sm"
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        exit={{ opacity: 0 }}
        onClick={onClose}
      >
        <motion.div
          className="relative w-80 h-[500px] bg-gradient-to-b from-navy-800 to-navy-900 rounded-3xl border-2 border-cyan-500/30 overflow-hidden shadow-2xl"
          initial={{ scale: 0.8, opacity: 0, rotateX: 20 }}
          animate={{ scale: 1, opacity: 1, rotateX: 0 }}
          exit={{ scale: 0.8, opacity: 0, rotateX: 20 }}
          transition={{ type: 'spring', damping: 20 }}
          onClick={(e) => e.stopPropagation()}
        >
          {/* Header */}
          <div className="absolute top-0 left-0 right-0 z-10 bg-gradient-to-b from-navy-800/95 to-transparent backdrop-blur-sm p-4 border-b border-white/10">
            <div className="flex items-center justify-between mb-3">
              <h2 className="text-lg font-bold text-white">All Learning Paths</h2>
              <button
                onClick={onClose}
                className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
              >
                <X size={18} className="text-gray-400" />
              </button>
            </div>

            {/* Search Bar */}
            <div className="relative">
              <Search size={16} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
              <input
                type="text"
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                placeholder="Search paths..."
                className="w-full bg-navy-700/50 border border-white/10 rounded-lg pl-9 pr-3 py-2 text-sm text-white placeholder:text-gray-500 outline-none focus:border-cyan-500/50 transition-colors"
              />
            </div>
          </div>

          {/* Scrollable Path List - Watch Style */}
          <div className="h-full pt-24 pb-4 overflow-y-auto snap-y snap-mandatory scrollbar-hide">
            <div className="px-4 space-y-3">
              {filteredPaths.length === 0 ? (
                <div className="text-center mt-20">
                  <p className="text-gray-400 text-sm">No paths found</p>
                  <p className="text-gray-500 text-xs mt-1">Try a different search term</p>
                </div>
              ) : (
                filteredPaths.map((path, index) => {
                const Icon = pathIcons[path.name] || pathIcons['Python']
                const iconColor = iconColors[path.name] || 'text-cyan-400'

                return (
                  <motion.button
                    key={path.id}
                    onClick={() => {
                      onPathClick(path)
                      onClose()
                    }}
                    className="w-full snap-center group"
                    initial={{ opacity: 0, x: -20 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.05 }}
                    whileHover={{ scale: 1.02 }}
                    whileTap={{ scale: 0.98 }}
                  >
                    <div className="w-full p-4 rounded-2xl bg-gradient-to-r from-white/5 to-white/0 border border-white/10 backdrop-blur-sm hover:from-white/10 hover:border-cyan-500/30 transition-all">
                      <div className="flex items-center gap-4">
                        {/* Icon */}
                        <div className={`w-12 h-12 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor} flex-shrink-0`}>
                          <Icon size={24} />
                        </div>

                        {/* Path Info */}
                        <div className="flex-1 text-left">
                          <h3 className="text-white font-semibold text-base">{path.name}</h3>
                          <p className="text-gray-400 text-xs mt-0.5">
                            {topicCounts[path.id] || 0} Topics
                          </p>
                        </div>

                        {/* Arrow Indicator */}
                        <div className="w-8 h-8 rounded-full bg-cyan-500/10 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                          <svg width="12" height="12" viewBox="0 0 12 12" fill="none" className="text-cyan-400">
                            <path d="M4 2L8 6L4 10" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
                          </svg>
                        </div>
                      </div>
                    </div>
                  </motion.button>
                )
              }))}
            </div>

            {/* Bottom Padding for better scroll */}
            <div className="h-20" />
          </div>

          {/* Scroll Indicator - Watch Style */}
          <div className="absolute right-2 top-20 bottom-20 w-1 bg-white/10 rounded-full overflow-hidden">
            <motion.div
              className="w-full bg-cyan-400 rounded-full"
              style={{ height: '20%' }}
            />
          </div>
        </motion.div>
      </motion.div>
    </AnimatePresence>
  )
}
