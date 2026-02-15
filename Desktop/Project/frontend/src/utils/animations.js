/**
 * Framer Motion Animation Variants & Utilities
 * Reusable animation configurations for PyDeck
 */

// Check if user prefers reduced motion
export const shouldReduceMotion = () => {
  return window.matchMedia('(prefers-reduced-motion: reduce)').matches;
};

// Spring physics configs
export const springConfigs = {
  gentle: { type: 'spring', stiffness: 100, damping: 15 },
  bouncy: { type: 'spring', stiffness: 400, damping: 25 },
  snappy: { type: 'spring', stiffness: 500, damping: 30 },
  smooth: { type: 'spring', stiffness: 200, damping: 20 },
};

// Page transition variants
export const pageTransition = {
  initial: { opacity: 0, y: 20 },
  animate: {
    opacity: 1,
    y: 0,
    transition: { duration: 0.4, ease: 'easeOut' }
  },
  exit: {
    opacity: 0,
    y: -20,
    transition: { duration: 0.3, ease: 'easeIn' }
  }
};

export const pageSlideUp = {
  initial: { opacity: 0, y: 30 },
  animate: {
    opacity: 1,
    y: 0,
    transition: springConfigs.smooth
  },
  exit: {
    opacity: 0,
    y: -30,
    transition: { duration: 0.2 }
  }
};

// Card entrance animations
export const cardFadeIn = {
  initial: { opacity: 0, scale: 0.95 },
  animate: {
    opacity: 1,
    scale: 1,
    transition: springConfigs.gentle
  }
};

export const cardSlideIn = {
  initial: { opacity: 0, y: 20, scale: 0.95 },
  animate: {
    opacity: 1,
    y: 0,
    scale: 1,
    transition: springConfigs.gentle
  }
};

// 3D flip variants for flashcards
export const flipCard = {
  front: {
    rotateY: 0,
    transition: springConfigs.bouncy
  },
  back: {
    rotateY: 180,
    transition: springConfigs.bouncy
  }
};

export const flipCardContent = {
  front: {
    rotateY: 0,
    opacity: 1,
    transition: { duration: 0.2 }
  },
  back: {
    rotateY: 180,
    opacity: 0,
    transition: { duration: 0.2 }
  }
};

// Stagger children pattern
export const staggerContainer = {
  animate: {
    transition: {
      staggerChildren: 0.05,
      delayChildren: 0.1
    }
  }
};

export const staggerItem = {
  initial: { opacity: 0, y: 20, scale: 0.95 },
  animate: {
    opacity: 1,
    y: 0,
    scale: 1,
    transition: springConfigs.gentle
  }
};

// Button interactions
export const buttonTap = {
  scale: 0.95,
  transition: { duration: 0.1 }
};

export const buttonHover = {
  scale: 1.02,
  transition: springConfigs.snappy
};

// Progress bar animation
export const progressBar = {
  initial: { width: 0 },
  animate: (width) => ({
    width: `${width}%`,
    transition: { duration: 0.8, ease: 'easeOut' }
  })
};

// Number counter animation helper
export const animateNumber = (target, duration = 1) => ({
  initial: 0,
  animate: target,
  transition: { duration, ease: 'easeOut' }
});

// Fade and scale
export const fadeScale = {
  initial: { opacity: 0, scale: 0.8 },
  animate: {
    opacity: 1,
    scale: 1,
    transition: springConfigs.gentle
  },
  exit: {
    opacity: 0,
    scale: 0.8,
    transition: { duration: 0.2 }
  }
};

// Slide from bottom
export const slideFromBottom = {
  initial: { y: 100, opacity: 0 },
  animate: {
    y: 0,
    opacity: 1,
    transition: springConfigs.smooth
  },
  exit: {
    y: 100,
    opacity: 0,
    transition: { duration: 0.3 }
  }
};

// Expand animation
export const expand = {
  initial: { height: 0, opacity: 0 },
  animate: {
    height: 'auto',
    opacity: 1,
    transition: springConfigs.smooth
  },
  exit: {
    height: 0,
    opacity: 0,
    transition: { duration: 0.2 }
  }
};

// Pulse animation for icons
export const pulse = {
  scale: [1, 1.1, 1],
  transition: {
    duration: 0.6,
    ease: 'easeInOut',
    repeat: Infinity,
    repeatDelay: 1
  }
};

// Shimmer effect (for loading states)
export const shimmer = {
  x: ['-100%', '100%'],
  transition: {
    duration: 1.5,
    ease: 'linear',
    repeat: Infinity,
    repeatDelay: 0.5
  }
};

// Glow effect
export const glow = {
  boxShadow: [
    '0 0 20px rgba(34, 211, 238, 0.3)',
    '0 0 30px rgba(34, 211, 238, 0.5)',
    '0 0 20px rgba(34, 211, 238, 0.3)',
  ],
  transition: {
    duration: 2,
    ease: 'easeInOut',
    repeat: Infinity
  }
};

// Get appropriate variants based on motion preferences
export const getVariants = (variants) => {
  if (shouldReduceMotion()) {
    // Return simplified variants for reduced motion
    return {
      initial: { opacity: 0 },
      animate: { opacity: 1 },
      exit: { opacity: 0 }
    };
  }
  return variants;
};
