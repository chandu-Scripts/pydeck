import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { ArrowLeft, ChevronLeft, ChevronRight, BookOpen, Terminal, ChevronDown } from 'lucide-react'
import CodeEditor from '../components/CodeEditor'
import SqlEditor from '../components/SqlEditor'
import { Prism as SyntaxHighlighter } from 'react-syntax-highlighter'
import { oneDark } from 'react-syntax-highlighter/dist/esm/styles/prism'
import { buttonHover, buttonTap } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'

function parseMarkdownToComponents(content) {
  const lines = content.split('\n')
  const components = []
  let currentCodeBlock = null
  let codeBlockLines = []

  for (let i = 0; i < lines.length; i++) {
    const line = lines[i]

    // Handle code blocks
    if (line.startsWith('```')) {
      if (currentCodeBlock === null) {
        // Start of code block
        currentCodeBlock = line.slice(3).trim() || 'python'
        codeBlockLines = []
      } else {
        // End of code block
        components.push({
          type: 'code',
          language: currentCodeBlock,
          content: codeBlockLines.join('\n'),
        })
        currentCodeBlock = null
        codeBlockLines = []
      }
      continue
    }

    if (currentCodeBlock !== null) {
      codeBlockLines.push(line)
      continue
    }

    // Handle headers
    if (line.startsWith('# ')) {
      components.push({ type: 'h1', content: line.slice(2) })
    } else if (line.startsWith('## ')) {
      components.push({ type: 'h2', content: line.slice(3) })
    } else if (line.startsWith('### ')) {
      components.push({ type: 'h3', content: line.slice(4) })
    }
    // Handle bullet points
    else if (line.startsWith('- ')) {
      components.push({ type: 'bullet', content: line.slice(2) })
    }
    // Handle bold text in paragraphs
    else if (line.trim()) {
      components.push({ type: 'paragraph', content: line })
    }
    // Empty lines
    else {
      components.push({ type: 'spacer' })
    }
  }

  return components
}

