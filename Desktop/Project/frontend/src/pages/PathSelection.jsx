import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ChevronRight, Code, Layers, Cpu, Database, Users, Menu } from 'lucide-react'
import { SiPython, SiMysql, SiFlask, SiDjango, SiNumpy, SiPandas } from 'react-icons/si'
import { buttonTap } from '../utils/animations'
import PathCarousel from '../components/PathCarousel'
import PathListModal from '../components/PathListModal'
import NotificationBell from '../components/NotificationBell'

const pathIcons = {
  'Python': SiPython,
  'MySQL': SiMysql,
  'Flask': SiFlask,
  'Django': SiDjango,
  'NumPy': SiNumpy,
  'Pandas': SiPandas,
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
  'Python Basics': 'text-cyan-400',
  'Intermediate Python': 'text-blue-400',
  'Advanced Python': 'text-purple-400',
  'Data Structures & Algorithms': 'text-amber-400',
}

// Get time-based greeting
function getGreeting() {
  const hour = new Date().getHours()

  if (hour >= 6 && hour < 12) {
    return { text: 'Good morning', emoji: '☀️' }
  } else if (hour >= 12 && hour < 18) {
    return { text: 'Good evening', emoji: '🌅' }
  } else {
    return { text: 'Knight Rider', emoji: '🧑‍🎓' }
  }
}

export default function PathSelection() {
  const [paths, setPaths] = useState([])
  const [topicCounts, setTopicCounts] = useState({})
  const [loading, setLoading] = useState(true)
  const [showPathList, setShowPathList] = useState(false)
  const [currentPathIndex, setCurrentPathIndex] = useState(0)
  const [orbitMode, setOrbitMode] = useState(() => {
    const saved = sessionStorage.getItem('orbitMode')
    return saved === null ? true : saved === 'true'
  })
  const navigate = useNavigate()
  const { profile } = useAuth()

  const greeting = getGreeting()

  useEffect(() => {
    async function fetchPathsAndTopics() {
      // Fetch paths
      const { data: pathsData } = await supabase
        .from('paths')
        .select('*')
        .order('display_order')

      // Fetch all topics to count per path
      const { data: topicsData } = await supabase
        .from('topics')
        .select('id, path_id')

      // Count topics per path
      const counts = {}
      topicsData?.forEach(topic => {
        counts[topic.path_id] = (counts[topic.path_id] || 0) + 1
      })

      setPaths(pathsData || [])
      setTopicCounts(counts)
      setLoading(false)
    }
    fetchPathsAndTopics()
  }, [])

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="relative px-5 py-8 lg:py-12 overflow-hidden">
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
      <div className="relative z-10">
      <motion.div
        className="mb-8 flex items-start justify-between"
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
      >
        <div>
          <p className="text-cyan-400 text-sm font-medium">
            {greeting.text} {greeting.emoji}
          </p>
          <h1 className="text-3xl lg:text-4xl font-bold text-white mt-1">
            {profile?.username || 'Focus'}
          </h1>
        </div>

        {/* Right side controls */}
        <div className="flex items-center gap-3">
          {/* Orbit Mode Toggle */}
          <motion.button
            onClick={() => {
                const next = !orbitMode
                setOrbitMode(next)
                sessionStorage.setItem('orbitMode', next)
              }}
            className={`relative w-12 h-12 rounded-xl flex items-center justify-center transition-all ${
              orbitMode
                ? 'bg-gradient-to-br from-purple-500/30 to-pink-500/30 border-2 border-purple-500/50'
                : 'bg-navy-700/50 border border-cyan-500/30'
            }`}
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            title={orbitMode ? 'Disable Orbit Mode' : 'Enable Orbit Mode'}
          >
            <motion.div
              animate={{ rotate: orbitMode ? 360 : 0 }}
              transition={{ duration: 2, repeat: orbitMode ? Infinity : 0, ease: 'linear' }}
            >
              <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" className={orbitMode ? 'text-purple-400' : 'text-cyan-400'}>
                <circle cx="12" cy="12" r="3" />
                <circle cx="12" cy="12" r="10" strokeDasharray="2 4" />
                <circle cx="12" cy="5" r="1.5" fill="currentColor" />
                <circle cx="19" cy="12" r="1.5" fill="currentColor" />
                <circle cx="12" cy="19" r="1.5" fill="currentColor" />
                <circle cx="5" cy="12" r="1.5" fill="currentColor" />
              </svg>
            </motion.div>
          </motion.button>

          {/* Notification Bell */}
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
        <PathCarousel
          paths={paths}
          pathIcons={pathIcons}
          iconColors={iconColors}
          pathColors={pathColors}
          topicCounts={topicCounts}
          onPathClick={(path) => navigate(`/paths/${path.id}`)}
          onIndexChange={setCurrentPathIndex}
          orbitMode={orbitMode}
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

      {/* Community Flashcards Card - Below Carousel */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5, delay: 0.4 }}
        className="max-w-md mx-auto mt-28 mb-8"
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
