import { useState, useEffect, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X, Send } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'

export default function CommunityChatModal({ isOpen, onClose }) {
  const { user, profile } = useAuth()
  const [messages, setMessages] = useState([])
  const [newMessage, setNewMessage] = useState('')
  const [sending, setSending] = useState(false)
  const messagesEndRef = useRef(null)

  const scrollToBottom = () => {
    messagesEndRef.current?.scrollIntoView({ behavior: 'smooth' })
  }

  useEffect(() => {
    if (isOpen) {
      fetchMessages()
      const cleanup = subscribeToMessages()

      // Cleanup subscription when modal closes
      return () => {
        if (cleanup) cleanup()
      }
    }
  }, [isOpen])

  useEffect(() => {
    scrollToBottom()
  }, [messages])

  async function fetchMessages() {
    const { data } = await supabase
      .from('community_chat')
      .select('*')
      .order('created_at', { ascending: true })
      .limit(100)

    setMessages(data || [])
  }

  function subscribeToMessages() {
    const channel = supabase
      .channel('community_chat_realtime')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'community_chat',
        },
        (payload) => {
          // Add new message in real-time
          setMessages((prev) => {
            // Check if message already exists by ID
            const exists = prev.some(msg => msg.id === payload.new.id)
            if (exists) return prev

            // Add new message
            return [...prev, payload.new]
          })

          // Auto scroll to bottom when new message arrives
          setTimeout(() => scrollToBottom(), 100)
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }

  async function handleSendMessage(e) {
    e.preventDefault()

    if (!newMessage.trim()) return

    setSending(true)

    const messageData = {
      user_id: user.id,
      username: profile?.username || 'Anonymous',
      message: newMessage.trim(),
    }

    const { error } = await supabase
      .from('community_chat')
      .insert(messageData)

    if (error) {
      console.error('Error sending message:', error)
      alert('Failed to send message')
    } else {
      // Clear input - message will appear via real-time subscription
      setNewMessage('')
    }

    setSending(false)
  }

  function formatTime(timestamp) {
    const date = new Date(timestamp)
    const now = new Date()
    const diffMs = now - date
    const diffMins = Math.floor(diffMs / 60000)

    if (diffMins < 1) return 'Just now'
    if (diffMins < 60) return `${diffMins}m ago`
    if (diffMins < 1440) return `${Math.floor(diffMins / 60)}h ago`
    return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
  }

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
        >
          <motion.div
            className="w-full max-w-lg h-[600px] bg-gradient-to-b from-navy-800 to-navy-900 rounded-2xl border border-cyan-500/30 flex flex-col shadow-2xl overflow-hidden"
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.9, opacity: 0 }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div className="flex items-center justify-between p-4 border-b border-white/10">
              <div>
                <h2 className="text-lg font-bold text-white">Community Chat</h2>
                <p className="text-xs text-gray-400">Share knowledge in real-time</p>
              </div>
              <button
                onClick={onClose}
                className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
              >
                <X size={18} className="text-gray-400" />
              </button>
            </div>

            {/* Messages */}
            <div className="flex-1 overflow-y-auto p-4 space-y-3">
              {messages.length === 0 ? (
                <div className="text-center text-gray-500 mt-20">
                  <p className="text-sm">No messages yet</p>
                  <p className="text-xs mt-1">Be the first to start the conversation!</p>
                </div>
              ) : (
                messages.map((msg) => {
                  const isOwnMessage = msg.user_id === user?.id
                  return (
                    <motion.div
                      key={msg.id}
                      className={`flex ${isOwnMessage ? 'justify-end' : 'justify-start'}`}
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                    >
                      <div className={`max-w-[75%] ${isOwnMessage ? 'items-end' : 'items-start'} flex flex-col`}>
                        <div className="flex items-baseline gap-2 mb-1">
                          <span className={`text-xs font-semibold ${isOwnMessage ? 'text-cyan-400' : 'text-purple-400'}`}>
                            {isOwnMessage ? 'You' : msg.username}
                          </span>
                          <span className="text-[10px] text-gray-500">{formatTime(msg.created_at)}</span>
                        </div>
                        <div
                          className={`px-4 py-2 rounded-2xl ${
                            isOwnMessage
                              ? 'bg-cyan-500/20 border border-cyan-500/30'
                              : 'bg-purple-500/20 border border-purple-500/30'
                          }`}
                        >
                          <p className="text-white text-sm break-words">{msg.message}</p>
                        </div>
                      </div>
                    </motion.div>
                  )
                })
              )}
              <div ref={messagesEndRef} />
            </div>

            {/* Input */}
            <form onSubmit={handleSendMessage} className="p-4 border-t border-white/10">
              <div className="flex gap-2">
                <input
                  type="text"
                  value={newMessage}
                  onChange={(e) => setNewMessage(e.target.value)}
                  placeholder="Type a message..."
                  className="flex-1 bg-navy-700/50 border border-white/10 rounded-xl px-4 py-2 text-white placeholder:text-gray-500 outline-none focus:border-cyan-500/50"
                  maxLength={500}
                />
                <button
                  type="submit"
                  disabled={sending || !newMessage.trim()}
                  className="w-12 h-10 bg-gradient-to-r from-cyan-500 to-blue-500 rounded-xl flex items-center justify-center hover:from-cyan-400 hover:to-blue-400 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <Send size={18} className="text-white" />
                </button>
              </div>
            </form>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
