import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion } from 'framer-motion'
import { ArrowLeft, Terminal } from 'lucide-react'
import CodeEditor from '../components/CodeEditor'

const DEFAULT_CODE = `# Welcome to PyDeck Python Playground!
# Write your Python code here and click Run

print("Hello, World!")

# Try some Python
name = "PyDeck"
for i in range(3):
    print(f"Learning Python with {name} — step {i + 1}")
`

const STORAGE_KEY = 'pydeck_playground_code'

export default function Playground() {
  const navigate = useNavigate()
  const [code] = useState(() => localStorage.getItem(STORAGE_KEY) || DEFAULT_CODE)

  function handleChange(newCode) {
    localStorage.setItem(STORAGE_KEY, newCode)
  }

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-white/5">
        <button
          onClick={() => navigate(-1)}
          className="text-gray-400 hover:text-white transition-colors"
        >
          <ArrowLeft size={22} />
        </button>
        <div className="flex items-center gap-2">
          <Terminal size={18} className="text-cyan-400" />
          <h1 className="text-lg font-bold text-white">Python Playground</h1>
        </div>
        <div className="w-6" />
      </div>

      {/* Editor */}
      <motion.div
        className="flex-1 px-4 py-5 pb-28"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
      >
        <p className="text-gray-500 text-xs mb-3">Code is saved automatically in your browser.</p>
        <CodeEditor
          initialCode={code}
          height="55vh"
          onCodeChange={handleChange}
        />
      </motion.div>
    </div>
  )
}
