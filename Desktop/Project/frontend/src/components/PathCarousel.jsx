import { useState, useEffect, useRef } from 'react'
import { motion } from 'framer-motion'
import { SiGit } from 'react-icons/si'

// ─── Color map (regular carousel badge colours) ───────────────────────────────
const colorMap = {
  'text-blue-400':   { bg: 'bg-blue-500/10',   border: 'border-blue-500/30',   text: 'text-blue-400' },
  'text-yellow-400': { bg: 'bg-yellow-500/10',  border: 'border-yellow-500/30', text: 'text-yellow-400' },
  'text-gray-300':   { bg: 'bg-gray-500/10',    border: 'border-gray-500/30',   text: 'text-gray-300' },
  'text-green-400':  { bg: 'bg-green-500/10',   border: 'border-green-500/30',  text: 'text-green-400' },
  'text-orange-400': { bg: 'bg-orange-500/10',  border: 'border-orange-500/30', text: 'text-orange-400' },
  'text-purple-400': { bg: 'bg-purple-500/10',  border: 'border-purple-500/30', text: 'text-purple-400' },
  'text-cyan-400':   { bg: 'bg-cyan-500/10',    border: 'border-cyan-500/30',   text: 'text-cyan-400' },
}

// ─── Holo Fan: rich card gradients ────────────────────────────────────────────
const CARD_GRADIENTS = {
  Python: 'linear-gradient(145deg,#1e3a8a 0%,#2563eb 55%,#3b82f6 100%)',
  MySQL:  'linear-gradient(145deg,#78350f 0%,#d97706 55%,#f59e0b 100%)',
  Flask:  'linear-gradient(145deg,#111827 0%,#374151 55%,#6b7280 100%)',
  Django: 'linear-gradient(145deg,#064e3b 0%,#059669 55%,#10b981 100%)',
  NumPy:  'linear-gradient(145deg,#7c2d12 0%,#ea580c 55%,#f97316 100%)',
  Pandas: 'linear-gradient(145deg,#4c1d95 0%,#7c3aed 55%,#a855f7 100%)',
  'Git & GitHub': 'linear-gradient(145deg,#7c1d0a 0%,#dc2626 55%,#f97316 100%)',
}
const DEFAULT_GRADIENT = 'linear-gradient(145deg,#164e63 0%,#0891b2 55%,#22d3ee 100%)'

const GLOW_COLORS = {
  Python: 'rgba(59,130,246,0.75)',
  MySQL:  'rgba(245,158,11,0.75)',
  Flask:  'rgba(107,114,128,0.65)',
  Django: 'rgba(16,185,129,0.75)',
  NumPy:  'rgba(249,115,22,0.75)',
  Pandas: 'rgba(168,85,247,0.75)',
  'Git & GitHub': 'rgba(249,115,22,0.75)',
}
const DEFAULT_GLOW = 'rgba(34,211,238,0.75)'

// Layout constants
const CARD_W = 148
const CARD_H = 205
const CONTAINER_H = 300
const BOTTOM_MARGIN = 20
// CSS top so card bottom rests at (CONTAINER_H - BOTTOM_MARGIN)
const CARD_TOP = CONTAINER_H - BOTTOM_MARGIN - CARD_H   // 75px

