import { motion } from 'framer-motion'
import { useState } from 'react'

/**
 * GlowingCard - Card component with animated border gradient glow
 * Inspired by Aceternity UI patterns
 */
export default function GlowingCard({
  children,
  className = '',
  glowColor = 'cyan',
  intensity = 'medium',
  onClick,
  ...props
}) {
  const [isHovered, setIsHovered] = useState(false)

  // Glow color configurations
  const glowColors = {
    cyan: 'from-cyan-500 via-cyan-400 to-cyan-500',
    blue: 'from-blue-500 via-blue-400 to-blue-500',
    purple: 'from-purple-500 via-purple-400 to-purple-500',
    emerald: 'from-emerald-500 via-emerald-400 to-emerald-500',
    amber: 'from-amber-500 via-amber-400 to-amber-500',
  }

  // Intensity configurations
  const intensityOpacity = {
    low: 0.2,
    medium: 0.4,
    high: 0.6,
  }

  const gradientColor = glowColors[glowColor] || glowColors.cyan
  const opacity = intensityOpacity[intensity] || intensityOpacity.medium

  return (
    <motion.div
      className={`relative group ${className}`}
      onHoverStart={() => setIsHovered(true)}
      onHoverEnd={() => setIsHovered(false)}
      onClick={onClick}
      {...props}
    >
      {/* Animated gradient border */}
      <motion.div
        className="absolute -inset-[2px] rounded-[inherit] opacity-0 group-hover:opacity-100 blur-sm transition-opacity duration-500"
        style={{
          background: `linear-gradient(90deg, ${gradientColor})`,
        }}
        animate={{
          backgroundPosition: isHovered ? ['0% 50%', '100% 50%', '0% 50%'] : '0% 50%',
        }}
        transition={{
          duration: 3,
          repeat: Infinity,
          ease: 'linear',
        }}
      />

      {/* Content */}
      <div className="relative z-10 h-full">
        {children}
      </div>
    </motion.div>
  )
}
