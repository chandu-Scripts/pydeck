import { useState } from 'react'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ShieldX, Send, LogOut } from 'lucide-react'

export default function BlockedUserScreen() {
  const { user, signOut } = useAuth()
  const [message, setMessage] = useState('')
  const [sending, setSending] = useState(false)
  const [sent, setSent] = useState(false)

  async function handleSendAppeal() {
    if (!message.trim()) return

    setSending(true)
    const { error } = await supabase
      .from('user_appeals')
      .insert({
        user_id: user.id,
        message: message.trim(),
      })

    setSending(false)

    if (error) {
      alert('Failed to send appeal. Please try again.')
    } else {
      setSent(true)
      setMessage('')
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center px-5 py-8 bg-gradient-to-br from-navy-900 via-navy-800 to-[#0d1a2e]">
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-96 h-96 bg-red-500/5 rounded-full blur-3xl" />

      <motion.div
        className="relative z-10 w-full max-w-md"
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
      >
        {/* Blocked Icon */}
        <div className="flex justify-center mb-6">
          <div className="w-20 h-20 rounded-full bg-red-500/20 border-2 border-red-500/40 flex items-center justify-center">
            <ShieldX size={40} className="text-red-400" />
          </div>
        </div>

        {/* Title */}
        <h1 className="text-3xl font-bold text-white text-center mb-3">
          Account Blocked
        </h1>
        <p className="text-gray-400 text-center mb-8">
          Your account has been blocked by an administrator. Send an appeal to request unblock.
        </p>

        {/* Appeal Card */}
        <div className="bg-navy-800/60 backdrop-blur-xl border border-red-500/20 rounded-2xl p-6 shadow-2xl">
          <h2 className="text-lg font-bold text-white mb-4 flex items-center gap-2">
            <Send size={20} className="text-red-400" />
            Send Appeal to Admin
          </h2>

          {sent ? (
            <motion.div
              className="text-center py-8"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
            >
              <div className="w-16 h-16 rounded-full bg-green-500/20 border-2 border-green-500/40 flex items-center justify-center mx-auto mb-4">
                <span className="text-3xl">✓</span>
              </div>
              <p className="text-green-400 font-semibold mb-2">Appeal Sent!</p>
              <p className="text-gray-400 text-sm">
                An administrator will review your appeal soon.
              </p>
            </motion.div>
          ) : (
            <>
              <textarea
                value={message}
                onChange={(e) => setMessage(e.target.value)}
                placeholder="Explain why your account should be unblocked..."
                className="w-full px-4 py-3 bg-navy-700/50 border border-white/10 rounded-xl text-white placeholder-gray-500 resize-none focus:border-red-500/50 outline-none mb-4"
                rows={5}
                maxLength={500}
              />

              <div className="flex items-center justify-between mb-4">
                <span className="text-gray-500 text-xs">
                  {message.length}/500 characters
                </span>
              </div>

              <button
                onClick={handleSendAppeal}
                disabled={sending || !message.trim()}
                className="w-full py-3.5 bg-gradient-to-r from-red-500 to-red-600 text-white font-semibold rounded-xl flex items-center justify-center gap-2 hover:from-red-400 hover:to-red-500 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {sending ? (
                  <>
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    Sending...
                  </>
                ) : (
                  <>
                    <Send size={18} />
                    Send Appeal
                  </>
                )}
              </button>
            </>
          )}
        </div>

        {/* Logout Button */}
        <button
          onClick={signOut}
          className="w-full mt-6 py-3 bg-navy-700/50 border border-white/10 text-gray-400 rounded-xl hover:bg-navy-700 transition-colors flex items-center justify-center gap-2"
        >
          <LogOut size={18} />
          Logout
        </button>
      </motion.div>
    </div>
  )
}
