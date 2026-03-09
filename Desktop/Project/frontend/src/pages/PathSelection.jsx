import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ChevronRight, Code, Layers, Cpu, Database, Users, Menu } from 'lucide-react'
import { SiPython, SiMysql, SiFlask, SiDjango, SiNumpy, SiPandas, SiGit, SiGithub } from 'react-icons/si'
import { buttonTap } from '../utils/animations'
import PathCarousel from '../components/PathCarousel'
import PathListModal from '../components/PathListModal'
import NotificationBell from '../components/NotificationBell'
import CardShuffleLoader from '../components/CardShuffleLoader'
import ErrorScreen from '../components/ErrorScreen'

const pathIcons = {
  'Python': SiPython,
  'MySQL': SiMysql,
  'Flask': SiFlask,
  'Django': SiDjango,
  'NumPy': SiNumpy,
  'Pandas': SiPandas,
  'Git & GitHub': SiGit,
  'Python Basics': Code,
  'Intermediate Python': Layers,
  'Advanced Python': Cpu,
  'Data Structures & Algorithms': Database,
}

const pathColors = {
  'Python': 'from-blue-500/20 to-blue-600/10 border-blue-500/20',
  'MySQL': 'from-yellow-500/20 to-yellow-600/10 border-yellow-500/20',
  'Flask': 'from-gray-500/20 to-gray-600/10 border-gray-500/20',
  'Django': 'from-green-500/20 to-green-600/10 border-green-500/20',
  'NumPy': 'from-orange-500/20 to-orange-600/10 border-orange-500/20',
  'Pandas': 'from-purple-500/20 to-purple-600/10 border-purple-500/20',
  'Git & GitHub': 'from-orange-500/20 to-red-600/10 border-orange-500/20',
  'Python Basics': 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20',
  'Intermediate Python': 'from-blue-500/20 to-blue-600/10 border-blue-500/20',
  'Advanced Python': 'from-purple-500/20 to-purple-600/10 border-purple-500/20',
  'Data Structures & Algorithms': 'from-amber-500/20 to-amber-600/10 border-amber-500/20',
}

const iconColors = {
  'Python': 'text-blue-400',
  'MySQL': 'text-yellow-400',
  'Flask': 'text-gray-300',
  'Django': 'text-green-400',
  'NumPy': 'text-orange-400',
  'Pandas': 'text-purple-400',
  'Git & GitHub': 'text-orange-400',
  'Python Basics': 'text-cyan-400',
  'Intermediate Python': 'text-blue-400',
  'Advanced Python': 'text-purple-400',
  'Data Structures & Algorithms': 'text-amber-400',
}

// Get time-based greeting
function getGreeting() {
  const hour = new Date().getHours()

  if (hour >= 6 && hour < 12) {
    return 'Good morning'
  } else if (hour >= 12 && hour < 18) {
    return 'Good afternoon'
  } else if (hour >= 18 && hour < 21) {
    return 'Good evening'
  } else {
    return 'Knight Rider'
  }
}

const TIPS = [
  { text: 'Python is the #1 language for AI & data science',           color: '#22d3ee' },
  { text: 'Every expert was once a complete beginner — start now',      color: '#a855f7' },
  { text: 'Master DSA and crack top tech interviews with confidence',   color: '#f59e0b' },
  { text: 'Flask & Django power millions of web apps worldwide',        color: '#10b981' },
  { text: 'NumPy makes numerical operations 100× faster',               color: '#f97316' },
  { text: 'Consistent daily practice beats marathon study sessions',    color: '#ec4899' },
  { text: 'Python reads like plain English — perfect for beginners',    color: '#3b82f6' },
  { text: 'pandas turns messy data into powerful insights instantly',   color: '#8b5cf6' },
  { text: '30 minutes a day can make you job-ready in 6 months',       color: '#f43f5e' },
  { text: 'Python is used by Google, NASA, Netflix & Instagram',       color: '#84cc16' },
  { text: 'Your streak is proof of your discipline — keep it alive!',  color: '#22d3ee' },
  { text: 'OOP makes your code cleaner, reusable & scalable',          color: '#f59e0b' },
  { text: 'Small progress every day leads to big results over time',   color: '#10b981' },
  { text: 'Algorithms are just recipes — Python makes them elegant',   color: '#a855f7' },
  { text: 'Spaced repetition rewires your brain for long-term memory', color: '#3b82f6' },
  { text: 'Django lets you build full web apps in record time',         color: '#f97316' },
  { text: 'Every line of code you write makes you 1% better',          color: '#f43f5e' },
  { text: 'Flashcards are the secret weapon of top students worldwide', color: '#84cc16' },
]

