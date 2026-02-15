import { motion, useSpring, useTransform } from 'framer-motion'
import { useEffect } from 'react'

/**
 * AnimatedNumber - Smoothly animates number changes
 * Inspired by Aceternity UI patterns
 */
export default function AnimatedNumber({
  value,
  className = '',
  duration = 1,
  decimals = 0,
  prefix = '',
  suffix = '',
  ...props
}) {
  const spring = useSpring(0, {
    duration: duration * 1000,
    bounce: 0
  })

  const display = useTransform(spring, (latest) => {
    return prefix + latest.toFixed(decimals) + suffix
  })

  useEffect(() => {
    spring.set(value)
  }, [spring, value])

  return (
    <motion.span className={className} {...props}>
      {display}
    </motion.span>
  )
}

/**
 * Simple version without spring physics (for cases where useSpring causes issues)
 */
export function SimpleAnimatedNumber({
  value,
  className = '',
  duration = 1,
  decimals = 0,
  prefix = '',
  suffix = '',
  ...props
}) {
  return (
    <motion.span
      className={className}
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      key={value}
      transition={{ duration: 0.3 }}
      {...props}
    >
      {prefix}{value.toFixed(decimals)}{suffix}
    </motion.span>
  )
}
