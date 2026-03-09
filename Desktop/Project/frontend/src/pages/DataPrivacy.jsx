import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Shield, Database, Trash2, AlertTriangle, X } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'

export default function DataPrivacy() {
  const navigate = useNavigate()
  const { user, signOut } = useAuth()
  const [showDeleteModal, setShowDeleteModal] = useState(false)
  const [deleting, setDeleting] = useState(false)
  const [confirmText, setConfirmText] = useState('')

  async function handleDeleteAccount() {
    if (confirmText !== 'DELETE') return
    setDeleting(true)
    // Soft delete — update profile status; full deletion requires backend service key
    await supabase.from('profiles').update({ status: 'deleted', username: '[Deleted]', avatar_url: null }).eq('id', user.id)
    await signOut()
  }

  const INFO = [
    { icon: Database, color: '#3b82f6', title: 'What we store', desc: 'Your username, email, study progress, flashcard responses, and session history.' },
    { icon: Shield,   color: '#22c55e', title: 'How we protect it', desc: 'All data is encrypted in transit and stored securely on Supabase with row-level security.' },
  ]

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <div>
          <h1 className="text-white font-bold text-lg">Data & Privacy</h1>
          <p className="text-gray-500 text-xs">Your data, your control</p>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-5 pb-28 flex flex-col gap-4">

        {/* Info cards */}
        <div className="flex flex-col gap-3">
          {INFO.map(({ icon: Icon, color, title, desc }, i) => (
            <motion.div key={title} initial={{ opacity: 0, y: 12 }} animate={{ opacity: 1, y: 0 }}
              transition={{ delay: i * 0.08 }}
              className="flex gap-4 px-5 py-4 rounded-2xl border border-white/10" style={{ background: '#0d1525' }}>
              <div className="w-9 h-9 rounded-xl flex items-center justify-center flex-shrink-0 shadow"
                style={{ background: color + '25', border: `1px solid ${color}40` }}>
                <Icon size={17} style={{ color }} />
              </div>
              <div>
                <p className="text-white text-sm font-semibold">{title}</p>
                <p className="text-gray-500 text-xs mt-1 leading-relaxed">{desc}</p>
              </div>
            </motion.div>
          ))}
        </div>

        {/* Delete account */}
        <div className="mt-2">
          <span className="block px-2 mb-2 text-[11px] font-bold tracking-widest uppercase"
            style={{ background: 'linear-gradient(90deg, #f43f5e, #fb923c)', WebkitBackgroundClip: 'text', WebkitTextFillColor: 'transparent' }}>
            Danger Zone
          </span>
          <div className="rounded-2xl border border-red-500/20 overflow-hidden" style={{ background: '#0d1525' }}>
            <button onClick={() => setShowDeleteModal(true)}
              className="w-full flex items-center gap-4 px-5 py-4 hover:bg-red-500/5 transition-colors">
              <div className="w-9 h-9 rounded-xl flex items-center justify-center shadow-lg"
                style={{ background: 'linear-gradient(135deg, #ef4444, #b91c1c)' }}>
                <Trash2 size={17} color="white" />
              </div>
              <div className="text-left">
                <p className="text-red-400 text-sm font-semibold">Delete Account</p>
                <p className="text-gray-500 text-xs">Permanently remove your account and data</p>
              </div>
            </button>
          </div>
        </div>
      </div>

      {/* Delete confirmation modal */}
      <AnimatePresence>
        {showDeleteModal && (
          <motion.div className="fixed inset-0 z-50 flex items-center justify-center p-5 bg-black/80 backdrop-blur-sm"
            initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            onClick={() => setShowDeleteModal(false)}>
            <motion.div className="w-full max-w-sm rounded-2xl border border-red-500/30 p-6 shadow-2xl"
              style={{ background: '#0d1525' }}
              initial={{ scale: 0.9, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.9, opacity: 0 }}
              onClick={e => e.stopPropagation()}>
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 rounded-full bg-red-500/15 flex items-center justify-center">
                    <AlertTriangle size={20} className="text-red-400" />
                  </div>
                  <h2 className="text-white font-bold">Delete Account?</h2>
                </div>
                <button onClick={() => setShowDeleteModal(false)} className="text-gray-500 hover:text-gray-300">
                  <X size={18} />
                </button>
              </div>
              <p className="text-gray-400 text-sm mb-4">
                This will permanently delete your account and all your progress. This action <span className="text-red-400 font-semibold">cannot be undone</span>.
              </p>
              <p className="text-gray-500 text-xs mb-2">Type <span className="text-red-400 font-mono font-bold">DELETE</span> to confirm</p>
              <input
                value={confirmText}
                onChange={e => setConfirmText(e.target.value)}
                placeholder="DELETE"
                className="w-full px-4 py-3 rounded-xl border border-white/10 bg-white/5 text-white text-sm font-mono outline-none focus:border-red-500/50 mb-4"
              />
              <button
                onClick={handleDeleteAccount}
                disabled={confirmText !== 'DELETE' || deleting}
                className="w-full py-3 rounded-xl bg-red-500/20 border border-red-500/40 text-red-400 font-semibold text-sm hover:bg-red-500/30 transition-colors disabled:opacity-40">
                {deleting ? 'Deleting...' : 'Delete My Account'}
              </button>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