const pathTipColors = {
  'Python':  '#3b82f6',
  'MySQL':   '#f59e0b',
  'Flask':   '#9ca3af',
  'Django':  '#10b981',
  'NumPy':   '#f97316',
  'Pandas':  '#a855f7',
}

function RotatingTip({ color = '#22d3ee' }) {
  const [index, setIndex] = useState(0)

  useEffect(() => {
    const t = setInterval(() => setIndex(i => (i + 1) % TIPS.length), 5000)
    return () => clearInterval(t)
  }, [])

  return (
    <div style={{
      background: `${color}12`,
      border: `1px solid ${color}30`,
      borderRadius: 12,
      padding: '8px 14px',
      display: 'flex',
      alignItems: 'center',
      gap: 8,
      transition: 'background 0.8s ease, border-color 0.8s ease',
      overflow: 'hidden',
    }}>
      <div style={{
        width: 6, height: 6, borderRadius: '50%',
        background: color,
        boxShadow: `0 0 8px ${color}`,
        flexShrink: 0,
        transition: 'background 0.8s ease, box-shadow 0.8s ease',
      }} />
      <div style={{ flex: 1, overflow: 'hidden', position: 'relative', height: 18 }}>
        <AnimatePresence mode="wait">
          <motion.p
            key={index}
            initial={{ opacity: 0, y: 10 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -10 }}
            transition={{ duration: 0.3 }}
            style={{
              color, fontSize: 11, lineHeight: 1.6,
              margin: 0, fontWeight: 500,
              textShadow: `0 0 16px ${color}60`,
              transition: 'color 0.8s ease',
              position: 'absolute', width: '100%',
              whiteSpace: 'nowrap', overflow: 'hidden',
              textOverflow: 'ellipsis',
            }}
          >
            {TIPS[index].text}
          </motion.p>
        </AnimatePresence>
      </div>
    </div>
  )
}

