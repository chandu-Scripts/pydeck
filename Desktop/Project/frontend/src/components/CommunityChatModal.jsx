import { useState, useEffect, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X, Send, Trash2 } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'

export default function CommunityChatModal({ isOpen, onClose }) {
  const { user, profile, isAdmin } = useAuth()
  const [messages, setMessages] = useState([])
  const [newMessage, setNewMessage] = useState('')
  const [sending, setSending] = useState(false)
  const [isConnected, setIsConnected] = useState(false)
  const [showClearConfirm, setShowClearConfirm] = useState(false)
  const [clearing, setClearing] = useState(false)
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
        setIsConnected(false)
      }
    } else {
      // Reset state when modal closes
      setIsConnected(false)
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
    console.log('📡 Setting up real-time chat subscription...')

    const channel = supabase
      .channel('community_chat_channel')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'community_chat',
        },
        (payload) => {
          console.log('💬 New message received via real-time:', payload.new)

          // Add new message in real-time
          setMessages((prev) => {
            // Check if message already exists by ID
            const exists = prev.some(msg => msg.id === payload.new.id)
            if (exists) {
              console.log('⚠️ Message already exists, skipping')
              return prev
            }

            console.log('✅ Adding new message to chat')
            // Add new message
            return [...prev, payload.new]
          })

          // Auto scroll to bottom when new message arrives
          setTimeout(() => scrollToBottom(), 100)
        }
      )
      .on(
        'postgres_changes',
        {
          event: 'DELETE',
          schema: 'public',
          table: 'community_chat',
        },
        (payload) => {
          console.log('🗑️ Message deleted via real-time:', payload.old)

          // Remove deleted message in real-time
          setMessages((prev) => prev.filter(msg => msg.id !== payload.old.id))
        }
      )
      .subscribe((status, err) => {
        console.log('📡 Subscription status:', status)
        if (err) {
          console.error('❌ Subscription error:', err)
        }
        if (status === 'SUBSCRIBED') {
          console.log('✅ Successfully subscribed to real-time chat!')
          setIsConnected(true)
        } else if (status === 'CLOSED' || status === 'CHANNEL_ERROR') {
          console.log('❌ Chat disconnected:', status)
          setIsConnected(false)
        } else if (status === 'TIMED_OUT') {
          console.log('⏱️ Subscription timed out')
          setIsConnected(false)
        }
      })

    return () => {
      console.log('🔌 Unsubscribing from chat...')
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

    console.log('📤 Sending message:', messageData)

    const { data, error } = await supabase
      .from('community_chat')
      .insert(messageData)
      .select()
      .single()

    if (error) {
      console.error('❌ Error sending message:', error)
      alert('Failed to send message')
    } else {
      console.log('✅ Message sent successfully:', data)

      // Optimistic update - add message immediately
      setMessages(prev => {
        // Check if message already exists (might have come via real-time)
        const exists = prev.some(msg => msg.id === data.id)
        if (exists) return prev
        return [...prev, data]
      })

      // Clear input
      setNewMessage('')

      // Scroll to bottom
      setTimeout(() => scrollToBottom(), 100)
    }

    setSending(false)
  }

  async function handleClearChat() {
    setClearing(true)

    const { error } = await supabase
      .from('community_chat')
      .delete()
      .neq('id', '00000000-0000-0000-0000-000000000000') // Delete all rows

    if (error) {
      console.error('❌ Error clearing chat:', error)
      alert('Failed to clear chat')
    } else {
      console.log('✅ Chat cleared successfully')
      setMessages([])
      setShowClearConfirm(false)
    }

    setClearing(false)
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
                <h2 className="text-lg font-bold text-white flex items-center gap-2">
                  Community Chat
                  {/* Connection Status Indicator */}
                  <span className="flex items-center gap-1.5">
                    <span className={`w-2 h-2 rounded-full ${isConnected ? 'bg-emerald-400 animate-pulse' : 'bg-gray-500'}`} />
                    <span className={`text-[10px] font-normal ${isConnected ? 'text-emerald-400' : 'text-gray-500'}`}>
                      {isConnected ? 'Live' : 'Connecting...'}
                    </span>
                  </span>
                </h2>
                <p className="text-xs text-gray-400">
                  {isConnected ? 'Messages appear instantly' : 'Setting up real-time connection...'}
                </p>
              </div>
              <div className="flex items-center gap-2">
                {/* Clear Chat Button (Admin Only) */}
                {isAdmin && (
                  <button
                    onClick={() => setShowClearConfirm(true)}
                    className="w-8 h-8 rounded-full bg-red-500/10 flex items-center justify-center hover:bg-red-500/20 transition-colors"
                    title="Clear all messages"
                  >
                    <Trash2 size={16} className="text-red-400" />
                  </button>
                )}
                <button
                  onClick={onClose}
                  className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
                >
                  <X size={18} className="text-gray-400" />
                </button>
              </div>
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

            {/* Clear Chat Confirmation Modal */}
            <AnimatePresence>
              {showClearConfirm && (
                <motion.div
                  className="absolute inset-0 z-10 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm rounded-2xl"
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  onClick={() => setShowClearConfirm(false)}
                >
                  <motion.div
                    className="bg-gradient-to-b from-navy-700 to-navy-800 rounded-xl border border-red-500/30 p-6 max-w-sm w-full"
                    initial={{ scale: 0.9, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    exit={{ scale: 0.9, opacity: 0 }}
                    onClick={(e) => e.stopPropagation()}
                  >
                    <div className="flex items-center gap-3 mb-4">
                      <div className="w-10 h-10 rounded-full bg-red-500/20 flex items-center justify-center">
                        <Trash2 size={20} className="text-red-400" />
                      </div>
                      <h3 className="text-lg font-bold text-white">Clear Chat</h3>
                    </div>

                    <p className="text-gray-300 text-sm mb-6">
                      Are you sure you want to clear all messages? This action cannot be undone and will permanently delete all chat history.
                    </p>

                    <div className="flex gap-3">
                      <button
                        onClick={() => setShowClearConfirm(false)}
                        className="flex-1 px-4 py-2.5 bg-white/5 border border-white/10 rounded-xl text-white font-medium hover:bg-white/10 transition-colors"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={handleClearChat}
                        disabled={clearing}
                        className="flex-1 px-4 py-2.5 bg-gradient-to-r from-red-500 to-red-600 rounded-xl text-white font-medium hover:from-red-400 hover:to-red-500 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        {clearing ? 'Clearing...' : 'Clear Chat'}
                      </button>
                    </div>
                  </motion.div>
                </motion.div>
              )}
            </AnimatePresence>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
