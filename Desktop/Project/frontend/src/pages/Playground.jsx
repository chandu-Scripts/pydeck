import { useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { ArrowLeft, Terminal, Save, FolderOpen, Trash2, Pencil, Check, X, Plus } from 'lucide-react'
import CodeEditor from '../components/CodeEditor'

const DEFAULT_CODE = `# Welcome to PyDeck Python Playground!
# Write your Python code here and click Run

print("Hello, World!")

# Try some Python
name = "PyDeck"
for i in range(3):
    print(f"Learning Python with {name} — step {i + 1}")
`

const CURRENT_KEY = 'pydeck_playground_code'
const SNIPPETS_KEY = 'pydeck_snippets'

function loadSnippets() {
  try { return JSON.parse(localStorage.getItem(SNIPPETS_KEY)) || [] } catch { return [] }
}

function saveSnippets(snippets) {
  localStorage.setItem(SNIPPETS_KEY, JSON.stringify(snippets))
}

export default function Playground() {
  const navigate = useNavigate()
  const [code, setCode] = useState(() => localStorage.getItem(CURRENT_KEY) || DEFAULT_CODE)
  const [snippets, setSnippets] = useState(loadSnippets)
  const [showSnippets, setShowSnippets] = useState(false)
  const [renamingId, setRenamingId] = useState(null)
  const [renameValue, setRenameValue] = useState('')
  const [savedFlash, setSavedFlash] = useState(false)

  function handleCodeChange(val) {
    setCode(val)
    localStorage.setItem(CURRENT_KEY, val)
  }

  function handleSave() {
    const name = `Snippet ${snippets.length + 1}`
    const newSnippet = { id: Date.now(), name, code }
    const updated = [newSnippet, ...snippets]
    setSnippets(updated)
    saveSnippets(updated)
    setSavedFlash(true)
    setTimeout(() => setSavedFlash(false), 1500)
    setShowSnippets(true)
  }

  function handleLoad(snippet) {
    setCode(snippet.code)
    localStorage.setItem(CURRENT_KEY, snippet.code)
    setShowSnippets(false)
  }

  function handleDelete(id) {
    const updated = snippets.filter(s => s.id !== id)
    setSnippets(updated)
    saveSnippets(updated)
  }

  function startRename(snippet) {
    setRenamingId(snippet.id)
    setRenameValue(snippet.name)
  }

  function confirmRename(id) {
    const updated = snippets.map(s => s.id === id ? { ...s, name: renameValue.trim() || s.name } : s)
    setSnippets(updated)
    saveSnippets(updated)
    setRenamingId(null)
  }

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-white/5">
        <button onClick={() => navigate(-1)} className="text-gray-400 hover:text-white transition-colors">
          <ArrowLeft size={22} />
        </button>
        <div className="flex items-center gap-2">
          <Terminal size={18} className="text-cyan-400" />
          <h1 className="text-lg font-bold text-white">Python Playground</h1>
        </div>
        <div className="flex items-center gap-2">
          {/* Snippets button */}
          <button
            onClick={() => setShowSnippets(v => !v)}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold transition-colors ${
              showSnippets
                ? 'bg-purple-500/20 border-purple-500/40 text-purple-400'
                : 'bg-white/5 border-white/10 text-gray-400 hover:text-white'
            }`}
          >
            <FolderOpen size={14} />
            {snippets.length > 0 && <span className="bg-purple-500 text-white text-[10px] rounded-full w-4 h-4 flex items-center justify-center">{snippets.length}</span>}
          </button>
          {/* Save button */}
          <motion.button
            onClick={handleSave}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold transition-colors ${
              savedFlash
                ? 'bg-emerald-500/20 border-emerald-500/40 text-emerald-400'
                : 'bg-cyan-500/20 border-cyan-500/40 text-cyan-400 hover:bg-cyan-500/30'
            }`}
            whileTap={{ scale: 0.95 }}
          >
            <Save size={14} />
            {savedFlash ? 'Saved!' : 'Save'}
          </motion.button>
        </div>
      </div>

      {/* Editor */}
      <motion.div
        className="flex-1 px-4 py-4 pb-28"
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.4 }}
      >
        <CodeEditor
          key={code === (localStorage.getItem(CURRENT_KEY) || DEFAULT_CODE) ? 'init' : undefined}
          initialCode={code}
          height="52vh"
          onCodeChange={handleCodeChange}
        />
      </motion.div>

      {/* Snippets Panel */}
      <AnimatePresence>
        {showSnippets && (
          <>
            {/* Backdrop */}
            <motion.div
              className="fixed inset-0 bg-black/50 z-40"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              onClick={() => setShowSnippets(false)}
            />
            {/* Panel */}
            <motion.div
              className="fixed bottom-0 left-0 right-0 z-50 bg-navy-800 border-t border-white/10 rounded-t-3xl max-h-[70vh] overflow-hidden flex flex-col"
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            >
              {/* Panel header */}
              <div className="flex items-center justify-between px-5 py-4 border-b border-white/10">
                <div className="flex items-center gap-2">
                  <FolderOpen size={18} className="text-purple-400" />
                  <h2 className="text-white font-bold">My Snippets</h2>
                  <span className="text-gray-500 text-sm">({snippets.length})</span>
                </div>
                <button onClick={() => setShowSnippets(false)} className="text-gray-400 hover:text-white">
                  <X size={20} />
                </button>
              </div>

              {/* Snippets list */}
              <div className="overflow-y-auto flex-1 p-4 space-y-3">
                {snippets.length === 0 ? (
                  <div className="text-center py-12">
                    <Save size={36} className="text-gray-600 mx-auto mb-3" />
                    <p className="text-gray-400 text-sm">No snippets saved yet.</p>
                    <p className="text-gray-500 text-xs mt-1">Tap Save to save your current code.</p>
                  </div>
                ) : (
                  snippets.map((snippet, index) => (
                    <motion.div
                      key={snippet.id}
                      className="bg-navy-700/50 border border-white/10 rounded-xl p-4"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.04 }}
                    >
                      {/* Name row */}
                      <div className="flex items-center gap-2 mb-2">
                        {renamingId === snippet.id ? (
                          <>
                            <input
                              autoFocus
                              value={renameValue}
                              onChange={e => setRenameValue(e.target.value)}
                              onKeyDown={e => e.key === 'Enter' && confirmRename(snippet.id)}
                              className="flex-1 px-2 py-1 bg-navy-600 border border-cyan-500/40 rounded-lg text-white text-sm"
                            />
                            <button onClick={() => confirmRename(snippet.id)} className="text-emerald-400 hover:text-emerald-300">
                              <Check size={16} />
                            </button>
                            <button onClick={() => setRenamingId(null)} className="text-gray-500 hover:text-white">
                              <X size={16} />
                            </button>
                          </>
                        ) : (
                          <>
                            <span className="flex-1 text-white font-medium text-sm truncate">{snippet.name}</span>
                            <button onClick={() => startRename(snippet)} className="text-gray-500 hover:text-cyan-400 transition-colors">
                              <Pencil size={14} />
                            </button>
                            <button onClick={() => handleDelete(snippet.id)} className="text-gray-500 hover:text-red-400 transition-colors">
                              <Trash2 size={14} />
                            </button>
                          </>
                        )}
                      </div>

                      {/* Code preview */}
                      <pre className="text-gray-400 text-xs font-mono truncate mb-3 bg-black/30 px-2 py-1.5 rounded-lg">
                        {snippet.code.split('\n').slice(0, 2).join(' | ')}
                      </pre>

                      {/* Load button */}
                      <button
                        onClick={() => handleLoad(snippet)}
                        className="w-full py-2 rounded-lg bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 text-xs font-semibold hover:bg-cyan-500/20 transition-colors"
                      >
                        Load into Editor
                      </button>
                    </motion.div>
                  ))
                )}
              </div>
            </motion.div>
          </>
        )}
      </AnimatePresence>
    </div>
  )
}
