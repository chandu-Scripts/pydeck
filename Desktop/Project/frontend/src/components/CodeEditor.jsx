import { useState } from 'react'
import CodeMirror from '@uiw/react-codemirror'
import { python } from '@codemirror/lang-python'
import { oneDark } from '@codemirror/theme-one-dark'
import { motion, AnimatePresence } from 'framer-motion'
import { Play, Trash2, Loader } from 'lucide-react'
import { usePythonRunner } from '../hooks/usePythonRunner'

export default function CodeEditor({ initialCode = '', height = '300px', compact = false, onCodeChange }) {
  const [code, setCode] = useState(initialCode)

  function handleChange(val) {
    setCode(val)
    onCodeChange?.(val)
  }
  const { run, output, running, error, clear } = usePythonRunner()

  return (
    <div className="rounded-2xl overflow-hidden border border-white/10 bg-[#1e2738]">
      {/* Toolbar */}
      <div className="flex items-center justify-between px-4 py-2.5 bg-navy-700/80 border-b border-white/10">
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full bg-red-500/70" />
          <div className="w-3 h-3 rounded-full bg-yellow-500/70" />
          <div className="w-3 h-3 rounded-full bg-green-500/70" />
          <span className="text-gray-400 text-xs ml-2 font-mono">python</span>
        </div>
        <div className="flex items-center gap-2">
          {output && (
            <button
              onClick={clear}
              className="flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs text-gray-400 hover:text-white hover:bg-white/10 transition-colors"
            >
              <Trash2 size={12} />
              Clear
            </button>
          )}
          <motion.button
            onClick={() => run(code)}
            disabled={running}
            className="flex items-center gap-1.5 px-3 py-1.5 rounded-lg bg-emerald-500/20 border border-emerald-500/30 text-emerald-400 text-xs font-semibold hover:bg-emerald-500/30 transition-colors disabled:opacity-50"
            whileTap={{ scale: 0.95 }}
          >
            {running ? <Loader size={13} className="animate-spin" /> : <Play size={13} />}
            {running ? 'Running...' : 'Run'}
          </motion.button>
        </div>
      </div>

      {/* Editor */}
      <CodeMirror
        value={code}
        height={height}
        theme={oneDark}
        extensions={[python()]}
        onChange={handleChange}
        style={{ fontSize: compact ? '12px' : '13px' }}
        basicSetup={{
          lineNumbers: true,
          foldGutter: false,
          dropCursor: false,
          allowMultipleSelections: false,
          indentOnInput: true,
          tabSize: 4,
        }}
      />

      {/* Output */}
      <AnimatePresence>
        {output && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
          >
            <div className="border-t border-white/10 bg-black/80 px-4 py-3">
              <p className="text-[10px] text-gray-500 uppercase font-mono mb-1.5">Output</p>
              <pre className={`text-sm font-mono whitespace-pre-wrap leading-relaxed ${error ? 'text-red-400' : 'text-emerald-400'}`}>
                {output}
              </pre>
            </div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
