import { motion } from 'framer-motion'

/**
 * ShimmerButton - Button with animated shimmer effect on hover
 * Inspired by Aceternity UI patterns
 */
export default function ShimmerButton({
  children,
  className = '',
  variant = 'primary',
  onClick,
  disabled = false,
  ...props
}) {
  // Variant configurations
  const variants = {
    primary: 'bg-cyan-500/20 border-cyan-500/20 text-cyan-400 hover:bg-cyan-500/30',
    success: 'bg-emerald-500/20 border-emerald-500/20 text-emerald-400 hover:bg-emerald-500/30',
    danger: 'bg-red-500/20 border-red-500/20 text-red-400 hover:bg-red-500/30',
    secondary: 'bg-navy-700/50 border-white/10 text-white hover:bg-navy-700/70',
  }

  const shimmerColors = {
    primary: 'rgba(34, 211, 238, 0.5)',
    success: 'rgba(16, 185, 129, 0.5)',
    danger: 'rgba(239, 68, 68, 0.5)',
    secondary: 'rgba(255, 255, 255, 0.3)',
  }

  const buttonVariant = variants[variant] || variants.primary
  const shimmerColor = shimmerColors[variant] || shimmerColors.primary

  return (
    <motion.button
      className={`relative overflow-hidden border rounded-2xl font-semibold transition-colors ${buttonVariant} ${className} ${
        disabled ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'
      }`}
      onClick={disabled ? undefined : onClick}
      disabled={disabled}
      whileHover={disabled ? {} : { scale: 1.02 }}
      whileTap={disabled ? {} : { scale: 0.98 }}
      {...props}
    >
      {/* Shimmer effect */}
      {!disabled && (
        <motion.div
          className="absolute inset-0 -translate-x-full"
          style={{
            background: `linear-gradient(90deg, transparent, ${shimmerColor}, transparent)`,
          }}
          whileHover={{
            translateX: ['100%', '-100%'],
            transition: {
              duration: 0.8,
              ease: 'easeInOut',
            },
          }}
        />
      )}

      {/* Content */}
      <span className="relative z-10">{children}</span>
    </motion.button>
  )
}
