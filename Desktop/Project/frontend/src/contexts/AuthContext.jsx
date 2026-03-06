import { createContext, useContext, useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'
import { subscribeToPush } from '../hooks/usePushNotifications'

const AuthContext = createContext({})

const BACKEND_URL = import.meta.env.VITE_BACKEND_URL || 'http://localhost:8000'

export const useAuth = () => useContext(AuthContext)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)

  const SESSION_TTL = 24 * 60 * 60 * 1000 // 24 hours in ms
  const LOGIN_TIME_KEY = 'pydeck_login_time'

  function isSessionExpired() {
    const t = localStorage.getItem(LOGIN_TIME_KEY)
    if (!t) return false
    return Date.now() - Number(t) > SESSION_TTL
  }

  useEffect(() => {
    supabase.auth.getSession().then(async ({ data: { session } }) => {
      if (session?.user && isSessionExpired()) {
        localStorage.removeItem(LOGIN_TIME_KEY)
        await supabase.auth.signOut()
        setLoading(false)
        return
      }
      setUser(session?.user ?? null)
      if (session?.user) fetchProfile(session.user.id)
      else setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      if (_event === 'SIGNED_IN') {
        localStorage.setItem(LOGIN_TIME_KEY, String(Date.now()))
        if (session?.user) subscribeToPush(session.user.id)
      }
      if (_event === 'SIGNED_OUT') {
        localStorage.removeItem(LOGIN_TIME_KEY)
      }
      setUser(session?.user ?? null)
      if (session?.user) fetchProfile(session.user.id)
      else {
        setProfile(null)
        setLoading(false)
      }
    })

    return () => subscription.unsubscribe()
  }, [])

  // Listen for profile changes (e.g., when user gets blocked)
  useEffect(() => {
    if (!user) return

    const channel = supabase
      .channel('profile_changes')
      .on(
        'postgres_changes',
        {
          event: 'UPDATE',
          schema: 'public',
          table: 'profiles',
          filter: `id=eq.${user.id}`,
        },
        (payload) => {
          setProfile(payload.new)
          // If user just got blocked, sign them out
          if (payload.new.status === 'blocked') {
            signOut()
          }
        }
      )
      .subscribe()

    return () => {
      supabase.removeChannel(channel)
    }
  }, [user])

  async function fetchProfile(userId) {
    const { data } = await supabase
      .from('profiles')
      .select('*')
      .eq('id', userId)
      .single()

    const user = (await supabase.auth.getUser()).data.user

    if (data) {
      // Update email and status if not set
      const updates = {}
      if (!data.email && user?.email) {
        updates.email = user.email
        data.email = user.email
      }
      if (!data.status) {
        updates.status = 'active'
        data.status = 'active'
      }

      if (Object.keys(updates).length > 0) {
        await supabase
          .from('profiles')
          .update(updates)
          .eq('id', userId)
      }

      setProfile(data)
    } else {
      const newProfile = {
        id: userId,
        username: user?.is_anonymous ? 'Guest' : (user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'User'),
        avatar_url: user?.user_metadata?.avatar_url || null,
        email: user?.email || null,
        status: 'active',
        role: user?.is_anonymous ? 'guest' : 'user',
        streak: 0,
        points: 0,
      }
      await supabase.from('profiles').insert(newProfile)
      setProfile(newProfile)
    }
    setLoading(false)
  }

  async function signInWithGoogle() {
    const { error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: {
        redirectTo: window.location.origin + '/paths',
        queryParams: {
          prompt: 'select_account',
        },
      },
    })
    if (error) {
      console.error('Error signing in:', error.message)
      return { error }
    }
    return {}
  }

  async function signOut() {
    await supabase.auth.signOut()
    setUser(null)
    setProfile(null)
  }

async function signUpWithEmail(email, password, name) {
    const { data, error } = await supabase.auth.signUp({
      email,
      password,
      options: { data: { full_name: name } },
    })
    return { data, error }
  }

  async function signInWithEmail(email, password) {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    return { data, error }
  }

  async function verifyEmailOtp(email, token) {
    const { data, error } = await supabase.auth.verifyOtp({ email, token, type: 'signup' })
    return { data, error }
  }

  async function signInWithPhone(phone) {
    const { data, error } = await supabase.auth.signInWithOtp({ phone })
    if (error) return { error }
    return { data }
  }

  async function verifyOtp(phone, token) {
    const { data, error } = await supabase.auth.verifyOtp({ phone, token, type: 'sms' })
    if (error) return { error }
    return { data }
  }

  async function signInWithEmailOtp(email) {
    try {
      const res = await fetch(`${BACKEND_URL}/api/otp/send`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      })
      const data = await res.json()
      if (!res.ok) return { error: { message: data.detail || 'Failed to send OTP' } }
      return { data }
    } catch {
      return { error: { message: 'Network error. Please try again.' } }
    }
  }

  async function checkEmailExists(email) {
    try {
      const res = await fetch(`${BACKEND_URL}/api/otp/check-email`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email }),
      })
      const data = await res.json()
      return data.exists ?? false
    } catch {
      return false
    }
  }

  async function createAccountWithOtp(email, code, password, name) {
    try {
      const res = await fetch(`${BACKEND_URL}/api/otp/create-account`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, code, password, name }),
      })
      const data = await res.json()
      if (!res.ok) return { error: { message: data.detail || 'Failed to create account' } }
      const { data: authData, error } = await supabase.auth.verifyOtp({
        token_hash: data.hashed_token,
        type: 'magiclink',
      })
      if (error) return { error }
      // Set password so user can sign in with email+password later
      await supabase.auth.updateUser({ password })
      return { data: authData }
    } catch {
      return { error: { message: 'Network error. Please try again.' } }
    }
  }

  async function verifyOtpOnly(email, code) {
    try {
      const res = await fetch(`${BACKEND_URL}/api/otp/verify-only`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, code }),
      })
      const data = await res.json()
      if (!res.ok) return { error: { message: data.detail || 'Invalid code' } }
      return { data }
    } catch {
      return { error: { message: 'Network error. Please try again.' } }
    }
  }

  async function verifyEmailSignInOtp(email, code) {
    try {
      const res = await fetch(`${BACKEND_URL}/api/otp/verify`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ email, code }),
      })
      const data = await res.json()
      if (!res.ok) return { error: { message: data.detail || 'Invalid code' } }
      const { data: authData, error } = await supabase.auth.verifyOtp({
        token_hash: data.hashed_token,
        type: 'magiclink',
      })
      if (error) return { error }
      return { data: authData }
    } catch {
      return { error: { message: 'Network error. Please try again.' } }
    }
  }

  const value = {
    user,
    profile,
    loading,
    isAdmin: profile?.role === 'admin',
    isBlocked: profile?.status === 'blocked',
    signInWithGoogle,
    signUpWithEmail,
    signInWithEmail,
    verifyEmailOtp,
    signInWithPhone,
    verifyOtp,
    signInWithEmailOtp,
    verifyEmailSignInOtp,
    verifyOtpOnly,
    createAccountWithOtp,
    checkEmailExists,
    signOut,
    refreshProfile: () => user && fetchProfile(user.id),
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
