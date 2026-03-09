import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Mail, Check } from 'lucide-react'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'

export default function ChangeEmail() {
  const navigate = useNavigate()
  const { user } = useAuth()
  const [email, setEmail] = useState('')
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const [error, setError] = useState('')

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    if (!email.includes('@')) { setError('Enter a valid email address.'); return }
    if (email === user?.email) { setError('This is already your current email.'); return }

    setLoading(true)
    const { error: err } = await supabase.auth.updateUser({ email })
    setLoading(false)

    if (err) { setError(err.message); return }
    setSuccess(true)
  }

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <h1 className="text-white font-bold text-lg">Change Email</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-6">
        {success ? (
          <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}
            className="flex flex-col items-center justify-center gap-4 mt-20">
            <div className="w-16 h-16 rounded-full bg-emerald-500/20 flex items-center justify-center">
              <Check size={32} className="text-emerald-400" />
            </div>
            <p className="text-white font-semibold text-lg">Confirmation Sent!</p>
            <p className="text-gray-400 text-sm text-center px-4">
              Check <span className="text-cyan-400">{email}</span> and click the confirmation link to complete the change.
            </p>
            <button onClick={() => navigate(-1)} className="mt-4 px-6 py-2.5 rounded-xl bg-white/5 border border-white/10 text-gray-300 text-sm">
              Back to Settings
            </button>
          </motion.div>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="w-14 h-14 rounded-2xl flex items-center justify-center mx-auto mb-2 shadow-lg"
              style={{ background: 'linear-gradient(135deg, #3b82f6, #1d4ed8)' }}>
              <Mail size={26} color="white" />
            </div>

            <div className="rounded-2xl border border-white/10 px-4 py-3 mb-2" style={{ background: '#0d1525' }}>
              <p className="text-gray-500 text-xs">Current email</p>
              <p className="text-white text-sm font-medium mt-0.5">{user?.email || '—'}</p>
            </div>

            <div className="flex flex-col gap-1.5">
              <label className="text-gray-400 text-xs font-medium px-1">New Email Address</label>
              <input
                type="email"
                value={email}
                onChange={e => setEmail(e.target.value)}
                placeholder="you@example.com"
                className="w-full px-4 py-3.5 rounded-xl border border-white/10 bg-white/5 text-white placeholder-gray-600 text-sm outline-none focus:border-cyan-500/50 transition-colors"
              />
            </div>

            {error && <p className="text-red-400 text-xs px-1">{error}</p>}

            <button type="submit" disabled={loading}
              className="mt-2 w-full py-3.5 rounded-xl bg-cyan-500/20 border border-cyan-500/40 text-cyan-400 font-semibold text-sm hover:bg-cyan-500/30 transition-colors disabled:opacity-50">
              {loading ? 'Sending...' : 'Send Confirmation'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
