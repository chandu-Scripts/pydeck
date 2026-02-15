import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import {
  ArrowLeft, Variable, Calculator, Type, List, Package,
  BookOpen, Repeat, GitBranch, FunctionSquare, Code,
  File, AlertTriangle, Box, Layers, Zap
} from 'lucide-react'
import { staggerContainer, staggerItem, buttonTap } from '../utils/animations'

const subtopicIcons = {
  'Variables & Data Types': Variable,
  'Operators': Calculator,
  'Strings': Type,
  'Lists': List,
  'Tuples': Package,
  'Dictionaries': BookOpen,
  'Loops': Repeat,
  'Conditionals': GitBranch,
  'Functions': FunctionSquare,
  'File Handling': File,
  'Exception Handling': AlertTriangle,
  'Classes & Objects': Box,
  'List Comprehensions': Layers,
  'Lambda Functions': Zap,
  'Modules & Packages': Package,
}

const subtopicColors = [
  'from-cyan-500/20 to-cyan-600/5 border-cyan-500/15 hover:border-cyan-500/30',
  'from-blue-500/20 to-blue-600/5 border-blue-500/15 hover:border-blue-500/30',
  'from-purple-500/20 to-purple-600/5 border-purple-500/15 hover:border-purple-500/30',
  'from-emerald-500/20 to-emerald-600/5 border-emerald-500/15 hover:border-emerald-500/30',
  'from-amber-500/20 to-amber-600/5 border-amber-500/15 hover:border-amber-500/30',
  'from-rose-500/20 to-rose-600/5 border-rose-500/15 hover:border-rose-500/30',
  'from-indigo-500/20 to-indigo-600/5 border-indigo-500/15 hover:border-indigo-500/30',
  'from-teal-500/20 to-teal-600/5 border-teal-500/15 hover:border-teal-500/30',
  'from-orange-500/20 to-orange-600/5 border-orange-500/15 hover:border-orange-500/30',
]

const subtopicIconColors = [
  'text-cyan-400', 'text-blue-400', 'text-purple-400',
  'text-emerald-400', 'text-amber-400', 'text-rose-400',
  'text-indigo-400', 'text-teal-400', 'text-orange-400',
]

export default function SubtopicGrid() {
  const { topicId } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const [topicData, setTopicData] = useState(null)
  const [subtopics, setSubtopics] = useState([])
  const [loading, setLoading] = useState(true)
  const [progress, setProgress] = useState({})

  useEffect(() => {
    async function fetchData() {
      const [topicRes, subtopicRes] = await Promise.all([
        supabase.from('topics').select('*, paths(name)').eq('id', topicId).single(),
        supabase.from('subtopics').select('*').eq('topic_id', topicId).order('display_order'),
      ])
      setTopicData(topicRes.data)
      setSubtopics(subtopicRes.data || [])

      if (user && subtopicRes.data && subtopicRes.data.length > 0) {
        const subtopicIds = subtopicRes.data.map(s => s.id)

        // Get flashcards for these subtopics
        const { data: cards } = await supabase
          .from('flashcards')
          .select('id, subtopic_id')
          .in('subtopic_id', subtopicIds)

        // Get user progress
        const { data: prog } = await supabase
          .from('user_progress')
          .select('flashcard_id, status')
          .eq('user_id', user.id)

        const progressMap = {}
        if (cards && prog) {
          const progMap = {}
          prog.forEach(p => { progMap[p.flashcard_id] = p.status })

          subtopicIds.forEach(sid => {
            const subtopicCards = cards.filter(c => c.subtopic_id === sid)
            const mastered = subtopicCards.filter(c => progMap[c.id] === 'mastered').length
            progressMap[sid] = {
              total: subtopicCards.length,
              mastered,
              percent: subtopicCards.length > 0 ? Math.round((mastered / subtopicCards.length) * 100) : 0,
            }
          })
        }
        setProgress(progressMap)
      }
      setLoading(false)
    }
    fetchData()
  }, [topicId, user])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="px-5 py-8 lg:py-12">
      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate(`/paths/${topicData?.paths?.id || topicData?.path_id}`)}
          className="text-gray-400 hover:text-white transition-colors cursor-pointer"
        >
          <ArrowLeft size={22} />
        </button>
        <div>
          <p className="text-cyan-400 text-xs font-medium mb-0.5">{topicData?.paths?.name}</p>
          <h1 className="text-2xl lg:text-3xl font-bold text-white">{topicData?.name}</h1>
          <p className="text-gray-400 text-sm">Select a subtopic</p>
        </div>
      </div>

      {/* Grid */}
      <motion.div
        className="grid grid-cols-2 lg:grid-cols-3 gap-3 lg:gap-4"
        variants={staggerContainer}
        initial="initial"
        animate="animate"
      >
        {subtopics.map((subtopic, idx) => {
          const Icon = subtopicIcons[subtopic.name] || Code
          const color = subtopicColors[idx % subtopicColors.length]
          const iconColor = subtopicIconColors[idx % subtopicIconColors.length]
          const prog = progress[subtopic.id]

          return (
            <motion.button
              key={subtopic.id}
              onClick={() => navigate(`/subtopics/${subtopic.id}`)}
              className={`relative flex flex-col items-center justify-center gap-3 p-5 lg:p-6 rounded-2xl bg-gradient-to-b ${color} border backdrop-blur-sm cursor-pointer aspect-square`}
              variants={staggerItem}
              whileHover={{ scale: 1.05, transition: { duration: 0.2 } }}
              whileTap={buttonTap}
            >
              <div className={`w-12 h-12 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor}`}>
                <Icon size={24} />
              </div>
              <span className="text-white text-sm font-medium text-center leading-tight">
                {subtopic.name}
              </span>
              {prog && prog.total > 0 && (
                <div className="absolute bottom-3 left-3 right-3">
                  <div className="h-1 bg-navy-700/50 rounded-full overflow-hidden">
                    <motion.div
                      className="h-full bg-cyan-400 rounded-full"
                      initial={{ width: 0 }}
                      animate={{ width: `${prog.percent}%` }}
                      transition={{ duration: 0.8, delay: 0.3, ease: 'easeOut' }}
                    />
                  </div>
                </div>
              )}
            </motion.button>
          )
        })}
      </motion.div>

      {subtopics.length === 0 && (
        <div className="text-center py-12">
          <p className="text-gray-400">No subtopics available for this topic yet.</p>
          <button
            onClick={() => navigate(-1)}
            className="mt-4 text-cyan-400 hover:underline cursor-pointer"
          >
            Go back
          </button>
        </div>
      )}
    </div>
  )
}
