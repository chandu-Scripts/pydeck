import { useEffect, useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { Flame, Star, Calendar, Users, Trophy, HelpCircle, LogOut, Pencil, Camera, Check, X, Shield } from 'lucide-react'

export default function Profile() {
  const { user, profile, signOut, refreshProfile, isAdmin } = useAuth()
  const navigate = useNavigate()
  const [stats, setStats] = useState({ streak: 0, points: 0, joinDate: '' })
  const [editingName, setEditingName] = useState(false)
  const [newName, setNewName] = useState('')
  const [saving, setSaving] = useState(false)
  const [uploading, setUploading] = useState(false)
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
        <MenuItem icon={Users} label="Invite Friends" />
        <MenuItem icon={HelpCircle} label="Contact Support" />
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