function renderInlineFormatting(text) {
  // Handle bold (**text**)
  const parts = text.split(/(\*\*[^*]+\*\*|`[^`]+`)/g)
  return parts.map((part, idx) => {
    if (part.startsWith('**') && part.endsWith('**')) {
      return <strong key={idx} className="text-white font-semibold">{part.slice(2, -2)}</strong>
    }
    if (part.startsWith('`') && part.endsWith('`')) {
      return <code key={idx} className="px-1.5 py-0.5 bg-navy-700 rounded text-cyan-400 text-sm font-mono">{part.slice(1, -1)}</code>
    }
    return <span key={idx}>{part}</span>
  })
}

function MarkdownRenderer({ content }) {
  const components = parseMarkdownToComponents(content)

  return (
    <div className="space-y-3">
      {components.map((comp, idx) => {
        switch (comp.type) {
          case 'h1':
            return <h1 key={idx} className="text-2xl font-bold text-white mt-6 mb-4">{comp.content}</h1>
          case 'h2':
            return <h2 key={idx} className="text-xl font-bold text-white mt-5 mb-3">{comp.content}</h2>
          case 'h3':
            return <h3 key={idx} className="text-lg font-semibold text-cyan-400 mt-4 mb-2">{comp.content}</h3>
          case 'code':
            return (
              <div key={idx} className="rounded-xl overflow-hidden my-4">
                <SyntaxHighlighter
                  language={comp.language}
                  style={oneDark}
                  customStyle={{
                    margin: 0,
                    padding: '1rem',
                    borderRadius: '0.75rem',
                    fontSize: '0.875rem',
                    background: 'rgba(30, 41, 59, 0.8)',
                  }}
                >
                  {comp.content}
                </SyntaxHighlighter>
              </div>
            )
          case 'bullet':
            return (
              <div key={idx} className="flex gap-2 text-gray-300">
                <span className="text-cyan-400">•</span>
                <span>{renderInlineFormatting(comp.content)}</span>
              </div>
            )
          case 'paragraph':
            return <p key={idx} className="text-gray-300 leading-relaxed">{renderInlineFormatting(comp.content)}</p>
          case 'spacer':
            return <div key={idx} className="h-2" />
          default:
            return null
        }
      })}
    </div>
  )
}

export default function Concept() {
  const { subtopicId } = useParams()
  const navigate = useNavigate()
  const [subtopic, setSubtopic] = useState(null)
  const [concepts, setConcepts] = useState([])
  const [currentIndex, setCurrentIndex] = useState(0)
  const [loading, setLoading] = useState(true)
  const [showEditor, setShowEditor] = useState(false)

  useEffect(() => {
    async function fetchData() {
      const [subtopicRes, conceptsRes] = await Promise.all([
        supabase
          .from('subtopics')
          .select('*, topics(name, paths(name))')
          .eq('id', subtopicId)
          .single(),
        supabase
          .from('concepts')
          .select('*')
          .eq('subtopic_id', subtopicId)
          .order('display_order'),
      ])

      setSubtopic(subtopicRes.data)
      setConcepts(conceptsRes.data || [])
      setLoading(false)
    }
    fetchData()
  }, [subtopicId])

  if (loading) {
    return <CardShuffleLoader />
  }

  if (concepts.length === 0) {
    return (
      <div className="min-h-screen flex flex-col items-center justify-center px-5">
        <BookOpen size={48} className="text-gray-600 mb-4" />
        <p className="text-gray-400 text-lg mb-4">No concepts available yet</p>
        <button onClick={() => navigate(-1)} className="text-cyan-400 hover:underline cursor-pointer">
          Go back
        </button>
      </div>
    )
  }

  const concept = concepts[currentIndex]
  const isFirst = currentIndex === 0
  const isLast = currentIndex === concepts.length - 1

  // Extract first code block from current concept
  const { firstCodeBlock, codeLanguage } = (() => {
    const parsed = parseMarkdownToComponents(concept.content)
    const codeComp = parsed.find(c => c.type === 'code')
    const lang = codeComp?.language?.toLowerCase() || 'python'
    const isSql = lang === 'sql' || lang === 'mysql'
    return {
      firstCodeBlock: codeComp ? codeComp.content : (isSql ? '-- Write your SQL here\n' : '# Write your Python here\n'),
      codeLanguage: isSql ? 'sql' : 'python',
    }
  })()

  return (
    <div className="min-h-screen flex flex-col">
      {/* Header */}
      <div className="flex items-center justify-between px-5 py-4 border-b border-white/5">
        <button
          onClick={() => navigate(`/subtopics/${subtopicId}`)}
          className="text-gray-400 hover:text-white transition-colors cursor-pointer"
        >
          <ArrowLeft size={22} />
        </button>
        <div className="text-center">
          <p className="text-xs text-gray-500">{subtopic?.name}</p>
          <p className="text-sm text-gray-400">
            {currentIndex + 1} / {concepts.length}
          </p>
        </div>
        <div className="w-6" /> {/* Spacer for alignment */}
      </div>

      {/* Progress bar */}
      <div className="px-5 py-3">
        <div className="h-1 bg-navy-700 rounded-full overflow-hidden">
          <motion.div
            className="h-full bg-gradient-to-r from-emerald-500 to-emerald-400 rounded-full"
            initial={{ width: 0 }}
            animate={{ width: `${((currentIndex + 1) / concepts.length) * 100}%` }}
            transition={{ duration: 0.5, ease: 'easeOut' }}
          />
        </div>
      </div>

      {/* Content */}
      <div className="flex-1 overflow-y-auto px-5 pb-24">
        <motion.div
          className="max-w-2xl mx-auto"
          key={currentIndex}
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ duration: 0.4 }}
        >
          <h1 className="text-xl font-bold text-white mb-6">{concept.title}</h1>
          <MarkdownRenderer content={concept.content} />

          {/* Try it in Editor */}
          <div className="mt-6 mb-4">
            <button
              onClick={() => setShowEditor(v => !v)}
              className="flex items-center gap-2 w-full px-4 py-3 rounded-xl bg-cyan-500/10 border border-cyan-500/20 text-cyan-400 font-semibold hover:bg-cyan-500/15 transition-colors"
            >
              <Terminal size={16} />
              Try it in Editor
              <motion.div
                className="ml-auto"
                animate={{ rotate: showEditor ? 180 : 0 }}
                transition={{ duration: 0.2 }}
              >
                <ChevronDown size={16} />
              </motion.div>
            </button>
            <AnimatePresence>
              {showEditor && (
                <motion.div
                  initial={{ height: 0, opacity: 0 }}
                  animate={{ height: 'auto', opacity: 1 }}
                  exit={{ height: 0, opacity: 0 }}
                  transition={{ duration: 0.25 }}
                  className="overflow-hidden mt-3"
                >
                  {codeLanguage === 'sql' ? (
                    <SqlEditor key={currentIndex} initialCode={firstCodeBlock} height="250px" compact />
                  ) : (
                    <CodeEditor key={currentIndex} initialCode={firstCodeBlock} height="250px" compact />
                  )}
                </motion.div>
              )}
            </AnimatePresence>
          </div>
        </motion.div>
      </div>

      {/* Navigation buttons */}
      <div className="fixed bottom-20 left-0 right-0 px-5 pb-4 bg-gradient-to-t from-navy-900 via-navy-900 to-transparent pt-8">
        <div className="max-w-2xl mx-auto flex gap-3">
          <motion.button
            onClick={() => setCurrentIndex(prev => prev - 1)}
            disabled={isFirst}
            className={`flex-1 py-3.5 rounded-2xl border font-semibold transition-colors flex items-center justify-center gap-2 ${
              isFirst
                ? 'bg-navy-700/30 border-navy-600/30 text-gray-600 cursor-not-allowed'
                : 'bg-navy-700/50 border-white/10 text-white hover:bg-navy-600/50 cursor-pointer'
            }`}
            whileHover={!isFirst ? buttonHover : {}}
            whileTap={!isFirst ? buttonTap : {}}
          >
            <ChevronLeft size={18} />
            Previous
          </motion.button>
          <motion.button
            onClick={() => {
              if (isLast) {
                navigate(`/subtopics/${subtopicId}`)
              } else {
                setCurrentIndex(prev => prev + 1)
              }
            }}
            className="flex-1 py-3.5 rounded-2xl bg-emerald-500/20 border border-emerald-500/20 text-emerald-400 font-semibold hover:bg-emerald-500/30 transition-colors cursor-pointer flex items-center justify-center gap-2"
            whileHover={buttonHover}
            whileTap={buttonTap}
          >
            {isLast ? 'Done' : 'Next'}
            {!isLast && <ChevronRight size={18} />}
          </motion.button>
        </div>
      </div>
    </div>
  )
}
