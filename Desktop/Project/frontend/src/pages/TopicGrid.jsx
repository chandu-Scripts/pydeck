import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Code, Repeat, FunctionSquare, Type, List, BookOpen, Search, ChevronRight, X, Layers, Cpu, GitBranch, Database, Link, BarChart2, Zap, FileText, Globe, Table2, Scissors, GitMerge, TrendingUp, Filter, Compass, Monitor, Server } from 'lucide-react'
import { staggerContainer, staggerItem, buttonTap } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'
import ErrorScreen from '../components/ErrorScreen'

const topicIcons = {
  // Python
  'Python Basics':                   Code,
  'Intermediate Python':             Layers,
  'Advanced Python':                 Cpu,
  'Data Structures & Algorithms':    GitBranch,

  // MySQL / SQL
  'SQL Basics':                      Database,
  'MySQL Basics':                    Database,
  'Joins & Relationships':           Link,
  'Aggregations & Grouping':         BarChart2,
  'Advanced SQL':                    Zap,
  'Advanced MySQL':                  Zap,

  // Flask
  'Flask Basics':                    Zap,
  'Routes & Views':                  Compass,
  'Templates & Jinja2':              FileText,
  'Flask with Databases':            Server,

  // Django
  'Django Basics':                   Layers,
  'Models & ORM':                    Database,
  'Views & Templates':               Monitor,
  'Django REST Framework':           Globe,

  // NumPy
  'Introduction to NumPy':           BookOpen,
  'NumPy Arrays':                    Table2,
  'Array Operations':                Scissors,
  'Math & Statistics':               TrendingUp,
  'Advanced NumPy':                  Zap,

  // Pandas
  'Introduction to Pandas':          BookOpen,
  'Series':                          List,
  'DataFrames':                      Table2,
  'Data Cleaning & Manipulation':    Filter,
  'GroupBy, Merge & Advanced':       GitMerge,

  // Generic subtopic fallbacks
  'Variables & Data Types':          Type,
  'Loops & Conditions':              Repeat,
  'Functions':                       FunctionSquare,
  'Strings':                         Type,
  'Lists & Tuples':                  List,
  'Dictionaries':                    BookOpen,
}

const topicIconColors = [
  'text-cyan-400', 'text-blue-400', 'text-purple-400',
  'text-emerald-400', 'text-amber-400', 'text-rose-400',
]

// Flashcard-style glow config per topic slot
const topicGlows = [
  { glow: 'rgba(6,182,212,',   border: 'border-cyan-500/40',    bg: 'from-cyan-500/10 to-cyan-600/5'    },
  { glow: 'rgba(59,130,246,',  border: 'border-blue-500/40',    bg: 'from-blue-500/10 to-blue-600/5'    },
  { glow: 'rgba(168,85,247,',  border: 'border-purple-500/40',  bg: 'from-purple-500/10 to-purple-600/5' },
  { glow: 'rgba(16,185,129,',  border: 'border-emerald-500/40', bg: 'from-emerald-500/10 to-emerald-600/5' },
  { glow: 'rgba(245,158,11,',  border: 'border-amber-500/40',   bg: 'from-amber-500/10 to-amber-600/5'  },
  { glow: 'rgba(244,63,94,',   border: 'border-rose-500/40',    bg: 'from-rose-500/10 to-rose-600/5'    },
]

// Module-level cache: pathId → { pathData, topics, subtopics }
const topicGridCache = new Map()

export default function TopicGrid() {
  const { pathId } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()

  const cached = topicGridCache.get(pathId)
  const [pathData, setPathData] = useState(cached?.pathData || null)
  const [topics, setTopics] = useState(cached?.topics || [])
  const [subtopics, setSubtopics] = useState(cached?.subtopics || [])
  const [loading, setLoading] = useState(!cached)
  const [error, setError] = useState(false)
  const [progress, setProgress] = useState({})
  const [searchQuery, setSearchQuery] = useState('')

  useEffect(() => {
    async function fetchData() {
      try {
        let currentTopics = cached?.topics || []

        // Only fetch structural data if not cached
        if (!cached) {
          const [pathRes, topicRes] = await Promise.all([
            supabase.from('paths').select('*').eq('id', pathId).single(),
            supabase.from('topics').select('*').eq('path_id', pathId).order('display_order'),
          ])
          if (pathRes.error) throw pathRes.error
          setPathData(pathRes.data)
          currentTopics = topicRes.data || []
          setTopics(currentTopics)

          if (currentTopics.length > 0) {
            const topicIds = currentTopics.map(t => t.id)
            const { data: subs } = await supabase
              .from('subtopics')
              .select('id, name, topic_id')
              .in('topic_id', topicIds)
              .order('display_order')
            setSubtopics(subs || [])
            topicGridCache.set(pathId, { pathData: pathRes.data, topics: currentTopics, subtopics: subs || [] })
          }
          setLoading(false)
        }

        // Always fetch progress fresh
        if (user && currentTopics.length > 0) {
          const topicIds = currentTopics.map(t => t.id)
          const [cardsRes, progRes] = await Promise.all([
            supabase.from('flashcards').select('id, topic_id').in('topic_id', topicIds),
            supabase.from('user_progress').select('flashcard_id, status').eq('user_id', user.id),
          ])
          const cards = cardsRes.data || []
          const prog  = progRes.data  || []
          const progressMap = {}
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
          setProgress(progressMap)
        }
      } catch (e) {
        console.error('TopicGrid fetch error:', e)
        topicGridCache.delete(pathId)
        setError(true)
        setLoading(false)
      }
    }
    fetchData()
  }, [pathId, user]) // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) return <CardShuffleLoader />
  if (error) return <ErrorScreen onRetry={() => navigate(0)} />

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
          placeholder="Search topics..."
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
          const iconColor = topicIconColors[idx % topicIconColors.length]
          const { glow, border, bg } = topicGlows[idx % topicGlows.length]
          const prog = progress[topic.id]

          return (
            <motion.button
              key={topic.id}
              onClick={() => navigate(`/topics/${topic.id}`)}
              className={`relative flex flex-col items-center justify-center gap-3 p-5 lg:p-6 rounded-2xl bg-gradient-to-b ${bg} from-navy-600/90 to-navy-700/90 border-2 ${border} backdrop-blur-xl cursor-pointer aspect-square overflow-hidden group`}
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
              {/* Icon */}
              <div className={`w-12 h-12 rounded-xl bg-navy-700/60 flex items-center justify-center ${iconColor} relative z-10`}
                style={{ boxShadow: `0 0 12px ${glow}0.3)` }}
              >
                <Icon size={24} />
              </div>

              {/* Topic name */}
              <span className="text-white text-sm font-semibold text-center leading-tight relative z-10">
                {topic.name}
              </span>

              {/* Progress bar */}
              {prog && prog.total > 0 && (
                <div className="absolute bottom-3 left-3 right-3 z-10">
                  <div className="flex justify-between mb-1">
                    <span className={`text-xs font-bold ${iconColor}`}>{prog.percent}%</span>
                    <span className="text-xs text-gray-500">{prog.mastered}/{prog.total}</span>
                  </div>
                  <div className="h-1 bg-navy-700/60 rounded-full overflow-hidden">
                    <motion.div
                      className="h-full rounded-full"
                      style={{ background: `${glow}0.9)` }}
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
