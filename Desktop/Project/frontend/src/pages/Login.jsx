import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'

export default function Login() {
  const { user, signInWithGoogle, signInWithPhone, verifyOtp, loading } = useAuth()
  const navigate = useNavigate()
  const [phone, setPhone] = useState('')
  const [otp, setOtp] = useState('')
  const [otpSent, setOtpSent] = useState(false)
  const [sending, setSending] = useState(false)
  const [verifying, setVerifying] = useState(false)
  const [error, setError] = useState('')

  useEffect(() => {
    if (user) navigate('/paths')
  }, [user, navigate])

  async function handleSendOtp(e) {
    e.preventDefault()
    if (!phone.trim()) {
      setError('Please enter phone number')
      return
    }

    // Format phone with country code if not present
    const formattedPhone = phone.startsWith('+') ? phone : `+91${phone}`

    setSending(true)
    setError('')
    const { error } = await signInWithPhone(formattedPhone)
    setSending(false)

    if (error) {
      setError(error.message)
    } else {
      setOtpSent(true)
    }
  }

  async function handleVerifyOtp(e) {
    e.preventDefault()
    if (!otp.trim()) {
      setError('Please enter OTP')
      return
    }

    const formattedPhone = phone.startsWith('+') ? phone : `+91${phone}`

    setVerifying(true)
    setError('')
    const { error } = await verifyOtp(formattedPhone, otp)
    setVerifying(false)

    if (error) {
      setError(error.message)
    }
    // If successful, useEffect will navigate to /paths
  }

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-navy-900">
        <div className="w-8 h-8 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" />
      </div>
    )
  }

  return (
    <div className="min-h-screen relative flex items-center justify-center px-4">
      {/* Background gradient */}
      <div className="absolute inset-0 bg-gradient-to-br from-navy-900 via-navy-800 to-[#0d1a2e]" />
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-96 h-96 bg-cyan-500/5 rounded-full blur-3xl" />

      {/* Login card */}
      <div className="relative z-10 w-full max-w-sm">
        <div className="flex flex-col items-center mb-8">
          {/* Logo */}
          <div className="w-16 h-16 rounded-2xl bg-gradient-to-br from-cyan-400 to-cyan-600 flex items-center justify-center mb-4 shadow-lg shadow-cyan-500/20">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="white" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
              <path d="M12 2L2 7l10 5 10-5-10-5z" />
              <path d="M2 17l10 5 10-5" />
              <path d="M2 12l10 5 10-5" />
            </svg>
          </div>
          <h1 className="text-3xl font-bold text-white">PyDeck</h1>
          <p className="text-cyan-400 text-sm mt-1">Master Python</p>
        </div>

        {/* Card */}
        <div className="bg-navy-800/60 backdrop-blur-xl border border-white/5 rounded-2xl p-8">
          <button
            onClick={signInWithGoogle}
            className="w-full flex items-center justify-center gap-3 px-4 py-3.5 bg-white text-gray-800 rounded-xl font-medium hover:bg-gray-100 transition-colors cursor-pointer"
          >
            <svg width="20" height="20" viewBox="0 0 24 24">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92a5.06 5.06 0 01-2.2 3.32v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.1z"/>
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            Continue with Google
          </button>

          <div className="flex items-center gap-3 my-6">
            <div className="flex-1 h-px bg-white/10" />
            <span className="text-gray-500 text-xs uppercase">or use phone</span>
            <div className="flex-1 h-px bg-white/10" />
          </div>

          {!otpSent ? (
            <>
              {/* Phone Input */}
              <form onSubmit={handleSendOtp}>
                <div className="relative">
                  <div className="flex items-center gap-2 px-4 py-3.5 bg-navy-700/50 border border-white/10 rounded-xl focus-within:border-cyan-500/50">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <path d="M22 16.92v3a2 2 0 01-2.18 2 19.79 19.79 0 01-8.63-3.07 19.5 19.5 0 01-6-6 19.79 19.79 0 01-3.07-8.67A2 2 0 014.11 2h3a2 2 0 012 1.72c.127.96.361 1.903.7 2.81a2 2 0 01-.45 2.11L8.09 9.91a16 16 0 006 6l1.27-1.27a2 2 0 012.11-.45c.907.339 1.85.573 2.81.7A2 2 0 0122 16.92z"/>
                    </svg>
                    <span className="text-gray-400 text-sm">+91</span>
                    <input
                      type="tel"
                      placeholder="Mobile Number"
                      value={phone}
                      onChange={(e) => setPhone(e.target.value)}
                      className="bg-transparent text-white placeholder-gray-500 text-sm outline-none flex-1"
                      maxLength={10}
                      pattern="[0-9]{10}"
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={sending || !phone}
                  className="w-full mt-4 py-3.5 bg-gradient-to-r from-cyan-500 to-cyan-400 text-navy-900 font-semibold rounded-xl flex items-center justify-center gap-2 hover:from-cyan-400 hover:to-cyan-300 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {sending ? (
                    <>
                      <div className="w-4 h-4 border-2 border-navy-900 border-t-transparent rounded-full animate-spin" />
                      Sending...
                    </>
                  ) : (
                    <>
                      Get OTP
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M5 12h14M12 5l7 7-7 7"/>
                      </svg>
                    </>
                  )}
                </button>
              </form>
            </>
          ) : (
            <>
              {/* OTP Input */}
              <form onSubmit={handleVerifyOtp}>
                <div className="text-center mb-4">
                  <p className="text-gray-400 text-sm">OTP sent to +91{phone}</p>
                  <button
                    type="button"
                    onClick={() => { setOtpSent(false); setOtp(''); setError('') }}
                    className="text-cyan-400 text-xs mt-1 hover:underline"
                  >
                    Change number
                  </button>
                </div>

                <div className="relative">
                  <div className="flex items-center gap-2 px-4 py-3.5 bg-navy-700/50 border border-white/10 rounded-xl focus-within:border-cyan-500/50">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#64748b" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                      <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                      <path d="M7 11V7a5 5 0 0110 0v4"/>
                    </svg>
                    <input
                      type="text"
                      placeholder="Enter 6-digit OTP"
                      value={otp}
                      onChange={(e) => setOtp(e.target.value.replace(/\D/g, ''))}
                      className="bg-transparent text-white placeholder-gray-500 text-sm outline-none flex-1 tracking-widest"
                      maxLength={6}
                      pattern="[0-9]{6}"
                      autoFocus
                    />
                  </div>
                </div>

                <button
                  type="submit"
                  disabled={verifying || otp.length !== 6}
                  className="w-full mt-4 py-3.5 bg-gradient-to-r from-cyan-500 to-cyan-400 text-navy-900 font-semibold rounded-xl flex items-center justify-center gap-2 hover:from-cyan-400 hover:to-cyan-300 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  {verifying ? (
                    <>
                      <div className="w-4 h-4 border-2 border-navy-900 border-t-transparent rounded-full animate-spin" />
                      Verifying...
                    </>
                  ) : (
                    <>
                      Verify OTP
                      <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                        <path d="M5 12h14M12 5l7 7-7 7"/>
                      </svg>
                    </>
                  )}
                </button>
              </form>
            </>
          )}

          {error && (
            <p className="text-red-400 text-xs text-center mt-3">{error}</p>
          )}
        </div>
      </div>
    </div>
  )
}
