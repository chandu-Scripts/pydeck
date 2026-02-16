import { useState, useEffect } from 'react'
import { motion } from 'framer-motion'

export default function PathCarousel({ paths, pathIcons, iconColors, pathColors, topicCounts, onPathClick, onIndexChange, orbitMode = false }) {
  const [currentIndex, setCurrentIndex] = useState(0)
  const [direction, setDirection] = useState(0)
  const [orbitAngle, setOrbitAngle] = useState(0)

  // Notify parent when index changes
  useEffect(() => {
    if (onIndexChange && paths[currentIndex]) {
      onIndexChange(currentIndex)
    }
  }, [currentIndex, onIndexChange, paths])

  // Orbit animation
  useEffect(() => {
    if (!orbitMode) return

    const interval = setInterval(() => {
      setOrbitAngle(prev => (prev + 1) % 360)
    }, 30) // Update every 30ms for smooth rotation

    return () => clearInterval(interval)
  }, [orbitMode])

  // Calculate circular orbit positions with 3D perspective (top-down view)
  const getOrbitStyle = (index) => {
    const total = paths.length
    const anglePerCard = 360 / total
    const currentAngle = orbitAngle + (index * anglePerCard)
    const radians = (currentAngle * Math.PI) / 180

    const radiusX = 150 // horizontal spread
    const radiusY = 60  // depth spread (reduced to keep cards visible)

    // Calculate position
    const x = Math.sin(radians) * radiusX
    const yRaw = Math.cos(radians) * radiusY

    // Add offset to move orbit down (negative value pushes down because of -y later)
    const yOffset = -40 // Negative = moves down
    const y = yRaw + yOffset

    // Calculate depth (0 to 1, where 1 is closest/front)
    // Cards at bottom (y > 0) are closer, cards at top (y < 0) are farther
    const depth = (yRaw + radiusY) / (radiusY * 2)

    // Scale based on depth: closer = bigger (1.0), farther = smaller (0.7)
    const scale = 0.7 + (depth * 0.3)

    // Opacity based on depth: closer = opaque (1), farther = transparent (0.5)
    const opacity = 0.5 + (depth * 0.5)

    // Z-index: closer cards on top
    const zIndex = Math.floor(depth * 10)

    return {
      x: x,
      y: -y, // Negative because CSS y increases downward
      scale: scale,
      opacity: opacity,
      rotateY: 0,
      zIndex: zIndex,
    }
  }

  // Calculate positions for 3D carousel with proper wrapping
  const getCardStyle = (index) => {
    // Use orbit positioning if orbit mode is enabled
    if (orbitMode) {
      return getOrbitStyle(index)
    }

    const total = paths.length
    let diff = index - currentIndex

    // Handle wrap-around for circular effect
    if (diff > total / 2) diff -= total
    if (diff < -total / 2) diff += total

    // Center card
    if (diff === 0) {
      return {
        x: 0,
        scale: 1,
        opacity: 1,
        rotateY: 0,
        zIndex: 3,
      }
    }
    // Right card
    else if (diff === 1) {
      return {
        x: '65%',
        scale: 0.75,
        opacity: 0.5,
        rotateY: -25,
        zIndex: 2,
      }
    }
    // Left card
    else if (diff === -1) {
      return {
        x: '-65%',
        scale: 0.75,
        opacity: 0.5,
        rotateY: 25,
        zIndex: 2,
      }
    }
    // Hidden cards
    else {
      return {
        x: diff > 0 ? '100%' : '-100%',
        scale: 0.5,
        opacity: 0,
        rotateY: diff > 0 ? -45 : 45,
        zIndex: 1,
      }
    }
  }

  const handlePrevious = () => {
    setDirection(-1)
    setCurrentIndex((prev) => (prev === 0 ? paths.length - 1 : prev - 1))
  }

  const handleNext = () => {
    setDirection(1)
    setCurrentIndex((prev) => (prev === paths.length - 1 ? 0 : prev + 1))
  }

  const handleCardClick = (index) => {
    if (index === currentIndex) {
      // Click on center card - navigate
      onPathClick(paths[index])
    } else if (index > currentIndex) {
      handleNext()
    } else {
      handlePrevious()
    }
  }

  // Drag to swipe
  const handleDragEnd = (event, info) => {
    const swipeThreshold = 50
    if (info.offset.x > swipeThreshold) {
      handlePrevious()
    } else if (info.offset.x < -swipeThreshold) {
      handleNext()
    }
  }

  return (
    <div className="relative w-full h-[350px] flex items-center justify-center overflow-visible">
      {/* Carousel Container */}
      <div className="relative w-full h-full flex items-center justify-center" style={{ perspective: '1500px' }}>
        {paths.map((path, index) => {
          const Icon = pathIcons[path.name] || pathIcons['Python']
          const iconColor = iconColors[path.name] || 'text-cyan-400'
          const colors = pathColors[path.name] || 'from-cyan-500/20 to-cyan-600/10 border-cyan-500/20'
          const style = getCardStyle(index)

          // Extract color name for button styling
          const colorMap = {
            'text-blue-400': { bg: 'bg-blue-500/10', border: 'border-blue-500/30', text: 'text-blue-400' },
            'text-yellow-400': { bg: 'bg-yellow-500/10', border: 'border-yellow-500/30', text: 'text-yellow-400' },
            'text-gray-300': { bg: 'bg-gray-500/10', border: 'border-gray-500/30', text: 'text-gray-300' },
            'text-green-400': { bg: 'bg-green-500/10', border: 'border-green-500/30', text: 'text-green-400' },
            'text-cyan-400': { bg: 'bg-cyan-500/10', border: 'border-cyan-500/30', text: 'text-cyan-400' },
          }
          const buttonColors = colorMap[iconColor] || colorMap['text-cyan-400']

          return (
            <motion.div
              key={path.id}
              className={`absolute w-56 h-64 ${orbitMode ? 'cursor-default' : 'cursor-pointer'}`}
              initial={false}
              animate={{
                x: style.x,
                y: style.y || 0,
                scale: style.scale,
                opacity: style.opacity,
                rotateY: style.rotateY,
                zIndex: style.zIndex,
              }}
              transition={{
                type: orbitMode ? 'tween' : 'spring',
                stiffness: 300,
                damping: 30,
                duration: orbitMode ? 0 : undefined,
              }}
              drag={!orbitMode && index === currentIndex ? 'x' : false}
              dragConstraints={{ left: 0, right: 0 }}
              onDragEnd={!orbitMode ? handleDragEnd : undefined}
              onClick={!orbitMode ? () => handleCardClick(index) : undefined}
              style={{
                transformStyle: 'preserve-3d',
              }}
            >
              {/* Card */}
              <div className={`w-full h-full bg-gradient-to-b ${colors} border-2 rounded-2xl p-5 flex flex-col items-center justify-between backdrop-blur-xl shadow-2xl`}>
                {/* Icon */}
                <div className={`w-16 h-16 rounded-xl bg-navy-700/50 flex items-center justify-center ${iconColor}`}>
                  <Icon size={32} />
                </div>

                {/* Path Name */}
                <div className="flex-1 flex flex-col items-center justify-center">
                  <h3 className="text-xl font-bold text-white mb-1 text-center">{path.name}</h3>
                  <p className="text-gray-400 text-xs">
                    {topicCounts[path.id] || 0} Topics
                  </p>
                </div>

                {/* Tap to Study */}
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
