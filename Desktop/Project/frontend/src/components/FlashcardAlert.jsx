import { motion, AnimatePresence } from 'framer-motion'
import { AlertCircle, CheckCircle, Trash2, X } from 'lucide-react'

export default function FlashcardAlert({
  isOpen,
  onClose,
  type = 'success', // 'success' (green) or 'danger' (red)
  title,
  message,
  confirmText = 'OK',
  cancelText = 'Cancel',
  onConfirm,
  showCancel = false,
  loading = false
}) {
  const isSuccess = type === 'success'
  const isDanger = type === 'danger'

  const iconColor = isSuccess ? 'text-emerald-400' : 'text-red-400'
  const bgColor = isSuccess ? 'bg-emerald-500/20' : 'bg-red-500/20'
  const borderColor = isSuccess ? 'border-emerald-500/30' : 'border-red-500/30'
  const buttonColor = isSuccess
    ? 'bg-gradient-to-r from-emerald-500 to-emerald-600 hover:from-emerald-400 hover:to-emerald-500'
    : 'bg-gradient-to-r from-red-500 to-red-600 hover:from-red-400 hover:to-red-500'

  const Icon = isDanger ? Trash2 : CheckCircle

  function handleConfirm() {
    if (onConfirm) {
      onConfirm()
    } else {
      onClose()
    }
  }

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 z-[70] flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={showCancel ? undefined : onClose}
        >
          <motion.div
            className={`bg-gradient-to-b from-navy-700 to-navy-800 rounded-2xl border ${borderColor} p-6 max-w-sm w-full shadow-2xl`}
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.9, opacity: 0 }}
            onClick={(e) => e.stopPropagation()}
          >
            <div className="flex items-center gap-3 mb-4">
              <div className={`w-10 h-10 rounded-full ${bgColor} flex items-center justify-center`}>
                <Icon size={20} className={iconColor} />
              </div>
              <h3 className="text-lg font-bold text-white">{title}</h3>
            </div>

            <p className="text-gray-300 text-sm mb-6 leading-relaxed">
              {message}
            </p>

            <div className={`flex gap-3 ${showCancel ? '' : 'justify-end'}`}>
              {showCancel && (
                <button
                  onClick={onClose}
                  className="flex-1 px-4 py-2.5 bg-white/5 border border-white/10 rounded-xl text-white font-medium hover:bg-white/10 transition-colors"
                >
                  {cancelText}
                </button>
              )}
              <button
                onClick={handleConfirm}
                disabled={loading}
                className={`${showCancel ? 'flex-1' : 'px-6'} px-4 py-2.5 ${buttonColor} rounded-xl text-white font-medium transition-all disabled:opacity-50 disabled:cursor-not-allowed`}
              >
                {loading ? 'Processing...' : confirmText}
              </button>
            </div>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
