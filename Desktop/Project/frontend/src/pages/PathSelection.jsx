import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ChevronRight, Code, Layers, Cpu, Database, Users, Menu } from 'lucide-react'
import { SiPython, SiMysql, SiFlask, SiDjango } from 'react-icons/si'
import { buttonTap } from '../utils/animations'
import PathCarousel from '../components/PathCarousel'
import PathListModal from '../components/PathListModal'
import NotificationBell from '../components/NotificationBell'

const pathIcons = {
  'Python': SiPython,
  'SQL': SiMysql,
  'Flask': SiFlask,
  'Django': SiDjango,
  'Python Basics': Code,
  'Intermediate Python': Layers,
  'Advanced Python': Cpu,
  'Data Structures & Algorithms': Database,
}

const pathColors = {
  'Python': 'from-blue-500/20 to-blue-600/10 border-blue-500/20',
  'SQL': 'from-yellow-500/20 to-yellow-600/10 border-yellow-500/20',
  'Flask': 'from-gray-500/20 to-gray-600/10 border-gray-500/20',
  'Django': 'from-green-500/20 to-green-600/10 border-green-500/20',
  'Python Basics': 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20',
  'Intermediate Python': 'from-blue-500/20 to-blue-600/10 border-blue-500/20',
  'Advanced Python': 'from-purple-500/20 to-purple-600/10 border-purple-500/20',
  'Data Structures & Algorithms': 'from-amber-500/20 to-amber-600/10 border-amber-500/20',
}

const iconColors = {
  'Python': 'text-blue-400',
  'SQL': 'text-yellow-400',
  'Flask': 'text-gray-300',
  'Django': 'text-green-400',
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
        {/* Notification Bell */}
        <NotificationBell />
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
        className="max-w-md mx-auto mt-32 mb-8"
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
