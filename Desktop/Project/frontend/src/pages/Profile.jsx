import { useEffect, useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { Flame, Star, Calendar, Users, Trophy, HelpCircle, LogOut, Pencil, Camera, Check, X, Shield, Share2 } from 'lucide-react'
import { motion, AnimatePresence } from 'framer-motion'

export default function Profile() {
  const { user, profile, signOut, refreshProfile, isAdmin } = useAuth()
  const navigate = useNavigate()
  const [stats, setStats] = useState({ streak: 0, points: 0, joinDate: '' })
  const [editingName, setEditingName] = useState(false)
  const [newName, setNewName] = useState('')
  const [saving, setSaving] = useState(false)
  const [uploading, setUploading] = useState(false)
  const [showShareModal, setShowShareModal] = useState(false)
  const fileInputRef = useRef(null)

  useEffect(() => {
    if (!user) return
    async function fetchStats() {
      // Calculate streak
      const { data: sessions } = await supabase
        .from('study_sessions')
        .select('date')
        .eq('user_id', user.id)
        .order('date', { ascending: false })

      let streak = 0
      const today = new Date().toISOString().split('T')[0]
      const sessionDates = new Set((sessions || []).map(s => s.date))

      // Streak is 0 if user didn't study today — no grace period
      if (sessionDates.has(today)) {
        streak = 1
        let checkDate = new Date()
        checkDate.setDate(checkDate.getDate() - 1)
        while (sessionDates.has(checkDate.toISOString().split('T')[0])) {
          streak++
          checkDate.setDate(checkDate.getDate() - 1)
        }
      }

      // Count points (mastered cards * 10)
      const { count } = await supabase
        .from('user_progress')
        .select('*', { count: 'exact', head: true })
        .eq('user_id', user.id)
        .eq('status', 'mastered')

      const joinDate = new Date(user.created_at).toLocaleDateString('en-US', {
        month: 'short',
        day: 'numeric',
      })

      setStats({ streak, points: (count || 0) * 10, joinDate })
    }
    fetchStats()
  }, [user])

  async function handleSaveName() {
    const trimmed = newName.trim()
    if (!trimmed || trimmed === profile?.username) {
      setEditingName(false)
      return
    }
    setSaving(true)
    await supabase.from('profiles').update({ username: trimmed }).eq('id', user.id)
    await refreshProfile()
    setSaving(false)
    setEditingName(false)
  }

  async function handleAvatarUpload(e) {
    const file = e.target.files?.[0]
    if (!file) return

    setUploading(true)
    const ext = file.name.split('.').pop()
    const filePath = `${user.id}.${ext}`

    // Upload to Supabase Storage
    const { error: uploadError } = await supabase.storage
      .from('avatars')
      .upload(filePath, file, { upsert: true })

    if (uploadError) {
      console.error('Upload error:', uploadError.message)
      setUploading(false)
      return
    }

    // Get public URL
    const { data: urlData } = supabase.storage.from('avatars').getPublicUrl(filePath)
    const publicUrl = urlData.publicUrl + '?t=' + Date.now()

    // Update profile
    await supabase.from('profiles').update({ avatar_url: publicUrl }).eq('id', user.id)
    await refreshProfile()
    setUploading(false)
  }

  const avatarUrl = profile?.avatar_url || user?.user_metadata?.avatar_url

  return (
    <div className="px-5 py-8 lg:py-12">
      {/* Profile header */}
      <div className="flex flex-col items-center mb-8">
        {/* Avatar with upload */}
        <div className="relative mb-3">
          <div className="w-20 h-20 rounded-full bg-gradient-to-br from-cyan-400 to-blue-500 flex items-center justify-center ring-4 ring-cyan-500/20 overflow-hidden">
            {uploading ? (
              <div className="w-6 h-6 border-2 border-white border-t-transparent rounded-full animate-spin" />
            ) : avatarUrl ? (
              <img src={avatarUrl} alt="Avatar" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
            ) : (
              <span className="text-2xl font-bold text-white">
                {(profile?.username || 'U')[0].toUpperCase()}
              </span>
            )}
          </div>
          <button
            onClick={() => fileInputRef.current?.click()}
            className="absolute -bottom-1 -right-1 w-7 h-7 bg-cyan-500 rounded-full flex items-center justify-center border-2 border-navy-900 hover:bg-cyan-400 transition-colors cursor-pointer"
          >
            <Camera size={13} className="text-navy-900" />
          </button>
          <input
            ref={fileInputRef}
            type="file"
            accept="image/*"
            onChange={handleAvatarUpload}
            className="hidden"
          />
        </div>

        {/* Editable username */}
        {editingName ? (
          <div className="flex items-center gap-2">
            <input
              type="text"
              value={newName}
              onChange={(e) => setNewName(e.target.value)}
              onKeyDown={(e) => {
                if (e.key === 'Enter') handleSaveName()
                if (e.key === 'Escape') setEditingName(false)
              }}
              autoFocus
              className="bg-navy-700/60 border border-white/10 rounded-lg px-3 py-1.5 text-white text-center text-lg font-bold outline-none focus:border-cyan-500/50 w-48"
            />
            <button onClick={handleSaveName} disabled={saving} className="w-7 h-7 rounded-full bg-emerald-500/20 flex items-center justify-center hover:bg-emerald-500/30 transition-colors cursor-pointer">
              <Check size={14} className="text-emerald-400" />
            </button>
            <button onClick={() => setEditingName(false)} className="w-7 h-7 rounded-full bg-red-500/20 flex items-center justify-center hover:bg-red-500/30 transition-colors cursor-pointer">
              <X size={14} className="text-red-400" />
            </button>
          </div>
        ) : (
          <button
            onClick={() => { setNewName(profile?.username || ''); setEditingName(true) }}
            className="flex items-center gap-2 group cursor-pointer"
          >
            <h1 className="text-xl font-bold text-white">{profile?.username || 'User'}</h1>
            <Pencil size={14} className="text-gray-500 group-hover:text-cyan-400 transition-colors" />
          </button>
        )}

        {/* Stats row */}
        <div className="flex items-center gap-6 mt-4">
          <div className="flex flex-col items-center">
            <div className="flex items-center gap-1">
              <Flame size={16} className="text-orange-400" />
              <span className="text-lg font-bold text-white">{stats.streak}</span>
            </div>
            <span className="text-[11px] text-gray-500">Streak</span>
          </div>
          <div className="w-px h-8 bg-white/10" />
          <div className="flex flex-col items-center">
            <div className="flex items-center gap-1">
              <Star size={16} className="text-amber-400" />
              <span className="text-lg font-bold text-white">{stats.points}</span>
            </div>
            <span className="text-[11px] text-gray-500">Points</span>
          </div>
          <div className="w-px h-8 bg-white/10" />
          <div className="flex flex-col items-center">
            <div className="flex items-center gap-1">
              <Calendar size={16} className="text-cyan-400" />
              <span className="text-lg font-bold text-white">{stats.joinDate}</span>
            </div>
            <span className="text-[11px] text-gray-500">Joined</span>
          </div>
        </div>
      </div>

      {/* Pro banner */}
      <div className="bg-gradient-to-r from-amber-500/20 to-orange-500/20 border border-amber-500/20 rounded-2xl p-4 mb-6 flex items-center justify-between">
        <div className="flex items-center gap-3">
          <span className="text-lg">✨</span>
          <div>
            <p className="text-sm font-semibold text-white">PyDeck Pro</p>
            <p className="text-[11px] text-gray-400">Unlock all decks & unlimited practice</p>
          </div>
        </div>
        <button className="px-4 py-1.5 bg-amber-500 text-navy-900 text-sm font-semibold rounded-lg hover:bg-amber-400 transition-colors cursor-pointer">
          Soon
        </button>
      </div>

      {/* Menu items */}
      <div className="flex flex-col gap-1">
        {isAdmin && (
          <MenuItem
            icon={Shield}
            label="Admin Panel"
            onClick={() => navigate('/admin')}
            isAdmin={true}
          />
        )}
        <MenuItem icon={Users} label="Invite Friends" onClick={() => setShowShareModal(true)} />
        <MenuItem icon={HelpCircle} label="Contact Support" onClick={() => window.location.href = 'mailto:support@pydeck.com?subject=PyDeck Support Request'} />
        <button
          onClick={signOut}
          className="w-full flex items-center gap-3 px-4 py-3.5 rounded-xl text-red-400 hover:bg-red-500/5 transition-colors cursor-pointer"
        >
          <LogOut size={20} />
          <span className="text-sm font-medium">Log Out</span>
        </button>
      </div>

      <p className="text-center text-gray-600 text-xs mt-8">
        PyDeck v1.0 — Master Python
      </p>

      {/* Share Modal */}
      <AnimatePresence>
        {showShareModal && (
          <motion.div
            className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/70 backdrop-blur-sm"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={() => setShowShareModal(false)}
          >
            <motion.div
              className="w-full max-w-md bg-gradient-to-b from-navy-800 to-navy-900 rounded-2xl border border-cyan-500/30 p-6 shadow-2xl"
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              onClick={(e) => e.stopPropagation()}
            >
              {/* Header */}
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <Share2 size={20} className="text-cyan-400" />
                  <h2 className="text-lg font-bold text-white">Invite Friends</h2>
                </div>
                <button
                  onClick={() => setShowShareModal(false)}
                  className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
                >
                  <X size={18} className="text-gray-400" />
                </button>
              </div>

              <p className="text-sm text-gray-400 mb-6">
                Share PyDeck with your friends and help them master Python!
              </p>

              {/* Share buttons */}
              <div className="flex flex-col gap-3">
                {/* WhatsApp */}
                <a
                  href="https://wa.me/?text=Check%20out%20PyDeck%20-%20Master%20Python%20with%20Flashcards!%20https://pydeck.vercel.app"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-3 px-4 py-3 bg-[#25D366]/20 border border-[#25D366]/30 rounded-xl hover:bg-[#25D366]/30 transition-colors"
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" className="text-[#25D366]">
                    <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413Z"/>
                  </svg>
                  <span className="text-white font-medium">Share on WhatsApp</span>
                </a>

                {/* Instagram */}
                <button
                  onClick={() => {
                    // Copy link and show instruction for Instagram
                    navigator.clipboard.writeText('https://pydeck.vercel.app')
                    alert('Link copied! Open Instagram and paste the link in your story or post.')
                  }}
                  className="flex items-center gap-3 px-4 py-3 bg-gradient-to-r from-[#833AB4]/20 via-[#FD1D1D]/20 to-[#F77737]/20 border border-[#E1306C]/30 rounded-xl hover:from-[#833AB4]/30 hover:via-[#FD1D1D]/30 hover:to-[#F77737]/30 transition-colors"
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" className="text-[#E1306C]">
                    <path d="M12 2.163c3.204 0 3.584.012 4.85.07 3.252.148 4.771 1.691 4.919 4.919.058 1.265.069 1.645.069 4.849 0 3.205-.012 3.584-.069 4.849-.149 3.225-1.664 4.771-4.919 4.919-1.266.058-1.644.07-4.85.07-3.204 0-3.584-.012-4.849-.07-3.26-.149-4.771-1.699-4.919-4.92-.058-1.265-.07-1.644-.07-4.849 0-3.204.013-3.583.07-4.849.149-3.227 1.664-4.771 4.919-4.919 1.266-.057 1.645-.069 4.849-.069zm0-2.163c-3.259 0-3.667.014-4.947.072-4.358.2-6.78 2.618-6.98 6.98-.059 1.281-.073 1.689-.073 4.948 0 3.259.014 3.668.072 4.948.2 4.358 2.618 6.78 6.98 6.98 1.281.058 1.689.072 4.948.072 3.259 0 3.668-.014 4.948-.072 4.354-.2 6.782-2.618 6.979-6.98.059-1.28.073-1.689.073-4.948 0-3.259-.014-3.667-.072-4.947-.196-4.354-2.617-6.78-6.979-6.98-1.281-.059-1.69-.073-4.949-.073zm0 5.838c-3.403 0-6.162 2.759-6.162 6.162s2.759 6.163 6.162 6.163 6.162-2.759 6.162-6.163c0-3.403-2.759-6.162-6.162-6.162zm0 10.162c-2.209 0-4-1.79-4-4 0-2.209 1.791-4 4-4s4 1.791 4 4c0 2.21-1.791 4-4 4zm6.406-11.845c-.796 0-1.441.645-1.441 1.44s.645 1.44 1.441 1.44c.795 0 1.439-.645 1.439-1.44s-.644-1.44-1.439-1.44z"/>
                  </svg>
                  <span className="text-white font-medium">Share on Instagram</span>
                </button>

                {/* Facebook */}
                <a
                  href="https://www.facebook.com/sharer/sharer.php?u=https://pydeck.vercel.app"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-3 px-4 py-3 bg-[#1877F2]/20 border border-[#1877F2]/30 rounded-xl hover:bg-[#1877F2]/30 transition-colors"
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" className="text-[#1877F2]">
                    <path d="M24 12.073c0-6.627-5.373-12-12-12s-12 5.373-12 12c0 5.99 4.388 10.954 10.125 11.854v-8.385H7.078v-3.47h3.047V9.43c0-3.007 1.792-4.669 4.533-4.669 1.312 0 2.686.235 2.686.235v2.953H15.83c-1.491 0-1.956.925-1.956 1.874v2.25h3.328l-.532 3.47h-2.796v8.385C19.612 23.027 24 18.062 24 12.073z"/>
                  </svg>
                  <span className="text-white font-medium">Share on Facebook</span>
                </a>

                {/* Twitter/X */}
                <a
                  href="https://twitter.com/intent/tweet?text=Check%20out%20PyDeck%20-%20Master%20Python%20with%20Flashcards!&url=https://pydeck.vercel.app"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center gap-3 px-4 py-3 bg-[#1DA1F2]/20 border border-[#1DA1F2]/30 rounded-xl hover:bg-[#1DA1F2]/30 transition-colors"
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="currentColor" className="text-[#1DA1F2]">
                    <path d="M23.953 4.57a10 10 0 01-2.825.775 4.958 4.958 0 002.163-2.723c-.951.555-2.005.959-3.127 1.184a4.92 4.92 0 00-8.384 4.482C7.69 8.095 4.067 6.13 1.64 3.162a4.822 4.822 0 00-.666 2.475c0 1.71.87 3.213 2.188 4.096a4.904 4.904 0 01-2.228-.616v.06a4.923 4.923 0 003.946 4.827 4.996 4.996 0 01-2.212.085 4.936 4.936 0 004.604 3.417 9.867 9.867 0 01-6.102 2.105c-.39 0-.779-.023-1.17-.067a13.995 13.995 0 007.557 2.209c9.053 0 13.998-7.496 13.998-13.985 0-.21 0-.42-.015-.63A9.935 9.935 0 0024 4.59z"/>
                  </svg>
                  <span className="text-white font-medium">Share on Twitter</span>
                </a>

                {/* Copy Link */}
                <button
                  onClick={() => {
                    navigator.clipboard.writeText('https://pydeck.vercel.app')
                    alert('Link copied to clipboard!')
                  }}
                  className="flex items-center gap-3 px-4 py-3 bg-cyan-500/20 border border-cyan-500/30 rounded-xl hover:bg-cyan-500/30 transition-colors"
                >
                  <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="text-cyan-400">
                    <rect x="9" y="9" width="13" height="13" rx="2" ry="2"></rect>
                    <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1"></path>
                  </svg>
                  <span className="text-white font-medium">Copy Link</span>
                </button>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}

function MenuItem({ icon: Icon, label, onClick, isAdmin }) {
  return (
    <button
      onClick={onClick}
      className={`w-full flex items-center gap-3 px-4 py-3.5 rounded-xl transition-colors cursor-pointer ${
        isAdmin
          ? 'bg-gradient-to-r from-amber-500/10 to-orange-500/10 border border-amber-500/20 text-amber-400 hover:from-amber-500/20 hover:to-orange-500/20'
          : 'text-gray-300 hover:bg-white/5'
      }`}
    >
      <Icon size={20} className={isAdmin ? 'text-amber-400' : 'text-gray-500'} />
      <span className="text-sm font-medium">{label}</span>
      {isAdmin && <span className="ml-auto text-xs bg-amber-500/20 px-2 py-0.5 rounded-full">ADMIN</span>}
    </button>
  )
}
