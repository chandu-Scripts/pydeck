import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Code, Repeat, FunctionSquare, Type, List, BookOpen, Search, ChevronRight, X } from 'lucide-react'
import { staggerContainer, staggerItem, buttonTap } from '../utils/animations'

const topicIcons = {
  'Variables & Data Types': Type,
  'Loops & Conditions': Repeat,
  'Functions': FunctionSquare,
  'Strings': Type,
  'Lists & Tuples': List,
  'Dictionaries': BookOpen,
}

const topicColors = [
  'from-cyan-500/20 to-cyan-600/5 border-cyan-500/15 hover:border-cyan-500/30',
  'from-blue-500/20 to-blue-600/5 border-blue-500/15 hover:border-blue-500/30',
  'from-purple-500/20 to-purple-600/5 border-purple-500/15 hover:border-purple-500/30',
  'from-emerald-500/20 to-emerald-600/5 border-emerald-500/15 hover:border-emerald-500/30',
  'from-amber-500/20 to-amber-600/5 border-amber-500/15 hover:border-amber-500/30',
  'from-rose-500/20 to-rose-600/5 border-rose-500/15 hover:border-rose-500/30',
]

const topicIconColors = [
  'text-cyan-400', 'text-blue-400', 'text-purple-400',
  'text-emerald-400', 'text-amber-400', 'text-rose-400',
]

