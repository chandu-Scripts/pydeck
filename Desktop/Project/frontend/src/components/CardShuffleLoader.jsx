import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'

const CARDS = [
  { letter: 'P', gradient: 'linear-gradient(145deg,#1e3a8a 0%,#2563eb 55%,#3b82f6 100%)', glow: 'rgba(59,130,246,0.85)' },
  { letter: 'Y', gradient: 'linear-gradient(145deg,#78350f 0%,#d97706 55%,#f59e0b 100%)', glow: 'rgba(245,158,11,0.85)' },
  { letter: 'D', gradient: 'linear-gradient(145deg,#1a1a2e 0%,#374151 55%,#6b7280 100%)', glow: 'rgba(107,114,128,0.75)' },
  { letter: 'E', gradient: 'linear-gradient(145deg,#064e3b 0%,#059669 55%,#10b981 100%)', glow: 'rgba(16,185,129,0.85)' },
  { letter: 'C', gradient: 'linear-gradient(145deg,#7c2d12 0%,#ea580c 55%,#f97316 100%)', glow: 'rgba(249,115,22,0.85)' },
  { letter: 'K', gradient: 'linear-gradient(145deg,#4c1d95 0%,#7c3aed 55%,#a855f7 100%)', glow: 'rgba(168,85,247,0.85)' },
]

const CW   = 30   // card width
const CH   = 42   // card height
const CCH  = 64   // container height
const CTOP = CCH - 6 - CH  // 16 — cards sit near bottom of container

export default function CardShuffleLoader({ fullScreen = true }) {
  const [offsets, setOffsets] = useState(CARDS.map(() => ({ x: 0, y: 0, rotate: 0 })))

  useEffect(() => {
    const iv = setInterval(() => {
      setOffsets(CARDS.map(() => ({
        x:      (Math.random() - 0.5) * 38,
        y:      (Math.random() - 0.5) * 16,
        rotate: (Math.random() - 0.5) * 24,
      })))
    }, 105)
    return () => clearInterval(iv)
  }, [])

  const loader = (
    <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 14 }}>
      {/* Shuffling cards */}
      <div style={{ position: 'relative', width: 100, height: CCH }}>
        {CARDS.map((card, i) => (
          <motion.div
            key={card.letter}
            animate={{ x: offsets[i].x, y: offsets[i].y, rotate: offsets[i].rotate }}
            transition={{ duration: 0.1, ease: 'easeInOut' }}
            style={{
              position:      'absolute',
              top:           CTOP,
              left:          '50%',
              marginLeft:    -(CW / 2),
              width:         CW,
              height:        CH,
              transformOrigin: 'bottom center',
              zIndex:        6 - Math.abs(i - 2),
            }}
          >
            <div style={{
              width: '100%', height: '100%', borderRadius: 7,
              background: card.gradient,
              border: '1px solid rgba(255,255,255,0.15)',
              boxShadow: `0 0 10px ${card.glow.replace('0.85', '0.45')}, 0 3px 10px rgba(0,0,0,0.5)`,
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              position: 'relative', overflow: 'hidden',
            }}>
              {/* Foil sheen */}
              <div style={{
                position: 'absolute', inset: 0, borderRadius: 7, pointerEvents: 'none',
                background: 'linear-gradient(135deg,rgba(255,255,255,0.13) 0%,rgba(255,255,255,0) 45%,rgba(255,255,255,0.06) 100%)',
              }} />
              <span style={{
                color: '#fff', fontSize: 14, fontWeight: 900,
                letterSpacing: '-0.02em', fontFamily: 'Inter, system-ui, sans-serif',
                textShadow: `0 0 8px ${card.glow}`,
                position: 'relative', zIndex: 1,
              }}>
                {card.letter}
              </span>
            </div>
          </motion.div>
        ))}
      </div>

      {/* Label */}
      <p style={{
        color: 'rgba(255,255,255,0.28)', fontSize: 10,
        letterSpacing: '0.14em', textTransform: 'uppercase',
        margin: 0, fontFamily: 'Inter, system-ui, sans-serif',
      }}>
        Loading...
      </p>
    </div>
  )

  if (!fullScreen) return loader

  return (
    <div className="fixed inset-0 flex items-center justify-center bg-navy-900">
      {loader}
    </div>
  )
}
