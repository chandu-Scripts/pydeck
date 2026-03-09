import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ChevronLeft, Eye, EyeOff, Check, Lock } from 'lucide-react'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'

export default function ChangePassword() {
  const navigate = useNavigate()
  const [current, setCurrent] = useState('')
  const [next, setNext] = useState('')
  const [confirm, setConfirm] = useState('')
  const [showCurrent, setShowCurrent] = useState(false)
  const [showNext, setShowNext] = useState(false)
  const [showConfirm, setShowConfirm] = useState(false)
  const [loading, setLoading] = useState(false)
  const [success, setSuccess] = useState(false)
  const [error, setError] = useState('')

  async function handleSubmit(e) {
    e.preventDefault()
    setError('')
    if (next.length < 6) { setError('New password must be at least 6 characters.'); return }
    if (next !== confirm) { setError('Passwords do not match.'); return }

    setLoading(true)
    const { error: err } = await supabase.auth.updateUser({ password: next })
    setLoading(false)

    if (err) { setError(err.message); return }
    setSuccess(true)
    setTimeout(() => navigate(-1), 1800)
  }

  return (
    <div className="fixed inset-0 flex flex-col bg-navy-900"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}>
      <div className="flex items-center gap-3 px-5 py-4 border-b border-white/10 flex-shrink-0">
        <button onClick={() => navigate(-1)} className="w-9 h-9 rounded-xl bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors">
          <ChevronLeft size={20} className="text-gray-300" />
        </button>
        <h1 className="text-white font-bold text-lg">Change Password</h1>
      </div>

      <div className="flex-1 overflow-y-auto px-5 py-6">
        {success ? (
          <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}
            className="flex flex-col items-center justify-center gap-4 mt-20">
            <div className="w-16 h-16 rounded-full bg-emerald-500/20 flex items-center justify-center">
              <Check size={32} className="text-emerald-400" />
            </div>
            <p className="text-white font-semibold text-lg">Password Updated!</p>
            <p className="text-gray-500 text-sm">Redirecting back...</p>
          </motion.div>
        ) : (
          <form onSubmit={handleSubmit} className="flex flex-col gap-4">
            <div className="w-14 h-14 rounded-2xl flex items-center justify-center mx-auto mb-2 shadow-lg"
              style={{ background: 'linear-gradient(135deg, #8b5cf6, #6d28d9)' }}>
              <Lock size={26} color="white" />
            </div>

            {[
              { label: 'Current Password', val: current, set: setCurrent, show: showCurrent, toggle: () => setShowCurrent(v => !v) },
              { label: 'New Password', val: next, set: setNext, show: showNext, toggle: () => setShowNext(v => !v) },
              { label: 'Confirm New Password', val: confirm, set: setConfirm, show: showConfirm, toggle: () => setShowConfirm(v => !v) },
            ].map(({ label, val, set, show, toggle }) => (
              <div key={label} className="flex flex-col gap-1.5">
                <label className="text-gray-400 text-xs font-medium px-1">{label}</label>
                <div className="relative">
                  <input
                    type={show ? 'text' : 'password'}
                    value={val}
                    onChange={e => set(e.target.value)}
                    placeholder="••••••••"
                    className="w-full px-4 py-3.5 pr-12 rounded-xl border border-white/10 bg-white/5 text-white placeholder-gray-600 text-sm outline-none focus:border-cyan-500/50 transition-colors"
                  />
                  <button type="button" onClick={toggle} className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-500 hover:text-gray-300">
                    {show ? <EyeOff size={17} /> : <Eye size={17} />}
                  </button>
                </div>
              </div>
            ))}

            {error && <p className="text-red-400 text-xs px-1">{error}</p>}

            <button type="submit" disabled={loading}
              className="mt-2 w-full py-3.5 rounded-xl bg-cyan-500/20 border border-cyan-500/40 text-cyan-400 font-semibold text-sm hover:bg-cyan-500/30 transition-colors disabled:opacity-50">
              {loading ? 'Updating...' : 'Update Password'}
            </button>
          </form>
        )}
      </div>
    </div>
  )
}
