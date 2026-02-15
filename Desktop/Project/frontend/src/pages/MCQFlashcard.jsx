import { useEffect, useState, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence, useMotionValue, useTransform } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, RotateCcw, Zap, RefreshCcw, CheckCircle, Trash2, Edit } from 'lucide-react'
import confetti from 'canvas-confetti'
import { springConfigs, buttonTap } from '../utils/animations'

const optionLabels = ['A', 'B', 'C', 'D']
const optionKeys = ['option_a', 'option_b', 'option_c', 'option_d']

// Color palette for vertical bars (excluding green - reserved for correct answer)
const barColors = ['#06b6d4', '#8b5cf6', '#ec4899', '#f59e0b'] // Cyan, Purple, Pink, Orange

// Speed presets
const SPEED_PRESETS = {
  slow: { duration: 3.0, label: 'Slow', icon: '🐢' },
  normal: { duration: 1.5, label: 'Normal', icon: '🚶' },
  fast: { duration: 0.5, label: 'Fast', icon: '🐰' },
}

export default function MCQFlashcard() {
  const { subtopicId } = useParams()
  const navigate = useNavigate()
  const { user, isAdmin } = useAuth()
  const [subtopic, setSubtopic] = useState(null)
  const [cards, setCards] = useState([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [selectedOption, setSelectedOption] = useState(null)
  const [showResult, setShowResult] = useState(false)
  const [isCorrect, setIsCorrect] = useState(false)
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState({ correct: 0, incorrect: 0 })
  const [responseStats, setResponseStats] = useState({})

  // Speed control state - load from localStorage or default to 'normal'
  const [flipSpeed, setFlipSpeed] = useState(() => {
    const saved = localStorage.getItem('quizFlipSpeed')
    return saved || 'normal'
  })

  // Speed popup visibility
  const [showSpeedPopup, setShowSpeedPopup] = useState(false)

  // Admin controls
  const [showEditModal, setShowEditModal] = useState(false)
  const [editForm, setEditForm] = useState({
    question: '',
    option_a: '',
    option_b: '',
    option_c: '',
    option_d: '',
    correct_option: '',
    explanation: ''
  })

  // Swipe motion values for visual feedback
  const x = useMotionValue(0)
  const rotate = useTransform(x, [-200, 0, 200], [-15, 0, 15])
  const opacity = useTransform(x, [-200, -100, 0, 100, 200], [0.5, 0.8, 1, 0.8, 0.5])
  const leftIndicatorOpacity = useTransform(x, [-200, -30, 0], [1, 1, 0])
  const rightIndicatorOpacity = useTransform(x, [0, 30, 200], [0, 1, 1])

  // Select speed function
  const selectSpeed = (speed) => {
    setFlipSpeed(speed)
    localStorage.setItem('quizFlipSpeed', speed)
    setShowSpeedPopup(false)
  }

  const currentSpeedConfig = SPEED_PRESETS[flipSpeed]

  useEffect(() => {
    async function fetchData() {
      const [subtopicRes, cardsRes] = await Promise.all([
        supabase
          .from('subtopics')
          .select('*, topics(name, paths(name))')
          .eq('id', subtopicId)
          .single(),
        supabase
          .from('flashcards')
          .select('*')
          .eq('subtopic_id', subtopicId)
          .not('correct_option', 'is', null)
          .order('id'),
      ])

      setSubtopic(subtopicRes.data)
      setCards(cardsRes.data || [])
      setLoading(false)
    }
    fetchData()
  }, [subtopicId])

  // Fetch response stats for current card
  useEffect(() => {
    async function fetchResponseStats() {
      if (cards.length === 0 || !cards[currentIndex]) return

      const cardId = cards[currentIndex].id
      const { data } = await supabase
        .from('flashcard_responses')
        .select('selected_option')
        .eq('flashcard_id', cardId)

      if (data) {
        const counts = { a: 0, b: 0, c: 0, d: 0 }
        data.forEach(r => {
          if (counts[r.selected_option] !== undefined) {
            counts[r.selected_option]++
          }
        })
        const total = data.length || 1
        setResponseStats({
          a: Math.round((counts.a / total) * 100),
          b: Math.round((counts.b / total) * 100),
          c: Math.round((counts.c / total) * 100),
          d: Math.round((counts.d / total) * 100),
          total: data.length,
        })
      }
    }
    fetchResponseStats()
  }, [cards, currentIndex])

  const fireConfetti = useCallback(() => {
    confetti({
      particleCount: 100,
      spread: 70,
      origin: { y: 0.6 },
      colors: ['#06b6d4', '#10b981', '#22d3ee', '#34d399'],
    })
  }, [])

  async function handleOptionSelect(optionKey) {
    if (showResult) return

    const option = optionKey.slice(-1) // 'a', 'b', 'c', or 'd'
    setSelectedOption(option)
    const card = cards[currentIndex]
    const correct = option === card.correct_option

    setIsCorrect(correct)
    setShowResult(true)

    if (correct) {
      fireConfetti()
      setStats(prev => ({ ...prev, correct: prev.correct + 1 }))
    } else {
      setStats(prev => ({ ...prev, incorrect: prev.incorrect + 1 }))
    }

    // Record response
    if (user) {
      await supabase.from('flashcard_responses').insert({
        flashcard_id: card.id,
        user_id: user.id,
        selected_option: option,
        is_correct: correct,
      })

      // Update user progress
      await supabase.from('user_progress').upsert({
        user_id: user.id,
        flashcard_id: card.id,
        status: correct ? 'mastered' : 'forgot',
        last_reviewed: new Date().toISOString(),
      }, { onConflict: 'user_id,flashcard_id' })

      // Track session
      const today = new Date().toISOString().split('T')[0]
      const { data: session } = await supabase
        .from('study_sessions')
        .select('*')
        .eq('user_id', user.id)
        .eq('date', today)
        .single()

      if (session) {
        await supabase.from('study_sessions').update({
          cards_studied: session.cards_studied + 1,
          cards_mastered: session.cards_mastered + (correct ? 1 : 0),
        }).eq('id', session.id)
      } else {
        await supabase.from('study_sessions').insert({
          user_id: user.id,
          date: today,
          cards_studied: 1,
          cards_mastered: correct ? 1 : 0,
        })
      }
    }
  }

  function handleNext() {
    if (currentIndex < cards.length - 1) {
      setCurrentIndex(prev => prev + 1)
      setSelectedOption(null)
      setShowResult(false)
      setIsCorrect(false)
      x.set(0) // Reset swipe position
    }
  }

  function handlePrevious() {
    if (currentIndex > 0) {
      setCurrentIndex(prev => prev - 1)
      setSelectedOption(null)
      setShowResult(false)
      setIsCorrect(false)
      x.set(0) // Reset swipe position
    }
  }

  // Swipe gesture handler for Recall/Mastered
  async function handleSwipe(direction) {
    const card = cards[currentIndex]
    if (!card || !user) return

    const status = direction === 'left' ? 'forgot' : 'mastered'

    // Update user progress
    await supabase.from('user_progress').upsert({
      user_id: user.id,
      flashcard_id: card.id,
      status: status,
      last_reviewed: new Date().toISOString(),
    }, { onConflict: 'user_id,flashcard_id' })

    // Show visual feedback
    if (direction === 'right') {
      confetti({
        particleCount: 50,
        spread: 60,
        origin: { y: 0.6 },
        colors: ['#10b981', '#34d399'],
      })
    }

    // Move to next question (card will reset due to key change)
    setTimeout(() => {
      x.set(0) // Reset position for next card
      handleNext()
    }, 400)
  }

  // Admin: Delete flashcard
  async function handleDelete() {
    if (!confirm('Are you sure you want to delete this flashcard? This cannot be undone.')) return

    const card = cards[currentIndex]
    const { error } = await supabase
      .from('flashcards')
      .delete()
      .eq('id', card.id)

    if (error) {
      alert('Error deleting flashcard: ' + error.message)
      return
    }

    // Remove from local state
    const newCards = cards.filter((_, idx) => idx !== currentIndex)
    setCards(newCards)

    // Adjust current index if needed
    if (currentIndex >= newCards.length && newCards.length > 0) {
      setCurrentIndex(newCards.length - 1)
    }

    // Reset state
    setSelectedOption(null)
    setShowResult(false)
    setIsCorrect(false)
  }

  // Admin: Open edit modal
  function handleEditOpen() {
    const card = cards[currentIndex]
    setEditForm({
      question: card.question,
      option_a: card.option_a || '',
      option_b: card.option_b || '',
      option_c: card.option_c || '',
      option_d: card.option_d || '',
      correct_option: card.correct_option || '',
      explanation: card.explanation || ''
    })
    setShowEditModal(true)
  }

  // Admin: Save edit
  async function handleEditSave() {
    const card = cards[currentIndex]
    const { error } = await supabase
      .from('flashcards')
      .update({
        question: editForm.question.trim(),
        option_a: editForm.option_a.trim(),
        option_b: editForm.option_b.trim(),
        option_c: editForm.option_c.trim(),
        option_d: editForm.option_d.trim(),
        correct_option: editForm.correct_option,
        explanation: editForm.explanation.trim()
      })
      .eq('id', card.id)

    if (error) {
      alert('Error updating flashcard: ' + error.message)
      return
    }

    // Update local state
    const newCards = [...cards]
    newCards[currentIndex] = {
      ...card,
      question: editForm.question.trim(),
      option_a: editForm.option_a.trim(),
      option_b: editForm.option_b.trim(),
      option_c: editForm.option_c.trim(),
      option_d: editForm.option_d.trim(),
      correct_option: editForm.correct_option,
      explanation: editForm.explanation.trim()
    }
    setCards(newCards)

    setShowEditModal(false)
    alert('Flashcard updated successfully!')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  if (cards.length === 0) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-5">
        <p className="text-gray-400 text-lg mb-4">No quiz questions available</p>
        <button onClick={() => navigate(-1)} className="text-cyan-400 hover:underline cursor-pointer">
          Go back
        </button>
      </div>
    )
  }

  const card = cards[currentIndex]
  const isLast = currentIndex === cards.length - 1

  // Get max value for vertical bar scaling
  const maxPercent = Math.max(
    responseStats.a || 0,
    responseStats.b || 0,
    responseStats.c || 0,
    responseStats.d || 0,
    10 // minimum 10% to always show some height
  )

  return (
    <div className="min-h-screen flex flex-col bg-navy-900">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4">
        <button onClick={() => navigate(-1)} className="text-gray-400 hover:text-white transition-colors cursor-pointer">
          <ArrowLeft size={22} />
        </button>
        <div className="text-center">
          <p className="text-xs text-gray-500">{subtopic?.name}</p>
          <p className="text-sm text-gray-400">
            {currentIndex + 1} / {cards.length}
          </p>
        </div>
        <div className="flex items-center gap-2 relative">
          {/* Admin Controls */}
          {isAdmin && (
            <>
              <motion.button
                onClick={handleEditOpen}
                className="p-2 rounded-xl bg-cyan-500/20 border border-cyan-500/30 hover:bg-cyan-500/30 transition-colors cursor-pointer"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                title="Edit this flashcard"
              >
                <Edit size={16} className="text-cyan-400" />
              </motion.button>
              <motion.button
                onClick={handleDelete}
                className="p-2 rounded-xl bg-red-500/20 border border-red-500/30 hover:bg-red-500/30 transition-colors cursor-pointer"
                whileHover={{ scale: 1.05 }}
                whileTap={{ scale: 0.95 }}
                title="Delete this flashcard"
              >
                <Trash2 size={16} className="text-red-400" />
              </motion.button>
            </>
          )}

          {/* Speed Button */}
          <motion.button
            onClick={() => setShowSpeedPopup(!showSpeedPopup)}
            className="flex items-center gap-2 px-3 py-1.5 rounded-xl bg-navy-700/50 border border-cyan-500/30 hover:bg-navy-700/70 transition-colors cursor-pointer"
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            title="Adjust flip speed"
          >
            <Zap size={16} className="text-cyan-400" />
            <span className="text-xs text-cyan-400 font-medium hidden sm:inline">
              Speed
            </span>
          </motion.button>

          {/* Speed Popup Flashcard */}
          <AnimatePresence>
            {showSpeedPopup && (
              <>
                {/* Backdrop */}
                <motion.div
                  className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  onClick={() => setShowSpeedPopup(false)}
                />

                {/* Popup Flashcard */}
                <motion.div
                  className="fixed top-20 right-5 z-50 w-80 bg-gradient-to-b from-navy-600/95 to-navy-700/95 backdrop-blur-xl border-2 border-cyan-500/40 rounded-2xl p-6 shadow-2xl"
                  style={{
                    boxShadow: '0 0 50px rgba(6, 182, 212, 0.4), inset 0 0 30px rgba(6, 182, 212, 0.1)',
                  }}
                  initial={{ opacity: 0, scale: 0.8, y: -20, rotateX: -15 }}
                  animate={{ opacity: 1, scale: 1, y: 0, rotateX: 0 }}
                  exit={{ opacity: 0, scale: 0.8, y: -20, rotateX: 15 }}
                  transition={springConfigs.bouncy}
                >
                  {/* Header */}
                  <div className="mb-4">
                    <h3 className="text-white font-bold text-lg flex items-center gap-2">
                      <Zap size={20} className="text-cyan-400" />
                      Flip Speed
                    </h3>
                    <p className="text-gray-400 text-xs mt-1">Choose your preferred animation speed</p>
                  </div>

                  {/* Speed Options */}
                  <div className="space-y-3">
                    {Object.entries(SPEED_PRESETS).map(([key, config]) => {
                      const isSelected = flipSpeed === key
                      return (
                        <motion.button
                          key={key}
                          onClick={() => selectSpeed(key)}
                          className={`w-full p-4 rounded-xl border-2 transition-all cursor-pointer ${
                            isSelected
                              ? 'bg-cyan-500/20 border-cyan-500/60 shadow-lg shadow-cyan-500/30'
                              : 'bg-navy-700/50 border-white/10 hover:border-cyan-500/30 hover:bg-navy-700/70'
                          }`}
                          whileHover={{ scale: 1.03 }}
                          whileTap={{ scale: 0.97 }}
                        >
                          <div className="flex items-center justify-between">
                            <div className="flex items-center gap-3">
                              <span className="text-3xl">{config.icon}</span>
                              <div className="text-left">
                                <p className={`font-bold text-sm ${isSelected ? 'text-cyan-400' : 'text-white'}`}>
                                  {config.label}
                                </p>
                                <p className="text-gray-400 text-xs">
                                  {config.duration}s flip
                                </p>
                              </div>
                            </div>
                            {isSelected && (
                              <motion.div
                                className="w-6 h-6 rounded-full bg-cyan-400 flex items-center justify-center"
                                initial={{ scale: 0, rotate: -180 }}
                                animate={{ scale: 1, rotate: 0 }}
                                transition={springConfigs.bouncy}
                              >
                                <svg className="w-4 h-4 text-navy-900" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                                </svg>
                              </motion.div>
                            )}
                          </div>
                        </motion.button>
                      )
                    })}
                  </div>

                  {/* Close hint */}
                  <p className="text-center text-gray-500 text-xs mt-4">
                    Click outside or select an option to close
                  </p>
                </motion.div>
              </>
            )}
          </AnimatePresence>

          {/* Stats */}
          <div className="flex items-center gap-2 text-sm">
            <span className="text-emerald-400">{stats.correct}</span>
            <span className="text-gray-600">/</span>
            <span className="text-red-400">{stats.incorrect}</span>
          </div>
        </div>
      </div>

      {/* Progress bar */}
      <div className="px-5 mb-6">
        <div className="h-1 bg-navy-700 rounded-full overflow-hidden">
          <motion.div
            className="h-full bg-gradient-to-r from-cyan-500 to-cyan-400 rounded-full"
            initial={{ width: 0 }}
            animate={{ width: `${((currentIndex + 1) / cards.length) * 100}%` }}
            transition={{ duration: 0.5, ease: 'easeOut' }}
          />
        </div>
      </div>

      {/* Centered Flashcard */}
      <div className="flex-1 flex items-center justify-center px-5 pb-8">
        <div className="w-full max-w-lg">
          {/* Swipe Hint - Just Above Card */}
          {showResult && (
            <motion.div
              className="flex justify-between items-center mb-3 px-2"
              initial={{ opacity: 0, y: -10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.6 }}
            >
              <div className="px-4 py-2 rounded-xl bg-red-500/10 border border-red-500/20">
                <span className="text-red-400 font-semibold text-sm">← Recall</span>
              </div>
              <div className="px-4 py-2 rounded-xl bg-emerald-500/10 border border-emerald-500/20">
                <span className="text-emerald-400 font-semibold text-sm">Mastered →</span>
              </div>
            </motion.div>
          )}

          <div style={{ perspective: '2500px' }}>
          <motion.div
            className="relative w-full min-h-[500px]"
            style={{
              transformStyle: 'preserve-3d',
              boxShadow: showResult
                ? isCorrect
                  ? '0 25px 50px -12px rgba(16, 185, 129, 0.4)'
                  : '0 25px 50px -12px rgba(239, 68, 68, 0.4)'
                : '0 25px 50px -12px rgba(6, 182, 212, 0.3)'
            }}
            animate={{
              rotateY: showResult ? 180 : 0,
              scale: showResult ? [1, 1.08, 1] : 1,
              z: showResult ? [0, 50, 0] : 0,
            }}
            transition={{
              rotateY: { duration: currentSpeedConfig.duration, ease: [0.25, 0.46, 0.45, 0.94] },
              scale: { duration: currentSpeedConfig.duration, ease: 'easeInOut' },
              z: { duration: currentSpeedConfig.duration, ease: 'easeInOut' }
            }}
            key={currentIndex}
          >
            {/* FRONT FACE - Question + Options */}
            <div
              className="absolute inset-0 bg-gradient-to-b from-navy-600/90 to-navy-700/90 backdrop-blur-xl border-2 border-cyan-500/30 rounded-3xl p-6 flex flex-col shadow-2xl"
              style={{
                backfaceVisibility: 'hidden',
                WebkitBackfaceVisibility: 'hidden',
                boxShadow: '0 0 40px rgba(6, 182, 212, 0.3), inset 0 0 20px rgba(6, 182, 212, 0.1)',
              }}
            >
              {/* Question */}
              <div className="mb-6">
                <span className="text-[11px] uppercase tracking-widest text-cyan-400 mb-3 block">
                  Question
                </span>
                <p className="text-white text-lg leading-relaxed font-medium">
                  {card.question}
                </p>
              </div>

              {/* Options */}
              <div className="flex-1 flex flex-col gap-3 justify-center">
                {optionKeys.map((key, idx) => {
                  const optionValue = key.slice(-1)
                  const optionText = card[key]
                  if (!optionText) return null

                  return (
                    <motion.button
                      key={key}
                      onClick={() => handleOptionSelect(key)}
                      className="w-full flex items-center gap-4 p-4 rounded-xl bg-navy-700/50 border border-white/10 hover:border-cyan-500/50 transition-all cursor-pointer"
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: idx * 0.1, ...springConfigs.gentle }}
                      whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
                      whileTap={buttonTap}
                    >
                      <div className="w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm bg-cyan-500/20 text-cyan-400">
                        {optionLabels[idx]}
                      </div>
                      <span className="flex-1 text-left text-white">{optionText}</span>
                    </motion.button>
                  )
                })}
              </div>

            </div>

            {/* BACK FACE - Result + Vertical Bar Graph (with swipe) */}
            <div
              className="absolute inset-0"
              style={{
                backfaceVisibility: 'hidden',
                WebkitBackfaceVisibility: 'hidden',
                transform: 'rotateY(180deg)',
              }}
            >
              <motion.div
                className={`w-full h-full backdrop-blur-xl border-2 rounded-3xl p-6 flex flex-col shadow-2xl ${
                  isCorrect
                    ? 'bg-gradient-to-b from-emerald-600/80 to-navy-700/90 border-emerald-500/40'
                    : 'bg-gradient-to-b from-red-600/80 to-navy-700/90 border-red-500/40'
                }`}
                style={{
                  boxShadow: isCorrect
                    ? '0 0 50px rgba(16, 185, 129, 0.4), inset 0 0 30px rgba(16, 185, 129, 0.15)'
                    : '0 0 50px rgba(239, 68, 68, 0.4), inset 0 0 30px rgba(239, 68, 68, 0.15)',
                  x,
                  rotate,
                  opacity,
                }}
                drag="x"
                dragConstraints={{ left: -200, right: 200 }}
                dragElastic={0.2}
                onDragEnd={(e, { offset, velocity }) => {
                  const swipeThreshold = 100

                  if (offset.x < -swipeThreshold) {
                    // Swipe left - animate card off-screen to the left
                    x.set(-500, { type: 'spring', velocity: velocity.x, stiffness: 300, damping: 30 })
                    handleSwipe('left')
                  } else if (offset.x > swipeThreshold) {
                    // Swipe right - animate card off-screen to the right
                    x.set(500, { type: 'spring', velocity: velocity.x, stiffness: 300, damping: 30 })
                    handleSwipe('right')
                  } else {
                    // Not enough swipe - snap back to center
                    x.set(0, { type: 'spring', stiffness: 500, damping: 30 })
                  }
                }}
              >
              {/* Swipe Indicators */}
              <motion.div
                className="absolute left-8 top-1/2 -translate-y-1/2 flex items-center gap-2"
                style={{
                  opacity: leftIndicatorOpacity
                }}
              >
                <RefreshCcw size={32} className="text-red-400" />
                <span className="text-red-400 font-bold text-lg">Recall</span>
              </motion.div>

              <motion.div
                className="absolute right-8 top-1/2 -translate-y-1/2 flex items-center gap-2"
                style={{
                  opacity: rightIndicatorOpacity
                }}
              >
                <span className="text-emerald-400 font-bold text-lg">Mastered</span>
                <CheckCircle size={32} className="text-emerald-400" />
              </motion.div>
              {/* Result Badge */}
              <div className="text-center mb-6">
                <motion.div
                  className={`inline-block px-6 py-2 rounded-full font-bold text-lg ${
                    isCorrect
                      ? 'bg-emerald-500/20 text-emerald-400 border border-emerald-500/30'
                      : 'bg-red-500/20 text-red-400 border border-red-500/30'
                  }`}
                  initial={{ scale: 0, rotate: -180 }}
                  animate={{ scale: 1, rotate: 0 }}
                  transition={{ delay: 0.3, ...springConfigs.bouncy }}
                >
                  {isCorrect ? '✓ Correct!' : '✗ Incorrect'}
                </motion.div>
              </div>

              {/* Explanation */}
              {card.explanation && (
                <motion.div
                  className="bg-navy-700/50 rounded-2xl p-4 mb-6 border border-white/5"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.4 }}
                >
                  <p className="text-cyan-400 font-medium text-sm mb-2">Explanation:</p>
                  <p className="text-gray-300 text-sm leading-relaxed">{card.explanation}</p>
                </motion.div>
              )}

              {/* Vertical Bar Graph - How Others Answered */}
              {responseStats.total > 0 && (
                <motion.div
                  className="flex-1 bg-navy-700/30 rounded-2xl p-5 border border-white/5 flex flex-col"
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.5 }}
                >
                  {/* Header - Fixed at top */}
                  <p className="text-gray-400 text-xs mb-6 text-center flex-shrink-0">
                    How others answered ({responseStats.total} responses)
                  </p>

                  {/* Bar Chart Container - Limited height to prevent overlap */}
                  <div className="flex items-end justify-around gap-3 flex-1" style={{ maxHeight: '180px' }}>
                    {optionKeys.map((key, idx) => {
                      const optionValue = key.slice(-1)
                      const percent = responseStats[optionValue] || 0
                      const isCorrectOption = card.correct_option === optionValue
                      const isUserSelection = selectedOption === optionValue

                      if (!card[key]) return null

                      // Always use green for correct answer, otherwise use assigned colors
                      const barColor = isCorrectOption ? '#10b981' : barColors[idx % barColors.length]

                      return (
                        <div key={key} className="flex-1 flex flex-col items-center justify-end h-full">
                          {/* Bar - grows upward, fixed position with safe margin */}
                          <div className="w-full flex flex-col items-center justify-end" style={{ height: '130px' }}>
                            <motion.div
                              className={`w-full rounded-t-xl relative flex items-start justify-center ${
                                isUserSelection ? 'ring-2 ring-white ring-offset-2 ring-offset-emerald-900/50' : ''
                              }`}
                              style={{
                                backgroundColor: barColor,
                                height: `${(percent / maxPercent) * 100}%`,
                                minHeight: percent > 0 ? '28px' : '0px',
                                boxShadow: isCorrectOption
                                  ? '0 0 20px rgba(16, 185, 129, 0.5)'
                                  : `0 0 15px ${barColor}40`,
                              }}
                              initial={{ height: 0 }}
                              animate={{ height: `${(percent / maxPercent) * 100}%` }}
                              transition={{ duration: 1, delay: 0.8 + idx * 0.15, ease: 'easeOut' }}
                            >
                              {/* Percentage Label - INSIDE bar at top */}
                              {percent > 0 && (
                                <motion.span
                                  className="text-xs font-bold text-white pt-1"
                                  initial={{ opacity: 0, scale: 0 }}
                                  animate={{ opacity: 1, scale: 1 }}
                                  transition={{ delay: 1 + idx * 0.15, ...springConfigs.bouncy }}
                                >
                                  {percent}%
                                </motion.span>
                              )}
                            </motion.div>
                          </div>

                          {/* Option Label - FIXED HEIGHT container for alignment */}
                          <div className="mt-2 flex flex-col items-center justify-start h-10 w-full">
                            {/* Label on same line for all options */}
                            <div className="flex items-center gap-1">
                              <span className={`text-sm font-bold ${
                                isCorrectOption ? 'text-emerald-400' :
                                isUserSelection ? 'text-white' : 'text-gray-400'
                              }`}>
                                {optionLabels[idx]}
                              </span>
                              {/* Checkmark next to label, not below */}
                              {isCorrectOption && (
                                <span className="text-xs text-emerald-400 font-bold">✓</span>
                              )}
                            </div>
                          </div>
                        </div>
                      )
                    })}
                  </div>
                </motion.div>
              )}
              </motion.div>
            </div>
          </motion.div>
          </div>

          {/* Previous/Next Navigation Buttons */}
          <motion.div
            className="flex items-center justify-between gap-4 mt-6"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
          >
            {/* Previous Button */}
            <motion.button
              onClick={handlePrevious}
              disabled={currentIndex === 0}
              className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
                currentIndex === 0
                  ? 'bg-gray-700/30 border border-gray-600/30 text-gray-500 cursor-not-allowed'
                  : 'bg-cyan-500/10 border border-cyan-500/30 text-cyan-400 hover:bg-cyan-500/20 cursor-pointer'
              }`}
              whileHover={currentIndex === 0 ? {} : { scale: 1.02 }}
              whileTap={currentIndex === 0 ? {} : buttonTap}
            >
              ← Previous
            </motion.button>

            {/* Next Button */}
            <motion.button
              onClick={handleNext}
              disabled={isLast}
              className={`flex-1 py-3 rounded-xl font-semibold transition-all ${
                isLast
                  ? 'bg-gray-700/30 border border-gray-600/30 text-gray-500 cursor-not-allowed'
                  : 'bg-cyan-500/10 border border-cyan-500/30 text-cyan-400 hover:bg-cyan-500/20 cursor-pointer'
              }`}
              whileHover={isLast ? {} : { scale: 1.02 }}
              whileTap={isLast ? {} : buttonTap}
            >
              Next →
            </motion.button>
          </motion.div>
        </div>
      </div>

      {/* Edit Modal */}
      {showEditModal && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-5">
          <motion.div
            className="bg-navy-800 border border-white/10 rounded-2xl p-6 max-w-lg w-full max-h-[90vh] overflow-y-auto"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            <h2 className="text-xl font-bold text-white mb-4">Edit Flashcard</h2>

            {/* Question */}
            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Question</label>
              <textarea
                value={editForm.question}
                onChange={(e) => setEditForm({ ...editForm, question: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                rows={3}
              />
            </div>

            {/* Options */}
            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option A</label>
              <input
                type="text"
                value={editForm.option_a}
                onChange={(e) => setEditForm({ ...editForm, option_a: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
              />
            </div>

            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option B</label>
              <input
                type="text"
                value={editForm.option_b}
                onChange={(e) => setEditForm({ ...editForm, option_b: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
              />
            </div>

            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option C</label>
              <input
                type="text"
                value={editForm.option_c}
                onChange={(e) => setEditForm({ ...editForm, option_c: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
              />
            </div>

            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option D</label>
              <input
                type="text"
                value={editForm.option_d}
                onChange={(e) => setEditForm({ ...editForm, option_d: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
              />
            </div>

            {/* Correct Answer */}
            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Correct Answer</label>
              <select
                value={editForm.correct_option}
                onChange={(e) => setEditForm({ ...editForm, correct_option: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
              >
                <option value="">Select correct answer</option>
                <option value="a">A</option>
                <option value="b">B</option>
                <option value="c">C</option>
                <option value="d">D</option>
              </select>
            </div>

            {/* Explanation */}
            <div className="mb-6">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Explanation</label>
              <textarea
                value={editForm.explanation}
                onChange={(e) => setEditForm({ ...editForm, explanation: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                rows={3}
              />
            </div>

            {/* Actions */}
            <div className="flex gap-3">
              <motion.button
                onClick={() => setShowEditModal(false)}
                className="flex-1 py-3 rounded-xl bg-gray-500/20 border border-gray-500/30 text-gray-400 font-semibold hover:bg-gray-500/30 transition-colors"
                whileTap={buttonTap}
              >
                Cancel
              </motion.button>
              <motion.button
                onClick={handleEditSave}
                className="flex-1 py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors"
                whileTap={buttonTap}
              >
                Save Changes
              </motion.button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