export default function TopicGrid() {
  const { pathId } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const [pathData, setPathData] = useState(null)
  const [topics, setTopics] = useState([])
  const [loading, setLoading] = useState(true)
  const [progress, setProgress] = useState({})
  const [searchQuery, setSearchQuery] = useState('')
  const [subtopics, setSubtopics] = useState([])

  useEffect(() => {
    async function fetchData() {
      const [pathRes, topicRes] = await Promise.all([
        supabase.from('paths').select('*').eq('id', pathId).single(),
        supabase.from('topics').select('*').eq('path_id', pathId).order('display_order'),
      ])
      setPathData(pathRes.data)
      setTopics(topicRes.data || [])

      if (topicRes.data) {
        const topicIds = topicRes.data.map(t => t.id)
        const { data: subs } = await supabase
          .from('subtopics')
          .select('id, name, topic_id')
          .in('topic_id', topicIds)
          .order('display_order')
        setSubtopics(subs || [])
      }

      if (user && topicRes.data) {
        const topicIds = topicRes.data.map(t => t.id)
        const { data: cards } = await supabase
          .from('flashcards')
          .select('id, topic_id')
          .in('topic_id', topicIds)

        const { data: prog } = await supabase
          .from('user_progress')
          .select('flashcard_id, status')
          .eq('user_id', user.id)

        const progressMap = {}
        if (cards && prog) {
          const progMap = {}
          prog.forEach(p => { progMap[p.flashcard_id] = p.status })

          topicIds.forEach(tid => {
            const topicCards = cards.filter(c => c.topic_id === tid)
            const mastered = topicCards.filter(c => progMap[c.id] === 'mastered').length
            progressMap[tid] = {
              total: topicCards.length,
              mastered,
              percent: topicCards.length > 0 ? Math.round((mastered / topicCards.length) * 100) : 0,
            }
          })
        }
        setProgress(progressMap)
      }
      setLoading(false)
    }
    fetchData()
  }, [pathId, user])

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
        <button onClick={() => navigate('/paths')} className="text-gray-400 hover:text-white transition-colors cursor-pointer">
          <ArrowLeft size={22} />
        </button>
        <div>
          <h1 className="text-2xl lg:text-3xl font-bold text-white">{pathData?.name}</h1>
          <p className="text-gray-400 text-sm">Select a topic</p>
        </div>
      </div>

      {/* Search */}
      <div className="relative mb-4">
        <Search size={18} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-400" />
        <input
          type="text"
          placeholder="Search subtopics... (e.g. Regular Expressions)"
          value={searchQuery}
          onChange={(e) => setSearchQuery(e.target.value)}
          className="w-full pl-10 pr-9 py-2.5 bg-navy-700/50 border border-navy-600/50 rounded-xl text-white text-sm placeholder-gray-500 focus:outline-none focus:border-cyan-500/50 transition-colors"
        />
        {searchQuery && (
          <button
            onClick={() => setSearchQuery('')}
            className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white cursor-pointer"
          >
            <X size={16} />
          </button>
        )}
      </div>

      {/* Search Results */}
      {searchQuery.trim() && (() => {
        const query = searchQuery.toLowerCase()
        const matchedSubtopics = subtopics.filter(s => s.name.toLowerCase().includes(query))
        const matchedTopics = topics.filter(t => t.name.toLowerCase().includes(query))
        const hasResults = matchedSubtopics.length > 0 || matchedTopics.length > 0

        if (!hasResults) {
          return (
            <div className="text-center py-8 text-gray-400 text-sm">
              No results found for "{searchQuery}"
            </div>
          )
        }

        return (
          <motion.div
            className="flex flex-col gap-2 mb-4"
            variants={staggerContainer}
            initial="initial"
            animate="animate"
          >
            {matchedTopics.map((topic, idx) => (
              <motion.button
                key={topic.id}
                onClick={() => navigate(`/topics/${topic.id}`)}
                className="flex items-center justify-between px-4 py-3 bg-navy-700/50 border border-navy-600/50 rounded-xl hover:border-cyan-500/30 transition-colors cursor-pointer"
                variants={staggerItem}
                whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
                whileTap={buttonTap}
              >
                <div className="flex items-center gap-3">
                  <div className="w-8 h-8 rounded-lg bg-cyan-500/20 flex items-center justify-center text-cyan-400">
                    <Code size={16} />
                  </div>
                  <div className="text-left">
                    <p className="text-white text-sm font-medium">{topic.name}</p>
                    <p className="text-gray-500 text-xs">Topic</p>
                  </div>
                </div>
                <ChevronRight size={16} className="text-gray-500" />
              </motion.button>
            ))}
            {matchedSubtopics.map((sub, idx) => {
              const parentTopic = topics.find(t => t.id === sub.topic_id)
              return (
                <motion.button
                  key={sub.id}
                  onClick={() => navigate(`/subtopics/${sub.id}`)}
                  className="flex items-center justify-between px-4 py-3 bg-navy-700/50 border border-navy-600/50 rounded-xl hover:border-cyan-500/30 transition-colors cursor-pointer"
                  variants={staggerItem}
                  whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
                  whileTap={buttonTap}
                >
                  <div className="flex items-center gap-3">
                    <div className="w-8 h-8 rounded-lg bg-purple-500/20 flex items-center justify-center text-purple-400">
                      <BookOpen size={16} />
                    </div>
                    <div className="text-left">
                      <p className="text-white text-sm font-medium">{sub.name}</p>
                      <p className="text-gray-500 text-xs">{parentTopic?.name}</p>
                    </div>
                  </div>
                  <ChevronRight size={16} className="text-gray-500" />
                </motion.button>
              )
            })}
          </motion.div>
        )
      })()}

      {/* Grid */}
      {!searchQuery.trim() && <motion.div
        className="grid grid-cols-2 lg:grid-cols-3 gap-3 lg:gap-4"
        variants={staggerContainer}
        initial="initial"
        animate="animate"
      >
        {topics.map((topic, idx) => {
          const Icon = topicIcons[topic.name] || Code
          const color = topicColors[idx % topicColors.length]
          const iconColor = topicIconColors[idx % topicIconColors.length]
          const prog = progress[topic.id]

          return (
            <motion.button
              key={topic.id}
              onClick={() => navigate(`/topics/${topic.id}`)}
              className={`relative flex flex-col items-center justify-center gap-3 p-5 lg:p-6 rounded-2xl bg-gradient-to-b ${color} border backdrop-blur-sm cursor-pointer aspect-square`}
              variants={staggerItem}
              whileHover={{ scale: 1.05, transition: { duration: 0.2 } }}
              whileTap={buttonTap}
            >
              <div className={`w-12 h-12 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor}`}>
                <Icon size={24} />
              </div>
              <span className="text-white text-sm font-medium text-center leading-tight">
                {topic.name}
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
      </motion.div>}
    </div>
  )
}
