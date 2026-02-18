import { useState, useEffect, useRef } from 'react'
import { motion } from 'framer-motion'

const colorMap = {
  'text-blue-400': { bg: 'bg-blue-500/10', border: 'border-blue-500/30', text: 'text-blue-400' },
  'text-yellow-400': { bg: 'bg-yellow-500/10', border: 'border-yellow-500/30', text: 'text-yellow-400' },
  'text-gray-300': { bg: 'bg-gray-500/10', border: 'border-gray-500/30', text: 'text-gray-300' },
  'text-green-400': { bg: 'bg-green-500/10', border: 'border-green-500/30', text: 'text-green-400' },
  'text-orange-400': { bg: 'bg-orange-500/10', border: 'border-orange-500/30', text: 'text-orange-400' },
  'text-purple-400': { bg: 'bg-purple-500/10', border: 'border-purple-500/30', text: 'text-purple-400' },
  'text-cyan-400': { bg: 'bg-cyan-500/10', border: 'border-cyan-500/30', text: 'text-cyan-400' },
}

function PathCard({ path, pathIcons, iconColors, pathColors, topicCounts, onClick, style = {} }) {
  const Icon = pathIcons[path.name] || pathIcons['Python']
  const iconColor = iconColors[path.name] || 'text-cyan-400'
  const colors = pathColors[path.name] || 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20'
  const buttonColors = colorMap[iconColor] || colorMap['text-cyan-400']

  return (
    <div
      style={style}
      onClick={onClick}
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
    </div>
  )
}

export default function PathCarousel({ paths, pathIcons, iconColors, pathColors, topicCounts, onPathClick, onIndexChange, orbitMode = false }) {
  const [currentIndex, setCurrentIndex] = useState(0)
  const angleRef = useRef(0)
  const drumRef = useRef(null)
  const rafRef = useRef(null)

  // Notify parent when index changes
  useEffect(() => {
    if (onIndexChange && paths[currentIndex]) {
      onIndexChange(currentIndex)
    }
  }, [currentIndex, onIndexChange, paths])

  // Cylinder rotation using requestAnimationFrame for butter-smooth 60fps
  useEffect(() => {
    if (!orbitMode) {
      if (rafRef.current) cancelAnimationFrame(rafRef.current)
      return
    }

    const SPEED = 0.4 // degrees per frame at 60fps (~24 seconds per rotation)

    function animate() {
      angleRef.current = (angleRef.current + SPEED) % 360
      if (drumRef.current) {
        drumRef.current.style.transform = `rotateX(8deg) rotateY(${angleRef.current}deg)`
      }
      rafRef.current = requestAnimationFrame(animate)
    }

    rafRef.current = requestAnimationFrame(animate)
    return () => {
      if (rafRef.current) cancelAnimationFrame(rafRef.current)
    }
  }, [orbitMode])

  // ===== CYLINDER / DRUM MODE =====
  if (orbitMode) {
    const total = paths.length
    if (total === 0) return null

    const CARD_W = 224  // px — matches w-56
    const CARD_H = 256  // px — matches h-64
    // Prism apothem: flat card edges share the exact same edge in 3D (no gap, no overlap)
    // radius = W / (2 * tan(π/n))  →  for n=6 cards: 224 / (2*tan(30°)) ≈ 194px
    const radius = Math.round(CARD_W / (2 * Math.tan(Math.PI / total)))
    const anglePerCard = 360 / total

    return (
      <div
        className="relative w-full h-[350px] flex items-center justify-center overflow-visible"
        style={{ perspective: '2000px', perspectiveOrigin: '50% 50%' }}
      >
        {/* Rotating drum — we mutate style directly via ref for smooth RAF animation */}
        <div
          ref={drumRef}
          style={{
            position: 'relative',
            width: 0,
            height: 0,
            transformStyle: 'preserve-3d',
            transform: `rotateX(8deg) rotateY(0deg)`,
          }}
        >
          {paths.map((path, index) => {
            const cardAngle = index * anglePerCard
            return (
              <PathCard
                key={path.id}
                path={path}
                pathIcons={pathIcons}
                iconColors={iconColors}
                pathColors={pathColors}
                topicCounts={topicCounts}
                onClick={() => onPathClick(path)}
                style={{
                  position: 'absolute',
                  width: `${CARD_W}px`,
                  height: `${CARD_H}px`,
                  left: `-${CARD_W / 2}px`,
                  top: `-${CARD_H / 2}px`,
                  transform: `rotateY(${cardAngle}deg) translateZ(${radius}px)`,
                  cursor: 'pointer',
                }}
              />
            )
          })}
        </div>
      </div>
    )
  }

  // ===== REGULAR CAROUSEL MODE =====
  const handlePrevious = () => {
    setCurrentIndex((prev) => (prev === 0 ? paths.length - 1 : prev - 1))
  }

  const handleNext = () => {
    setCurrentIndex((prev) => (prev === paths.length - 1 ? 0 : prev + 1))
  }

  const handleCardClick = (index) => {
    if (index === currentIndex) {
      onPathClick(paths[index])
    } else if (index > currentIndex) {
      handleNext()
    } else {
      handlePrevious()
    }
  }

  const handleDragEnd = (event, info) => {
    if (info.offset.x > 50) handlePrevious()
    else if (info.offset.x < -50) handleNext()
  }

  const getCardStyle = (index) => {
    const total = paths.length
    let diff = index - currentIndex
    if (diff > total / 2) diff -= total
    if (diff < -total / 2) diff += total

    if (diff === 0) return { x: 0, scale: 1, opacity: 1, rotateY: 0, zIndex: 3 }
    if (diff === 1) return { x: '65%', scale: 0.75, opacity: 0.5, rotateY: -25, zIndex: 2 }
    if (diff === -1) return { x: '-65%', scale: 0.75, opacity: 0.5, rotateY: 25, zIndex: 2 }
    return { x: diff > 0 ? '100%' : '-100%', scale: 0.5, opacity: 0, rotateY: diff > 0 ? -45 : 45, zIndex: 1 }
  }

  return (
    <div className="relative w-full h-[350px] flex items-center justify-center overflow-visible">
      <div className="relative w-full h-full flex items-center justify-center" style={{ perspective: '1500px' }}>
        {paths.map((path, index) => {
          const style = getCardStyle(index)
          const Icon = pathIcons[path.name] || pathIcons['Python']
          const iconColor = iconColors[path.name] || 'text-cyan-400'
          const colors = pathColors[path.name] || 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20'
          const buttonColors = colorMap[iconColor] || colorMap['text-cyan-400']

          return (
            <motion.div
              key={path.id}
              className="absolute w-56 h-64 cursor-pointer"
              initial={false}
              animate={{
                x: style.x,
                scale: style.scale,
                opacity: style.opacity,
                rotateY: style.rotateY,
                zIndex: style.zIndex,
              }}
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
