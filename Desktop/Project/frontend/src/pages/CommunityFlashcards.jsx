import { useEffect, useState } from 'react'
import { motion, useMotionValue, useTransform } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { ArrowLeft, User, Plus, MessageCircle, Palette } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import CreateFlashcardModal from '../components/CreateFlashcardModal'
import CommunityChatModal from '../components/CommunityChatModal'

export default function CommunityFlashcards() {
  const [flashcards, setFlashcards] = useState([])
  const [loading, setLoading] = useState(true)
  const [currentIndex, setCurrentIndex] = useState(0)
  const [isFlipped, setIsFlipped] = useState(false)
  const [selectedAnswer, setSelectedAnswer] = useState(null)
  const [showCreateModal, setShowCreateModal] = useState(false)
  const [showChatModal, setShowChatModal] = useState(false)
  const [showFlashcards, setShowFlashcards] = useState(false)
  const [unreadCount, setUnreadCount] = useState(0)
  const [filterType, setFilterType] = useState(null) // null, 'mcq', 'qa'
  const [cardColor, setCardColor] = useState('black') // 'black', 'orange', 'purple', 'blue', 'green', 'red'
  const [showColorPicker, setShowColorPicker] = useState(false)
  const navigate = useNavigate()
  const { user, profile } = useAuth()

  // Motion values for swipe
  const x = useMotionValue(0)
  const rotate = useTransform(x, [-200, 0, 200], [-20, 0, 20])
  const opacity = useTransform(x, [-200, 0, 200], [0.5, 1, 0.5])

  async function fetchCommunityFlashcards() {
    setLoading(true)
    // Fetch community flashcards
    const { data: cards, error: cardsError } = await supabase
      .from('community_flashcards')
      .select('*')
      .eq('is_approved', true)
      .order('created_at', { ascending: false })

    if (cardsError) {
      console.error('Error fetching community flashcards:', cardsError)
      setLoading(false)
      return
    }

    if (!cards || cards.length === 0) {
      setFlashcards([])
      setLoading(false)
      return
    }

    // Get unique creator IDs
    const creatorIds = [...new Set(cards.map(c => c.created_by))]

    // Fetch profiles for all creators
    const { data: profiles, error: profilesError } = await supabase
      .from('profiles')
      .select('id, username, avatar_url')
      .in('id', creatorIds)

    if (profilesError) {
      console.error('Error fetching profiles:', profilesError)
    }

    // Join the data
    const cardsWithProfiles = cards.map(card => ({
      ...card,
      profiles: profiles?.find(p => p.id === card.created_by) || null
    }))

    setFlashcards(cardsWithProfiles)
    setLoading(false)
  }

  useEffect(() => {
    if (showFlashcards) {
      fetchCommunityFlashcards()
    }
  }, [showFlashcards])

  // Fetch unread count on mount and subscribe to new messages
  useEffect(() => {
    if (user && profile) {
      fetchUnreadCount()
      subscribeToNewMessages()
    }
  }, [user, profile])

  async function fetchUnreadCount() {
    if (!profile) return

    const { data: messages } = await supabase
      .from('community_chat')
      .select('id')
      .gt('created_at', profile.chat_last_seen || '2000-01-01')

    setUnreadCount(messages?.length || 0)
  }

  function subscribeToNewMessages() {
    const channel = supabase
      .channel('unread_chat_channel')
      .on(
        'postgres_changes',
        {
          event: 'INSERT',
          schema: 'public',
          table: 'community_chat',
        },
        (payload) => {
          // Only increment if it's not from the current user
          if (payload.new.user_id !== user?.id) {
            setUnreadCount((prev) => prev + 1)
          }
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }

  async function handleOpenChat() {
    setShowChatModal(true)
    // Mark all messages as read
    await supabase
      .from('profiles')
      .update({ chat_last_seen: new Date().toISOString() })
      .eq('id', user.id)

    setUnreadCount(0)
  }

  function handleNext() {
    if (currentIndex < filteredFlashcards.length - 1) {
      setCurrentIndex(currentIndex + 1)
      setIsFlipped(false)
      setSelectedAnswer(null)
      x.set(0)
    }
  }

  function handlePrevious() {
    if (currentIndex > 0) {
      setCurrentIndex(currentIndex - 1)
      setIsFlipped(false)
      setSelectedAnswer(null)
      x.set(0)
    }
  }

  function handleFilterChange(type) {
    setFilterType(type)
    setCurrentIndex(0) // Reset to first card when filter changes
    setIsFlipped(false)
    setSelectedAnswer(null)
    x.set(0)
  }

  function getColorClasses(color) {
    const colors = {
      black: { border: 'border-gray-500/30', shadow: 'rgba(107, 114, 128, 0.3)', badge: 'bg-gray-500/20 text-gray-400', hoverBorder: 'hover:border-gray-500/50' },
      gray: { border: 'border-gray-400/30', shadow: 'rgba(156, 163, 175, 0.3)', badge: 'bg-gray-400/20 text-gray-300', hoverBorder: 'hover:border-gray-400/50' },
      slate: { border: 'border-slate-400/30', shadow: 'rgba(148, 163, 184, 0.3)', badge: 'bg-slate-400/20 text-slate-300', hoverBorder: 'hover:border-slate-400/50' },
      red: { border: 'border-red-500/30', shadow: 'rgba(239, 68, 68, 0.3)', badge: 'bg-red-500/20 text-red-400', hoverBorder: 'hover:border-red-500/50' },
      orange: { border: 'border-orange-500/30', shadow: 'rgba(249, 115, 22, 0.3)', badge: 'bg-orange-500/20 text-orange-400', hoverBorder: 'hover:border-orange-500/50' },
      amber: { border: 'border-amber-500/30', shadow: 'rgba(245, 158, 11, 0.3)', badge: 'bg-amber-500/20 text-amber-400', hoverBorder: 'hover:border-amber-500/50' },
      yellow: { border: 'border-yellow-500/30', shadow: 'rgba(234, 179, 8, 0.3)', badge: 'bg-yellow-500/20 text-yellow-400', hoverBorder: 'hover:border-yellow-500/50' },
      lime: { border: 'border-lime-500/30', shadow: 'rgba(132, 204, 22, 0.3)', badge: 'bg-lime-500/20 text-lime-400', hoverBorder: 'hover:border-lime-500/50' },
      green: { border: 'border-green-500/30', shadow: 'rgba(34, 197, 94, 0.3)', badge: 'bg-green-500/20 text-green-400', hoverBorder: 'hover:border-green-500/50' },
      emerald: { border: 'border-emerald-500/30', shadow: 'rgba(16, 185, 129, 0.3)', badge: 'bg-emerald-500/20 text-emerald-400', hoverBorder: 'hover:border-emerald-500/50' },
      teal: { border: 'border-teal-500/30', shadow: 'rgba(20, 184, 166, 0.3)', badge: 'bg-teal-500/20 text-teal-400', hoverBorder: 'hover:border-teal-500/50' },
      cyan: { border: 'border-cyan-500/30', shadow: 'rgba(6, 182, 212, 0.3)', badge: 'bg-cyan-500/20 text-cyan-400', hoverBorder: 'hover:border-cyan-500/50' },
      sky: { border: 'border-sky-500/30', shadow: 'rgba(14, 165, 233, 0.3)', badge: 'bg-sky-500/20 text-sky-400', hoverBorder: 'hover:border-sky-500/50' },
      blue: { border: 'border-blue-500/30', shadow: 'rgba(59, 130, 246, 0.3)', badge: 'bg-blue-500/20 text-blue-400', hoverBorder: 'hover:border-blue-500/50' },
      indigo: { border: 'border-indigo-500/30', shadow: 'rgba(99, 102, 241, 0.3)', badge: 'bg-indigo-500/20 text-indigo-400', hoverBorder: 'hover:border-indigo-500/50' },
      violet: { border: 'border-violet-500/30', shadow: 'rgba(139, 92, 246, 0.3)', badge: 'bg-violet-500/20 text-violet-400', hoverBorder: 'hover:border-violet-500/50' },
      purple: { border: 'border-purple-500/30', shadow: 'rgba(168, 85, 247, 0.3)', badge: 'bg-purple-500/20 text-purple-400', hoverBorder: 'hover:border-purple-500/50' },
      fuchsia: { border: 'border-fuchsia-500/30', shadow: 'rgba(217, 70, 239, 0.3)', badge: 'bg-fuchsia-500/20 text-fuchsia-400', hoverBorder: 'hover:border-fuchsia-500/50' },
      pink: { border: 'border-pink-500/30', shadow: 'rgba(236, 72, 153, 0.3)', badge: 'bg-pink-500/20 text-pink-400', hoverBorder: 'hover:border-pink-500/50' },
      rose: { border: 'border-rose-500/30', shadow: 'rgba(244, 63, 94, 0.3)', badge: 'bg-rose-500/20 text-rose-400', hoverBorder: 'hover:border-rose-500/50' },
    }
    return colors[color] || colors.cyan
  }

  function handleOptionSelect(option) {
    if (selectedAnswer) return // Already answered
    setSelectedAnswer(option)
    setTimeout(() => {
      setIsFlipped(true)
    }, 300)
  }

  function handleSwipe(direction) {
    if (direction === 'right' && currentIndex < filteredFlashcards.length - 1) {
      setTimeout(() => handleNext(), 300)
    }
  }

  // Landing page - show Create and View options
  if (!showFlashcards) {
    return (
      <div className="px-5 py-8 min-h-screen">
        <div className="flex items-center justify-between mb-8">
          <button
            onClick={() => navigate('/')}
            className="flex items-center gap-2 text-cyan-400 hover:text-cyan-300 transition-colors"
          >
            <ArrowLeft size={20} />
            <span className="font-medium">Back</span>
          </button>

          {/* Chat Button */}
          <motion.button
            onClick={handleOpenChat}
            className="relative flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-emerald-500/20 to-green-500/20 border border-emerald-500/30 rounded-xl hover:from-emerald-500/30 hover:to-green-500/30 transition-all"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <MessageCircle size={18} className="text-emerald-400" />
            <span className="text-sm font-semibold text-white">Chat</span>
            {unreadCount > 0 && (
              <span className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white text-xs font-bold rounded-full flex items-center justify-center">
                {unreadCount > 9 ? '9+' : unreadCount}
              </span>
            )}
          </motion.button>
        </div>

        <h1 className="text-3xl font-bold text-white mb-3">Community Flashcards</h1>
        <p className="text-gray-400 mb-12">Create or practice user-generated flashcards</p>

        <div className="flex flex-col gap-4 max-w-md mx-auto">
          {/* Create Flashcard Button */}
          <motion.button
            onClick={() => setShowCreateModal(true)}
            className="w-full p-6 bg-gradient-to-r from-purple-500/20 to-pink-600/10 border-2 border-purple-500/30 rounded-2xl backdrop-blur-sm hover:from-purple-500/30 hover:to-pink-600/20 transition-all"
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-xl bg-purple-500/20 flex items-center justify-center">
                <Plus size={28} className="text-purple-400" />
              </div>
              <div className="flex-1 text-left">
                <h3 className="text-white font-bold text-lg">Create Flashcard</h3>
                <p className="text-gray-400 text-sm">Share your knowledge</p>
              </div>
            </div>
          </motion.button>

          {/* View Flashcards Button */}
          <motion.button
            onClick={() => setShowFlashcards(true)}
            className="w-full p-6 bg-gradient-to-r from-cyan-500/20 to-blue-600/10 border-2 border-cyan-500/30 rounded-2xl backdrop-blur-sm hover:from-cyan-500/30 hover:to-blue-600/20 transition-all"
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            <div className="flex items-center gap-4">
              <div className="w-14 h-14 rounded-xl bg-cyan-500/20 flex items-center justify-center">
                <User size={28} className="text-cyan-400" />
              </div>
              <div className="flex-1 text-left">
                <h3 className="text-white font-bold text-lg">View Flashcards</h3>
                <p className="text-gray-400 text-sm">Practice community cards</p>
              </div>
            </div>
          </motion.button>
        </div>

        <CreateFlashcardModal
          isOpen={showCreateModal}
          onClose={() => {
            setShowCreateModal(false)
          }}
        />

        <CommunityChatModal isOpen={showChatModal} onClose={() => setShowChatModal(false)} />
      </div>
    )
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  if (flashcards.length === 0) {
    return (
      <div className="px-5 py-8">
        <div className="flex items-center justify-between mb-6">
          <button
            onClick={() => setShowFlashcards(false)}
            className="flex items-center gap-2 text-cyan-400 hover:text-cyan-300 transition-colors"
          >
            <ArrowLeft size={20} />
            <span className="font-medium">Back</span>
          </button>
          <motion.button
            onClick={() => setShowCreateModal(true)}
            className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-purple-500/20 to-pink-500/20 border border-purple-500/30 rounded-xl hover:from-purple-500/30 hover:to-pink-500/30 transition-all"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Plus size={18} className="text-purple-400" />
            <span className="text-sm font-semibold text-white">Create</span>
          </motion.button>
        </div>
        <div className="text-center mt-20">
          <p className="text-gray-400 text-lg">No community flashcards yet</p>
          <p className="text-gray-500 text-sm mt-2">Be the first to create one!</p>
          <motion.button
            onClick={() => setShowCreateModal(true)}
            className="mt-6 px-6 py-3 bg-gradient-to-r from-purple-500 to-pink-500 text-white font-semibold rounded-xl hover:from-purple-400 hover:to-pink-400 transition-all"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            Create First Flashcard
          </motion.button>
        </div>
        <CreateFlashcardModal
          isOpen={showCreateModal}
          onClose={() => {
            setShowCreateModal(false)
            fetchCommunityFlashcards()
          }}
        />
      </div>
    )
  }

  // Filter flashcards by type
  const filteredFlashcards = flashcards.filter(card => {
    if (!filterType) return false // Don't show any if no filter selected
    if (filterType === 'mcq') return card.type === 'mcq'
    if (filterType === 'qa') return card.type === 'qa'
    return false
  })

  const currentCard = filteredFlashcards[currentIndex]
  const isCorrect = selectedAnswer === currentCard?.correct_answer
  const swipeThreshold = 100
  const isMCQ = currentCard?.type === 'mcq'
  const isQA = currentCard?.type === 'qa'

  return (
    <div className="px-5 py-8 min-h-screen">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <button
          onClick={() => setShowFlashcards(false)}
          className="flex items-center gap-2 text-cyan-400 hover:text-cyan-300 transition-colors"
        >
          <ArrowLeft size={20} />
          <span className="font-medium">Back</span>
        </button>

        {/* Color Picker Button */}
        <div className="relative">
          <motion.button
            onClick={() => setShowColorPicker(!showColorPicker)}
            className="flex items-center gap-2 px-4 py-2 bg-gradient-to-r from-cyan-500/20 to-blue-500/20 border border-cyan-500/30 rounded-xl hover:from-cyan-500/30 hover:to-blue-500/30 transition-all"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
          >
            <Palette size={18} className="text-cyan-400" />
            <span className="text-sm font-semibold text-white">Color</span>
          </motion.button>

          {/* Color Palette Dropdown */}
          {showColorPicker && (
            <motion.div
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              className="absolute right-0 mt-2 bg-navy-800 border border-white/10 rounded-xl p-4 shadow-2xl z-50 w-64"
            >
              <p className="text-gray-400 text-xs mb-3 font-semibold">Choose Color</p>
              <div className="grid grid-cols-5 gap-2">
                {[
                  { name: 'black', bg: 'bg-gray-900', border: 'border-gray-500' },
                  { name: 'gray', bg: 'bg-gray-700', border: 'border-gray-400' },
                  { name: 'slate', bg: 'bg-slate-700', border: 'border-slate-400' },
                  { name: 'red', bg: 'bg-red-600', border: 'border-red-500' },
                  { name: 'orange', bg: 'bg-orange-600', border: 'border-orange-500' },
                  { name: 'amber', bg: 'bg-amber-600', border: 'border-amber-500' },
                  { name: 'yellow', bg: 'bg-yellow-600', border: 'border-yellow-500' },
                  { name: 'lime', bg: 'bg-lime-600', border: 'border-lime-500' },
                  { name: 'green', bg: 'bg-green-600', border: 'border-green-500' },
                  { name: 'emerald', bg: 'bg-emerald-600', border: 'border-emerald-500' },
                  { name: 'teal', bg: 'bg-teal-600', border: 'border-teal-500' },
                  { name: 'cyan', bg: 'bg-cyan-600', border: 'border-cyan-500' },
                  { name: 'sky', bg: 'bg-sky-600', border: 'border-sky-500' },
                  { name: 'blue', bg: 'bg-blue-600', border: 'border-blue-500' },
                  { name: 'indigo', bg: 'bg-indigo-600', border: 'border-indigo-500' },
                  { name: 'violet', bg: 'bg-violet-600', border: 'border-violet-500' },
                  { name: 'purple', bg: 'bg-purple-600', border: 'border-purple-500' },
                  { name: 'fuchsia', bg: 'bg-fuchsia-600', border: 'border-fuchsia-500' },
                  { name: 'pink', bg: 'bg-pink-600', border: 'border-pink-500' },
                  { name: 'rose', bg: 'bg-rose-600', border: 'border-rose-500' },
                ].map((color) => (
                  <button
                    key={color.name}
                    onClick={() => {
                      setCardColor(color.name)
                      setShowColorPicker(false)
                    }}
                    className={`w-10 h-10 ${color.bg} rounded-lg border-2 ${
                      cardColor === color.name ? color.border : 'border-transparent'
                    } hover:scale-110 transition-transform`}
                    title={color.name.charAt(0).toUpperCase() + color.name.slice(1)}
                  />
                ))}
              </div>
            </motion.div>
          )}
        </div>
      </div>

      <h1 className="text-2xl font-bold text-white mb-6">Community Flashcards</h1>

      {/* Type Filter Buttons */}
      <div className="flex gap-3 mb-6">
        <button
          onClick={() => handleFilterChange('mcq')}
          className={`flex-1 py-3 rounded-xl font-semibold text-sm transition-all ${
            filterType === 'mcq'
              ? 'bg-cyan-500/20 border-2 border-cyan-500/40 text-cyan-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400 hover:border-white/20'
          }`}
        >
          MCQ ({flashcards.filter(c => c.type === 'mcq').length})
        </button>
        <button
          onClick={() => handleFilterChange('qa')}
          className={`flex-1 py-3 rounded-xl font-semibold text-sm transition-all ${
            filterType === 'qa'
              ? 'bg-purple-500/20 border-2 border-purple-500/40 text-purple-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400 hover:border-white/20'
          }`}
        >
          Q/A ({flashcards.filter(c => c.type === 'qa').length})
        </button>
      </div>

      {/* Swipe hints - only for MCQ */}
      {filterType && isMCQ && selectedAnswer && (
        <motion.div
          className="flex justify-center items-center mb-3"
          initial={{ opacity: 0, y: -10 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <div className="px-4 py-2 rounded-xl bg-cyan-500/10 border border-cyan-500/20">
            <span className="text-cyan-400 font-semibold text-sm">Swipe Right for Next →</span>
          </div>
        </motion.div>
      )}

      {/* Show message when no filter selected */}
      {!filterType ? (
        <div className="text-center mt-20">
          <p className="text-gray-400 text-lg mb-2">Select a flashcard type to view</p>
          <p className="text-gray-500 text-sm">Click MCQ or Q/A above to start practicing</p>
        </div>
      ) : filteredFlashcards.length === 0 ? (
        <div className="text-center mt-20">
          <p className="text-gray-400 text-lg">No {filterType === 'mcq' ? 'MCQ' : 'Q/A'} flashcards yet</p>
          <p className="text-gray-500 text-sm mt-2">Be the first to create one!</p>
        </div>
      ) : isQA ? (
        /* Q/A Type - Simple Card (No Flip) */
        <div className="relative mb-6">
          <motion.div
            className={`w-full bg-gradient-to-b from-navy-600/90 to-navy-700/90 backdrop-blur-xl border-2 ${getColorClasses(cardColor).border} rounded-3xl p-6 shadow-2xl`}
            style={{
              boxShadow: `0 0 40px ${getColorClasses(cardColor).shadow}, inset 0 0 20px ${getColorClasses(cardColor).shadow}`,
            }}
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            {/* Creator info */}
            <div className="flex items-center gap-2 mb-6 pb-4 border-b border-white/10">
              <div className="w-8 h-8 rounded-full bg-gradient-to-br from-cyan-400 to-blue-500 flex items-center justify-center text-xs font-bold text-white overflow-hidden">
                {currentCard.profiles?.avatar_url ? (
                  <img src={currentCard.profiles.avatar_url} alt="Avatar" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                ) : (
                  <User size={14} />
                )}
              </div>
              <div className="flex-1">
                <p className="text-white text-sm font-medium">{currentCard.profiles?.username || 'Anonymous'}</p>
                <p className="text-gray-400 text-xs">
                  {new Date(currentCard.created_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                </p>
              </div>
            </div>

            {/* Question */}
            <div className="mb-6">
              <p className="text-cyan-400 text-xs font-semibold mb-2">QUESTION</p>
              <p className="text-white text-lg font-semibold leading-relaxed">
                {currentCard.question}
              </p>
            </div>

            {/* Answer */}
            <div className="bg-navy-800/50 rounded-xl p-5 border border-white/5">
              <p className="text-purple-400 font-semibold text-sm mb-3">ANSWER</p>
              <p className="text-gray-300 text-base leading-relaxed">
                {currentCard.explanation}
              </p>
            </div>

          </motion.div>

          {/* Previous/Next Navigation for Q/A */}
          <div className="flex items-center justify-between gap-4 mt-4">
            <button
              onClick={handlePrevious}
              disabled={currentIndex === 0}
              className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
                currentIndex === 0
                  ? 'bg-gray-700/30 border border-gray-600/30 text-gray-500 cursor-not-allowed'
                  : 'bg-gray-700/20 border border-gray-500/40 text-gray-300 hover:bg-gray-700/30 cursor-pointer'
              }`}
            >
              ← Previous
            </button>

            <button
              onClick={currentIndex === filteredFlashcards.length - 1 ? () => navigate('/') : handleNext}
              className="flex-1 py-3 rounded-xl font-semibold bg-gray-700/20 border border-gray-500/40 text-gray-300 hover:bg-gray-700/30 cursor-pointer transition-all"
            >
              {currentIndex === filteredFlashcards.length - 1 ? 'Back to Home' : 'Next →'}
            </button>
          </div>
        </div>
      ) : (
        /* MCQ Type - 3D Flip Card */
        <div>
        <div className="relative h-[500px] flex items-center justify-center mb-6" style={{ perspective: '1000px' }}>
        <div
          style={{
            width: '100%',
            height: '100%',
            transformStyle: 'preserve-3d',
            transition: 'transform 0.6s',
            transform: isFlipped ? 'rotateY(180deg)' : 'rotateY(0deg)',
          }}
        >
          {/* Front - Question */}
          <div style={{ backfaceVisibility: 'hidden', position: 'absolute', width: '100%', height: '100%' }}>
            <motion.div
              style={{
                x,
                rotate,
                opacity,
                boxShadow: `0 0 40px ${getColorClasses(cardColor).shadow}, inset 0 0 20px ${getColorClasses(cardColor).shadow}`,
              }}
              drag={selectedAnswer ? 'x' : false}
              dragConstraints={{ left: -200, right: 200 }}
              onDragEnd={(e, { offset, velocity }) => {
                if (offset.x > swipeThreshold) {
                  x.set(500, { type: 'spring', velocity: velocity.x, stiffness: 300, damping: 30 })
                  handleSwipe('right')
                } else {
                  x.set(0, { type: 'spring' })
                }
              }}
              className={`w-full h-full bg-gradient-to-b from-navy-600/90 to-navy-700/90 backdrop-blur-xl border-2 ${getColorClasses(cardColor).border} rounded-3xl p-6 flex flex-col shadow-2xl`}
            >
              {/* Creator info */}
              <div className="flex items-center gap-2 mb-4 pb-4 border-b border-white/10">
                <div className="w-8 h-8 rounded-full bg-gradient-to-br from-cyan-400 to-blue-500 flex items-center justify-center text-xs font-bold text-white overflow-hidden">
                  {currentCard.profiles?.avatar_url ? (
                    <img src={currentCard.profiles.avatar_url} alt="Avatar" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                  ) : (
                    <User size={14} />
                  )}
                </div>
                <div className="flex-1">
                  <p className="text-white text-sm font-medium">{currentCard.profiles?.username || 'Anonymous'}</p>
                  <p className="text-gray-400 text-xs">
                    {new Date(currentCard.created_at).toLocaleDateString('en-US', { month: 'short', day: 'numeric' })}
                  </p>
                </div>
              </div>

              {/* Question */}
              <div className="flex-1 flex items-center justify-center">
                <p className="text-white text-xl font-semibold text-center leading-relaxed">
                  {currentCard.question}
                </p>
              </div>

              {/* Options */}
              <div className="space-y-3 mt-4">
                {['a', 'b', 'c', 'd'].map((letter, idx) => {
                  const optionText = currentCard[`option_${letter}`]
                  if (!optionText) return null

                  const isSelected = selectedAnswer === letter
                  const showResult = selectedAnswer !== null
                  const isThisCorrect = letter === currentCard.correct_answer

                  let bgColor = `bg-navy-700/50 border-white/10 ${getColorClasses(cardColor).hoverBorder}`
                  let badgeColor = getColorClasses(cardColor).badge

                  if (showResult) {
                    if (isThisCorrect) {
                      bgColor = 'bg-emerald-500/20 border-emerald-500/50'
                      badgeColor = 'bg-emerald-500/30 text-emerald-400'
                    } else if (isSelected) {
                      bgColor = 'bg-red-500/20 border-red-500/50'
                      badgeColor = 'bg-red-500/30 text-red-400'
                    }
                  }

                  return (
                    <motion.button
                      key={letter}
                      onClick={() => handleOptionSelect(letter)}
                      disabled={selectedAnswer !== null}
                      className={`w-full flex items-center gap-4 p-4 rounded-xl border transition-all ${bgColor} ${
                        selectedAnswer ? 'cursor-not-allowed' : 'cursor-pointer'
                      }`}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: idx * 0.1 }}
                      whileHover={!selectedAnswer ? { scale: 1.02 } : {}}
                      whileTap={!selectedAnswer ? { scale: 0.98 } : {}}
                    >
                      <div className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm ${badgeColor}`}>
                        {letter.toUpperCase()}
                      </div>
                      <span className="flex-1 text-left text-white">{optionText}</span>
                    </motion.button>
                  )
                })}
              </div>
            </motion.div>
          </div>

          {/* Back - Explanation */}
          <div
            style={{
              backfaceVisibility: 'hidden',
              position: 'absolute',
              width: '100%',
              height: '100%',
              transform: 'rotateY(180deg)',
            }}
          >
            <div
              className={`w-full h-full bg-gradient-to-b from-navy-600/90 to-navy-700/90 backdrop-blur-xl border-2 ${getColorClasses(cardColor).border} rounded-3xl p-6 flex flex-col shadow-2xl`}
              style={{
                boxShadow: `0 0 40px ${getColorClasses(cardColor).shadow}, inset 0 0 20px ${getColorClasses(cardColor).shadow}`,
              }}
            >
              {/* Result */}
              <div className="text-center mb-6">
                <div className={`text-5xl mb-3`}>{isCorrect ? '✓' : '✗'}</div>
                <p className={`text-xl font-bold ${isCorrect ? 'text-emerald-400' : 'text-red-400'}`}>
                  {isCorrect ? 'Correct!' : 'Incorrect'}
                </p>
                <p className="text-gray-300 text-sm mt-2">
                  Answer: {currentCard.correct_answer.toUpperCase()}. {currentCard[`option_${currentCard.correct_answer}`]}
                </p>
              </div>

              {/* Explanation */}
              {currentCard.explanation && (
                <div className="flex-1 bg-navy-800/50 rounded-xl p-4">
                  <p className="text-cyan-400 font-semibold text-sm mb-2">Explanation</p>
                  <p className="text-gray-300 text-sm leading-relaxed">{currentCard.explanation}</p>
                </div>
              )}

            </div>
          </div>
        </div>
        </div>

        {/* Previous/Next Navigation for MCQ */}
        <div className="flex items-center justify-between gap-4 mt-4">
          <button
            onClick={handlePrevious}
            disabled={currentIndex === 0}
            className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
              currentIndex === 0
                ? 'bg-gray-700/30 border border-gray-600/30 text-gray-500 cursor-not-allowed'
                : 'bg-cyan-500/10 border border-cyan-500/30 text-cyan-400 hover:bg-cyan-500/20 cursor-pointer'
            }`}
          >
            ← Previous
          </button>

          <button
            onClick={currentIndex === filteredFlashcards.length - 1 ? () => navigate('/') : handleNext}
            className="flex-1 py-3 rounded-xl font-semibold bg-cyan-500/10 border border-cyan-500/30 text-cyan-400 hover:bg-cyan-500/20 cursor-pointer transition-all"
          >
            {currentIndex === filteredFlashcards.length - 1 ? 'Back to Home' : 'Next →'}
          </button>
        </div>
        </div>
      )}

      {/* Create Flashcard Modal */}
      <CreateFlashcardModal
        isOpen={showCreateModal}
        onClose={() => {
          setShowCreateModal(false)
          fetchCommunityFlashcards() // Refresh the list
        }}
      />
    </div>
  )
}
