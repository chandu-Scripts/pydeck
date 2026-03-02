import { useEffect, useState } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import { motion, AnimatePresence } from 'framer-motion'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'
import { ArrowLeft, BookOpen, HelpCircle, Upload, X, CheckCircle, AlertCircle } from 'lucide-react'
import { staggerContainer, staggerItem, buttonTap } from '../utils/animations'
import CardShuffleLoader from '../components/CardShuffleLoader'
import ErrorScreen from '../components/ErrorScreen'

const REQUIRED_FIELDS = ['question', 'option_a', 'option_b', 'option_c', 'option_d', 'correct_option', 'difficulty']
const VALID_OPTIONS = ['a', 'b', 'c', 'd']
const VALID_DIFFICULTY = ['easy', 'medium', 'hard']

function validateQuestions(parsed) {
  if (!Array.isArray(parsed)) return 'JSON must be an array [ ... ]'
  if (parsed.length === 0) return 'Array is empty'
  for (let i = 0; i < parsed.length; i++) {
    const q = parsed[i]
    for (const field of REQUIRED_FIELDS) {
      if (!q[field] || !String(q[field]).trim()) {
        return `Question ${i + 1}: missing "${field}"`
      }
    }
    if (!VALID_OPTIONS.includes(q.correct_option.toLowerCase())) {
      return `Question ${i + 1}: correct_option must be a, b, c, or d`
    }
    if (!VALID_DIFFICULTY.includes(q.difficulty.toLowerCase())) {
      return `Question ${i + 1}: difficulty must be easy, medium, or hard`
    }
  }
  return null
}

// Module-level cache: subtopicId → { subtopic, conceptCount, flashcardCount }
const subtopicDetailCache = new Map()

