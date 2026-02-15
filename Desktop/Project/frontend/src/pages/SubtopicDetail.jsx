import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { ArrowLeft, BookOpen, HelpCircle } from 'lucide-react'
import { staggerContainer, staggerItem, buttonTap } from '../utils/animations'

export default function SubtopicDetail() {
  const { subtopicId } = useParams()
  const navigate = useNavigate()
  const [subtopic, setSubtopic] = useState(null)
  const [conceptCount, setConceptCount] = useState(0)
  const [flashcardCount, setFlashcardCount] = useState(0)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    async function fetchData() {
      const [subtopicRes, conceptRes, flashcardRes] = await Promise.all([
        supabase
          .from('subtopics')
          .select('*, topics(name, paths(name))')
          .eq('id', subtopicId)
          .single(),
        supabase
          .from('concepts')
          .select('id', { count: 'exact' })
          .eq('subtopic_id', subtopicId),
        supabase
          .from('flashcards')
          .select('id', { count: 'exact' })
          .eq('subtopic_id', subtopicId),
      ])

      setSubtopic(subtopicRes.data)
      setConceptCount(conceptRes.count || 0)
      setFlashcardCount(flashcardRes.count || 0)
      setLoading(false)
    }
    fetchData()
  }, [subtopicId])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen flex flex-col px-5 py-8 lg:py-12">
      {/* Header */}
      <div className="flex items-center gap-3 mb-8">
        <button
          onClick={() => navigate(`/topics/${subtopic?.topic_id}`)}
          className="text-gray-400 hover:text-white transition-colors cursor-pointer"
        >
          <ArrowLeft size={22} />
        </button>
        <div>
          <p className="text-cyan-400 text-xs font-medium mb-0.5">
            {subtopic?.topics?.paths?.name} / {subtopic?.topics?.name}
          </p>
          <h1 className="text-2xl lg:text-3xl font-bold text-white">{subtopic?.name}</h1>
        </div>
      </div>

      {/* Choice Cards */}
      <motion.div
        className="flex-1 flex flex-col lg:flex-row items-center justify-center gap-4 lg:gap-6 max-w-2xl mx-auto w-full"
        variants={staggerContainer}
        initial="initial"
        animate="animate"
      >
        {/* Concept Card */}
        <motion.button
          onClick={() => navigate(`/concept/${subtopicId}`)}
          disabled={conceptCount === 0}
          className={`w-full lg:flex-1 p-6 lg:p-8 rounded-2xl bg-gradient-to-b from-emerald-500/20 to-emerald-600/5 border border-emerald-500/15 hover:border-emerald-500/30 backdrop-blur-sm transition-colors ${conceptCount === 0 ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
          variants={staggerItem}
          whileHover={conceptCount > 0 ? { scale: 1.05, transition: { duration: 0.2 } } : {}}
          whileTap={conceptCount > 0 ? buttonTap : {}}
        >
          <div className="flex flex-col items-center gap-4">
            <div className="w-16 h-16 rounded-2xl bg-emerald-500/20 flex items-center justify-center">
              <BookOpen size={32} className="text-emerald-400" />
            </div>
            <div className="text-center">
              <h2 className="text-xl font-bold text-white mb-1">Concept</h2>
              <p className="text-gray-400 text-sm">
                {conceptCount > 0
                  ? `Learn with ${conceptCount} detailed ${conceptCount === 1 ? 'section' : 'sections'}`
                  : 'No concepts available yet'}
              </p>
            </div>
            <div className="flex items-center gap-2 text-emerald-400 text-sm font-medium">
              <span>Read & Learn</span>
              <span>&rarr;</span>
            </div>
          </div>
        </motion.button>

        {/* Flashcard/Quiz Card */}
        <motion.button
          onClick={() => navigate(`/quiz/${subtopicId}`)}
          disabled={flashcardCount === 0}
          className={`w-full lg:flex-1 p-6 lg:p-8 rounded-2xl bg-gradient-to-b from-cyan-500/20 to-cyan-600/5 border border-cyan-500/15 hover:border-cyan-500/30 backdrop-blur-sm transition-colors ${flashcardCount === 0 ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
          variants={staggerItem}
          whileHover={flashcardCount > 0 ? { scale: 1.05, transition: { duration: 0.2 } } : {}}
          whileTap={flashcardCount > 0 ? buttonTap : {}}
        >
          <div className="flex flex-col items-center gap-4">
            <div className="w-16 h-16 rounded-2xl bg-cyan-500/20 flex items-center justify-center">
              <HelpCircle size={32} className="text-cyan-400" />
            </div>
            <div className="text-center">
              <h2 className="text-xl font-bold text-white mb-1">Quiz</h2>
              <p className="text-gray-400 text-sm">
                {flashcardCount > 0
                  ? `Test with ${flashcardCount} MCQ ${flashcardCount === 1 ? 'question' : 'questions'}`
                  : 'No quiz questions available yet'}
              </p>
            </div>
            <div className="flex items-center gap-2 text-cyan-400 text-sm font-medium">
              <span>Take Quiz</span>
              <span>&rarr;</span>
            </div>
          </div>
        </motion.button>
      </motion.div>

      {/* Progress hint */}
      <div className="text-center mt-8">
        <p className="text-gray-500 text-xs">
          Read concepts first, then test your knowledge with quizzes
        </p>
      </div>
    </div>
  )
}
