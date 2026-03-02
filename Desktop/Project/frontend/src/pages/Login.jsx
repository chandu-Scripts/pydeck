import { useEffect, useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { useAuth } from '../contexts/AuthContext'
import { supabase } from '../lib/supabase'
import { motion } from 'framer-motion'
import { ArrowLeft, Eye, EyeOff, Mail, Smartphone } from 'lucide-react'
import CardShuffleLoader from '../components/CardShuffleLoader'

// ─── Logo Holo Fan (shuffle → fan reveal) ─────────────────────────────────────
const LOGO_LETTERS = [
  { letter: 'P', gradient: 'linear-gradient(145deg,#1e3a8a 0%,#2563eb 55%,#3b82f6 100%)', glow: 'rgba(59,130,246,0.85)' },
  { letter: 'Y', gradient: 'linear-gradient(145deg,#78350f 0%,#d97706 55%,#f59e0b 100%)', glow: 'rgba(245,158,11,0.85)' },
  { letter: 'D', gradient: 'linear-gradient(145deg,#1a1a2e 0%,#374151 55%,#6b7280 100%)', glow: 'rgba(107,114,128,0.75)' },
  { letter: 'E', gradient: 'linear-gradient(145deg,#064e3b 0%,#059669 55%,#10b981 100%)', glow: 'rgba(16,185,129,0.85)' },
  { letter: 'C', gradient: 'linear-gradient(145deg,#7c2d12 0%,#ea580c 55%,#f97316 100%)', glow: 'rgba(249,115,22,0.85)' },
  { letter: 'K', gradient: 'linear-gradient(145deg,#4c1d95 0%,#7c3aed 55%,#a855f7 100%)', glow: 'rgba(168,85,247,0.85)' },
]

const LW   = 50   // card width
const LH   = 70   // card height
const LCH  = 128  // container height
const LTOP = LCH - 10 - LH  // 48px from top → cards sit near bottom

// Final fan target for each card index (P=0 … K=5)
function getFanTarget(i) {
  const pos    = i - 2.5               // -2.5, -1.5, -0.5, 0.5, 1.5, 2.5
  const absPos = Math.abs(pos)
  return {
    rotate:  pos * 11,
    x:       pos * 24,
    y:       absPos * 9 - 12,          // arch: center lifted, edges dip
    scale:   Math.max(0.78, 1 - absPos * 0.06),
    opacity: 1,
  }
}

// ── Individual card (receives full animate target + transition as props) ───────
function LogoLetterCard({ item, animTarget, transition, zIndex, isFan }) {
  const innerRef = useRef(null)
  const shineRef = useRef(null)

  function handleMouseMove(e) {
    const el = innerRef.current; const shine = shineRef.current
    if (!el || !shine) return
    const r  = el.getBoundingClientRect()
    const px = ((e.clientX - r.left) / r.width)  * 100
    const py = ((e.clientY - r.top)  / r.height) * 100
    el.style.transform     = `perspective(600px) rotateX(${-(py-50)*0.16}deg) rotateY(${(px-50)*0.24}deg)`
    shine.style.opacity    = '1'
    shine.style.background = `radial-gradient(circle at ${px}% ${py}%,rgba(255,230,80,.65) 0%,rgba(40,220,255,.55) 30%,rgba(200,55,255,.45) 60%,transparent 82%)`
  }
  function handleMouseLeave() {
    const el = innerRef.current; const shine = shineRef.current
    if (!el || !shine) return
    el.style.transform  = ''
    shine.style.opacity = '0'
  }
  function handleTouchMove(e) {
    const t = e.touches[0]
    handleMouseMove({ clientX: t.clientX, clientY: t.clientY })
  }

  return (
    <motion.div
      initial={{ x: 0, y: 0, rotate: 0, scale: 0.25, opacity: 0 }}
      animate={animTarget}
      transition={transition}
      style={{
        position: 'absolute',
        top: LTOP, left: '50%', marginLeft: -(LW / 2),
        width: LW, height: LH,
        transformOrigin: 'bottom center',
        zIndex,
      }}
    >
      <div
        ref={innerRef}
        onMouseMove={isFan ? handleMouseMove : undefined}
        onMouseLeave={isFan ? handleMouseLeave : undefined}
        onTouchMove={isFan ? handleTouchMove : undefined}
        onTouchEnd={isFan ? handleMouseLeave : undefined}
        style={{
          width: '100%', height: '100%', borderRadius: 12,
          background: item.gradient,
          border: `1.5px solid ${isFan ? item.glow : 'rgba(255,255,255,0.15)'}`,
          boxShadow: isFan
            ? `0 0 0 1px ${item.glow}, 0 0 26px ${item.glow}, 0 10px 28px rgba(0,0,0,0.6)`
            : '0 4px 20px rgba(0,0,0,0.55)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          position: 'relative', overflow: 'hidden',
          transition: 'border-color .35s, box-shadow .35s',
        }}
      >
        {/* Foil sheen */}
        <div style={{
          position: 'absolute', inset: 0, borderRadius: 12, pointerEvents: 'none',
          background: 'linear-gradient(135deg,rgba(255,255,255,0.13) 0%,rgba(255,255,255,0) 45%,rgba(255,255,255,0.06) 100%)',
        }} />
        {/* Shimmer */}
        <div ref={shineRef} style={{
          position: 'absolute', inset: 0, borderRadius: 12, pointerEvents: 'none',
          opacity: 0, mixBlendMode: 'screen', transition: 'opacity .14s',
        }} />
        {/* Letter */}
        <span style={{
          color: '#fff', fontSize: 26, fontWeight: 900,
          letterSpacing: '-0.02em', fontFamily: 'Inter, system-ui, sans-serif',
          textShadow: `0 0 18px ${item.glow}`, position: 'relative', zIndex: 1,
        }}>
          {item.letter}
        </span>
      </div>
    </motion.div>
  )
}

// ── Orchestrates deal → shuffle → fan ─────────────────────────────────────────
function LogoFan() {
  // 'deal' = cards materialise stacked; 'shuffle' = rapid riffle; 'fan' = spread out
  const [phase, setPhase] = useState('deal')
  const [shuffleOffsets, setShuffleOffsets] = useState(
    LOGO_LETTERS.map(() => ({ x: 0, y: 0, rotate: 0 }))
  )

  useEffect(() => {
    // ① Wait for deal-in animation (~480ms), then shuffle
    const dealDone = setTimeout(() => {
      setPhase('shuffle')

      let count = 0
      const MAX_SHUFFLES = 11
      const iv = setInterval(() => {
        count++
        if (count <= MAX_SHUFFLES) {
          // Rapid riffle: cards scatter in a tight cluster
          setShuffleOffsets(LOGO_LETTERS.map(() => ({
            x:      (Math.random() - 0.5) * 50,
            y:      (Math.random() - 0.5) * 24,
            rotate: (Math.random() - 0.5) * 30,
          })))
        } else {
          // ② Settle back to centre
          setShuffleOffsets(LOGO_LETTERS.map(() => ({ x: 0, y: 0, rotate: 0 })))
          clearInterval(iv)
          // ③ Fan out
          setTimeout(() => setPhase('fan'), 260)
        }
      }, 105)
    }, 480)

    return () => clearTimeout(dealDone)
  }, [])

  return (
    <div style={{ position: 'relative', width: '100%', height: LCH }}>
      {LOGO_LETTERS.map((item, i) => {
        const fanTarget = getFanTarget(i)
        const sp        = shuffleOffsets[i]
        const absPosFan = Math.abs(i - 2.5)

        // z-index: during fan, centre cards on top; during shuffle, stack order
        const zIndex = phase === 'fan'
          ? Math.round(10 - absPosFan * 2)
          : 6 - Math.abs(i - 2)

        // What to animate to this frame
        let animTarget
        if (phase === 'deal') {
          animTarget = { x: 0, y: 0, rotate: 0, scale: 1, opacity: 1 }
        } else if (phase === 'shuffle') {
          animTarget = { x: sp.x, y: sp.y, rotate: sp.rotate, scale: 0.9, opacity: 1 }
        } else {
          animTarget = fanTarget
        }

        const transition = phase === 'fan'
          ? { type: 'spring', stiffness: 155, damping: 19, delay: i * 0.055 }
          : phase === 'shuffle'
          ? { duration: 0.09, ease: 'easeInOut' }
          : { type: 'spring', stiffness: 290, damping: 26, delay: i * 0.06 }

        return (
          <LogoLetterCard
            key={item.letter}
            item={item}
            animTarget={animTarget}
            transition={transition}
            zIndex={zIndex}
            isFan={phase === 'fan'}
          />
        )
      })}
    </div>
  )
}


export default function Login() {
  const { user, signInWithGoogle, signInWithEmail,
          signInWithPhone, verifyOtp, signInWithEmailOtp, verifyEmailSignInOtp, createAccountWithOtp, checkEmailExists, loading } = useAuth()
  const navigate = useNavigate()
  const [pathCount, setPathCount] = useState(6)

  // Flip
  const [isFlipped, setIsFlipped] = useState(false)

  // Front-face view: 'main' | 'phone' | 'phone-otp' | 'emailotp' | 'emailotp-verify'
  const [siView, setSiView] = useState('main')

  // Sign In (password)
  const [siEmail, setSiEmail] = useState('')
  const [siPassword, setSiPassword] = useState('')
  const [siLoading, setSiLoading] = useState(false)
  const [siError, setSiError] = useState('')
  const [showSiPass, setShowSiPass] = useState(false)
  const [showPhoneSoon, setShowPhoneSoon] = useState(false)

  // Phone OTP
  const [phoneNum, setPhoneNum] = useState('')
  const [phoneOtp, setPhoneOtp] = useState('')
  const [phoneLoading, setPhoneLoading] = useState(false)
  const [phoneError, setPhoneError] = useState('')

  // Email OTP (sign-in, not sign-up)
  const [eoEmail, setEoEmail] = useState('')
  const [eoOtp, setEoOtp] = useState('')
  const [eoLoading, setEoLoading] = useState(false)
  const [eoError, setEoError] = useState('')

  // Sign Up
  const [suStep, setSuStep] = useState('form') // 'form' | 'otp'
  const [suName, setSuName] = useState('')
  const [suEmail, setSuEmail] = useState('')
  const [suPassword, setSuPassword] = useState('')
  const [suConfirmPassword, setSuConfirmPassword] = useState('')
  const [suOtp, setSuOtp] = useState('')
  const [suLoading, setSuLoading] = useState(false)
  const [suError, setSuError] = useState('')
  const [showSuPass, setShowSuPass] = useState(false)
  const [showSuConfirmPass, setShowSuConfirmPass] = useState(false)

  useEffect(() => {
    if (user) navigate('/paths')
  }, [user, navigate])

  useEffect(() => {
    async function fetchPathCount() {
      const { count, error } = await supabase.from('paths').select('*', { count: 'exact', head: true })
      if (!error && count > 0) setPathCount(count)
    }
    fetchPathCount()
  }, [])

  async function handleSignIn(e) {
    e.preventDefault()
    if (!siEmail.trim() || !siPassword.trim()) { setSiError('Please fill in all fields'); return }
    setSiLoading(true); setSiError('')
    const { error } = await signInWithEmail(siEmail.trim(), siPassword)
    setSiLoading(false)
    if (error) setSiError(error.message === 'Invalid login credentials' ? 'Wrong email or password' : error.message)
  }

  async function handleSignUp(e) {
    e.preventDefault()
    if (!suName.trim() || !suEmail.trim() || !suPassword.trim() || !suConfirmPassword.trim()) { setSuError('Please fill in all fields'); return }
    if (suPassword.length < 6) { setSuError('Password must be at least 6 characters'); return }
    if (suPassword !== suConfirmPassword) { setSuError('Passwords do not match'); return }
    setSuLoading(true); setSuError('')
    const exists = await checkEmailExists(suEmail.trim())
    if (exists) {
      setSuLoading(false)
      setSuError('An account with this email already exists. Please sign in instead.')
      return
    }
    const { error } = await signInWithEmailOtp(suEmail.trim())
    setSuLoading(false)
    if (error) setSuError(error.message)
    else setSuStep('otp')
  }

  async function handleVerifyOtp(e) {
    e.preventDefault()
    if (suOtp.length < 6) { setSuError('Enter the verification code'); return }
    setSuLoading(true); setSuError('')
    const { error } = await createAccountWithOtp(suEmail.trim(), suOtp.trim(), suPassword, suName.trim())
    setSuLoading(false)
    if (error) setSuError(error.message)
  }

  async function handleSendPhoneOtp(e) {
    e.preventDefault()
    if (!phoneNum.trim()) { setPhoneError('Enter your phone number'); return }
    setPhoneLoading(true); setPhoneError('')
    const { error } = await signInWithPhone(phoneNum.trim())
    setPhoneLoading(false)
    if (error) setPhoneError(error.message)
    else setSiView('phone-otp')
  }

  async function handleVerifyPhoneOtp(e) {
    e.preventDefault()
    if (phoneOtp.length < 6) { setPhoneError('Enter the 6-digit OTP'); return }
    setPhoneLoading(true); setPhoneError('')
    const { error } = await verifyOtp(phoneNum.trim(), phoneOtp.trim())
    setPhoneLoading(false)
    if (error) setPhoneError(error.message)
  }

  async function handleSendEmailOtp(e) {
    e.preventDefault()
    if (!eoEmail.trim()) { setEoError('Enter your email'); return }
    setEoLoading(true); setEoError('')
    const { error } = await signInWithEmailOtp(eoEmail.trim())
    setEoLoading(false)
    if (error) setEoError(error.message)
    else setSiView('emailotp-verify')
  }

  async function handleVerifyEmailOtp(e) {
    e.preventDefault()
    if (eoOtp.length < 6) { setEoError('Enter the verification code'); return }
    setEoLoading(true); setEoError('')
    const { error } = await verifyEmailSignInOtp(eoEmail.trim(), eoOtp.trim())
    setEoLoading(false)
    if (error) setEoError(error.message)
  }

  function backToMain() {
    setSiView('main'); setPhoneError(''); setEoError('')
    setPhoneOtp(''); setEoOtp('')
  }

  function flipToSignUp() { setSiError(''); setIsFlipped(true) }
  function flipToSignIn() { setSuError(''); setSuStep('form'); setSuOtp(''); setSuConfirmPassword(''); setIsFlipped(false) }

  if (loading) return <CardShuffleLoader />

  const inputCls = 'w-full px-4 py-3 bg-navy-700/50 border border-white/10 rounded-xl text-white text-sm placeholder-gray-500 focus:outline-none focus:border-cyan-500/50 transition-colors'
  const btnCls = 'w-full py-3.5 bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 rounded-xl font-semibold hover:bg-cyan-500/30 transition-colors flex items-center justify-center gap-2 disabled:opacity-50 cursor-pointer disabled:cursor-not-allowed'

  return (
    <div
      className="fixed inset-0 overflow-hidden flex items-center justify-center px-4"
      style={{ paddingTop: 'env(safe-area-inset-top)', paddingBottom: 'env(safe-area-inset-bottom)' }}
    >
      <div className="absolute inset-0 bg-gradient-to-br from-navy-900 via-navy-800 to-[#0d1a2e]" />
      <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-96 h-96 bg-cyan-500/5 rounded-full blur-3xl" />

      <div className="relative z-10 w-full max-w-sm overflow-y-auto scrollbar-hide" style={{ maxHeight: '100%' }}>
        {/* Logo */}
        <div className="flex flex-col items-center mb-4">
          <LogoFan />
        </div>

        {/* Stats strip */}
        <div className="flex items-center justify-center mb-5">
          {[
            { value: '1,200+', label: 'Flashcards' },
            { value: String(pathCount), label: 'Learning Paths' },
            { value: 'Free', label: 'Forever' },
          ].map((stat, i, arr) => (
            <div key={stat.label} className="flex items-center">
              <div className="flex flex-col items-center px-4">
                <span className="font-bold text-sm" style={{ color: '#22d3ee', textShadow: '0 0 12px rgba(6,182,212,0.7)' }}>{stat.value}</span>
                <span className="text-[11px]" style={{ color: 'rgba(6,182,212,0.65)' }}>{stat.label}</span>
              </div>
              {i < arr.length - 1 && <div className="w-px h-7" style={{ background: 'rgba(6,182,212,0.2)' }} />}
            </div>
          ))}
        </div>

        {/* Flip Card */}
        <div className="relative" style={{ perspective: '1200px' }}>
          {/* Beam lives outside the 3D context — no animation/compositing conflict */}
          <div className="login-card-beam absolute inset-0" />

          <motion.div
            animate={{ rotateY: isFlipped ? 180 : 0 }}
            transition={{ duration: 0.55, type: 'spring', stiffness: 80, damping: 18 }}
            style={{ transformStyle: 'preserve-3d', display: 'grid', position: 'relative', zIndex: 1 }}
          >
            {/* ── FRONT: Sign In ── */}
            <div
              style={{ gridArea: '1/1', backfaceVisibility: 'hidden', WebkitBackfaceVisibility: 'hidden', padding: '1.5px', borderRadius: '1rem' }}
            >
              <div className="login-card-inner p-7">

              {/* ── PHONE: enter number ── */}
              {siView === 'phone' && (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={backToMain} className="text-gray-400 hover:text-white transition-colors cursor-pointer"><ArrowLeft size={20} /></button>
                    <h2 className="text-white font-bold text-lg">Phone Sign In</h2>
                  </div>
                  <div className="text-center mb-5">
                    <div className="w-14 h-14 rounded-2xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center mx-auto mb-3">
                      <Smartphone size={26} className="text-purple-400" />
                    </div>
                    <p className="text-gray-400 text-sm">Enter your number with country code</p>
                  </div>
                  <form onSubmit={handleSendPhoneOtp} className="space-y-3">
                    <input type="tel" placeholder="+91XXXXXXXXXX" value={phoneNum}
                      onChange={e => setPhoneNum(e.target.value)} className={inputCls} />
                    {phoneError && <p className="text-red-400 text-xs">{phoneError}</p>}
                    <button type="submit" disabled={phoneLoading} className={btnCls}>
                      {phoneLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Send OTP'}
                    </button>
                  </form>
                </>
              )}

              {/* ── PHONE: verify OTP ── */}
              {siView === 'phone-otp' && (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={() => { setSiView('phone'); setPhoneOtp(''); setPhoneError('') }} className="text-gray-400 hover:text-white transition-colors cursor-pointer"><ArrowLeft size={20} /></button>
                    <h2 className="text-white font-bold text-lg">Verify Phone</h2>
                  </div>
                  <div className="text-center mb-5">
                    <div className="w-14 h-14 rounded-2xl bg-purple-500/10 border border-purple-500/20 flex items-center justify-center mx-auto mb-3">
                      <Smartphone size={26} className="text-purple-400" />
                    </div>
                    <p className="text-gray-400 text-sm">OTP sent to</p>
                    <p className="text-white font-semibold text-sm mt-0.5">{phoneNum}</p>
                  </div>
                  <form onSubmit={handleVerifyPhoneOtp} className="space-y-3">
                    <input type="text" inputMode="numeric" placeholder="000000" value={phoneOtp} maxLength={6}
                      onChange={e => setPhoneOtp(e.target.value.replace(/\D/g, '').slice(0, 6))}
                      className={inputCls + ' text-center tracking-[0.5em] text-xl font-mono'} />
                    {phoneError && <p className="text-red-400 text-xs text-center">{phoneError}</p>}
                    <button type="submit" disabled={phoneLoading || phoneOtp.length < 6} className={btnCls}>
                      {phoneLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Verify & Sign In'}
                    </button>
                  </form>
                  <p className="text-center text-gray-500 text-xs mt-4">Didn't get it? Check your number and retry.</p>
                </>
              )}

              {/* ── EMAIL OTP: enter email ── */}
              {siView === 'emailotp' && (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={backToMain} className="text-gray-400 hover:text-white transition-colors cursor-pointer"><ArrowLeft size={20} /></button>
                    <h2 className="text-white font-bold text-lg">Email OTP</h2>
                  </div>
                  <div className="text-center mb-5">
                    <div className="w-14 h-14 rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center mx-auto mb-3">
                      <Mail size={26} className="text-cyan-400" />
                    </div>
                    <p className="text-gray-400 text-sm">We'll send a code to your email</p>
                  </div>
                  <form onSubmit={handleSendEmailOtp} className="space-y-3">
                    <input type="email" placeholder="Email" value={eoEmail}
                      onChange={e => setEoEmail(e.target.value)} className={inputCls} />
                    {eoError && <p className="text-red-400 text-xs">{eoError}</p>}
                    <button type="submit" disabled={eoLoading} className={btnCls}>
                      {eoLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Send Code'}
                    </button>
                  </form>
                </>
              )}

              {/* ── EMAIL OTP: verify ── */}
              {siView === 'emailotp-verify' && (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={() => { setSiView('emailotp'); setEoOtp(''); setEoError('') }} className="text-gray-400 hover:text-white transition-colors cursor-pointer"><ArrowLeft size={20} /></button>
                    <h2 className="text-white font-bold text-lg">Check Your Email</h2>
                  </div>
                  <div className="text-center mb-5">
                    <div className="w-14 h-14 rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center mx-auto mb-3">
                      <Mail size={26} className="text-cyan-400" />
                    </div>
                    <p className="text-gray-400 text-sm">Code sent to</p>
                    <p className="text-white font-semibold text-sm mt-0.5">{eoEmail}</p>
                  </div>
                  <form onSubmit={handleVerifyEmailOtp} className="space-y-3">
                    <input type="text" inputMode="numeric" placeholder="000000" value={eoOtp} maxLength={6}
                      onChange={e => setEoOtp(e.target.value.replace(/\D/g, '').slice(0, 6))}
                      className={inputCls + ' text-center tracking-[0.5em] text-xl font-mono'} />
                    {eoError && <p className="text-red-400 text-xs text-center">{eoError}</p>}
                    <button type="submit" disabled={eoLoading || eoOtp.length < 6} className={btnCls}>
                      {eoLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Verify & Sign In'}
                    </button>
                  </form>
                  <p className="text-center text-gray-500 text-xs mt-4">Didn't get it? Check your spam folder.</p>
                </>
              )}

              {/* ── MAIN sign-in view ── */}
              {siView === 'main' && (<>
              {/* Google */}
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

              <div className="flex items-center gap-3 my-4">
                <div className="flex-1 h-px bg-white/10" />
                <span className="text-gray-500 text-xs uppercase">or</span>
                <div className="flex-1 h-px bg-white/10" />
              </div>

              {/* Email + Password Sign In */}
              <form onSubmit={handleSignIn} className="space-y-3">
                <input type="email" placeholder="Email" value={siEmail}
                  onChange={e => setSiEmail(e.target.value)} className={inputCls} />
                <div className="relative">
                  <input type={showSiPass ? 'text' : 'password'} placeholder="Password" value={siPassword}
                    onChange={e => setSiPassword(e.target.value)} className={inputCls + ' pr-11'} />
                  <button type="button" onClick={() => setShowSiPass(p => !p)}
                    className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                    {showSiPass ? <EyeOff size={17} /> : <Eye size={17} />}
                  </button>
                </div>
                {siError && <p className="text-red-400 text-xs">{siError}</p>}
                <button type="submit" disabled={siLoading} className={btnCls}>
                  {siLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Sign In'}
                </button>
              </form>

              {/* OTP options */}
              <div className="grid grid-cols-2 gap-2 mt-3">
                <div className="relative">
                  <button onClick={() => { setShowPhoneSoon(true); setTimeout(() => setShowPhoneSoon(false), 2000) }}
                    className="w-full py-2.5 bg-purple-500/10 border border-purple-500/20 text-purple-400 rounded-xl text-xs font-semibold hover:bg-purple-500/20 transition-colors flex items-center justify-center gap-1.5 cursor-pointer">
                    <Smartphone size={14} /> Phone OTP
                  </button>
                  {showPhoneSoon && (
                    <div className="absolute inset-0 bg-navy-800 border border-yellow-500/40 rounded-xl flex items-center justify-center">
                      <span className="text-yellow-400 text-xs font-bold">Coming Soon!</span>
                    </div>
                  )}
                </div>
                <button onClick={() => { setSiView('emailotp'); setEoError('') }}
                  className="py-2.5 bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 rounded-xl text-xs font-semibold hover:bg-cyan-500/20 transition-colors flex items-center justify-center gap-1.5 cursor-pointer">
                  <Mail size={14} /> Email OTP
                </button>
              </div>

              <p className="text-center text-gray-500 text-sm mt-4">
                New here?{' '}
                <button onClick={flipToSignUp} className="text-cyan-400 hover:text-cyan-300 font-semibold transition-colors cursor-pointer">
                  Create account
                </button>
              </p>
              </>)}
              </div>{/* end content */}
            </div>

            {/* ── BACK: Sign Up ── */}
            <div
              style={{ gridArea: '1/1', backfaceVisibility: 'hidden', WebkitBackfaceVisibility: 'hidden', transform: 'rotateY(180deg)', padding: '1.5px', borderRadius: '1rem' }}
            >
              <div className="login-card-inner p-7">
              {suStep === 'form' ? (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={flipToSignIn} className="text-gray-400 hover:text-white transition-colors cursor-pointer">
                      <ArrowLeft size={20} />
                    </button>
                    <h2 className="text-white font-bold text-lg">Create Account</h2>
                  </div>

                  <form onSubmit={handleSignUp} className="space-y-3">
                    <input type="text" placeholder="Your name" value={suName}
                      onChange={e => setSuName(e.target.value)} className={inputCls} />
                    <input type="email" placeholder="Email" value={suEmail}
                      onChange={e => setSuEmail(e.target.value)} className={inputCls} />
                    <div className="relative">
                      <input type={showSuPass ? 'text' : 'password'} placeholder="Password (min 6 characters)" value={suPassword}
                        onChange={e => setSuPassword(e.target.value)} className={inputCls + ' pr-11'} />
                      <button type="button" onClick={() => setShowSuPass(p => !p)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                        {showSuPass ? <EyeOff size={17} /> : <Eye size={17} />}
                      </button>
                    </div>
                    <div className="relative">
                      <input type={showSuConfirmPass ? 'text' : 'password'} placeholder="Confirm password" value={suConfirmPassword}
                        onChange={e => setSuConfirmPassword(e.target.value)} className={inputCls + ' pr-11'} />
                      <button type="button" onClick={() => setShowSuConfirmPass(p => !p)}
                        className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-white transition-colors">
                        {showSuConfirmPass ? <EyeOff size={17} /> : <Eye size={17} />}
                      </button>
                    </div>
                    {suError && <p className="text-red-400 text-xs">{suError}</p>}
                    <button type="submit" disabled={suLoading} className={btnCls}>
                      {suLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Create Account'}
                    </button>
                  </form>

                  <p className="text-center text-gray-500 text-sm mt-4">
                    Already have an account?{' '}
                    <button onClick={flipToSignIn} className="text-cyan-400 hover:text-cyan-300 font-semibold transition-colors cursor-pointer">
                      Sign in
                    </button>
                  </p>
                </>
              ) : (
                <>
                  <div className="flex items-center gap-3 mb-5">
                    <button onClick={() => { setSuStep('form'); setSuError(''); setSuOtp('') }}
                      className="text-gray-400 hover:text-white transition-colors cursor-pointer">
                      <ArrowLeft size={20} />
                    </button>
                    <h2 className="text-white font-bold text-lg">Verify Email</h2>
                  </div>

                  <div className="text-center mb-6">
                    <div className="w-14 h-14 rounded-2xl bg-cyan-500/10 border border-cyan-500/20 flex items-center justify-center mx-auto mb-3">
                      <Mail size={26} className="text-cyan-400" />
                    </div>
                    <p className="text-gray-400 text-sm">We sent a 6-digit code to</p>
                    <p className="text-white font-semibold text-sm mt-0.5">{suEmail}</p>
                  </div>

                  <form onSubmit={handleVerifyOtp} className="space-y-3">
                    <input
                      type="text" inputMode="numeric" placeholder="000000"
                      value={suOtp} maxLength={6}
                      onChange={e => setSuOtp(e.target.value.replace(/\D/g, '').slice(0, 6))}
                      className={inputCls + ' text-center tracking-[0.5em] text-xl font-mono'}
                    />
                    {suError && <p className="text-red-400 text-xs text-center">{suError}</p>}
                    <button type="submit" disabled={suLoading || suOtp.length < 6} className={btnCls}>
                      {suLoading ? <div className="w-4 h-4 border-2 border-cyan-400 border-t-transparent rounded-full animate-spin" /> : 'Verify & Continue'}
                    </button>
                  </form>

                  <p className="text-center text-gray-500 text-xs mt-4">
                    Didn't get it? Check your spam folder.
                  </p>
                </>
              )}
              </div>{/* end content */}
            </div>
          </motion.div>
        </div>

      </div>
    </div>
  )
}