// ─── Single holo card ─────────────────────────────────────────────────────────
function HoloCard({
  path, pathIcons, iconColors, topicCounts,
  isSelected, position, total, dealDelay,
  onSelect, onNavigate,
}) {
  const innerRef = useRef(null)
  const shineRef = useRef(null)

  const Icon      = pathIcons[path.name] || SiGit
  const iconColor = iconColors[path.name] || 'text-cyan-400'
  const btnColors = colorMap[iconColor]   || colorMap['text-cyan-400']
  const bg        = CARD_GRADIENTS[path.name] || DEFAULT_GRADIENT
  const glow      = GLOW_COLORS[path.name]    || DEFAULT_GLOW

  // Fan geometry
  const STEP_ANGLE = Math.min(16, 72 / Math.max(total - 1, 1))
  const STEP_X     = Math.min(38, 152 / Math.max(total - 1, 1))
  const absPos     = Math.abs(position)

  const angle   = position * STEP_ANGLE
  const tx      = position * STEP_X
  const ty      = isSelected ? -22 : absPos * 5
  const scale   = Math.max(0.72, 1 - absPos * 0.07)
  const opacity = Math.max(0.42, 1 - absPos * 0.13)
  const zIndex  = 20 - absPos

  // ── Mouse tilt + holographic shine ──────────────────────────────────────────
  function handleMouseMove(e) {
    const el    = innerRef.current
    const shine = shineRef.current
    if (!el || !shine) return
    const rect = el.getBoundingClientRect()
    const px   = ((e.clientX - rect.left) / rect.width)  * 100
    const py   = ((e.clientY - rect.top)  / rect.height) * 100
    el.style.transform    = `perspective(900px) rotateX(${-(py - 50) * 0.14}deg) rotateY(${(px - 50) * 0.22}deg)`
    shine.style.opacity   = '1'
    shine.style.background = `radial-gradient(circle at ${px}% ${py}%,rgba(255,230,80,0.62) 0%,rgba(40,220,255,0.52) 30%,rgba(200,55,255,0.44) 60%,transparent 82%)`
  }

  function handleMouseLeave() {
    const el    = innerRef.current
    const shine = shineRef.current
    if (!el || !shine) return
    el.style.transform  = 'perspective(900px) rotateX(0deg) rotateY(0deg)'
    shine.style.opacity = '0'
  }

  // ── Touch shimmer (mobile) ───────────────────────────────────────────────────
  function handleTouchMove(e) {
    const touch = e.touches[0]
    handleMouseMove({ clientX: touch.clientX, clientY: touch.clientY })
  }

  function handleClick() {
    if (isSelected) {
      onNavigate(path)
    } else {
      onSelect()
      // short delay so the fan animates to center before navigating
      setTimeout(() => onNavigate(path), 320)
    }
  }

  return (
    <motion.div
      style={{
        position:        'absolute',
        top:             CARD_TOP,
        left:            '50%',
        marginLeft:      -(CARD_W / 2),
        width:           CARD_W,
        height:          CARD_H,
        transformOrigin: 'bottom center',
        cursor:          'pointer',
        zIndex,
      }}
      initial={{ rotate: 0, x: 0, y: 90, scale: 0.15, opacity: 0 }}
      animate={{ rotate: angle, x: tx, y: ty, scale, opacity }}
      transition={{ type: 'spring', stiffness: 210, damping: 24, delay: dealDelay }}
      onClick={handleClick}
      whileTap={{ scale: scale * 0.94 }}
    >
      {/* Inner card — handles tilt & shine independently of Framer transform */}
      <div
        ref={innerRef}
        onMouseMove={handleMouseMove}
        onMouseLeave={handleMouseLeave}
        onTouchMove={handleTouchMove}
        onTouchEnd={handleMouseLeave}
        style={{
          width:        '100%',
          height:       '100%',
          borderRadius: 18,
          background:   bg,
          border:       `1.5px solid ${isSelected ? glow.replace('0.75', '0.85') : 'rgba(255,255,255,0.10)'}`,
          boxShadow:    isSelected
            ? `0 0 0 1px ${glow}, 0 0 32px ${glow}, 0 14px 44px rgba(0,0,0,0.6)`
            : '0 4px 22px rgba(0,0,0,0.45)',
          display:        'flex',
          flexDirection:  'column',
          alignItems:     'center',
          justifyContent: 'space-between',
          padding:        '18px 14px 16px',
          position:       'relative',
          overflow:       'hidden',
          transition:     'border-color .3s, box-shadow .3s',
        }}
      >
        {/* Static foil sheen — always visible */}
        <div style={{
          position:     'absolute',
          inset:        0,
          borderRadius: 18,
          background:   'linear-gradient(135deg,rgba(255,255,255,0.09) 0%,rgba(255,255,255,0) 45%,rgba(255,255,255,0.05) 100%)',
          pointerEvents: 'none',
        }} />

        {/* Dynamic mouse-tracking rainbow shimmer */}
        <div
          ref={shineRef}
          style={{
            position:      'absolute',
            inset:         0,
            borderRadius:  18,
            opacity:       0,
            mixBlendMode:  'screen',
            pointerEvents: 'none',
            transition:    'opacity .14s',
          }}
        />

        {/* Icon */}
        <div
          className={iconColor}
          style={{
            width: 58, height: 58, borderRadius: 14,
            background: 'rgba(0,0,0,0.28)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
          }}
        >
          <Icon size={28} />
        </div>

        {/* Name + topic count */}
        <div style={{
          textAlign:      'center',
          flex:           1,
          display:        'flex',
          flexDirection:  'column',
          alignItems:     'center',
          justifyContent: 'center',
          gap:            4,
        }}>
          <h3 style={{ color: '#fff', fontWeight: 800, fontSize: 15, margin: 0 }}>
            {path.name}
          </h3>
          <p style={{ color: 'rgba(255,255,255,0.45)', fontSize: 11, margin: 0 }}>
            {topicCounts[path.id] || 0} Topics
          </p>
        </div>

        {/* Action badge */}
        <div className={`px-4 py-1.5 rounded-lg ${btnColors.bg} border ${btnColors.border}`}>
          <span
            className={`${btnColors.text} font-bold`}
            style={{ fontSize: 9, letterSpacing: '0.1em' }}
          >
            TAP TO STUDY
          </span>
        </div>
      </div>
    </motion.div>
  )
}