export default function PathSelection() {
  const [paths, setPaths] = useState([])
  const [topicCounts, setTopicCounts] = useState({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(false)
  const [retryCount, setRetryCount] = useState(0)
  const [showPathList, setShowPathList] = useState(false)
  const [currentPathIndex, setCurrentPathIndex] = useState(0)
  const [frontCard, setFrontCard] = useState(null)
  const [todayCards, setTodayCards] = useState(0)
  const navigate = useNavigate()
  const { user, profile } = useAuth()

  const greeting = getGreeting()
  const dailyGoal = parseInt(localStorage.getItem('pydeck_daily_goal') || '10')

  useEffect(() => {
    if (!user) return
    function fetchTodayCards() {
      const today = new Date().toISOString().split('T')[0]
      supabase.from('study_sessions').select('cards_studied')
        .eq('user_id', user.id).eq('date', today).maybeSingle()
        .then(({ data }) => setTodayCards(data?.cards_studied || 0))
    }
    fetchTodayCards()
    // Re-fetch when user returns to this tab/page
    window.addEventListener('focus', fetchTodayCards)
    return () => window.removeEventListener('focus', fetchTodayCards)
  }, [user])

  useEffect(() => {
    async function fetchPathsAndTopics() {
      try {
        const [pathsRes, topicsRes] = await Promise.all([
          supabase.from('paths').select('*').order('display_order'),
          supabase.from('topics').select('id, path_id'),
        ])
        if (pathsRes.error) throw pathsRes.error
        const counts = {}
        topicsRes.data?.forEach(topic => {
          counts[topic.path_id] = (counts[topic.path_id] || 0) + 1
        })
        setPaths(pathsRes.data || [])
        setTopicCounts(counts)
        setLoading(false)
      } catch (e) {
        console.error('PathSelection fetch error:', e)
        setError(true)
        setLoading(false)
      }
    }
    fetchPathsAndTopics()
  }, [retryCount]) // eslint-disable-line react-hooks/exhaustive-deps

  if (loading) return <CardShuffleLoader />
  if (error) return <ErrorScreen onRetry={() => { setError(false); setLoading(true); setRetryCount(c => c + 1) }} />

  return (
    <div className="fixed inset-0 px-5 py-6 lg:py-10 overflow-hidden" style={{ paddingTop: 'calc(env(safe-area-inset-top) + 1.5rem)', paddingBottom: 'calc(env(safe-area-inset-bottom) + 1rem)' }}>
      {/* Aurora background — color matches the selected holo fan card */}
      {(() => {
        const auroraColors = {
          'Python':  'rgba(59,130,246,0.18)',
          'MySQL':   'rgba(245,158,11,0.18)',
          'Flask':   'rgba(156,163,175,0.15)',
          'Django':  'rgba(16,185,129,0.18)',
          'NumPy':   'rgba(249,115,22,0.18)',
          'Pandas':  'rgba(168,85,247,0.18)',
        }
        return Object.entries(auroraColors).map(([name, color]) => (
          <div
            key={name}
            className="absolute inset-0 pointer-events-none"
            style={{
              background: `radial-gradient(ellipse 85% 50% at 50% 25%, ${color} 0%, transparent 70%)`,
              opacity: frontCard?.name === name ? 1 : 0,
              transition: 'opacity 1.2s ease',
            }}
          />
        ))
      })()}

      {/* Starfield Background */}
      <div className="absolute inset-0 pointer-events-none">
        {/* Stars */}
        {[...Array(50)].map((_, i) => (
          <div
            key={i}
            className="absolute rounded-full bg-white animate-pulse"
            style={{
              width: Math.random() * 3 + 1 + 'px',
              height: Math.random() * 3 + 1 + 'px',
              top: Math.random() * 100 + '%',
              left: Math.random() * 100 + '%',
              opacity: Math.random() * 0.7 + 0.3,
              animationDuration: Math.random() * 3 + 2 + 's',
              animationDelay: Math.random() * 2 + 's',
            }}
          />
        ))}
      </div>

      {/* Content */}
      <div className="relative z-10 h-full flex flex-col">

      {/* Rotating motivational tip — colour follows the front carousel card */}
      <div className="mb-2">
        <RotatingTip color={pathTipColors[frontCard?.name] ?? '#22d3ee'} />
      </div>


      <motion.div
        className="mb-8 flex items-start justify-between"
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <div>
          <p className="text-cyan-400 text-sm font-medium">
            {greeting}
          </p>
          <h1 className="text-3xl lg:text-4xl font-bold text-white mt-1">
            {profile?.username || 'Focus'}
          </h1>
        </div>

        {/* Right side controls */}
        <div className="flex items-center gap-3">
          <NotificationBell />
        </div>
      </motion.div>

      {/* 3D Carousel with Menu Button */}
      <motion.div
        initial={{ opacity: 0, scale: 0.9 }}
        animate={{ opacity: 1, scale: 1 }}
        transition={{ duration: 0.6, delay: 0.2 }}
        className="mb-16 relative"
      >
        {/* Daily Goal Ring — floats on top of front card, cards don't move */}
        <motion.div
          initial={{ opacity: 0, scale: 0.5 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ duration: 0.5, delay: 0.35, type: 'spring', stiffness: 200 }}
          className="absolute top-6 left-1/2 -translate-x-1/2 -translate-y-full z-30 flex flex-col items-center pointer-events-none"
        >
          <p className="text-xs font-semibold mb-1 tracking-widest uppercase" style={{ color: 'var(--color-cyan-400)', textShadow: '0 0 10px var(--color-cyan-500)' }}>Daily Goal</p>
          <DailyGoalRing todayCards={todayCards} dailyGoal={dailyGoal} />
        </motion.div>
        <PathCarousel
          paths={paths}
          pathIcons={pathIcons}
          iconColors={iconColors}
          pathColors={pathColors}
          topicCounts={topicCounts}
          onPathClick={(path) => navigate(`/paths/${path.id}`)}
          onIndexChange={setCurrentPathIndex}
          orbitMode={true}
          onFrontCardChange={setFrontCard}
        />

        {/* View All Button - Below Carousel */}
        {(() => {
          const currentPath = paths[currentPathIndex]
          const currentIconColor = iconColors[currentPath?.name] || 'text-cyan-400'

          // Extract color name from icon color class
          const colorMap = {
            'text-blue-400': { from: 'from-blue-500/20', to: 'to-blue-600/20', border: 'border-blue-500/30', hoverFrom: 'hover:from-blue-500/30', hoverTo: 'hover:to-blue-600/30', icon: 'text-blue-400' },
            'text-yellow-400': { from: 'from-yellow-500/20', to: 'to-yellow-600/20', border: 'border-yellow-500/30', hoverFrom: 'hover:from-yellow-500/30', hoverTo: 'hover:to-yellow-600/30', icon: 'text-yellow-400' },
            'text-gray-300': { from: 'from-gray-500/20', to: 'to-gray-600/20', border: 'border-gray-500/30', hoverFrom: 'hover:from-gray-500/30', hoverTo: 'hover:to-gray-600/30', icon: 'text-gray-300' },
            'text-green-400': { from: 'from-green-500/20', to: 'to-green-600/20', border: 'border-green-500/30', hoverFrom: 'hover:from-green-500/30', hoverTo: 'hover:to-green-600/30', icon: 'text-green-400' },
            'text-orange-400': { from: 'from-orange-500/20', to: 'to-orange-600/20', border: 'border-orange-500/30', hoverFrom: 'hover:from-orange-500/30', hoverTo: 'hover:to-orange-600/30', icon: 'text-orange-400' },
            'text-purple-400': { from: 'from-purple-500/20', to: 'to-purple-600/20', border: 'border-purple-500/30', hoverFrom: 'hover:from-purple-500/30', hoverTo: 'hover:to-purple-600/30', icon: 'text-purple-400' },
            'text-cyan-400': { from: 'from-cyan-500/20', to: 'to-blue-500/20', border: 'border-cyan-500/30', hoverFrom: 'hover:from-cyan-500/30', hoverTo: 'hover:to-blue-500/30', icon: 'text-cyan-400' },
          }

          const buttonColors = colorMap[currentIconColor] || colorMap['text-cyan-400']

          return (
            <motion.button
              onClick={() => setShowPathList(true)}
              className={`absolute left-1/2 -translate-x-1/2 -bottom-8 z-20 w-12 h-12 rounded-full bg-gradient-to-br ${buttonColors.from} ${buttonColors.to} border-2 ${buttonColors.border} backdrop-blur-xl flex items-center justify-center ${buttonColors.hoverFrom} ${buttonColors.hoverTo} transition-all shadow-lg`}
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.9 }}
            >
              <Menu size={20} className={buttonColors.icon} />
            </motion.button>
          )
        })()}
      </motion.div>

      {/* Community Flashcards Card */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.4 }}
        className="max-w-md mx-auto mt-auto mb-20"
      >
        <motion.button
          onClick={() => navigate('/community')}
          className="w-full flex items-center gap-4 p-4 rounded-2xl bg-gradient-to-r from-purple-500/20 to-pink-600/10 border border-purple-500/20 backdrop-blur-xl cursor-pointer group shadow-2xl"
          whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
          whileTap={buttonTap}
        >
          <div className="w-11 h-11 rounded-xl bg-navy-700/50 flex items-center justify-center text-purple-400">
            <Users size={22} />
          </div>
          <span className="flex-1 text-left text-white font-medium text-base">
            Community Flashcards
          </span>
          <ChevronRight size={18} className="text-gray-500 group-hover:text-white transition-colors" />
        </motion.button>
      </motion.div>
      </div>

      {/* Path List Modal */}
      <PathListModal
        isOpen={showPathList}
        onClose={() => setShowPathList(false)}
        paths={paths}
        pathIcons={pathIcons}
        iconColors={iconColors}
        topicCounts={topicCounts}
        onPathClick={(path) => navigate(`/paths/${path.id}`)}
      />
    </div>
  )
}

