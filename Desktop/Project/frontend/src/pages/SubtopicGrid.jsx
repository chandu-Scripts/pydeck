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
import CardShuffleLoader from '../components/CardShuffleLoader'
import ErrorScreen from '../components/ErrorScreen'

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

const subtopicGlows = [
  { glow: 'rgba(6,182,212,',   border: 'border-cyan-500/40',    bg: 'from-cyan-500/10 to-cyan-600/5'     },
  { glow: 'rgba(59,130,246,',  border: 'border-blue-500/40',    bg: 'from-blue-500/10 to-blue-600/5'     },
  { glow: 'rgba(168,85,247,',  border: 'border-purple-500/40',  bg: 'from-purple-500/10 to-purple-600/5' },
  { glow: 'rgba(16,185,129,',  border: 'border-emerald-500/40', bg: 'from-emerald-500/10 to-emerald-600/5' },
  { glow: 'rgba(245,158,11,',  border: 'border-amber-500/40',   bg: 'from-amber-500/10 to-amber-600/5'   },
  { glow: 'rgba(244,63,94,',   border: 'border-rose-500/40',    bg: 'from-rose-500/10 to-rose-600/5'     },
  { glow: 'rgba(99,102,241,',  border: 'border-indigo-500/40',  bg: 'from-indigo-500/10 to-indigo-600/5' },
  { glow: 'rgba(20,184,166,',  border: 'border-teal-500/40',    bg: 'from-teal-500/10 to-teal-600/5'    },
  { glow: 'rgba(249,115,22,',  border: 'border-orange-500/40',  bg: 'from-orange-500/10 to-orange-600/5' },
]

const subtopicIconColors = [
  'text-cyan-400', 'text-blue-400', 'text-purple-400',
  'text-emerald-400', 'text-amber-400', 'text-rose-400',
  'text-indigo-400', 'text-teal-400', 'text-orange-400',
]

// Module-level cache: topicId → { topicData, subtopics }
const subtopicGridCache = new Map()

export default function SubtopicGrid() {
  const { topicId } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()

  const cached = subtopicGridCache.get(topicId)
  const [topicData, setTopicData] = useState(cached?.topicData || null)
  const [subtopics, setSubtopics] = useState(cached?.subtopics || [])
  const [loading, setLoading] = useState(!cached)
  const [error, setError] = useState(false)
  const [progress, setProgress] = useState({})

  useEffect(() => {
    async function fetchData() {
      try {
        let currentSubtopics = cached?.subtopics || []

        // Only fetch structural data if not cached
        if (!cached) {
          const [topicRes, subtopicRes] = await Promise.all([
            supabase.from('topics').select('*, paths(name, id)').eq('id', topicId).single(),
            supabase.from('subtopics').select('*').eq('topic_id', topicId).order('display_order'),
          ])
          if (topicRes.error) throw topicRes.error
          setTopicData(topicRes.data)
          currentSubtopics = subtopicRes.data || []
          setSubtopics(currentSubtopics)
          subtopicGridCache.set(topicId, { topicData: topicRes.data, subtopics: currentSubtopics })
          setLoading(false)
        }

        // Always fetch progress fresh
        if (user && currentSubtopics.length > 0) {
          const subtopicIds = currentSubtopics.map(s => s.id)
          const [cardsRes, progRes] = await Promise.all([
            supabase.from('flashcards').select('id, subtopic_id').in('subtopic_id', subtopicIds),
            supabase.from('user_progress').select('flashcard_id, status').eq('user_id', user.id),
          ])
          const cards = cardsRes.data || []
          const prog  = progRes.data  || []
          const progressMap = {}
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
          setProgress(progressMap)
        }
      } catch (e) {
        console.error('SubtopicGrid fetch error:', e)
        subtopicGridCache.delete(topicId)
        setError(true)
        setLoading(false)
      }
    }
    fetchData()
  }, [topicId, user]) // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) return <CardShuffleLoader />
  if (error) return <ErrorScreen onRetry={() => navigate(0)} />

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
          const { glow, border, bg } = subtopicGlows[idx % subtopicGlows.length]
          const iconColor = subtopicIconColors[idx % subtopicIconColors.length]
          const prog = progress[subtopic.id]

          return (
            <motion.button
              key={subtopic.id}
              onClick={() => navigate(`/subtopics/${subtopic.id}`)}
              className={`relative flex flex-col items-center justify-center gap-3 p-5 lg:p-6 rounded-2xl bg-gradient-to-b ${bg} from-navy-600/90 to-navy-700/90 border-2 ${border} backdrop-blur-xl cursor-pointer aspect-square overflow-hidden`}
              style={{
                boxShadow: `0 0 22px ${glow}0.22), inset 0 0 22px ${glow}0.06)`,
              }}
              variants={staggerItem}
              whileHover={{
                scale: 1.05,
                boxShadow: `0 0 38px ${glow}0.45), inset 0 0 30px ${glow}0.12)`,
                transition: { duration: 0.2 },
              }}
              whileTap={buttonTap}
            >
              <div className={`w-12 h-12 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor} relative z-10`}>
                <Icon size={24} />
              </div>
              <span className="text-white text-sm font-medium text-center leading-tight relative z-10">
                {subtopic.name}
              </span>
              {prog && prog.total > 0 && (
                <div className="absolute bottom-3 left-3 right-3 z-10">
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
