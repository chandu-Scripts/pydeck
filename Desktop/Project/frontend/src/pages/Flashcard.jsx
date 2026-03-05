import { useEffect, useState, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Bookmark, RotateCcw, Terminal } from 'lucide-react'
import CodeEditor from '../components/CodeEditor'
import SqlEditor from '../components/SqlEditor'
import { springConfigs, buttonTap, buttonHover } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'

export default function Flashcard() {
  const { topicId } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const [topic, setTopic] = useState(null)
  const [cards, setCards] = useState([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [showAnswer, setShowAnswer] = useState(false)
  const [loading, setLoading] = useState(true)
  const [stats, setStats] = useState({ mastered: 0, recall: 0 })
  const [showCodeEditor, setShowCodeEditor] = useState(false)

  useEffect(() => {
    async function fetchCards() {
      const [topicRes, cardsRes] = await Promise.all([
        supabase.from('topics').select('*, paths(name)').eq('id', topicId).single(),
        supabase.from('flashcards').select('*').eq('topic_id', topicId).order('id'),
      ])
      setTopic(topicRes.data)
      setCards(cardsRes.data || [])
      setLoading(false)
    }
    fetchCards()
  }, [topicId])

  async function trackSession(status) {
    if (!user) return
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
        cards_mastered: session.cards_mastered + (status === 'mastered' ? 1 : 0),
      }).eq('id', session.id)
    } else {
      await supabase.from('study_sessions').insert({
        user_id: user.id,
        date: today,
        cards_studied: 1,
        cards_mastered: status === 'mastered' ? 1 : 0,
      })
    }
  }

  async function handleAction(status) {
    const card = cards[currentIndex]
    if (!card || !user) return

    await supabase.from('user_progress').upsert({
      user_id: user.id,
      flashcard_id: card.id,
      status: status === 'recall' ? 'forgot' : 'mastered',
      last_reviewed: new Date().toISOString(),
    }, { onConflict: 'user_id,flashcard_id' })

    await trackSession(status === 'recall' ? 'forgot' : 'mastered')

    setStats(prev => ({
      ...prev,
      [status]: prev[status] + 1,
    }))

    setShowAnswer(false)

    // Move to next card if available
    if (currentIndex < cards.length - 1) {
      setCurrentIndex(prev => prev + 1)
    }
  }

  if (loading) {
    return <CardShuffleLoader />
  }

  if (cards.length === 0) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-5">
        <p className="text-gray-400 text-lg mb-4">No flashcards yet for this topic</p>
        <button onClick={() => navigate(-1)} className="text-cyan-400 hover:underline cursor-pointer">Go back</button>
      </div>
    )
  }

  const card = cards[currentIndex]
  const isLast = currentIndex === cards.length - 1

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4">
        <button onClick={() => navigate(-1)} className="text-gray-400 hover:text-white transition-colors cursor-pointer">
          <ArrowLeft size={22} />
        </button>
        <div className="flex items-center gap-2">
          <span className="text-sm text-gray-400">
            {currentIndex + 1} / {cards.length}
          </span>
          <Bookmark size={18} className="text-gray-500" />
          <button
            onClick={() => setShowCodeEditor(v => !v)}
            className={`p-1.5 rounded-lg transition-colors ${showCodeEditor ? 'text-cyan-400 bg-cyan-500/10' : 'text-gray-500 hover:text-gray-300'}`}
          >
            <Terminal size={18} />
          </button>
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

      {/* Card */}
      <div className="flex-1 flex items-center justify-center px-5 pb-8">
        <div className="w-full max-w-sm" style={{ perspective: '1000px' }}>
          <motion.div
            className="relative w-full min-h-[380px] cursor-pointer"
            style={{ transformStyle: 'preserve-3d' }}
            animate={{ rotateY: showAnswer ? 180 : 0 }}
            transition={springConfigs.bouncy}
            onClick={() => !showAnswer && setShowAnswer(true)}
          >
            {/* Front Face */}
            <div
              className="absolute inset-0 bg-gradient-to-b from-navy-600/80 to-navy-700/80 backdrop-blur-xl border border-white/5 rounded-3xl p-8 flex flex-col items-center justify-center"
              style={{
                backfaceVisibility: 'hidden',
                WebkitBackfaceVisibility: 'hidden',
              }}
            >
              <span className="text-[11px] uppercase tracking-widest text-cyan-400 mb-6">
                {topic?.name}
              </span>
              <p className="text-white text-center text-lg leading-relaxed font-medium">
                {card.question}
              </p>
              <motion.button
                onClick={(e) => { e.stopPropagation(); setShowAnswer(true) }}
                className="mt-8 text-sm text-gray-400 hover:text-cyan-400 transition-colors flex items-center gap-1 cursor-pointer"
                whileHover={buttonHover}
                whileTap={buttonTap}
              >
                <RotateCcw size={14} />
                Show Answer
              </motion.button>
            </div>

            {/* Back Face */}
            <div
              className="absolute inset-0 bg-gradient-to-b from-navy-600/80 to-navy-700/80 backdrop-blur-xl border border-white/5 rounded-3xl p-8 flex flex-col items-center justify-center"
              style={{
                backfaceVisibility: 'hidden',
                WebkitBackfaceVisibility: 'hidden',
                transform: 'rotateY(180deg)',
              }}
            >
              <span className="text-[11px] uppercase tracking-widest text-emerald-400 mb-6">
                Answer
              </span>
              <p className="text-cyan-400 text-center text-xl leading-relaxed font-bold mb-4">
                {card.answer}
              </p>
              {card.explanation && (
                <p className="text-gray-400 text-center text-sm leading-relaxed">
                  {card.explanation}
                </p>
              )}
            </div>
          </motion.div>

          {/* Action buttons */}
          {showAnswer && (
            <motion.div
              className="flex gap-3 mt-6"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
            >
              <motion.button
                onClick={() => handleAction('recall')}
                className="flex-1 py-3.5 rounded-2xl bg-red-500/10 border border-red-500/20 text-red-400 font-semibold hover:bg-red-500/20 transition-colors cursor-pointer"
                whileHover={buttonHover}
                whileTap={buttonTap}
              >
                Recall
              </motion.button>
              <motion.button
                onClick={() => handleAction('mastered')}
                className="flex-1 py-3.5 rounded-2xl bg-emerald-500/10 border border-emerald-500/20 text-emerald-400 font-semibold hover:bg-emerald-500/20 transition-colors cursor-pointer"
                whileHover={buttonHover}
                whileTap={buttonTap}
              >
                Mastered
              </motion.button>
            </motion.div>
          )}

          {/* Stats */}
          <div className="flex justify-center gap-6 mt-4">
            <span className="text-sm text-emerald-400">{stats.mastered} mastered</span>
            <span className="text-sm text-red-400">{stats.recall} recall</span>
          </div>

          {/* End of deck message */}
          {isLast && showAnswer && (
            <p className="text-center text-gray-500 text-xs mt-3">Last card in this topic</p>
          )}
        </div>
      </div>

      {/* Sliding Code Editor */}
      <AnimatePresence>
        {showCodeEditor && (
          <motion.div
            className="fixed bottom-0 left-0 right-0 z-40 px-4 pb-4"
            initial={{ y: '100%' }}
            animate={{ y: 0 }}
            exit={{ y: '100%' }}
            transition={{ type: 'spring', stiffness: 300, damping: 30 }}
          >
            {topic?.paths?.name === 'MySQL' ? (
              <SqlEditor initialCode="-- Test your SQL here\nSELECT * FROM students;\n" height="200px" compact />
            ) : (
              <CodeEditor initialCode="# Test your understanding here\n" height="200px" compact />
            )}
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