function DailyGoalRing({ todayCards, dailyGoal }) {
  const size = 76
  const strokeWidth = 6
  const radius = (size - strokeWidth) / 2
  const circumference = 2 * Math.PI * radius
  const progress = Math.min(todayCards / dailyGoal, 1)
  const offset = circumference - progress * circumference
  const done = todayCards >= dailyGoal

  // Use the CSS variable so it follows the user's chosen theme color
  const ringColor = done ? '#4ade80' : 'var(--color-cyan-400)'
  const glowColor = done ? '#4ade80' : 'var(--color-cyan-500)'

  return (
    <div className="relative" style={{ width: size, height: size }}>
      {/* Dark background circle */}
      <div className="absolute inset-0 rounded-full"
        style={{ background: 'radial-gradient(circle, #0d1a2e 60%, #060a13 100%)', border: '1px solid rgba(255,255,255,0.08)' }} />

      <svg width={size} height={size} style={{ transform: 'rotate(-90deg)', position: 'absolute', inset: 0 }}>
        {/* Track */}
        <circle cx={size / 2} cy={size / 2} r={radius}
          fill="none" stroke="var(--color-cyan-500)" strokeWidth={strokeWidth} strokeOpacity="0.15" />
        {/* Progress arc */}
        <motion.circle cx={size / 2} cy={size / 2} r={radius}
          fill="none" stroke={ringColor} strokeWidth={strokeWidth}
          strokeLinecap="round"
          strokeDasharray={circumference}
          initial={{ strokeDashoffset: circumference }}
          animate={{ strokeDashoffset: offset }}
          transition={{ duration: 1.2, ease: 'easeOut' }}
          style={{ filter: `drop-shadow(0 0 5px ${glowColor})` }}
        />
      </svg>

      {/* Center content */}
      <div className="absolute inset-0 flex flex-col items-center justify-center">
        {done ? (
          <span className="text-lg">🎉</span>
        ) : (
          <>
            <span className="font-bold leading-none text-cyan-400" style={{ fontSize: 15 }}>{todayCards}</span>
            <div className="w-3 h-px my-0.5 bg-cyan-500/40" />
            <span className="text-gray-500 leading-none" style={{ fontSize: 10 }}>{dailyGoal}</span>
          </>
        )}
      </div>
    </div>
  )
}