// ─── Holo Fan container ───────────────────────────────────────────────────────
function HoloFan({
  paths, pathIcons, iconColors, topicCounts,
  onPathClick, onIndexChange, onFrontCardChange,
}) {
  const [selectedIndex, setSelectedIndex] = useState(0)
  const [dealt, setDealt] = useState(false)
  const total = paths.length

  // Mark cards as dealt-in after stagger completes so re-selections animate instantly
  useEffect(() => {
    const t = setTimeout(() => setDealt(true), total * 100 + 1200)
    return () => clearTimeout(t)
  }, [total])

  // Propagate selection upward
  useEffect(() => {
    if (onIndexChange)     onIndexChange(selectedIndex)
    if (onFrontCardChange && paths[selectedIndex]) onFrontCardChange(paths[selectedIndex])
  }, [selectedIndex]) // eslint-disable-line react-hooks/exhaustive-deps

  // Touch-swipe detection on the container (without blocking card clicks)
  const touchStartX = useRef(null)
  function handleTouchStart(e) { touchStartX.current = e.touches[0].clientX }
  function handleTouchEnd(e) {
    if (touchStartX.current === null) return
    const dx = e.changedTouches[0].clientX - touchStartX.current
    if (dx < -40) setSelectedIndex(i => (i + 1) % total)
    else if (dx > 40) setSelectedIndex(i => (i - 1 + total) % total)
    touchStartX.current = null
  }

  function getPosition(i) {
    let pos = i - selectedIndex
    if (pos >  total / 2) pos -= total
    if (pos < -total / 2) pos += total
    return pos
  }

  // Render back-to-front (most negative |pos| first) so center card is on top
  const sorted = [...paths]
    .map((path, i) => ({ path, i, absPos: Math.abs(getPosition(i)) }))
    .sort((a, b) => b.absPos - a.absPos)

  return (
    <div
      style={{ position: 'relative', width: '100%', height: CONTAINER_H, overflow: 'visible' }}
      onTouchStart={handleTouchStart}
      onTouchEnd={handleTouchEnd}
    >
      {/* Cards */}
      {sorted.map(({ path, i }) => (
        <HoloCard
          key={path.id}
          path={path}
          pathIcons={pathIcons}
          iconColors={iconColors}
          topicCounts={topicCounts}
          isSelected={i === selectedIndex}
          position={getPosition(i)}
          total={total}
          dealDelay={dealt ? 0 : i * 0.09}
          onSelect={() => setSelectedIndex(i)}
          onNavigate={onPathClick}
        />
      ))}

      {/* Hint */}
      <motion.p
        key={selectedIndex}
        initial={{ opacity: 0, y: 4 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
        style={{
          position:    'absolute',
          bottom:      -20,
          left:        '50%',
          transform:   'translateX(-50%)',
          fontSize:    10,
          color:       'rgba(255,255,255,0.28)',
          letterSpacing: '0.12em',
          whiteSpace:  'nowrap',
          pointerEvents: 'none',
          textTransform: 'uppercase',
        }}
      >
        tap any card to open · swipe to browse
      </motion.p>
    </div>
  )
}

// ═══════════════════════════════════════════════════════════════════════════════
// MAIN EXPORT
// ═══════════════════════════════════════════════════════════════════════════════
export default function PathCarousel({
  paths, pathIcons, iconColors, pathColors, topicCounts,
  onPathClick, onIndexChange, orbitMode = false, onFrontCardChange,
}) {
  const [currentIndex, setCurrentIndex] = useState(0)
  const total = paths.length

  useEffect(() => {
    if (onIndexChange && paths[currentIndex]) onIndexChange(currentIndex)
  }, [currentIndex, onIndexChange, paths])

  // ── Holographic Fan mode ────────────────────────────────────────────────────
  if (orbitMode) {
    if (total === 0) return null
    return (
      <HoloFan
        paths={paths}
        pathIcons={pathIcons}
        iconColors={iconColors}
        topicCounts={topicCounts}
        onPathClick={onPathClick}
        onIndexChange={onIndexChange}
        onFrontCardChange={onFrontCardChange}
      />
    )
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // REGULAR CAROUSEL MODE (unchanged)
  // ═══════════════════════════════════════════════════════════════════════════
  const handlePrevious = () =>
    setCurrentIndex(p => (p === 0 ? paths.length - 1 : p - 1))
  const handleNext = () =>
    setCurrentIndex(p => (p === paths.length - 1 ? 0 : p + 1))
  const handleCardClick = (index) => {
    if (index === currentIndex) onPathClick(paths[index])
    else if (index > currentIndex) handleNext()
    else handlePrevious()
  }
  const handleDragEnd = (_, info) => {
    if (info.offset.x > 50) handlePrevious()
    else if (info.offset.x < -50) handleNext()
  }
  const getCardStyle = (index) => {
    let diff = index - currentIndex
    if (diff > total / 2)  diff -= total
    if (diff < -total / 2) diff += total
    if (diff === 0)  return { x: 0,      scale: 1,    opacity: 1,   rotateY: 0,   zIndex: 3 }
    if (diff === 1)  return { x: '65%',  scale: 0.75, opacity: 0.5, rotateY: -25, zIndex: 2 }
    if (diff === -1) return { x: '-65%', scale: 0.75, opacity: 0.5, rotateY: 25,  zIndex: 2 }
    return { x: diff > 0 ? '100%' : '-100%', scale: 0.5, opacity: 0, rotateY: diff > 0 ? -45 : 45, zIndex: 1 }
  }

  return (
    <div className="relative w-full h-[350px] flex items-center justify-center overflow-visible">
      <div className="relative w-full h-full flex items-center justify-center" style={{ perspective: '1500px' }}>
        {paths.map((path, index) => {
          const style        = getCardStyle(index)
          const Icon         = pathIcons[path.name] || pathIcons['Python']
          const iconColor    = iconColors[path.name] || 'text-cyan-400'
          const colors       = pathColors[path.name] || 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20'
          const buttonColors = colorMap[iconColor] || colorMap['text-cyan-400']
          return (
            <motion.div
              key={path.id}
              className="absolute w-56 h-64 cursor-pointer"
              initial={false}
              animate={{ x: style.x, scale: style.scale, opacity: style.opacity, rotateY: style.rotateY, zIndex: style.zIndex }}
              transition={{ type: 'spring', stiffness: 200, damping: 25 }}
              drag={index === currentIndex ? 'x' : false}
              dragConstraints={{ left: 0, right: 0 }}
              onDragEnd={handleDragEnd}
              onClick={() => handleCardClick(index)}
              style={{ transformStyle: 'preserve-3d' }}
            >
              <div className={`w-full h-full bg-gradient-to-b ${colors} border-2 rounded-2xl p-5 flex flex-col items-center justify-between backdrop-blur-xl shadow-2xl`}>
                <div className={`w-16 h-16 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor}`}>
                  <Icon size={32} />
                </div>
                <div className="flex-1 flex flex-col items-center justify-center">
                  <h3 className="text-xl font-bold text-white mb-1 text-center">{path.name}</h3>
                  <p className="text-gray-400 text-xs">{topicCounts[path.id] || 0} Topics</p>
                </div>
                <div className="mt-3">
                  <div className={`px-5 py-1.5 rounded-lg ${buttonColors.bg} border ${buttonColors.border}`}>
                    <span className={`${buttonColors.text} font-semibold text-xs tracking-wide`}>TAP TO STUDY</span>
                  </div>
                </div>
              </div>
            </motion.div>
          )
        })}
      </div>
    </div>
  )
}
