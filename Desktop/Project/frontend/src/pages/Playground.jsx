import { useState, useRef } from 'react'
import { useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { ArrowLeft, Terminal, Save, FolderOpen, Trash2, Pencil, Check, X, Database } from 'lucide-react'
import CodeEditor from '../components/CodeEditor'
import SqlEditor from '../components/SqlEditor'

const DEFAULT_PYTHON = `# Welcome to PyDeck Python Playground!
print("Hello, World!")

name = "PyDeck"
for i in range(3):
    print(f"Learning Python with {name} — step {i + 1}")
`

const DEFAULT_SQL = `-- Welcome to PyDeck SQL Playground!
-- Sample tables: students, courses, enrollments, products, orders

SELECT * FROM students;
`

const SNIPPETS_KEY = 'pydeck_snippets'

function loadSnippets() {
  try { return JSON.parse(localStorage.getItem(SNIPPETS_KEY)) || [] } catch { return [] }
}
function saveSnippets(snippets) {
  localStorage.setItem(SNIPPETS_KEY, JSON.stringify(snippets))
}

export default function Playground() {
  const navigate = useNavigate()
  const [tab, setTab] = useState('python') // 'python' | 'sql'
  const [pyCode, setPyCode] = useState(() => localStorage.getItem('pydeck_playground_py') || DEFAULT_PYTHON)
  const [sqlCode, setSqlCode] = useState(() => localStorage.getItem('pydeck_playground_sql') || DEFAULT_SQL)
  const [snippets, setSnippets] = useState(loadSnippets)
  const [showSnippets, setShowSnippets] = useState(false)
  const [renamingId, setRenamingId] = useState(null)
  const [renameValue, setRenameValue] = useState('')
  const [savedFlash, setSavedFlash] = useState(false)

  const currentCode = tab === 'python' ? pyCode : sqlCode

  function handleCodeChange(val) {
    if (tab === 'python') {
      setPyCode(val)
      localStorage.setItem('pydeck_playground_py', val)
    } else {
      setSqlCode(val)
      localStorage.setItem('pydeck_playground_sql', val)
    }
  }

  function handleSave() {
    const name = `${tab === 'python' ? 'Python' : 'SQL'} Snippet ${snippets.length + 1}`
    const newSnippet = { id: Date.now(), name, code: currentCode, lang: tab }
    const updated = [newSnippet, ...snippets]
    setSnippets(updated)
    saveSnippets(updated)
    setSavedFlash(true)
    setTimeout(() => setSavedFlash(false), 1500)
    setShowSnippets(true)
  }

  function handleLoad(snippet) {
    if (snippet.lang === 'python') {
      setPyCode(snippet.code)
      localStorage.setItem('pydeck_playground_py', snippet.code)
      setTab('python')
    } else {
      setSqlCode(snippet.code)
      localStorage.setItem('pydeck_playground_sql', snippet.code)
      setTab('sql')
    }
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
    <div className="fixed inset-0 flex flex-col overflow-hidden">
      {/* Header */}
      <div className="flex-shrink-0 flex items-center justify-between px-5 py-4 border-b border-white/5">
        <button onClick={() => navigate(-1)} className="text-gray-400 hover:text-white transition-colors">
          <ArrowLeft size={22} />
        </button>
        <div className="flex items-center gap-2">
          <Terminal size={18} className="text-cyan-400" />
          <h1 className="text-lg font-bold text-white">Playground</h1>
        </div>
        <div className="flex items-center gap-2">
          <button
            onClick={() => setShowSnippets(v => !v)}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold transition-colors ${
              showSnippets ? 'bg-purple-500/20 border-purple-500/40 text-purple-400' : 'bg-white/5 border-white/10 text-gray-400 hover:text-white'
            }`}
          >
            <FolderOpen size={14} />
            {snippets.length > 0 && (
              <span className="bg-purple-500 text-white text-[10px] rounded-full w-4 h-4 flex items-center justify-center">
                {snippets.length}
              </span>
            )}
          </button>
          <motion.button
            onClick={handleSave}
            className={`flex items-center gap-1.5 px-3 py-1.5 rounded-lg border text-xs font-semibold transition-colors ${
              savedFlash ? 'bg-emerald-500/20 border-emerald-500/40 text-emerald-400' : 'bg-cyan-500/20 border-cyan-500/40 text-cyan-400 hover:bg-cyan-500/30'
            }`}
            whileTap={{ scale: 0.95 }}
          >
            <Save size={14} />
            {savedFlash ? 'Saved!' : 'Save'}
          </motion.button>
        </div>
      </div>

      {/* Tab switcher */}
      <div className="flex-shrink-0 flex gap-2 px-4 pt-3 pb-2">
        <button
          onClick={() => setTab('python')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-semibold transition-all border ${
            tab === 'python'
              ? 'bg-blue-500/20 border-blue-500/40 text-blue-400'
              : 'bg-white/5 border-white/10 text-gray-400 hover:text-white'
          }`}
        >
          <Terminal size={15} />
          Python
        </button>
        <button
          onClick={() => setTab('sql')}
          className={`flex items-center gap-2 px-4 py-2 rounded-xl text-sm font-semibold transition-all border ${
            tab === 'sql'
              ? 'bg-yellow-500/20 border-yellow-500/40 text-yellow-400'
              : 'bg-white/5 border-white/10 text-gray-400 hover:text-white'
          }`}
        >
          <Database size={15} />
          SQL
        </button>
      </div>

      {/* Editor */}
      <motion.div
        className="flex-1 min-h-0 px-4 pb-4 overflow-hidden"
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        key={tab}
        transition={{ duration: 0.2 }}
      >
        {tab === 'python' ? (
          <CodeEditor initialCode={pyCode} height="100%" onCodeChange={handleCodeChange} />
        ) : (
          <SqlEditor initialCode={sqlCode} height="100%" onCodeChange={handleCodeChange} />
        )}
      </motion.div>

      {/* Snippets Panel */}
      <AnimatePresence>
        {showSnippets && (
          <div className="fixed inset-0 bg-black/80 backdrop-blur-sm flex items-center justify-center z-50 p-5">
            <motion.div
              className="w-full max-w-lg flex flex-col rounded-3xl border-2 border-purple-500/40"
              style={{
                background: 'linear-gradient(to bottom, #0f1a2e, #0a1220)',
                maxHeight: '80vh',
                boxShadow: '0 0 50px rgba(168,85,247,0.3)',
              }}
              initial={{ opacity: 0, scale: 0.85 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.85 }}
              transition={{ type: 'spring', stiffness: 300, damping: 25 }}
              onClick={e => e.stopPropagation()}
            >
              {/* Header */}
              <div className="flex items-center justify-between px-5 py-4 border-b border-white/10 flex-shrink-0">
                <div className="flex items-center gap-2">
                  <FolderOpen size={18} className="text-purple-400" />
                  <h2 className="text-white font-bold">My Snippets</h2>
                  <span className="text-gray-500 text-sm">({snippets.length})</span>
                </div>
                <button onClick={() => setShowSnippets(false)} className="text-gray-400 hover:text-white transition-colors">
                  <X size={20} />
                </button>
              </div>

              {/* Scrollable list */}
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
                      className="bg-white/5 border border-white/10 rounded-xl p-4"
                      initial={{ opacity: 0, y: 10 }}
                      animate={{ opacity: 1, y: 0 }}
                      transition={{ delay: index * 0.04 }}
                    >
                      <div className="flex items-center gap-2 mb-2">
                        <span className={`text-[10px] px-1.5 py-0.5 rounded font-mono font-bold ${
                          snippet.lang === 'sql' ? 'bg-yellow-500/20 text-yellow-400' : 'bg-blue-500/20 text-blue-400'
                        }`}>
                          {snippet.lang?.toUpperCase() || 'PY'}
                        </span>
                        {renamingId === snippet.id ? (
                          <>
                            <input
                              autoFocus
                              value={renameValue}
                              onChange={e => setRenameValue(e.target.value)}
                              onKeyDown={e => e.key === 'Enter' && confirmRename(snippet.id)}
                              className="flex-1 px-2 py-1 bg-white/10 border border-cyan-500/40 rounded-lg text-white text-sm"
                            />
                            <button onClick={() => confirmRename(snippet.id)} className="text-emerald-400"><Check size={16} /></button>
                            <button onClick={() => setRenamingId(null)} className="text-gray-500"><X size={16} /></button>
                          </>
                        ) : (
                          <>
                            <span className="flex-1 text-white font-medium text-sm truncate">{snippet.name}</span>
                            <button onClick={() => startRename(snippet)} className="text-gray-500 hover:text-cyan-400 transition-colors"><Pencil size={14} /></button>
                            <button onClick={() => handleDelete(snippet.id)} className="text-gray-500 hover:text-red-400 transition-colors"><Trash2 size={14} /></button>
                          </>
                        )}
                      </div>
                      <pre className="text-gray-400 text-xs font-mono truncate mb-3 bg-black/30 px-2 py-1.5 rounded-lg">
                        {snippet.code.split('\n').filter(l => l.trim()).slice(0, 2).join(' | ')}
                      </pre>
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
          </div>
        )}
      </AnimatePresence>
    </div>
  )
}
