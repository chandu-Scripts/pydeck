import { useState, useEffect } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { Bell, X, Send, History, Trash2, BarChart3, CheckCircle } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { buttonTap } from '../utils/animations'
import FlashcardAlert from './FlashcardAlert'

export default function NotificationBell() {
  const { user, isAdmin } = useAuth()
  const [showModal, setShowModal] = useState(false)
  const [notifications, setNotifications] = useState([])
  const [unreadCount, setUnreadCount] = useState(0)
  const [activeTab, setActiveTab] = useState('view') // 'view', 'send', 'history'
  const [loading, setLoading] = useState(false)
  const [pollResults, setPollResults] = useState({}) // Store poll results for admin
  const [userVotes, setUserVotes] = useState({}) // Track user's votes
  const [votedPolls, setVotedPolls] = useState(new Set()) // Track which polls user voted on
  const [deleteConfirm, setDeleteConfirm] = useState(null) // ID of notification to delete
  const [deleting, setDeleting] = useState(false)
  const [alert, setAlert] = useState({ show: false, type: 'success', title: '', message: '' })

  // Form state for sending notifications
  const [sendForm, setSendForm] = useState({
    title: '',
    message: '',
    isPoll: false,
    pollQuestion: '',
    pollOptionA: '',
    pollOptionB: '',
    pollOptionC: '',
    pollOptionD: ''
  })

  useEffect(() => {
    if (user) {
      fetchNotifications()
      fetchUnreadCount()
      if (!isAdmin) {
        fetchUserVotes()
      }

      // Realtime subscription for new and deleted notifications
      const channel = supabase
        .channel('notifications_channel')
        .on(
          'postgres_changes',
          {
            event: 'INSERT',
            schema: 'public',
            table: 'admin_notifications'
          },
          () => {
            fetchNotifications()
            fetchUnreadCount()
          }
        )
        .on(
          'postgres_changes',
          {
            event: 'DELETE',
            schema: 'public',
            table: 'admin_notifications'
          },
          (payload) => {
            // Remove deleted notification instantly
            setNotifications(prev => prev.filter(n => n.id !== payload.old.id))
            fetchUnreadCount()
          }
        )
        .subscribe()

      return () => {
        supabase.removeChannel(channel)
      }
    }
  }, [user, isAdmin])

  async function fetchNotifications() {
    if (isAdmin) {
      // Admin sees all notifications they created
      const { data } = await supabase
        .from('admin_notifications')
        .select('*')
        .eq('created_by', user.id)
        .order('created_at', { ascending: false })

      setNotifications(data || [])

      // Fetch poll results for admin
      if (data) {
        const pollNotifs = data.filter(n => n.is_poll)
        for (const notif of pollNotifs) {
          await fetchPollResults(notif.id)
        }
      }
    } else {
      // Users see active notifications
      const { data } = await supabase
        .from('admin_notifications')
        .select('*')
        .eq('is_active', true)
        .order('created_at', { ascending: false })

      setNotifications(data || [])
    }
  }

  async function fetchPollResults(notificationId) {
    const { data } = await supabase
      .from('poll_responses')
      .select('selected_option')
      .eq('notification_id', notificationId)

    if (data) {
      const counts = { a: 0, b: 0, c: 0, d: 0, total: data.length }
      data.forEach(r => {
        counts[r.selected_option]++
      })
      setPollResults(prev => ({ ...prev, [notificationId]: counts }))
    }
  }

  async function fetchUserVotes() {
    const { data } = await supabase
      .from('poll_responses')
      .select('notification_id, selected_option')
      .eq('user_id', user.id)

    if (data) {
      const votes = {}
      const votedSet = new Set()
      data.forEach(v => {
        votes[v.notification_id] = v.selected_option
        votedSet.add(v.notification_id)
      })
      setUserVotes(votes)
      setVotedPolls(votedSet)
    }
  }

  async function fetchUnreadCount() {
    if (isAdmin) {
      setUnreadCount(0)
      return
    }

    const { data: allNotifications } = await supabase
      .from('admin_notifications')
      .select('id')
      .eq('is_active', true)

    const { data: readNotifications } = await supabase
      .from('user_notification_reads')
      .select('notification_id')
      .eq('user_id', user.id)

    const readIds = new Set(readNotifications?.map(r => r.notification_id) || [])
    const unread = allNotifications?.filter(n => !readIds.has(n.id)) || []

    setUnreadCount(unread.length)
  }

  async function markAllAsRead() {
    if (isAdmin) return

    const promises = notifications.map(n =>
      supabase
        .from('user_notification_reads')
        .upsert({
          user_id: user.id,
          notification_id: n.id
        }, { onConflict: 'user_id,notification_id' })
    )

    await Promise.all(promises)
    fetchUnreadCount()
  }

  async function handleSendNotification() {
    // Validation
    if (!sendForm.title.trim()) {
      setAlert({ show: true, type: 'danger', title: 'Missing Title', message: 'Please enter a title for the notification.' })
      return
    }

    if (sendForm.isPoll) {
      if (!sendForm.pollQuestion.trim()) {
        setAlert({ show: true, type: 'danger', title: 'Missing Question', message: 'Please enter a poll question.' })
        return
      }
      if (!sendForm.pollOptionA.trim() || !sendForm.pollOptionB.trim() ||
          !sendForm.pollOptionC.trim() || !sendForm.pollOptionD.trim()) {
        setAlert({ show: true, type: 'danger', title: 'Incomplete Poll', message: 'Please fill all 4 poll options.' })
        return
      }
    } else {
      if (!sendForm.message.trim()) {
        setAlert({ show: true, type: 'danger', title: 'Missing Message', message: 'Please enter a message for the notification.' })
        return
      }
    }

    setLoading(true)

    const insertData = {
      title: sendForm.title.trim(),
      created_by: user.id,
      is_poll: sendForm.isPoll
    }

    if (sendForm.isPoll) {
      insertData.poll_question = sendForm.pollQuestion.trim()
      insertData.poll_option_a = sendForm.pollOptionA.trim()
      insertData.poll_option_b = sendForm.pollOptionB.trim()
      insertData.poll_option_c = sendForm.pollOptionC.trim()
      insertData.poll_option_d = sendForm.pollOptionD.trim()
      insertData.message = sendForm.pollQuestion.trim() // Store question in message too
    } else {
      insertData.message = sendForm.message.trim()
    }

    const { error } = await supabase
      .from('admin_notifications')
      .insert(insertData)

    setLoading(false)

    if (error) {
      setAlert({ show: true, type: 'danger', title: 'Error', message: 'Failed to send notification: ' + error.message })
      return
    }

    setAlert({
      show: true,
      type: 'success',
      title: 'Sent Successfully!',
      message: sendForm.isPoll ? 'Poll sent to all users! 🎉' : 'Notification sent to all users! 🎉'
    })
    setSendForm({
      title: '',
      message: '',
      isPoll: false,
      pollQuestion: '',
      pollOptionA: '',
      pollOptionB: '',
      pollOptionC: '',
      pollOptionD: ''
    })
    setActiveTab('history')
    fetchNotifications()
  }

  async function handleVote(notificationId, option) {
    if (votedPolls.has(notificationId)) {
      setAlert({ show: true, type: 'danger', title: 'Already Voted', message: 'You have already voted on this poll!' })
      return
    }

    const { error } = await supabase
      .from('poll_responses')
      .insert({
        notification_id: notificationId,
        user_id: user.id,
        selected_option: option
      })

    if (error) {
      setAlert({ show: true, type: 'danger', title: 'Error', message: 'Failed to submit your vote. Please try again.' })
      return
    }

    setVotedPolls(prev => new Set([...prev, notificationId]))
    setUserVotes(prev => ({ ...prev, [notificationId]: option }))
    setAlert({ show: true, type: 'success', title: 'Vote Submitted!', message: 'Thank you for voting! 🎉' })
  }

  async function handleDeleteNotification() {
    setDeleting(true)

    const { error} = await supabase
      .from('admin_notifications')
      .delete()
      .eq('id', deleteConfirm)

    if (error) {
      setAlert({ show: true, type: 'danger', title: 'Error', message: 'Failed to delete notification. Please try again.' })
      setDeleting(false)
      return
    }

    setDeleteConfirm(null)
    setDeleting(false)
    fetchNotifications()
  }

  function openModal() {
    setShowModal(true)
    if (isAdmin) {
      setActiveTab('send')
    } else {
      setActiveTab('view')
      markAllAsRead()
    }
  }

  return (
    <>
      {/* Notification Bell Icon */}
      <motion.button
        onClick={openModal}
        className="relative p-2 rounded-xl bg-navy-700/50 border border-cyan-500/30 hover:bg-navy-700 transition-colors"
        whileHover={{ scale: 1.05 }}
        whileTap={{ scale: 0.95 }}
      >
        <Bell size={20} className="text-cyan-400" />
        {unreadCount > 0 && (
          <motion.div
            className="absolute -top-1 -right-1 w-5 h-5 bg-red-500 rounded-full flex items-center justify-center"
            initial={{ scale: 0 }}
            animate={{ scale: 1 }}
            transition={{ type: 'spring', stiffness: 500, damping: 15 }}
          >
            <span className="text-white text-xs font-bold">{unreadCount}</span>
          </motion.div>
        )}
      </motion.button>

      {/* Flashcard-Style Modal */}
      <AnimatePresence>
        {showModal && (
          <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-5">
            <motion.div
              className="bg-gradient-to-b from-navy-600/95 to-navy-700/95 backdrop-blur-xl border-2 border-cyan-500/40 rounded-3xl p-6 max-w-2xl w-full min-h-[600px] max-h-[90vh] overflow-y-auto shadow-2xl"
              style={{
                boxShadow: '0 0 50px rgba(6, 182, 212, 0.4), inset 0 0 30px rgba(6, 182, 212, 0.1)',
              }}
              initial={{ opacity: 0, scale: 0.8, rotateX: -15 }}
              animate={{ opacity: 1, scale: 1, rotateX: 0 }}
              exit={{ opacity: 0, scale: 0.8, rotateX: 15 }}
              transition={{ type: 'spring', stiffness: 300, damping: 25 }}
            >
              {/* Header */}
              <div className="flex items-center justify-between mb-6">
                <div className="flex items-center gap-3">
                  <Bell size={24} className="text-cyan-400" />
                  <h2 className="text-2xl font-bold text-white">Notifications</h2>
                </div>
                <button
                  onClick={() => setShowModal(false)}
                  className="text-gray-400 hover:text-white transition-colors"
                >
                  <X size={24} />
                </button>
              </div>

              {/* Admin Tabs */}
              {isAdmin && (
                <div className="flex gap-2 mb-6">
                  <motion.button
                    onClick={() => setActiveTab('send')}
                    className={`flex-1 py-3 rounded-xl font-semibold transition-all flex items-center justify-center gap-2 ${
                      activeTab === 'send'
                        ? 'bg-cyan-500/20 border-2 border-cyan-500/40 text-cyan-400'
                        : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
                    }`}
                    whileTap={buttonTap}
                  >
                    <Send size={18} />
                    Send New
                  </motion.button>
                  <motion.button
                    onClick={() => setActiveTab('history')}
                    className={`flex-1 py-3 rounded-xl font-semibold transition-all flex items-center justify-center gap-2 ${
                      activeTab === 'history'
                        ? 'bg-purple-500/20 border-2 border-purple-500/40 text-purple-400'
                        : 'bg-navy-700/50 border-2 border-white/10 text-gray-400'
                    }`}
                    whileTap={buttonTap}
                  >
                    <History size={18} />
                    History
                  </motion.button>
                </div>
              )}

              {/* Content */}
              <div className="space-y-4">
                {/* Send Notification Form (Admin) */}
                {isAdmin && activeTab === 'send' && (
                  <motion.div
                    className="space-y-4"
                    initial={{ opacity: 0, y: 20 }}
                    animate={{ opacity: 1, y: 0 }}
                  >
                    <div>
                      <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                        Title
                      </label>
                      <input
                        type="text"
                        value={sendForm.title}
                        onChange={(e) => setSendForm({ ...sendForm, title: e.target.value })}
                        placeholder="e.g., New Feature Update!"
                        className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                        maxLength={100}
                      />
                    </div>

                    {/* Poll Toggle */}
                    <div className="flex items-center justify-between p-4 bg-navy-700/30 border border-white/10 rounded-xl">
                      <div>
                        <p className="text-white font-semibold">Poll</p>
                        <p className="text-gray-400 text-xs">Create a poll with 4 options</p>
                      </div>
                      <motion.button
                        onClick={() => setSendForm({ ...sendForm, isPoll: !sendForm.isPoll })}
                        className={`relative w-14 h-7 rounded-full transition-colors ${
                          sendForm.isPoll ? 'bg-cyan-500' : 'bg-gray-600'
                        }`}
                        whileTap={{ scale: 0.95 }}
                      >
                        <motion.div
                          className="absolute top-1 w-5 h-5 bg-white rounded-full"
                          animate={{ left: sendForm.isPoll ? '30px' : '4px' }}
                          transition={{ type: 'spring', stiffness: 500, damping: 30 }}
                        />
                      </motion.button>
                    </div>

                    {/* Poll Form */}
                    {sendForm.isPoll ? (
                      <>
                        <div>
                          <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                            Poll Question
                          </label>
                          <input
                            type="text"
                            value={sendForm.pollQuestion}
                            onChange={(e) => setSendForm({ ...sendForm, pollQuestion: e.target.value })}
                            placeholder="e.g., Next which subject u want?"
                            className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white"
                          />
                        </div>

                        <div className="grid grid-cols-2 gap-3">
                          <div>
                            <label className="text-cyan-400 text-xs font-semibold mb-1 block">Option A</label>
                            <input
                              type="text"
                              value={sendForm.pollOptionA}
                              onChange={(e) => setSendForm({ ...sendForm, pollOptionA: e.target.value })}
                              placeholder="e.g., SQL"
                              className="w-full px-3 py-2 bg-navy-700 border border-white/10 rounded-lg text-white text-sm"
                            />
                          </div>
                          <div>
                            <label className="text-cyan-400 text-xs font-semibold mb-1 block">Option B</label>
                            <input
                              type="text"
                              value={sendForm.pollOptionB}
                              onChange={(e) => setSendForm({ ...sendForm, pollOptionB: e.target.value })}
                              placeholder="e.g., Git"
                              className="w-full px-3 py-2 bg-navy-700 border border-white/10 rounded-lg text-white text-sm"
                            />
                          </div>
                          <div>
                            <label className="text-cyan-400 text-xs font-semibold mb-1 block">Option C</label>
                            <input
                              type="text"
                              value={sendForm.pollOptionC}
                              onChange={(e) => setSendForm({ ...sendForm, pollOptionC: e.target.value })}
                              placeholder="e.g., Pandas"
                              className="w-full px-3 py-2 bg-navy-700 border border-white/10 rounded-lg text-white text-sm"
                            />
                          </div>
                          <div>
                            <label className="text-cyan-400 text-xs font-semibold mb-1 block">Option D</label>
                            <input
                              type="text"
                              value={sendForm.pollOptionD}
                              onChange={(e) => setSendForm({ ...sendForm, pollOptionD: e.target.value })}
                              placeholder="e.g., PySpark"
                              className="w-full px-3 py-2 bg-navy-700 border border-white/10 rounded-lg text-white text-sm"
                            />
                          </div>
                        </div>
                      </>
                    ) : (
                      <div>
                        <label className="text-cyan-400 text-sm font-semibold mb-2 block">
                          Message
                        </label>
                        <textarea
                          value={sendForm.message}
                          onChange={(e) => setSendForm({ ...sendForm, message: e.target.value })}
                          placeholder="Write your message to all users..."
                          className="w-full px-4 py-3 bg-navy-700 border border-white/10 rounded-xl text-white resize-none"
                          rows={4}
                          maxLength={500}
                        />
                        <p className="text-gray-500 text-xs mt-1">
                          {sendForm.message.length}/500 characters
                        </p>
                      </div>
                    )}

                    <motion.button
                      onClick={handleSendNotification}
                      disabled={loading}
                      className="w-full py-3 rounded-xl bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 font-semibold hover:bg-cyan-500/30 transition-colors flex items-center justify-center gap-2 disabled:opacity-50"
                      whileTap={loading ? {} : buttonTap}
                    >
                      {loading ? (
                        <>
                          <div className="w-5 h-5 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
                          Sending...
                        </>
                      ) : (
                        <>
                          <Send size={18} />
                          {sendForm.isPoll ? 'Send Poll to All Users' : 'Send to All Users'}
                        </>
                      )}
                    </motion.button>
                  </motion.div>
                )}

                {/* Notifications List (Admin History or User View) */}
                {((isAdmin && activeTab === 'history') || (!isAdmin && activeTab === 'view')) && (
                  <div className="space-y-3">
                    {notifications.length === 0 ? (
                      <div className="text-center py-12">
                        <Bell size={48} className="text-gray-500 mx-auto mb-3" />
                        <p className="text-gray-400">
                          {isAdmin ? 'No notifications sent yet' : 'No new notifications'}
                        </p>
                      </div>
                    ) : (
                      notifications.map((notif, index) => (
                        <motion.div
                          key={notif.id}
                          className="bg-navy-700/30 border border-white/10 rounded-xl p-4 hover:bg-navy-700/50 transition-colors"
                          initial={{ opacity: 0, y: 20 }}
                          animate={{ opacity: 1, y: 0 }}
                          transition={{ delay: index * 0.05 }}
                        >
                          <div className="flex items-start justify-between mb-2">
                            <h3 className="text-white font-bold text-lg flex items-center gap-2">
                              {notif.title}
                              {notif.is_poll && <BarChart3 size={18} className="text-purple-400" />}
                            </h3>
                            {isAdmin && (
                              <motion.button
                                onClick={() => setDeleteConfirm(notif.id)}
                                className="text-red-400 hover:text-red-300 transition-colors"
                                whileHover={{ scale: 1.1 }}
                                whileTap={{ scale: 0.9 }}
                              >
                                <Trash2 size={18} />
                              </motion.button>
                            )}
                          </div>

                          {/* Poll */}
                          {notif.is_poll ? (
                            <div>
                              <p className="text-gray-300 text-sm mb-3">{notif.poll_question}</p>

                              {/* User View - Vote Buttons */}
                              {!isAdmin && (
                                <div className="space-y-2">
                                  {[
                                    { key: 'a', text: notif.poll_option_a },
                                    { key: 'b', text: notif.poll_option_b },
                                    { key: 'c', text: notif.poll_option_c },
                                    { key: 'd', text: notif.poll_option_d }
                                  ].map(option => (
                                    <motion.button
                                      key={option.key}
                                      onClick={() => handleVote(notif.id, option.key)}
                                      disabled={votedPolls.has(notif.id)}
                                      className={`w-full p-3 rounded-lg border text-left transition-all ${
                                        votedPolls.has(notif.id) && userVotes[notif.id] === option.key
                                          ? 'bg-cyan-500/20 border-cyan-500/50 text-cyan-400'
                                          : votedPolls.has(notif.id)
                                          ? 'bg-navy-700/30 border-white/5 text-gray-500'
                                          : 'bg-navy-700/50 border-white/10 text-white hover:border-cyan-500/50'
                                      }`}
                                      whileHover={votedPolls.has(notif.id) ? {} : { scale: 1.02 }}
                                      whileTap={votedPolls.has(notif.id) ? {} : { scale: 0.98 }}
                                    >
                                      <span className="font-bold mr-2">{option.key.toUpperCase()})</span>
                                      {option.text}
                                      {votedPolls.has(notif.id) && userVotes[notif.id] === option.key && (
                                        <CheckCircle size={16} className="inline ml-2" />
                                      )}
                                    </motion.button>
                                  ))}
                                  {votedPolls.has(notif.id) && (
                                    <p className="text-center text-cyan-400 text-sm mt-2">✓ You voted</p>
                                  )}
                                </div>
                              )}

                              {/* Admin View - Poll Results */}
                              {isAdmin && pollResults[notif.id] && (
                                <div className="space-y-2">
                                  {[
                                    { key: 'a', text: notif.poll_option_a },
                                    { key: 'b', text: notif.poll_option_b },
                                    { key: 'c', text: notif.poll_option_c },
                                    { key: 'd', text: notif.poll_option_d }
                                  ].map(option => {
                                    const count = pollResults[notif.id][option.key]
                                    const total = pollResults[notif.id].total || 1
                                    const percent = Math.round((count / total) * 100)
                                    return (
                                      <div key={option.key} className="bg-navy-700/30 border border-white/5 rounded-lg p-2">
                                        <div className="flex justify-between text-sm mb-1">
                                          <span className="text-white">
                                            <span className="font-bold">{option.key.toUpperCase()})</span> {option.text}
                                          </span>
                                          <span className="text-cyan-400 font-bold">{count} votes ({percent}%)</span>
                                        </div>
                                        <div className="h-2 bg-navy-700 rounded-full overflow-hidden">
                                          <motion.div
                                            className="h-full bg-cyan-500"
                                            initial={{ width: 0 }}
                                            animate={{ width: `${percent}%` }}
                                            transition={{ duration: 0.5, delay: 0.2 }}
                                          />
                                        </div>
                                      </div>
                                    )
                                  })}
                                  <p className="text-gray-500 text-xs text-center mt-2">
                                    Total responses: {pollResults[notif.id].total}
                                  </p>
                                </div>
                              )}
                            </div>
                          ) : (
                            // Regular Message
                            <p className="text-gray-300 text-sm leading-relaxed mb-3">
                              {notif.message}
                            </p>
                          )}

                          <p className="text-gray-500 text-xs mt-3">
                            {new Date(notif.created_at).toLocaleString()}
                          </p>
                        </motion.div>
                      ))
                    )}
                  </div>
                )}
              </div>
            </motion.div>

            {/* Delete Confirmation Modal */}
            <AnimatePresence>
              {deleteConfirm && (
                <motion.div
                  className="fixed inset-0 z-[60] flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  onClick={() => setDeleteConfirm(null)}
                >
                  <motion.div
                    className="bg-gradient-to-b from-navy-700 to-navy-800 rounded-2xl border border-red-500/30 p-6 max-w-sm w-full shadow-2xl"
                    initial={{ scale: 0.9, opacity: 0 }}
                    animate={{ scale: 1, opacity: 1 }}
                    exit={{ scale: 0.9, opacity: 0 }}
                    onClick={(e) => e.stopPropagation()}
                  >
                    <div className="flex items-center gap-3 mb-4">
                      <div className="w-10 h-10 rounded-full bg-red-500/20 flex items-center justify-center">
                        <Trash2 size={20} className="text-red-400" />
                      </div>
                      <h3 className="text-lg font-bold text-white">Delete Notification</h3>
                    </div>

                    <p className="text-gray-300 text-sm mb-6">
                      Delete this notification? Users will no longer see it.
                    </p>

                    <div className="flex gap-3">
                      <button
                        onClick={() => setDeleteConfirm(null)}
                        className="flex-1 px-4 py-2.5 bg-white/5 border border-white/10 rounded-xl text-white font-medium hover:bg-white/10 transition-colors"
                      >
                        Cancel
                      </button>
                      <button
                        onClick={handleDeleteNotification}
                        disabled={deleting}
                        className="flex-1 px-4 py-2.5 bg-gradient-to-r from-red-500 to-red-600 rounded-xl text-white font-medium hover:from-red-400 hover:to-red-500 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                      >
                        {deleting ? 'Deleting...' : 'Delete'}
                      </button>
                    </div>
                  </motion.div>
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        )}
      </AnimatePresence>

      {/* Flashcard Alert */}
      <FlashcardAlert
        isOpen={alert.show}
        onClose={() => setAlert({ ...alert, show: false })}
        type={alert.type}
        title={alert.title}
        message={alert.message}
      />
    </>
  )
}