export default function SubtopicDetail() {
  const { subtopicId } = useParams()
  const navigate = useNavigate()
  const { isAdmin } = useAuth()

  const cached = subtopicDetailCache.get(subtopicId)
  const [subtopic, setSubtopic] = useState(cached?.subtopic || null)
  const [conceptCount, setConceptCount] = useState(cached?.conceptCount ?? 0)
  const [flashcardCount, setFlashcardCount] = useState(cached?.flashcardCount ?? 0)
  const [loading, setLoading] = useState(!cached)
  const [error, setError] = useState(false)

  // Bulk upload state
  const [showBulkModal, setShowBulkModal] = useState(false)
  const [jsonInput, setJsonInput] = useState('')
  const [uploading, setUploading] = useState(false)
  const [uploadResult, setUploadResult] = useState(null) // { success, count, error }
  const [validationError, setValidationError] = useState('')

  useEffect(() => {
    if (cached) return // Already have data, skip fetch
    async function fetchData() {
      try {
        const [subtopicRes, conceptRes, flashcardRes] = await Promise.all([
          supabase.from('subtopics').select('*, topics(name, paths(name))').eq('id', subtopicId).single(),
          supabase.from('concepts').select('id', { count: 'exact' }).eq('subtopic_id', subtopicId),
          supabase.from('flashcards').select('*', { count: 'exact', head: true }).eq('subtopic_id', subtopicId).not('correct_option', 'is', null),
        ])
        if (subtopicRes.error) throw subtopicRes.error
        const sub = subtopicRes.data
        const cc  = conceptRes.count  || 0
        const fc  = flashcardRes.count || 0
        setSubtopic(sub)
        setConceptCount(cc)
        setFlashcardCount(fc)
        subtopicDetailCache.set(subtopicId, { subtopic: sub, conceptCount: cc, flashcardCount: fc })
        setLoading(false)
      } catch (e) {
        console.error('SubtopicDetail fetch error:', e)
        subtopicDetailCache.delete(subtopicId)
        setError(true)
        setLoading(false)
      }
    }
    fetchData()
  }, [subtopicId]) // eslint-disable-line react-hooks/exhaustive-deps

  function handleJsonChange(val) {
    setJsonInput(val)
    setValidationError('')
    setUploadResult(null)
    if (!val.trim()) return
    try {
      const parsed = JSON.parse(val)
      const err = validateQuestions(parsed)
      if (err) setValidationError(err)
    } catch {
      setValidationError('Invalid JSON — check your syntax')
    }
  }

  async function handleBulkUpload() {
    if (!jsonInput.trim() || validationError) return
    let parsed
    try {
      parsed = JSON.parse(jsonInput)
    } catch {
      setValidationError('Invalid JSON')
      return
    }

    setUploading(true)
    setUploadResult(null)

    const rows = parsed.map(q => {
      const correctKey = 'option_' + q.correct_option.toLowerCase().trim()
      return {
        topic_id: subtopic.topic_id,
        subtopic_id: subtopicId,
        card_type: 'mcq',
        question: q.question.trim(),
        option_a: q.option_a.trim(),
        option_b: q.option_b.trim(),
        option_c: q.option_c.trim(),
        option_d: q.option_d.trim(),
        correct_option: q.correct_option.toLowerCase().trim(),
        answer: q[correctKey].trim(),
        difficulty: q.difficulty.toLowerCase().trim(),
        explanation: q.explanation ? q.explanation.trim() : null,
      }
    })

    const { error } = await supabase.from('flashcards').insert(rows)
    setUploading(false)

    if (error) {
      setUploadResult({ success: false, error: error.message })
    } else {
      setUploadResult({ success: true, count: rows.length })
      const newCount = flashcardCount + rows.length
      setFlashcardCount(newCount)
      // Update cache with new flashcard count
      if (subtopicDetailCache.has(subtopicId)) {
        const c = subtopicDetailCache.get(subtopicId)
        subtopicDetailCache.set(subtopicId, { ...c, flashcardCount: newCount })
      }
      setJsonInput('')
    }
  }

  function closeModal() {
    setShowBulkModal(false)
    setJsonInput('')
    setValidationError('')
    setUploadResult(null)
  }

  if (loading) return <CardShuffleLoader />
  if (error) return <ErrorScreen onRetry={() => navigate(0)} />

  const parsedCount = (() => {
    try { const p = JSON.parse(jsonInput); return Array.isArray(p) ? p.length : 0 } catch { return 0 }
  })()

  return (
    <div className="fixed inset-0 flex flex-col px-5 py-6 overflow-hidden" style={{ paddingTop: 'calc(env(safe-area-inset-top) + 1.5rem)', paddingBottom: 'calc(env(safe-area-inset-bottom) + 1rem)' }}>
      {/* Header */}
      <div className="flex items-center gap-3 mb-5">
        <button
          onClick={() => navigate(`/topics/${subtopic?.topic_id}`)}
          className="text-gray-400 hover:text-white transition-colors cursor-pointer"
        >
          <ArrowLeft size={22} />
        </button>
        <div>
          <p className="text-cyan-400 text-xs font-medium mb-0.5">
            {subtopic?.topics?.paths?.name} / {subtopic?.topics?.name}
          </p>
          <h1 className="text-2xl lg:text-3xl font-bold text-white">{subtopic?.name}</h1>
        </div>
      </div>

      {/* Choice Cards */}
      <motion.div
        className="flex flex-col lg:flex-row gap-4 lg:gap-6 max-w-2xl mx-auto w-full"
        variants={staggerContainer}
        initial="initial"
        animate="animate"
      >
        {/* Concept Card */}
        <motion.button
          onClick={() => navigate(`/concept/${subtopicId}`)}
          disabled={conceptCount === 0}
          className={`w-full lg:flex-1 p-6 lg:p-8 rounded-2xl bg-gradient-to-b from-emerald-500/10 to-emerald-600/5 from-navy-600/90 to-navy-700/90 border-2 border-emerald-500/40 backdrop-blur-xl transition-colors ${conceptCount === 0 ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
          style={{ boxShadow: '0 0 22px rgba(16,185,129,0.22), inset 0 0 22px rgba(16,185,129,0.06)' }}
          variants={staggerItem}
          whileHover={conceptCount > 0 ? { scale: 1.05, boxShadow: '0 0 38px rgba(16,185,129,0.45), inset 0 0 30px rgba(16,185,129,0.12)', transition: { duration: 0.2 } } : {}}
          whileTap={conceptCount > 0 ? buttonTap : {}}
        >
          <div className="flex flex-col items-center gap-4">
            <div className="w-16 h-16 rounded-2xl bg-emerald-500/20 flex items-center justify-center">
              <BookOpen size={32} className="text-emerald-400" />
            </div>
            <div className="text-center">
              <h2 className="text-xl font-bold text-white mb-1">Concept</h2>
              <p className="text-gray-400 text-sm">
                {conceptCount > 0
                  ? `Learn with ${conceptCount} detailed ${conceptCount === 1 ? 'section' : 'sections'}`
                  : 'No concepts available yet'}
              </p>
            </div>
            <div className="flex items-center gap-2 text-emerald-400 text-sm font-medium">
              <span>Read & Learn</span>
              <span>&rarr;</span>
            </div>
          </div>
        </motion.button>

        {/* Flashcard/Quiz Card */}
        <motion.button
          onClick={() => navigate(`/quiz/${subtopicId}`)}
          disabled={flashcardCount === 0}
          className={`w-full lg:flex-1 p-6 lg:p-8 rounded-2xl bg-gradient-to-b from-cyan-500/10 to-cyan-600/5 from-navy-600/90 to-navy-700/90 border-2 border-cyan-500/40 backdrop-blur-xl transition-colors ${flashcardCount === 0 ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
          style={{ boxShadow: '0 0 22px rgba(6,182,212,0.22), inset 0 0 22px rgba(6,182,212,0.06)' }}
          variants={staggerItem}
          whileHover={flashcardCount > 0 ? { scale: 1.05, boxShadow: '0 0 38px rgba(6,182,212,0.45), inset 0 0 30px rgba(6,182,212,0.12)', transition: { duration: 0.2 } } : {}}
          whileTap={flashcardCount > 0 ? buttonTap : {}}
        >
          <div className="flex flex-col items-center gap-4">
            <div className="w-16 h-16 rounded-2xl bg-cyan-500/20 flex items-center justify-center">
              <HelpCircle size={32} className="text-cyan-400" />
            </div>
            <div className="text-center">
              <h2 className="text-xl font-bold text-white mb-1">Quiz</h2>
              <p className="text-gray-400 text-sm">
                {flashcardCount > 0
                  ? `Test with ${flashcardCount} MCQ ${flashcardCount === 1 ? 'question' : 'questions'}`
                  : 'No quiz questions available yet'}
              </p>
            </div>
            <div className="flex items-center gap-2 text-cyan-400 text-sm font-medium">
              <span>Take Quiz</span>
              <span>&rarr;</span>
            </div>
          </div>
        </motion.button>
      </motion.div>

      {/* Progress hint */}
      <div className="text-center mt-4">
        <p className="text-gray-500 text-xs">
          Read concepts first, then test your knowledge with quizzes
        </p>
      </div>

      {/* Admin: Bulk Upload Button — just below quiz card */}
      {isAdmin && (
        <motion.button
          onClick={() => setShowBulkModal(true)}
          className="max-w-2xl mx-auto w-full mt-3 flex items-center justify-center gap-2 py-3 rounded-2xl bg-amber-500/10 border border-amber-500/30 text-amber-400 hover:bg-amber-500/20 transition-colors cursor-pointer"
          whileHover={{ scale: 1.02 }}
          whileTap={buttonTap}
        >
          <Upload size={18} />
          <span className="font-medium text-sm">Bulk Upload Questions</span>
        </motion.button>
      )}

      {/* Bulk Upload Modal */}
      <AnimatePresence>
        {showBulkModal && (
          <motion.div
            className="fixed inset-0 bg-black/70 backdrop-blur-sm z-50 flex items-center justify-center p-4"
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={(e) => { if (e.target === e.currentTarget) closeModal() }}
          >
            <motion.div
              className="w-full max-w-lg bg-navy-800 border border-white/10 rounded-2xl flex flex-col"
              style={{ maxHeight: 'calc(100dvh - 2rem)' }}
              initial={{ scale: 0.95, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.95, opacity: 0 }}
              transition={{ type: 'spring', stiffness: 300, damping: 30 }}
            >
              {/* Header */}
              <div className="flex items-center justify-between px-4 py-3 border-b border-white/10 flex-shrink-0">
                <div>
                  <h2 className="text-white font-bold text-sm">Bulk Upload Questions</h2>
                  <p className="text-gray-400 text-xs">{subtopic?.name}</p>
                </div>
                <button onClick={closeModal} className="text-gray-400 hover:text-white cursor-pointer">
                  <X size={18} />
                </button>
              </div>

              {/* Body — flex-1 so textarea fills remaining space */}
              <div className="flex flex-col gap-2 p-3 flex-1 min-h-0">
                {/* Format hint */}
                <div className="px-3 py-2 bg-navy-700/50 rounded-xl border border-white/5 flex-shrink-0">
                  <p className="text-gray-400 text-xs font-medium mb-1">Expected JSON format:</p>
                  <pre className="text-cyan-400 text-[11px] leading-relaxed overflow-x-auto">{`[
  {
    "question": "...",
    "option_a": "...",
    "option_b": "...",
    "option_c": "...",
    "option_d": "...",
    "correct_option": "a",
    "difficulty": "easy",
    "explanation": "..."
  }
]`}</pre>
                </div>

                {/* Textarea — grows to fill available space */}
                <textarea
                  value={jsonInput}
                  onChange={(e) => handleJsonChange(e.target.value)}
                  placeholder="Paste your JSON array here..."
                  className="flex-1 min-h-0 w-full px-3 py-2 bg-navy-700/50 border border-white/10 rounded-xl text-white text-sm placeholder-gray-600 focus:outline-none focus:border-amber-500/50 resize-none font-mono transition-colors"
                />

                {/* Feedback */}
                <div className="flex-shrink-0 min-h-[18px]">
                  {validationError && (
                    <div className="flex items-center gap-1.5 text-red-400 text-xs">
                      <AlertCircle size={12} /><span>{validationError}</span>
                    </div>
                  )}
                  {!validationError && parsedCount > 0 && !uploadResult && (
                    <div className="flex items-center gap-1.5 text-emerald-400 text-xs">
                      <CheckCircle size={12} /><span>{parsedCount} question{parsedCount !== 1 ? 's' : ''} ready</span>
                    </div>
                  )}
                  {uploadResult && (
                    <div className={`flex items-center gap-1.5 text-xs ${uploadResult.success ? 'text-emerald-400' : 'text-red-400'}`}>
                      {uploadResult.success ? <CheckCircle size={12} /> : <AlertCircle size={12} />}
                      {uploadResult.success ? `${uploadResult.count} uploaded!` : `Error: ${uploadResult.error}`}
                    </div>
                  )}
                </div>

                {/* Actions */}
                <div className="flex gap-2 flex-shrink-0">
                  <button
                    onClick={closeModal}
                    className="flex-1 py-2.5 rounded-xl bg-navy-700/50 border border-white/10 text-gray-400 text-sm font-medium cursor-pointer"
                  >
                    Cancel
                  </button>
                  <motion.button
                    onClick={handleBulkUpload}
                    disabled={uploading || !!validationError || !jsonInput.trim()}
                    className="flex-1 py-2.5 rounded-xl bg-amber-500/20 border border-amber-500/40 text-amber-400 text-sm font-semibold cursor-pointer disabled:opacity-40 flex items-center justify-center gap-2"
                    whileTap={buttonTap}
                  >
                    {uploading
                      ? <div className="w-4 h-4 border-2 border-amber-400 border-t-transparent rounded-full animate-spin" />
                      : <><Upload size={14} /> Upload</>
                    }
                  </motion.button>
                </div>
              </div>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  )
}
