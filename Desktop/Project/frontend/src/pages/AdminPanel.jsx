import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Check, X, AlertCircle, Users, BarChart3, Edit, Shield, ShieldX, Megaphone, Send } from 'lucide-react'
import { buttonTap } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'

export default function AdminPanel() {
  const { isAdmin, profile } = useAuth()
  const navigate = useNavigate()
  const [pendingCards, setPendingCards] = useState([])
  const [approvedCards, setApprovedCards] = useState([])
  const [loading, setLoading] = useState(true)
  const [activeTab, setActiveTab] = useState('pending') // 'pending', 'approved', 'users', 'appeals', 'quiz'
  const [analytics, setAnalytics] = useState(null)
  const [users, setUsers] = useState([])
  const [appeals, setAppeals] = useState([])
  const [editingCard, setEditingCard] = useState(null)
  const [showUsersModal, setShowUsersModal] = useState(false)
  const [announceForm, setAnnounceForm] = useState({ title: '', message: '' })
  const [announceStatus, setAnnounceStatus] = useState(null) // { type: 'success'|'error', text: string }
  const [announceSending, setAnnounceSending] = useState(false)
  const [pushSending, setPushSending] = useState(false)
  const [pushStatus, setPushStatus] = useState(null)
  const [editForm, setEditForm] = useState({
    question: '',
    option_a: '',
    option_b: '',
    option_c: '',
    option_d: '',
    correct_answer: '',
    explanation: '',
    type: 'mcq'
  })


  useEffect(() => {
    if (!isAdmin) {
      navigate('/paths')
      return
    }
    fetchFlashcards()
    fetchAnalytics()
    fetchUsers()
    fetchAppeals()
  }, [isAdmin, navigate])


  async function fetchFlashcards() {
    // Fetch pending flashcards
    const { data: pending } = await supabase
      .from('community_flashcards')
      .select('*')
      .eq('is_approved', false)
      .order('created_at', { ascending: false })

    // Fetch approved flashcards
    const { data: approved } = await supabase
      .from('community_flashcards')
      .select('*')
      .eq('is_approved', true)
      .order('created_at', { ascending: false })

    // Fetch creator profiles for all cards
    const allCards = [...(pending || []), ...(approved || [])]
    const creatorIds = [...new Set(allCards.map(c => c.created_by))]

    const { data: profiles } = await supabase
      .from('profiles')
      .select('id, username, avatar_url')
      .in('id', creatorIds)

    // Attach profiles to cards
    const attachProfiles = (cards) => cards?.map(card => ({
      ...card,
      profiles: profiles?.find(p => p.id === card.created_by) || null
    })) || []

    setPendingCards(attachProfiles(pending))
    setApprovedCards(attachProfiles(approved))
    setLoading(false)
  }

  async function fetchAnalytics() {
    // Get total users (excluding guests)
    const { count: totalUsers } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })
      .neq('role', 'guest')

    // Get active users (studied in last 7 days)
    const sevenDaysAgo = new Date()
    sevenDaysAgo.setDate(sevenDaysAgo.getDate() - 7)
    const { count: activeUsers } = await supabase
      .from('study_sessions')
      .select('user_id', { count: 'exact', head: true })
      .gte('date', sevenDaysAgo.toISOString().split('T')[0])

    // Get total flashcards
    const { count: totalFlashcards } = await supabase
      .from('community_flashcards')
      .select('*', { count: 'exact', head: true })
      .eq('is_approved', true)

    // Get top contributors
    const { data: allCards } = await supabase
      .from('community_flashcards')
      .select('created_by')
      .eq('is_approved', true)

    const contributorCounts = {}
    allCards?.forEach(card => {
      contributorCounts[card.created_by] = (contributorCounts[card.created_by] || 0) + 1
    })

    const topContributorIds = Object.entries(contributorCounts)
      .sort((a, b) => b[1] - a[1])
      .slice(0, 5)
      .map(([id]) => id)

    const { data: topContributors } = await supabase
      .from('profiles')
      .select('id, username, avatar_url')
      .in('id', topContributorIds)

    const topContributorsWithCount = topContributors?.map(user => ({
      ...user,
      count: contributorCounts[user.id]
    })) || []

    setAnalytics({
      totalUsers: totalUsers || 0,
      activeUsers: activeUsers || 0,
      totalFlashcards: totalFlashcards || 0,
      topContributors: topContributorsWithCount
    })
  }

  async function fetchUsers() {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .neq('role', 'guest')
      .order('created_at', { ascending: false })

    // Note: Email is stored in auth.users (private)
    // For production, add 'email' column to profiles table or use backend API
    setUsers(data || [])
  }

  async function handleBlockUnblock(userId, currentStatus) {
    const newStatus = currentStatus === 'blocked' ? 'active' : 'blocked'

    const { error } = await supabase
      .from('profiles')
      .update({ status: newStatus })
      .eq('id', userId)

    if (error) {
      console.error('Error blocking user:', error)
      alert('Error: ' + error.message)
      return
    }

    alert(`User ${newStatus === 'blocked' ? 'blocked' : 'unblocked'} successfully!`)
    fetchUsers()
  }

  async function handleApprove(cardId) {
    await supabase
      .from('community_flashcards')
      .update({ is_approved: true })
      .eq('id', cardId)

    fetchFlashcards() // Refresh list
  }

  async function handleDelete(cardId) {
    if (!confirm('Are you sure you want to delete this flashcard?')) return

    await supabase
      .from('community_flashcards')
      .delete()
      .eq('id', cardId)

    fetchFlashcards() // Refresh list
  }

  function handleEdit(card) {
    setEditingCard(card)
    setEditForm({
      question: card.question,
      option_a: card.option_a || '',
      option_b: card.option_b || '',
      option_c: card.option_c || '',
      option_d: card.option_d || '',
      correct_answer: card.correct_answer || '',
      explanation: card.explanation || '',
      type: card.type || 'mcq'
    })
  }

  async function handleSaveEdit() {
    if (!editingCard) return

    await supabase
      .from('community_flashcards')
      .update(editForm)
      .eq('id', editingCard.id)

    setEditingCard(null)
    fetchFlashcards()
  }

  async function handleChangeUserRole(userId, newRole) {
    await supabase
      .from('profiles')
      .update({ role: newRole })
      .eq('id', userId)

    fetchUsers()
  }

  async function fetchAppeals() {
    const { data } = await supabase
      .from('user_appeals')
      .select('*, profiles!user_id(id, username, email, avatar_url)')
      .eq('status', 'pending')
      .order('created_at', { ascending: false })

    setAppeals(data || [])
  }

  async function handleUnblockFromAppeal(appealId, userId) {
    // Unblock the user
    await supabase
      .from('profiles')
      .update({ status: 'active' })
      .eq('id', userId)

    // Mark appeal as reviewed
    await supabase
      .from('user_appeals')
      .update({
        status: 'reviewed',
        reviewed_at: new Date().toISOString(),
        reviewed_by: profile.id
      })
      .eq('id', appealId)

    fetchAppeals()
    fetchUsers()
  }

  async function handleAnnounce() {
    const title = announceForm.title.trim()
    const message = announceForm.message.trim()
    if (!title || !message) {
      setAnnounceStatus({ type: 'error', text: 'Please fill in both title and message.' })
      return
    }
    setAnnounceSending(true)
    setAnnounceStatus(null)

    try {
      // 1. Email all active users via backend
      const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000'
      const res = await fetch(`${BACKEND_URL}/api/notifications/send-update`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, message }),
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.detail || 'Email send failed')

      // 2. Create in-app notification for all users
      await supabase.from('admin_notifications').insert({
        title,
        message,
        created_by: profile.id,
        is_poll: false,
      })

      setAnnounceStatus({ type: 'success', text: `Announcement sent! Emailed ${data.sent} users.` })
      setAnnounceForm({ title: '', message: '' })
    } catch (e) {
      setAnnounceStatus({ type: 'error', text: e.message })
    } finally {
      setAnnounceSending(false)
    }
  }

  async function handleSendPush() {
    const title = announceForm.title.trim()
    const message = announceForm.message.trim()
    if (!title || !message) {
      setPushStatus({ type: 'error', text: 'Please fill in both title and message.' })
      return
    }
    setPushSending(true)
    setPushStatus(null)
    try {
      const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000'
      const res = await fetch(`${BACKEND_URL}/api/push/send`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, body: message }),
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.detail || 'Push failed')
      setPushStatus({ type: 'success', text: `Push sent to ${data.sent} device(s)!` })
    } catch (e) {
      setPushStatus({ type: 'error', text: e.message })
    } finally {
      setPushSending(false)
    }
  }

  if (loading) {
    return <CardShuffleLoader />
  }

  const displayCards = activeTab === 'pending' ? pendingCards : activeTab === 'approved' ? approvedCards : []


  return (
    <div className="min-h-screen px-5 py-6">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <button onClick={() => navigate(-1)} className="text-gray-400 hover:text-white transition-colors">
          <ArrowLeft size={22} />
        </button>
        <h1 className="text-2xl font-bold text-white">Admin Panel</h1>
        <div className="w-6" />
      </div>

      {/* Analytics Dashboard */}
      {analytics && (
        <div className="grid grid-cols-3 gap-4 mb-6">
          <motion.div
            onClick={() => setShowUsersModal(true)}
            className="relative bg-gradient-to-br from-cyan-500/20 to-blue-500/20 border border-cyan-500/30 rounded-xl p-4 cursor-pointer hover:border-cyan-500/50 transition-colors"
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
          >
            {/* Blocked Users Count - Top Right */}
            {users.filter(u => u.status === 'blocked').length > 0 && (
              <div className="absolute top-2 right-2 flex items-center gap-1 px-2 py-1 bg-red-500/30 border border-red-500/50 rounded-lg">
                <ShieldX size={12} className="text-red-400" />
                <span className="text-red-400 text-xs font-bold">
                  {users.filter(u => u.status === 'blocked').length}
                </span>
              </div>
            )}

            <div className="flex items-center gap-3 mb-2">
              <Users size={20} className="text-cyan-400" />
              <p className="text-cyan-400 text-xs font-semibold uppercase">Total Users</p>
            </div>
            <p className="text-white text-2xl font-bold">{analytics.totalUsers}</p>
            <p className="text-cyan-400/70 text-xs mt-1">Click to view all</p>
          </motion.div>

          <div className="bg-gradient-to-br from-purple-500/20 to-pink-500/20 border border-purple-500/30 rounded-xl p-4">
            <div className="flex items-center gap-3 mb-2">
              <Check size={20} className="text-purple-400" />
              <p className="text-purple-400 text-xs font-semibold uppercase">Approved</p>
            </div>
            <p className="text-white text-2xl font-bold">{analytics.totalFlashcards}</p>
          </div>

          <div className="bg-gradient-to-br from-orange-500/20 to-red-500/20 border border-orange-500/30 rounded-xl p-4">
            <div className="flex items-center gap-3 mb-2">
              <AlertCircle size={20} className="text-orange-400" />
              <p className="text-orange-400 text-xs font-semibold uppercase">Pending</p>
            </div>
            <p className="text-white text-2xl font-bold">{pendingCards.length}</p>
          </div>
        </div>
      )}

      {/* Tabs */}
      <div className="grid grid-cols-2 lg:grid-cols-5 gap-2 mb-6">
        <button
          onClick={() => setActiveTab('pending')}
          className={`py-3 rounded-xl font-semibold transition-all ${
            activeTab === 'pending'
              ? 'bg-orange-500/20 border-2 border-orange-500/40 text-orange-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          Pending ({pendingCards.length})
        </button>
        <button
          onClick={() => setActiveTab('approved')}
          className={`py-3 rounded-xl font-semibold transition-all ${
            activeTab === 'approved'
              ? 'bg-green-500/20 border-2 border-green-500/40 text-green-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          Approved ({approvedCards.length})
        </button>
        <button
          onClick={() => setActiveTab('users')}
          className={`py-3 rounded-xl font-semibold transition-all ${
            activeTab === 'users'
              ? 'bg-cyan-500/20 border-2 border-cyan-500/40 text-cyan-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          Users ({users.length})
        </button>
        <button
          onClick={() => setActiveTab('appeals')}
          className={`py-3 rounded-xl font-semibold transition-all ${
            activeTab === 'appeals'
              ? 'bg-red-500/20 border-2 border-red-500/40 text-red-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          Appeals ({appeals.length})
        </button>
        <button
          onClick={() => setActiveTab('announce')}
          className={`py-3 rounded-xl font-semibold transition-all flex items-center justify-center gap-2 col-span-2 lg:col-span-1 ${
            activeTab === 'announce'
              ? 'bg-purple-500/20 border-2 border-purple-500/40 text-purple-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          <Megaphone size={16} />
          Announce
        </button>
      </div>

      {/* Tab Content */}
      {activeTab === 'announce' ? (
        <div className="max-w-lg pb-24">
          <div className="bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-purple-500/20 rounded-2xl p-6 space-y-4">
            <div className="flex items-center gap-3 mb-2">
              <Megaphone size={20} className="text-purple-400" />
              <h2 className="text-white font-bold text-lg">Send Announcement</h2>
            </div>
            <p className="text-gray-400 text-sm">Emails all active users and creates an in-app notification.</p>

            <div>
              <label className="text-purple-400 text-sm font-semibold mb-2 block">Title</label>
              <input
                type="text"
                value={announceForm.title}
                onChange={(e) => setAnnounceForm({ ...announceForm, title: e.target.value })}
                placeholder="e.g., New MySQL Path Added!"
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                maxLength={100}
              />
            </div>

            <div>
              <label className="text-purple-400 text-sm font-semibold mb-2 block">Message</label>
              <textarea
                value={announceForm.message}
                onChange={(e) => setAnnounceForm({ ...announceForm, message: e.target.value })}
                placeholder="e.g., We've added 200+ new MySQL flashcards covering joins, indexes, and more!"
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                rows={4}
                maxLength={500}
              />
              <p className="text-gray-500 text-xs mt-1">{announceForm.message.length}/500 characters</p>
            </div>

            {announceStatus && (
              <div className={`p-3 rounded-xl border text-sm font-medium ${
                announceStatus.type === 'success'
                  ? 'bg-green-500/10 border-green-500/30 text-green-400'
                  : 'bg-red-500/10 border-red-500/30 text-red-400'
              }`}>
                {announceStatus.text}
              </div>
            )}

            <motion.button
              onClick={handleAnnounce}
              disabled={announceSending}
              className="w-full py-3 rounded-xl bg-purple-500/20 border border-purple-500/30 text-purple-400 font-semibold hover:bg-purple-500/30 transition-colors flex items-center justify-center gap-2 disabled:opacity-50"
              whileTap={announceSending ? {} : buttonTap}
            >
              {announceSending ? (
                <>
                  <div className="w-5 h-5 border-2 border-purple-400 border-t-transparent rounded-full animate-spin" />
                  Sending...
                </>
              ) : (
                <>
                  <Send size={18} />
                  Send Email to All Users
                </>
              )}
            </motion.button>
          </div>

          {/* Push Notification */}
          <div className="bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-cyan-500/20 rounded-2xl p-6 space-y-4 mt-4">
            <div className="flex items-center gap-3 mb-2">
              <Megaphone size={20} className="text-cyan-400" />
              <h2 className="text-white font-bold text-lg">Send Push Notification</h2>
            </div>
            <p className="text-gray-400 text-sm">Sends a native mobile/browser notification to all subscribed users. Uses the same title & message above.</p>

            {pushStatus && (
              <div className={`p-3 rounded-xl border text-sm font-medium ${
                pushStatus.type === 'success'
                  ? 'bg-green-500/10 border-green-500/30 text-green-400'
                  : 'bg-red-500/10 border-red-500/30 text-red-400'
              }`}>
                {pushStatus.text}
              </div>
            )}

            <motion.button
              onClick={handleSendPush}
              disabled={pushSending}
              className="w-full py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors flex items-center justify-center gap-2 disabled:opacity-50"
              whileTap={pushSending ? {} : buttonTap}
            >
              {pushSending ? (
                <>
                  <div className="w-5 h-5 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
                  Sending...
                </>
              ) : (
                <>
                  <Send size={18} />
                  Send Push to All Devices
                </>
              )}
            </motion.button>
          </div>
        </div>
      ) : activeTab === 'appeals' ? (
        <div className="space-y-4 pb-24">
          {appeals.length === 0 ? (
            <div className="text-center mt-20">
              <AlertCircle size={48} className="text-gray-500 mx-auto mb-3" />
              <p className="text-gray-400">No pending appeals</p>
            </div>
          ) : (
            appeals.map((appeal, index) => (
              <motion.div
                key={appeal.id}
                className="bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-red-500/20 rounded-2xl p-5"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: index * 0.05 }}
              >
                {/* User Info */}
                <div className="flex items-center gap-4 mb-4 pb-4 border-b border-white/10">
                  {appeal.profiles?.avatar_url ? (
                    <img
                      src={appeal.profiles.avatar_url}
                      alt={appeal.profiles.username}
                      className="w-12 h-12 rounded-full"
                      referrerPolicy="no-referrer"
                    />
                  ) : (
                    <div className="w-12 h-12 rounded-full bg-red-500/20 flex items-center justify-center">
                      <span className="text-red-400 font-bold text-lg">
                        {appeal.profiles?.username?.[0]?.toUpperCase() || 'U'}
                      </span>
                    </div>
                  )}
                  <div className="flex-1">
                    <p className="text-white font-bold">{appeal.profiles?.username}</p>
                    <p className="text-gray-400 text-sm">{appeal.profiles?.email || 'No email'}</p>
                    <p className="text-gray-500 text-xs mt-1">
                      {new Date(appeal.created_at).toLocaleString()}
                    </p>
                  </div>
                </div>

                {/* Appeal Message */}
                <div className="mb-4 p-4 bg-navy-700/30 rounded-xl border border-white/5">
                  <p className="text-red-400 text-xs font-semibold mb-2">APPEAL MESSAGE</p>
                  <p className="text-gray-300 text-sm leading-relaxed">{appeal.message}</p>
                </div>

                {/* Unblock Button */}
                <motion.button
                  onClick={() => handleUnblockFromAppeal(appeal.id, appeal.user_id)}
                  className="w-full py-3 rounded-xl bg-green-500/20 border border-green-500/30 text-green-400 font-semibold hover:bg-green-500/30 transition-colors flex items-center justify-center gap-2"
                  whileTap={buttonTap}
                >
                  <Check size={18} />
                  Unblock User
                </motion.button>
              </motion.div>
            ))
          )}
        </div>
      ) : activeTab === 'users' ? (
        <div className="space-y-4 pb-24">
          {users.map((user, index) => (
            <motion.div
              key={user.id}
              className="relative bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-white/10 rounded-2xl p-5"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.03 }}
            >
              {/* Blocked Badge - Top Right */}
              {user.status === 'blocked' && (
                <div className="absolute top-3 right-3 flex items-center gap-1 px-2 py-1 bg-red-500/20 border border-red-500/40 rounded-lg">
                  <ShieldX size={14} className="text-red-400" />
                  <span className="text-red-400 text-xs font-bold">BLOCKED</span>
                </div>
              )}

              <div className="flex items-center gap-4">
                {user.avatar_url ? (
                  <img src={user.avatar_url} alt={user.username} className="w-12 h-12 rounded-full" referrerPolicy="no-referrer" />
                ) : (
                  <div className="w-12 h-12 rounded-full bg-cyan-500/20 flex items-center justify-center">
                    <span className="text-cyan-400 font-bold text-lg">
                      {user.username?.[0]?.toUpperCase() || 'U'}
                    </span>
                  </div>
                )}
                <div className="flex-1">
                  <p className="text-white font-bold">{user.username}</p>
                  <p className="text-gray-400 text-sm">
                    Joined {new Date(user.created_at).toLocaleDateString()}
                  </p>
                  <p className="text-gray-500 text-xs mt-1">
                    Points: {user.points || 0} • Streak: {user.streak || 0} days
                  </p>
                </div>
                <div className="flex items-center gap-2">
                  <select
                    value={user.role || 'user'}
                    onChange={(e) => handleChangeUserRole(user.id, e.target.value)}
                    className="px-3 py-2 bg-navy-700 border border-white/10 rounded-lg text-white text-sm"
                  >
                    <option value="user">User</option>
                    <option value="moderator">Moderator</option>
                    <option value="admin">Admin</option>
                  </select>
                  {(user.role === 'admin' || user.role === 'moderator') && (
                    <Shield size={18} className="text-cyan-400" />
                  )}
                </div>
              </div>
            </motion.div>
          ))}
        </div>
      ) : displayCards.length === 0 ? (
        <div className="text-center mt-20">
          <AlertCircle size={48} className="text-gray-500 mx-auto mb-3" />
          <p className="text-gray-400">
            {activeTab === 'pending' ? 'No pending flashcards' : 'No approved flashcards'}
          </p>
        </div>
      ) : (
        <div className="space-y-4 pb-24">
          {displayCards.map((card, index) => (
            <motion.div
              key={card.id}
              className="bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-white/10 rounded-2xl p-5"
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
            >
              {/* Creator Info */}
              <div className="flex items-center gap-3 mb-4 pb-4 border-b border-white/10">
                {card.profiles?.avatar_url ? (
                  <img
                    src={card.profiles.avatar_url}
                    alt={card.profiles.username}
                    className="w-8 h-8 rounded-full"
                  />
                ) : (
                  <div className="w-8 h-8 rounded-full bg-cyan-500/20 flex items-center justify-center">
                    <span className="text-cyan-400 font-bold text-sm">
                      {card.profiles?.username?.[0]?.toUpperCase() || 'U'}
                    </span>
                  </div>
                )}
                <div className="flex-1">
                  <p className="text-white font-medium text-sm">{card.profiles?.username || 'Unknown'}</p>
                  <p className="text-gray-500 text-xs">{new Date(card.created_at).toLocaleDateString()}</p>
                </div>
              </div>

              {/* Question */}
              <div className="mb-4">
                <p className="text-cyan-400 text-xs font-semibold mb-2">QUESTION</p>
                <p className="text-white font-medium">{card.question}</p>
              </div>

              {/* Options */}
              <div className="space-y-2 mb-4">
                {['a', 'b', 'c', 'd'].map((opt) => {
                  const optionKey = `option_${opt}`
                  const isCorrect = card.correct_answer === opt
                  return (
                    <div
                      key={opt}
                      className={`p-3 rounded-lg border ${
                        isCorrect
                          ? 'bg-green-500/10 border-green-500/30'
                          : 'bg-navy-700/30 border-white/10'
                      }`}
                    >
                      <span className={`font-bold text-sm mr-2 ${isCorrect ? 'text-green-400' : 'text-gray-400'}`}>
                        {opt.toUpperCase()}.
                      </span>
                      <span className={isCorrect ? 'text-green-400' : 'text-gray-300'}>
                        {card[optionKey]}
                        {isCorrect && ' ✓'}
                      </span>
                    </div>
                  )
                })}
              </div>

              {/* Explanation */}
              {card.explanation && (
                <div className="mb-4 p-3 bg-navy-700/30 rounded-lg border border-white/5">
                  <p className="text-cyan-400 text-xs font-semibold mb-1">EXPLANATION</p>
                  <p className="text-gray-300 text-sm">{card.explanation}</p>
                </div>
              )}

              {/* Action Buttons */}
              <div className="flex gap-3">
                {activeTab === 'pending' && (
                  <motion.button
                    onClick={() => handleApprove(card.id)}
                    className="flex-1 py-3 rounded-xl bg-green-500/20 border border-green-500/30 text-green-400 font-semibold hover:bg-green-500/30 transition-colors flex items-center justify-center gap-2"
                    whileTap={buttonTap}
                  >
                    <Check size={18} />
                    Approve
                  </motion.button>
                )}
                <motion.button
                  onClick={() => handleEdit(card)}
                  className="flex-1 py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors flex items-center justify-center gap-2"
                  whileTap={buttonTap}
                >
                  <Edit size={18} />
                  Edit
                </motion.button>
                <motion.button
                  onClick={() => handleDelete(card.id)}
                  className="flex-1 py-3 rounded-xl bg-red-500/20 border border-red-500/30 text-red-400 font-semibold hover:bg-red-500/30 transition-colors flex items-center justify-center gap-2"
                  whileTap={buttonTap}
                >
                  <X size={18} />
                  Delete
                </motion.button>
              </div>
            </motion.div>
          ))}
        </div>
      )}

      {/* Users List Modal */}
      {showUsersModal && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-5">
          <motion.div
            className="bg-navy-800 border border-white/10 rounded-2xl p-6 max-w-4xl w-full max-h-[90vh] overflow-y-auto"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-2xl font-bold text-white flex items-center gap-3">
                <Users size={24} className="text-cyan-400" />
                All Users ({users.length})
              </h2>
              <button
                onClick={() => setShowUsersModal(false)}
                className="text-gray-400 hover:text-white transition-colors"
              >
                <X size={24} />
              </button>
            </div>

            {/* Table Header - Desktop Only */}
            <div className="hidden lg:grid grid-cols-3 gap-4 bg-navy-700/50 border border-white/10 rounded-xl p-4 mb-3">
              <div className="text-cyan-400 font-semibold text-sm uppercase">Name</div>
              <div className="text-cyan-400 font-semibold text-sm uppercase">Email</div>
              <div className="text-cyan-400 font-semibold text-sm uppercase text-center">Action</div>
            </div>

            {/* Table Rows */}
            <div className="space-y-3">
              {users.map((user, index) => (
                <motion.div
                  key={user.id}
                  className="relative bg-navy-700/30 border border-white/5 rounded-xl p-4 hover:bg-navy-700/50 transition-colors"
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.02 }}
                >
                  {/* Blocked Badge - Top Right */}
                  {user.status === 'blocked' && (
                    <div className="absolute top-2 right-2 flex items-center gap-1 px-2 py-1 bg-red-500/20 border border-red-500/40 rounded-lg z-10">
                      <ShieldX size={12} className="text-red-400" />
                      <span className="text-red-400 text-xs font-bold">BLOCKED</span>
                    </div>
                  )}

                  {/* Desktop Layout - 3 Columns */}
                  <div className="hidden lg:grid grid-cols-3 gap-4 items-center">
                    {/* Name Column */}
                    <div className="flex items-center gap-3">
                      {user.avatar_url ? (
                        <img
                          src={user.avatar_url}
                          alt={user.username}
                          className="w-10 h-10 rounded-full"
                          referrerPolicy="no-referrer"
                        />
                      ) : (
                        <div className="w-10 h-10 rounded-full bg-cyan-500/20 flex items-center justify-center">
                          <span className="text-cyan-400 font-bold">
                            {user.username?.[0]?.toUpperCase() || 'U'}
                          </span>
                        </div>
                      )}
                      <div>
                        <p className="text-white font-medium">{user.username}</p>
                        {user.role === 'admin' && (
                          <span className="text-xs text-cyan-400">Admin</span>
                        )}
                        {user.role === 'moderator' && (
                          <span className="text-xs text-purple-400">Moderator</span>
                        )}
                      </div>
                    </div>

                    {/* Email Column */}
                    <div className="text-gray-300 text-sm truncate">{user.email || 'No email'}</div>

                    {/* Action Column */}
                    <div className="flex justify-center">
                      <motion.button
                        onClick={() => handleBlockUnblock(user.id, user.status)}
                        className={`px-4 py-2 rounded-lg font-semibold text-sm transition-colors ${
                          user.status === 'blocked'
                            ? 'bg-green-500/20 border border-green-500/30 text-green-400 hover:bg-green-500/30'
                            : 'bg-red-500/20 border border-red-500/30 text-red-400 hover:bg-red-500/30'
                        }`}
                        whileHover={{ scale: 1.05 }}
                        whileTap={{ scale: 0.95 }}
                      >
                        {user.status === 'blocked' ? 'Unblock' : 'Block'}
                      </motion.button>
                    </div>
                  </div>

                  {/* Mobile Layout - Stacked */}
                  <div className="lg:hidden space-y-3">
                    {/* Name */}
                    <div className="flex items-center gap-3">
                      {user.avatar_url ? (
                        <img
                          src={user.avatar_url}
                          alt={user.username}
                          className="w-12 h-12 rounded-full"
                          referrerPolicy="no-referrer"
                        />
                      ) : (
                        <div className="w-12 h-12 rounded-full bg-cyan-500/20 flex items-center justify-center">
                          <span className="text-cyan-400 font-bold text-lg">
                            {user.username?.[0]?.toUpperCase() || 'U'}
                          </span>
                        </div>
                      )}
                      <div className="flex-1">
                        <p className="text-white font-bold text-base">{user.username}</p>
                        {user.role === 'admin' && (
                          <span className="text-xs text-cyan-400">Admin</span>
                        )}
                        {user.role === 'moderator' && (
                          <span className="text-xs text-purple-400">Moderator</span>
                        )}
                      </div>
                    </div>

                    {/* Email */}
                    <div>
                      <p className="text-cyan-400 text-xs font-semibold uppercase mb-1">Email</p>
                      <p className="text-gray-300 text-sm break-all">{user.email || 'No email'}</p>
                    </div>

                    {/* Action */}
                    <div>
                      <p className="text-cyan-400 text-xs font-semibold uppercase mb-2">Action</p>
                      <motion.button
                        onClick={() => handleBlockUnblock(user.id, user.status)}
                        className={`w-full px-4 py-2.5 rounded-lg font-semibold text-sm transition-colors ${
                          user.status === 'blocked'
                            ? 'bg-green-500/20 border border-green-500/30 text-green-400 hover:bg-green-500/30'
                            : 'bg-red-500/20 border border-red-500/30 text-red-400 hover:bg-red-500/30'
                        }`}
                        whileHover={{ scale: 1.02 }}
                        whileTap={{ scale: 0.98 }}
                      >
                        {user.status === 'blocked' ? 'Unblock' : 'Block'}
                      </motion.button>
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </div>
      )}

      {/* Edit Modal */}
      {editingCard && (
        <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-5">
          <motion.div
            className="bg-navy-800 border border-white/10 rounded-2xl p-6 max-w-lg w-full max-h-[90vh] overflow-y-auto"
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
          >
            <h2 className="text-xl font-bold text-white mb-4">Edit Flashcard</h2>

            {/* Question */}
            <div className="mb-4">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">Question</label>
              <textarea
                value={editForm.question}
                onChange={(e) => setEditForm({ ...editForm, question: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                rows={3}
              />
            </div>

            {/* Options (only for MCQ) */}
            {editForm.type === 'mcq' && (
              <>
                <div className="mb-4">
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option A</label>
                  <input
                    type="text"
                    value={editForm.option_a}
                    onChange={(e) => setEditForm({ ...editForm, option_a: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  />
                </div>

                <div className="mb-4">
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option B</label>
                  <input
                    type="text"
                    value={editForm.option_b}
                    onChange={(e) => setEditForm({ ...editForm, option_b: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  />
                </div>

                <div className="mb-4">
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option C</label>
                  <input
                    type="text"
                    value={editForm.option_c}
                    onChange={(e) => setEditForm({ ...editForm, option_c: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  />
                </div>

                <div className="mb-4">
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">Option D</label>
                  <input
                    type="text"
                    value={editForm.option_d}
                    onChange={(e) => setEditForm({ ...editForm, option_d: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  />
                </div>

                <div className="mb-4">
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">Correct Answer</label>
                  <select
                    value={editForm.correct_answer}
                    onChange={(e) => setEditForm({ ...editForm, correct_answer: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  >
                    <option value="">Select correct answer</option>
                    <option value="a">A</option>
                    <option value="b">B</option>
                    <option value="c">C</option>
                    <option value="d">D</option>
                  </select>
                </div>
              </>
            )}

            {/* Explanation */}
            <div className="mb-6">
              <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                {editForm.type === 'mcq' ? 'Explanation' : 'Answer'}
              </label>
              <textarea
                value={editForm.explanation}
                onChange={(e) => setEditForm({ ...editForm, explanation: e.target.value })}
                className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                rows={3}
              />
            </div>

            {/* Actions */}
            <div className="flex gap-3">
              <motion.button
                onClick={() => setEditingCard(null)}
                className="flex-1 py-3 rounded-xl bg-gray-500/20 border border-gray-500/30 text-gray-400 font-semibold hover:bg-gray-500/30 transition-colors"
                whileTap={buttonTap}
              >
                Cancel
              </motion.button>
              <motion.button
                onClick={handleSaveEdit}
                className="flex-1 py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors"
                whileTap={buttonTap}
              >
                Save Changes
              </motion.button>
            </div>
          </motion.div>
        </div>
      )}
    </div>
  )
}
