import { useState } from 'react'
import CodeMirror from '@uiw/react-codemirror'
import { sql } from '@codemirror/lang-sql'
import { oneDark } from '@codemirror/theme-one-dark'
import { motion, AnimatePresence } from 'framer-motion'
import { Play, Trash2, Loader, RefreshCw, Database } from 'lucide-react'
import { useSqlRunner } from '../hooks/useSqlRunner'

export default function SqlEditor({ initialCode = '', height = '300px', compact = false }) {
  const [code, setCode] = useState(initialCode)
  const { run, output, columns, rows, running, error, dbReady, clear, resetDb } = useSqlRunner()

  const hasTable = columns.length > 0

  return (
    <div className="rounded-2xl overflow-hidden border border-white/10 bg-[#1e2738]">
      {/* Toolbar */}
      <div className="flex items-center justify-between px-4 py-2.5 bg-navy-700/80 border-b border-white/10">
        <div className="flex items-center gap-2">
          <div className="w-3 h-3 rounded-full bg-red-500/70" />
          <div className="w-3 h-3 rounded-full bg-yellow-500/70" />
          <div className="w-3 h-3 rounded-full bg-green-500/70" />
          <span className="text-gray-400 text-xs ml-2 font-mono">sql</span>
          {!dbReady && <span className="text-yellow-400 text-xs ml-1">Loading engine...</span>}
        </div>
        <div className="flex items-center gap-2">
          {(output || hasTable) && (
            <button
              onClick={clear}
              className="flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs text-gray-400 hover:text-white hover:bg-white/10 transition-colors"
            >
              <Trash2 size={12} />
              Clear
            </button>
          )}
          <button
            onClick={resetDb}
            disabled={!dbReady}
            className="flex items-center gap-1 px-2.5 py-1 rounded-lg text-xs text-gray-400 hover:text-orange-400 hover:bg-white/10 transition-colors disabled:opacity-40"
            title="Reset database to sample data"
          >
            <RefreshCw size={12} />
            Reset DB
          </button>
          <motion.button
            onClick={() => run(code)}
            disabled={running || !dbReady}
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
        extensions={[sql()]}
        onChange={setCode}
        style={{ fontSize: compact ? '12px' : '13px' }}
        basicSetup={{
          lineNumbers: true,
          foldGutter: false,
          tabSize: 2,
        }}
      />

      {/* Output */}
      <AnimatePresence>
        {(output || hasTable) && (
          <motion.div
            initial={{ height: 0, opacity: 0 }}
            animate={{ height: 'auto', opacity: 1 }}
            exit={{ height: 0, opacity: 0 }}
            transition={{ duration: 0.2 }}
          >
            <div className="border-t border-white/10 bg-black/80 px-4 py-3 overflow-x-auto">
              <p className="text-[10px] text-gray-500 uppercase font-mono mb-2">Output</p>

              {/* Table result */}
              {hasTable ? (
                <table className="text-xs font-mono w-full border-collapse">
                  <thead>
                    <tr>
                      {columns.map(col => (
                        <th key={col} className="text-cyan-400 text-left px-3 py-1.5 border-b border-white/10 whitespace-nowrap">{col}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {rows.map((row, i) => (
                      <tr key={i} className={i % 2 === 0 ? 'bg-white/5' : ''}>
                        {row.map((cell, j) => (
                          <td key={j} className="text-gray-300 px-3 py-1.5 border-b border-white/5 whitespace-nowrap">{cell ?? 'NULL'}</td>
                        ))}
                      </tr>
                    ))}
                  </tbody>
                </table>
              ) : (
                <pre className={`text-sm font-mono whitespace-pre-wrap ${error ? 'text-red-400' : 'text-emerald-400'}`}>
                  {output}
                </pre>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Sample tables hint */}
      <div className="px-4 py-2 bg-navy-700/40 border-t border-white/5 flex items-center gap-2 flex-wrap">
        <Database size={11} className="text-gray-500 flex-shrink-0" />
        <span className="text-[10px] text-gray-500">Sample tables:</span>
        {['students', 'courses', 'enrollments', 'products', 'orders'].map(t => (
          <span key={t} className="text-[10px] font-mono text-cyan-500/70 bg-cyan-500/10 px-1.5 py-0.5 rounded">{t}</span>
        ))}
      </div>
    </div>
  )
}
