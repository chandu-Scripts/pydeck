import { useEffect, useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Flame, Trophy, RotateCcw, ChevronRight, Crown, Medal } from 'lucide-react'
import { useNavigate } from 'react-router-dom'
import { SimpleAnimatedNumber } from '../components/ui/AnimatedNumber'
import { staggerContainer, staggerItem, buttonHover, buttonTap } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'

// Module-level cache — persists across navigations in same session
// Stores both static data (paths/topics/cards) and user data per userId
const _cache = {}

export default function Analytics() {
  const { user } = useAuth()
  const navigate = useNavigate()
  const [stats, setStats] = useState({ streak: 0, mastered: 0, recall: 0, tomorrow: 0, totalCards: 0 })
  const [sessions, setSessions] = useState([])
  const [topicMastery, setTopicMastery] = useState([])
  const [leaderboard, setLeaderboard] = useState([])
  const [showLeaderboard, setShowLeaderboard] = useState(false)
  const [lbLoading, setLbLoading] = useState(false)
  const [loading, setLoading] = useState(!_cache[`user_${user?.id}`])

  useEffect(() => {
    if (!user) return

    // If cached data exists — show it instantly, no spinner
    const userCache = _cache[`user_${user.id}`]
    if (userCache) {
      setSessions(userCache.sessions)
      setStats(userCache.stats)
      setTopicMastery(userCache.mastery)
      setLoading(false)
    }

    // Always fetch fresh data in background (silent refresh)
    async function fetchAnalytics() {
      const today = new Date().toISOString().split('T')[0]
      const thirtyDaysAgo = new Date()
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)
      const thirtyDaysAgoStr = thirtyDaysAgo.toISOString().split('T')[0]

      // All queries fire simultaneously
      const [
        { data: sessionsData },
        { data: allSessions },
        { count: masteredCount },
        { count: recallCount },
        { count: totalCards },
        { data: progress },
        pathsResult,
        topicsResult,
        cardsResult,
      ] = await Promise.all([
        supabase.from('study_sessions').select('*').eq('user_id', user.id).gte('date', thirtyDaysAgoStr).order('date'),
        supabase.from('study_sessions').select('date').eq('user_id', user.id).order('date', { ascending: false }),
        supabase.from('user_progress').select('*', { count: 'exact', head: true }).eq('user_id', user.id).eq('status', 'mastered'),
        supabase.from('user_progress').select('*', { count: 'exact', head: true }).eq('user_id', user.id).eq('status', 'forgot'),
        supabase.from('flashcards').select('*', { count: 'exact', head: true }),
        supabase.from('user_progress').select('flashcard_id, status').eq('user_id', user.id),
        _cache.paths   ? Promise.resolve({ data: _cache.paths })   : supabase.from('paths').select('id, name').order('display_order'),
        _cache.topics  ? Promise.resolve({ data: _cache.topics })  : supabase.from('topics').select('id, path_id'),
        _cache.allCards? Promise.resolve({ data: _cache.allCards }): supabase.from('flashcards').select('id, topic_id'),
      ])

      // Cache static data
      if (!_cache.paths)    _cache.paths    = pathsResult.data
      if (!_cache.topics)   _cache.topics   = topicsResult.data
      if (!_cache.allCards) _cache.allCards = cardsResult.data

      const paths    = _cache.paths    || []
      const topics   = _cache.topics   || []
      const allCards = _cache.allCards || []

      // Calculate streak
      let streak = 0
      const sessionDates = new Set((allSessions || []).map(s => s.date))
      if (sessionDates.has(today)) {
        streak = 1
        let checkDate = new Date()
        checkDate.setDate(checkDate.getDate() - 1)
        while (sessionDates.has(checkDate.toISOString().split('T')[0])) {
          streak++
          checkDate.setDate(checkDate.getDate() - 1)
        }
      }

      const newStats = {
        streak,
        mastered: masteredCount || 0,
        recall: recallCount || 0,
        tomorrow: recallCount || 0,
        totalCards: totalCards || 0,
      }

      const progMap = {}
      ;(progress || []).forEach(p => { progMap[p.flashcard_id] = p.status })

      const mastery = paths.map(path => {
        const pathTopicIds = topics.filter(t => t.path_id === path.id).map(t => t.id)
        const pathCards = allCards.filter(c => pathTopicIds.includes(c.topic_id))
        const mastered = pathCards.filter(c => progMap[c.id] === 'mastered').length
        return {
          name: path.name,
          total: pathCards.length,
          mastered,
          percent: pathCards.length > 0 ? Math.round((mastered / pathCards.length) * 100) : 0,
        }
      })

      // Save to cache for next visit
      _cache[`user_${user.id}`] = { sessions: sessionsData || [], stats: newStats, mastery }

      setSessions(sessionsData || [])
      setStats(newStats)
      setTopicMastery(mastery)
      setLoading(false)
    }
    fetchAnalytics()
  }, [user])

  function handleLeaderboardClick() {
    if (showLeaderboard) {
      setShowLeaderboard(false)
      return
    }
    setShowLeaderboard(true)
    setLbLoading(true)

    const uid = user.id
    supabase
      .from('user_progress')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', uid)
      .eq('status', 'mastered')
      .then((res) => {
        const pts = (res.count || 0) * 10
        return supabase.from('profiles').update({ points: pts }).eq('id', uid)
      })
      .then(() => {
        return supabase.from('profiles').select('id, username, avatar_url, points').neq('role', 'guest').order('points', { ascending: false })
      })
      .then((res) => {
        const data = res.data || []
        setLeaderboard(data.map(p => ({
          ...p,
          points: p.points || 0,
          isCurrentUser: p.id === uid,
        })))
        setLbLoading(false)
      })
  }

  function getHeatmapData() {
    const days = 14
    const grid = []
    const sessionMap = {}
    sessions.forEach(s => { sessionMap[s.date] = s.cards_studied })

    const today = new Date().toISOString().split('T')[0]
    for (let i = days - 1; i >= 0; i--) {
      const d = new Date()
      d.setDate(d.getDate() - i)
      const dateStr = d.toISOString().split('T')[0]
      grid.push({
        date: dateStr,
        count: sessionMap[dateStr] || 0,
        isToday: dateStr === today,
        day: d.toLocaleDateString('en', { weekday: 'short' }).charAt(0),
      })
    }
    return grid
  }

  function getIntensity(count) {
    return count > 0 ? 'bg-emerald-500' : 'bg-navy-700/40'
  }

  if (loading) {
    return <CardShuffleLoader />
  }

  const heatmap = getHeatmapData()
  const allCaughtUp = stats.recall === 0
  const masteredPercent = stats.totalCards > 0 ? Math.round((stats.mastered / stats.totalCards) * 100) : 0

  return (
    <div className="px-5 py-8 lg:py-12">
      {/* Header */}
      <div className="flex items-center gap-3 mb-1">
        <button onClick={() => navigate('/paths')} className="text-gray-400 hover:text-white transition-colors cursor-pointer lg:hidden">
          <ArrowLeft size={22} />
        </button>
        <h1 className="text-2xl lg:text-3xl font-bold text-white">Analytics</h1>
      </div>
      <p className={`text-sm mb-6 ml-0 lg:ml-0 ${allCaughtUp ? 'text-emerald-400' : 'text-amber-400'}`}>
        {allCaughtUp ? '● All caught up!' : `● ${stats.recall} cards due for recall`}
      </p>

      {/* Stats cards - New Layout */}
      <motion.div
        className="mb-6"
        variants={staggerContainer}
        initial="initial"
        animate="animate"
      >
        {/* Top Row - Square Cards */}
        <div className="grid grid-cols-2 gap-3 mb-3">
          {/* Recall — clickable, opens recall session */}
          <motion.button
            onClick={() => navigate('/recall')}
            className="aspect-square bg-gradient-to-b from-red-500/20 to-navy-700/90 backdrop-blur-xl border border-red-500/30 rounded-2xl p-4 flex flex-col items-center justify-center text-center cursor-pointer hover:border-red-500/50 transition-all"
            style={{
              boxShadow: '0 8px 32px rgba(239, 68, 68, 0.15)',
            }}
            variants={staggerItem}
            whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
            whileTap={buttonTap}
          >
            <div className="w-10 h-10 rounded-lg bg-red-500/10 flex items-center justify-center mb-3">
              <RotateCcw size={20} className="text-red-400" />
            </div>
            <p className="text-3xl font-bold text-white mb-1">
              <SimpleAnimatedNumber value={stats.recall} />
            </p>
            <p className="text-red-400 text-xs mb-0.5">Recall</p>
            <p className="text-gray-600 text-[10px]">{stats.recall === 0 ? 'No cards due' : 'Cards due'}</p>
          </motion.button>

          {/* Mastered */}
          <motion.div
            className="aspect-square bg-gradient-to-b from-emerald-500/20 to-navy-700/90 backdrop-blur-xl border border-emerald-500/30 rounded-2xl p-4 flex flex-col items-center justify-center text-center"
            style={{
              boxShadow: '0 8px 32px rgba(16, 185, 129, 0.15)',
            }}
            variants={staggerItem}
          >
            <div className="w-10 h-10 rounded-lg bg-emerald-500/10 flex items-center justify-center mb-3">
              <Trophy size={20} className="text-emerald-400" />
            </div>
            <p className="text-3xl font-bold text-white mb-1">
              <SimpleAnimatedNumber value={stats.mastered} />
            </p>
            <p className="text-emerald-400 text-xs mb-0.5">Mastered</p>
            <p className="text-gray-600 text-[10px]">{masteredPercent}% of total</p>
          </motion.div>
        </div>

        {/* Bottom Row - Rectangular Cards (shorter height) */}
        <div className="grid grid-cols-2 gap-3">
          {/* Streak */}
          <motion.div
            className="bg-gradient-to-b from-amber-500/20 to-navy-700/90 backdrop-blur-xl border border-amber-500/30 rounded-2xl p-4 flex items-center gap-3"
            style={{
              boxShadow: '0 8px 32px rgba(251, 191, 36, 0.15)',
            }}
            variants={staggerItem}
          >
            <motion.div
              className="w-10 h-10 rounded-lg bg-amber-500/10 flex items-center justify-center flex-shrink-0"
              animate={stats.streak > 0 ? {
                scale: [1, 1.1, 1],
                transition: { duration: 1, repeat: Infinity, repeatDelay: 1 }
              } : {}}
            >
              <Flame size={20} className="text-amber-400" />
            </motion.div>
            <div>
              <p className="text-2xl font-bold text-white">
                <SimpleAnimatedNumber value={stats.streak} />
              </p>
              <p className="text-amber-400 text-xs">Streak</p>
            </div>
          </motion.div>

          {/* Leaderboard - Clickable Card */}
          <motion.button
            onClick={handleLeaderboardClick}
            className="bg-gradient-to-b from-amber-500/20 to-navy-700/90 backdrop-blur-xl border border-amber-500/30 rounded-2xl p-4 flex items-center gap-3 cursor-pointer hover:border-amber-500/50 transition-all"
            style={{
              boxShadow: '0 8px 32px rgba(251, 191, 36, 0.15)',
            }}
            variants={staggerItem}
            whileHover={{ scale: 1.02, transition: { duration: 0.2 } }}
            whileTap={buttonTap}
          >
            <div className="w-10 h-10 rounded-lg bg-amber-500/10 flex items-center justify-center flex-shrink-0">
              <Crown size={20} className="text-amber-400" />
            </div>
            <div className="flex-1 text-left">
              <p className="text-amber-400 font-semibold text-sm">Leaderboard</p>
              <p className="text-gray-500 text-xs">{showLeaderboard ? 'Hide' : 'View rankings'}</p>
            </div>
            <ChevronRight size={16} className="text-gray-600" />
          </motion.button>
        </div>
      </motion.div>

      {/* Leaderboard Popup Flashcard */}
      <AnimatePresence>
        {showLeaderboard && (
          <>
            {/* Backdrop */}
            <motion.div
              className="fixed inset-0 bg-black/50 backdrop-blur-sm z-40"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowLeaderboard(false)}
            />

            {/* Centered Flashcard */}
            <motion.div
              className="fixed inset-0 z-50 flex items-center justify-center px-5"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowLeaderboard(false)}
            >
              <motion.div
                className="w-full max-w-md bg-gradient-to-b from-navy-600/95 to-navy-700/95 backdrop-blur-xl border-2 border-amber-500/40 rounded-2xl shadow-2xl max-h-[80vh] overflow-hidden flex flex-col"
                style={{
                  boxShadow: '0 0 50px rgba(251, 191, 36, 0.4), inset 0 0 30px rgba(251, 191, 36, 0.1)',
                }}
                initial={{ opacity: 0, scale: 0.8, y: -20 }}
                animate={{ opacity: 1, scale: 1, y: 0 }}
                exit={{ opacity: 0, scale: 0.8, y: 20 }}
                transition={{ type: 'spring', stiffness: 300, damping: 30 }}
                onClick={(e) => e.stopPropagation()}
              >
                {/* Header */}
                <div className="p-6 border-b border-white/10 flex-shrink-0">
                  <h3 className="text-white font-bold text-xl flex items-center gap-2">
                    <Crown size={24} className="text-amber-400" />
                    Leaderboard
                  </h3>
                  <p className="text-gray-400 text-xs mt-1">Top players by mastered cards</p>
                </div>

                {/* Rankings - Scrollable */}
                <div className="flex-1 overflow-y-auto p-6">
                  {lbLoading && (
                    <div className="flex justify-center py-8">
                      <div className="w-8 h-8 border-2 border-amber-400 border-t-transparent rounded-full animate-spin" />
                    </div>
                  )}

                  {!lbLoading && (
                    <motion.div
                      className="flex flex-col gap-2"
                      variants={staggerContainer}
                      initial="initial"
                      animate="animate"
                    >
                      {leaderboard.map((entry, idx) => {
                        const rank = idx + 1
                        const isTop3 = rank <= 3
                        return (
                          <motion.div
                            key={entry.id}
                            className={`flex items-center gap-3 p-3 rounded-xl border ${
                              entry.isCurrentUser
                                ? 'bg-cyan-500/20 border-cyan-500/50 shadow-lg shadow-cyan-500/20'
                                : isTop3
                                  ? 'bg-amber-500/10 border-amber-500/20'
                                  : 'bg-navy-700/30 border-white/5'
                            }`}
                            variants={staggerItem}
                            animate={entry.isCurrentUser ? {
                              boxShadow: [
                                '0 0 20px rgba(6, 182, 212, 0.2)',
                                '0 0 30px rgba(6, 182, 212, 0.4)',
                                '0 0 20px rgba(6, 182, 212, 0.2)',
                              ],
                              transition: { duration: 2, repeat: Infinity }
                            } : {}}
                          >
                            <div className={`w-8 h-8 rounded-lg flex items-center justify-center font-bold text-sm ${
                              entry.isCurrentUser ? 'text-cyan-400' : isTop3 ? 'text-amber-400' : 'text-gray-500'
                            }`}>
                              #{rank}
                            </div>
                            <div className="w-8 h-8 rounded-full bg-navy-600 flex items-center justify-center overflow-hidden flex-shrink-0">
                              {entry.avatar_url ? (
                                <img src={entry.avatar_url} alt="" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                              ) : (
                                <span className="text-xs font-bold text-white">
                                  {(entry.username || 'U')[0].toUpperCase()}
                                </span>
                              )}
                            </div>
                            <div className="flex-1 min-w-0">
                              <p className={`text-sm font-medium truncate ${entry.isCurrentUser ? 'text-cyan-400 font-bold' : 'text-white'}`}>
                                {entry.username || 'User'}
                              </p>
                            </div>
                            <span className={`text-sm font-bold ${
                              entry.isCurrentUser ? 'text-cyan-400' : isTop3 ? 'text-amber-400' : 'text-gray-400'
                            }`}>
                              {entry.points} pts
                            </span>
                          </motion.div>
                        )
                      })}
                      {leaderboard.length === 0 && (
                        <p className="text-gray-500 text-sm text-center py-8">No rankings yet</p>
                      )}
                    </motion.div>
                  )}
                </div>

                {/* Close hint */}
                <div className="p-4 border-t border-white/10 flex-shrink-0">
                  <p className="text-center text-gray-500 text-xs">
                    Click outside to close
                  </p>
                </div>
              </motion.div>
            </motion.div>
          </>
        )}
      </AnimatePresence>

      {/* Activity heatmap */}
      <div className="bg-navy-700/40 backdrop-blur-sm border border-white/5 rounded-2xl p-5 mb-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-base font-semibold text-white">Activity</h2>
          <span className="text-xs text-gray-500">Last 14 Days</span>
        </div>
        {/* Day labels */}
        <div className="grid grid-cols-7 gap-2 mb-1">
          {heatmap.slice(0, 7).map((cell, idx) => (
            <div key={idx} className="text-center text-[10px] text-gray-600 font-medium">{cell.day}</div>
          ))}
        </div>
        {/* Squares */}
        <div className="grid grid-cols-7 gap-2">
          {heatmap.map((cell, idx) => (
            <div
              key={idx}
              className={`aspect-square rounded-md ${getIntensity(cell.count)}`}
              title={`${cell.date}: ${cell.count} cards`}
            />
          ))}
        </div>
      </div>

      {/* Topic mastery */}
      <div>
        <h2 className="text-base font-semibold text-white mb-4">Topic Mastery</h2>
        <motion.div
          className="flex flex-col gap-3"
          variants={staggerContainer}
          initial="initial"
          animate="animate"
        >
          {topicMastery.map((topic, idx) => (
            <motion.div
              key={topic.name}
              className="bg-navy-700/30 border border-white/5 rounded-xl p-4 flex items-center gap-4"
              variants={staggerItem}
            >
              {/* Percentage circle */}
              <div className="relative w-10 h-10 flex-shrink-0">
                <svg className="w-10 h-10 -rotate-90" viewBox="0 0 36 36">
                  <circle cx="18" cy="18" r="15" fill="none" stroke="#1a2440" strokeWidth="3" />
                  <motion.circle
                    cx="18" cy="18" r="15" fill="none"
                    stroke="#06b6d4"
                    strokeWidth="3"
                    strokeLinecap="round"
                    initial={{ strokeDasharray: '0 94.2' }}
                    animate={{ strokeDasharray: `${topic.percent * 0.942} 94.2` }}
                    transition={{ duration: 1, delay: idx * 0.1, ease: 'easeOut' }}
                  />
                </svg>
                <span className="absolute inset-0 flex items-center justify-center text-[9px] font-bold text-white">
                  {topic.percent}%
                </span>
              </div>
              <div className="flex-1">
                <p className="text-sm font-medium text-white">{topic.name}</p>
                <p className="text-xs text-gray-500">{topic.mastered} / {topic.total} mastered</p>
              </div>
            </motion.div>
          ))}
        </motion.div>
      </div>

    </div>
  )
}
