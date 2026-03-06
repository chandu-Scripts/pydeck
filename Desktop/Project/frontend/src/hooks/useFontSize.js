import { useState, useEffect } from 'react'

const SIZES = { normal: '14px', large: '16px', xlarge: '19px' }
const KEY = 'pydeck_font_size'

export function useFontSize() {
  const [size, setSize] = useState(() => localStorage.getItem(KEY) || 'normal')

  useEffect(() => {
    document.documentElement.style.fontSize = SIZES[size]
    localStorage.setItem(KEY, size)
  }, [size])

  return { size, setSize }
}
