import { useState, useEffect } from 'react'

const KEY = 'pydeck_accent'

export const THEMES = [
  { id: 'cyan',        label: 'Cyan',        c400: '#22d3ee', c500: '#06b6d4', c600: '#0891b2' },
  { id: 'sky',         label: 'Sky',         c400: '#38bdf8', c500: '#0ea5e9', c600: '#0284c7' },
  { id: 'blue',        label: 'Blue',        c400: '#60a5fa', c500: '#3b82f6', c600: '#2563eb' },
  { id: 'indigo',      label: 'Indigo',      c400: '#818cf8', c500: '#6366f1', c600: '#4f46e5' },
  { id: 'violet',      label: 'Violet',      c400: '#a78bfa', c500: '#8b5cf6', c600: '#7c3aed' },
  { id: 'purple',      label: 'Purple',      c400: '#c084fc', c500: '#a855f7', c600: '#9333ea' },
  { id: 'fuchsia',     label: 'Fuchsia',     c400: '#e879f9', c500: '#d946ef', c600: '#c026d3' },
  { id: 'pink',        label: 'Pink',        c400: '#f472b6', c500: '#ec4899', c600: '#db2777' },
  { id: 'rose',        label: 'Rose',        c400: '#fb7185', c500: '#f43f5e', c600: '#e11d48' },
  { id: 'red',         label: 'Red',         c400: '#f87171', c500: '#ef4444', c600: '#dc2626' },
  { id: 'orange',      label: 'Orange',      c400: '#fb923c', c500: '#f97316', c600: '#ea580c' },
  { id: 'amber',       label: 'Amber',       c400: '#fbbf24', c500: '#f59e0b', c600: '#d97706' },
  { id: 'yellow',      label: 'Yellow',      c400: '#facc15', c500: '#eab308', c600: '#ca8a04' },
  { id: 'lime',        label: 'Lime',        c400: '#a3e635', c500: '#84cc16', c600: '#65a30d' },
  { id: 'green',       label: 'Green',       c400: '#4ade80', c500: '#22c55e', c600: '#16a34a' },
  { id: 'emerald',     label: 'Emerald',     c400: '#34d399', c500: '#10b981', c600: '#059669' },
  { id: 'teal',        label: 'Teal',        c400: '#2dd4bf', c500: '#14b8a6', c600: '#0d9488' },
  { id: 'white',       label: 'White',       c400: '#f1f5f9', c500: '#e2e8f0', c600: '#cbd5e1' },
  { id: 'slate',       label: 'Slate',       c400: '#94a3b8', c500: '#64748b', c600: '#475569' },
  { id: 'coral',       label: 'Coral',       c400: '#ff7f7f', c500: '#ff6b6b', c600: '#ee5a5a' },
  { id: 'gold',        label: 'Gold',        c400: '#ffd700', c500: '#f5c400', c600: '#d4a900' },
  { id: 'mint',        label: 'Mint',        c400: '#98ffcc', c500: '#6ef0aa', c600: '#3ddc82' },
  { id: 'lavender',    label: 'Lavender',    c400: '#d8b4fe', c500: '#c4b5fd', c600: '#a78bfa' },
  { id: 'peach',       label: 'Peach',       c400: '#ffb347', c500: '#ffa07a', c600: '#ff8c69' },
]

function applyTheme(themeId) {
  const theme = THEMES.find(t => t.id === themeId) || THEMES[0]
  const root = document.documentElement
  root.style.setProperty('--color-cyan-400', theme.c400)
  root.style.setProperty('--color-cyan-500', theme.c500)
  root.style.setProperty('--color-cyan-600', theme.c600)
}

export function useTheme() {
  const [accent, setAccent] = useState(() => localStorage.getItem(KEY) || 'cyan')

  useEffect(() => {
    applyTheme(accent)
    localStorage.setItem(KEY, accent)
  }, [accent])

  return { accent, setAccent, themes: THEMES }
}
