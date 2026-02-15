import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, Check, X, AlertCircle, Users, BarChart3, Edit, Shield, ShieldX, Plus } from 'lucide-react'
import { buttonTap } from '../utils/animations'

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

  // Quiz Creation State
  const [paths, setPaths] = useState([])
  const [topics, setTopics] = useState([])
  const [subtopics, setSubtopics] = useState([])
  const [selectedPathId, setSelectedPathId] = useState('')
  const [selectedTopicId, setSelectedTopicId] = useState('')
  const [selectedSubtopicId, setSelectedSubtopicId] = useState('')
  const [quizForm, setQuizForm] = useState({
    question: '',
    option_a: '',
    option_b: '',
    option_c: '',
    option_d: '',
    correct_option: '',
    explanation: ''
  })
  const [submittingQuiz, setSubmittingQuiz] = useState(false)

  useEffect(() => {
    if (!isAdmin) {
      navigate('/paths')
      return
    }
    fetchFlashcards()
    fetchAnalytics()
    fetchUsers()
    fetchAppeals()
    fetchPaths()
  }, [isAdmin, navigate])

  // Fetch topics when path is selected
  useEffect(() => {
    if (selectedPathId) {
      fetchTopics(selectedPathId)
      setSelectedTopicId('')
      setSelectedSubtopicId('')
    } else {
      setTopics([])
      setSubtopics([])
    }
  }, [selectedPathId])

  // Fetch subtopics when topic is selected
  useEffect(() => {
    if (selectedTopicId) {
      fetchSubtopics(selectedTopicId)
      setSelectedSubtopicId('')
    } else {
      setSubtopics([])
    }
  }, [selectedTopicId])

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
    // Get total users
    const { count: totalUsers } = await supabase
      .from('profiles')
      .select('*', { count: 'exact', head: true })

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

  // Quiz Creation Functions
  async function fetchPaths() {
    const { data } = await supabase
      .from('paths')
      .select('*')
      .order('display_order', { ascending: true })

    setPaths(data || [])
  }

  async function fetchTopics(pathId) {
    const { data } = await supabase
      .from('topics')
      .select('*')
      .eq('path_id', pathId)
      .order('display_order', { ascending: true })

    setTopics(data || [])
  }

  async function fetchSubtopics(topicId) {
    const { data } = await supabase
      .from('subtopics')
      .select('*')
      .eq('topic_id', topicId)
      .order('display_order', { ascending: true })

    setSubtopics(data || [])
  }

  async function handleSubmitQuiz() {
    // Validate all fields
    if (!selectedSubtopicId) {
      alert('Please select a subtopic')
      return
    }

    if (!quizForm.question.trim()) {
      alert('Please enter a question')
      return
    }

    if (!quizForm.option_a.trim() || !quizForm.option_b.trim() ||
        !quizForm.option_c.trim() || !quizForm.option_d.trim()) {
      alert('Please fill in all 4 options')
      return
    }

    if (!quizForm.correct_option || !['a', 'b', 'c', 'd'].includes(quizForm.correct_option)) {
      alert('Please select the correct answer')
      return
    }

    if (!quizForm.explanation.trim()) {
      alert('Please add an explanation')
      return
    }

    setSubmittingQuiz(true)

    const { error } = await supabase
      .from('flashcards')
      .insert({
        topic_id: selectedTopicId, // Required field
        subtopic_id: selectedSubtopicId,
        question: quizForm.question.trim(),
        answer: quizForm.explanation.trim(), // Store explanation in answer field
        explanation: quizForm.explanation.trim(),
        option_a: quizForm.option_a.trim(),
        option_b: quizForm.option_b.trim(),
        option_c: quizForm.option_c.trim(),
        option_d: quizForm.option_d.trim(),
        correct_option: quizForm.correct_option,
        card_type: 'mcq'
      })

    setSubmittingQuiz(false)

    if (error) {
      console.error('Error creating quiz:', error)
      alert('Error creating quiz: ' + error.message)
      return
    }

    // Success - reset form
    alert('Quiz flashcard created successfully!')
    setQuizForm({
      question: '',
      option_a: '',
      option_b: '',
      option_c: '',
      option_d: '',
      correct_option: '',
      explanation: ''
    })
    setSelectedPathId('')
    setSelectedTopicId('')
    setSelectedSubtopicId('')
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
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
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
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

          <div className="bg-gradient-to-br from-emerald-500/20 to-green-500/20 border border-emerald-500/30 rounded-xl p-4">
            <div className="flex items-center gap-3 mb-2">
              <BarChart3 size={20} className="text-emerald-400" />
              <p className="text-emerald-400 text-xs font-semibold uppercase">Active (7d)</p>
            </div>
            <p className="text-white text-2xl font-bold">{analytics.activeUsers}</p>
          </div>

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
          onClick={() => setActiveTab('quiz')}
          className={`py-3 rounded-xl font-semibold transition-all flex items-center justify-center gap-2 ${
            activeTab === 'quiz'
              ? 'bg-purple-500/20 border-2 border-purple-500/40 text-purple-400'
              : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
          }`}
        >
          <Plus size={18} />
          Quiz
        </button>
      </div>

      {/* Quiz Creation Form */}
      {activeTab === 'quiz' ? (
        <div className="pb-24">
          <motion.div
            className="bg-gradient-to-b from-navy-700/50 to-navy-800/50 border border-purple-500/20 rounded-2xl p-6 max-w-3xl mx-auto"
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
          >
            <div className="flex items-center gap-3 mb-6 pb-4 border-b border-white/10">
              <Plus size={24} className="text-purple-400" />
              <h2 className="text-xl font-bold text-white">Create Quiz Flashcard</h2>
            </div>

            {/* Cascading Dropdowns */}
            <div className="space-y-4 mb-6">
              {/* Learning Path Dropdown */}
              <div>
                <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                  1. Select Learning Path
                </label>
                <select
                  value={selectedPathId}
                  onChange={(e) => setSelectedPathId(e.target.value)}
                  className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                >
                  <option value="">Choose a path...</option>
                  {paths.map((path) => (
                    <option key={path.id} value={path.id}>
                      {path.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Topic Dropdown */}
              <div>
                <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                  2. Select Topic
                </label>
                <select
                  value={selectedTopicId}
                  onChange={(e) => setSelectedTopicId(e.target.value)}
                  disabled={!selectedPathId}
                  className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <option value="">Choose a topic...</option>
                  {topics.map((topic) => (
                    <option key={topic.id} value={topic.id}>
                      {topic.name}
                    </option>
                  ))}
                </select>
              </div>

              {/* Subtopic Dropdown */}
              <div>
                <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                  3. Select Subtopic
                </label>
                <select
                  value={selectedSubtopicId}
                  onChange={(e) => setSelectedSubtopicId(e.target.value)}
                  disabled={!selectedTopicId}
                  className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  <option value="">Choose a subtopic...</option>
                  {subtopics.map((subtopic) => (
                    <option key={subtopic.id} value={subtopic.id}>
                      {subtopic.name}
                    </option>
                  ))}
                </select>
              </div>
            </div>

            {/* Only show form if subtopic is selected */}
            {selectedSubtopicId && (
              <motion.div
                className="space-y-4"
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: 'auto' }}
                transition={{ duration: 0.3 }}
              >
                <div className="h-px bg-gradient-to-r from-transparent via-purple-500/30 to-transparent mb-6" />

                {/* Question */}
                <div>
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                    Question
                  </label>
                  <textarea
                    value={quizForm.question}
                    onChange={(e) => setQuizForm({ ...quizForm, question: e.target.value })}
                    placeholder="Enter the quiz question..."
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                    rows={3}
                  />
                </div>

                {/* Options */}
                <div className="grid grid-cols-1 lg:grid-cols-2 gap-4">
                  <div>
                    <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                      Option A
                    </label>
                    <input
                      type="text"
                      value={quizForm.option_a}
                      onChange={(e) => setQuizForm({ ...quizForm, option_a: e.target.value })}
                      placeholder="First option..."
                      className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                    />
                  </div>

                  <div>
                    <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                      Option B
                    </label>
                    <input
                      type="text"
                      value={quizForm.option_b}
                      onChange={(e) => setQuizForm({ ...quizForm, option_b: e.target.value })}
                      placeholder="Second option..."
                      className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                    />
                  </div>

                  <div>
                    <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                      Option C
                    </label>
                    <input
                      type="text"
                      value={quizForm.option_c}
                      onChange={(e) => setQuizForm({ ...quizForm, option_c: e.target.value })}
                      placeholder="Third option..."
                      className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                    />
                  </div>

                  <div>
                    <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                      Option D
                    </label>
                    <input
                      type="text"
                      value={quizForm.option_d}
                      onChange={(e) => setQuizForm({ ...quizForm, option_d: e.target.value })}
                      placeholder="Fourth option..."
                      className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                    />
                  </div>
                </div>

                {/* Correct Answer */}
                <div>
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                    Correct Answer
                  </label>
                  <select
                    value={quizForm.correct_option}
                    onChange={(e) => setQuizForm({ ...quizForm, correct_option: e.target.value })}
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                  >
                    <option value="">Select correct answer...</option>
                    <option value="a">A</option>
                    <option value="b">B</option>
                    <option value="c">C</option>
                    <option value="d">D</option>
                  </select>
                </div>

                {/* Explanation */}
                <div>
                  <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                    Explanation
                  </label>
                  <textarea
                    value={quizForm.explanation}
                    onChange={(e) => setQuizForm({ ...quizForm, explanation: e.target.value })}
                    placeholder="Explain why this answer is correct..."
                    className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                    rows={3}
                  />
                </div>

                {/* Submit Button */}
                <motion.button
                  onClick={handleSubmitQuiz}
                  disabled={submittingQuiz}
                  className="w-full py-3 rounded-xl bg-purple-500/20 border border-purple-500/30 text-purple-400 font-semibold hover:bg-purple-500/30 transition-colors flex items-center justify-center gap-2 disabled:opacity-50 disabled:cursor-not-allowed"
                  whileTap={submittingQuiz ? {} : buttonTap}
                >
                  {submittingQuiz ? (
                    <>
                      <div className="w-5 h-5 border-2 border-purple-400 border-t-transparent rounded-full animate-spin" />
                      Creating...
                    </>
                  ) : (
                    <>
                      <Check size={18} />
                      Create Quiz Flashcard
                    </>
                  )}
                </motion.button>
              </motion.div>
            )}
          </motion.div>
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
