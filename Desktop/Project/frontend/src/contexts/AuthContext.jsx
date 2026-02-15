import { createContext, useContext, useEffect, useState } from 'react'
import { supabase } from '../lib/supabase'

const AuthContext = createContext({})

export const useAuth = () => useContext(AuthContext)

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null)
  const [profile, setProfile] = useState(null)
  const [loading, setLoading] = useState(true)

  useEffect(() => {
    supabase.auth.getSession().then(({ data: { session } }) => {
      setUser(session?.user ?? null)
      if (session?.user) fetchProfile(session.user.id)
      else setLoading(false)
    })

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
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
        username: user?.user_metadata?.full_name || user?.email?.split('@')[0] || 'User',
        avatar_url: user?.user_metadata?.avatar_url || null,
        email: user?.email || null,
        status: 'active',
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
          prompt: 'select_account', // Force Google account picker to show
        },
      },
    })
    if (error) console.error('Error signing in:', error.message)
  }

  async function signOut() {
    await supabase.auth.signOut()
    setUser(null)
    setProfile(null)
  }

  async function signInWithPhone(phone) {
    const { data, error } = await supabase.auth.signInWithOtp({
      phone: phone,
    })
    if (error) {
      console.error('Error sending OTP:', error.message)
      return { error }
    }
    return { data }
  }

  async function verifyOtp(phone, token) {
    const { data, error } = await supabase.auth.verifyOtp({
      phone: phone,
      token: token,
      type: 'sms',
    })
    if (error) {
      console.error('Error verifying OTP:', error.message)
      return { error }
    }
    return { data }
  }

  const value = {
    user,
    profile,
    loading,
    isAdmin: profile?.role === 'admin',
    isBlocked: profile?.status === 'blocked',
    signInWithGoogle,
    signInWithPhone,
    verifyOtp,
    signOut,
    refreshProfile: () => user && fetchProfile(user.id),
  }

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>
}
