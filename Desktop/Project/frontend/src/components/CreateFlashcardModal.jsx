import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { X, Check } from 'lucide-react'
import { supabase } from '../lib/supabase'
import { useAuth } from '../contexts/AuthContext'

export default function CreateFlashcardModal({ isOpen, onClose }) {
  const { user } = useAuth()
  const [type, setType] = useState('mcq') // 'mcq' or 'qa'
  const [question, setQuestion] = useState('')
  const [optionA, setOptionA] = useState('')
  const [optionB, setOptionB] = useState('')
  const [optionC, setOptionC] = useState('')
  const [optionD, setOptionD] = useState('')
  const [correctAnswer, setCorrectAnswer] = useState('a')
  const [explanation, setExplanation] = useState('')
  const [answer, setAnswer] = useState('') // For Q/A type
  const [submitting, setSubmitting] = useState(false)

  async function handleSubmit(e) {
    e.preventDefault()

    // Validate based on type
    if (type === 'mcq') {
      if (!question.trim() || !optionA.trim() || !optionB.trim() || !optionC.trim() || !optionD.trim()) {
        alert('Please fill in all fields')
        return
      }
    } else {
      if (!question.trim() || !answer.trim()) {
        alert('Please fill in question and answer')
        return
      }
    }

    setSubmitting(true)

    // Prepare data based on type
    const flashcardData = {
      created_by: user.id,
      type: type,
      question: question.trim(),
      // is_approved defaults to false (requires admin approval)
    }

    if (type === 'mcq') {
      flashcardData.option_a = optionA.trim()
      flashcardData.option_b = optionB.trim()
      flashcardData.option_c = optionC.trim()
      flashcardData.option_d = optionD.trim()
      flashcardData.correct_answer = correctAnswer
      flashcardData.explanation = explanation.trim() || null
    } else {
      // Q/A type - answer goes in explanation field
      flashcardData.explanation = answer.trim()
    }

    const { error } = await supabase.from('community_flashcards').insert(flashcardData)

    setSubmitting(false)

    if (error) {
      console.error('Error creating flashcard:', error)
      alert('Error creating flashcard: ' + error.message + '\n\nMake sure you ran the database migration!')
      return
    }

    // Reset form
    setType('mcq')
    setQuestion('')
    setOptionA('')
    setOptionB('')
    setOptionC('')
    setOptionD('')
    setCorrectAnswer('a')
    setExplanation('')
    setAnswer('')
    onClose()
    alert('✅ Flashcard submitted successfully! It will appear in Community after admin approval.')
  }

  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          className="fixed inset-0 z-50 flex items-center justify-center p-5 bg-black/70 backdrop-blur-sm"
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          exit={{ opacity: 0 }}
          onClick={onClose}
        >
          <motion.div
            className="w-full max-w-lg bg-gradient-to-b from-navy-800 to-navy-900 rounded-2xl border border-cyan-500/30 p-6 max-h-[90vh] overflow-y-auto"
            initial={{ scale: 0.9, opacity: 0 }}
            animate={{ scale: 1, opacity: 1 }}
            exit={{ scale: 0.9, opacity: 0 }}
            onClick={(e) => e.stopPropagation()}
          >
            {/* Header */}
            <div className="flex items-center justify-between mb-6">
              <h2 className="text-xl font-bold text-white">Create Flashcard</h2>
              <button
                onClick={onClose}
                className="w-8 h-8 rounded-full bg-white/5 flex items-center justify-center hover:bg-white/10 transition-colors"
              >
                <X size={18} className="text-gray-400" />
              </button>
            </div>

            {/* Form */}
            <form onSubmit={handleSubmit} className="flex flex-col gap-4">
              {/* Type Selector */}
              <div>
                <label className="text-sm font-medium text-cyan-400 mb-2 block">Flashcard Type</label>
                <div className="flex gap-2">
                  <button
                    type="button"
                    onClick={() => setType('mcq')}
                    className={`flex-1 py-2.5 rounded-lg font-semibold text-sm transition-all ${
                      type === 'mcq'
                        ? 'bg-cyan-500/20 border-2 border-cyan-500/40 text-cyan-400'
                        : 'bg-navy-700/50 border-2 border-white/10 text-gray-400 hover:border-white/20'
                    }`}
                  >
                    MCQ
                  </button>
                  <button
                    type="button"
                    onClick={() => setType('qa')}
                    className={`flex-1 py-2.5 rounded-lg font-semibold text-sm transition-all ${
                      type === 'qa'
                        ? 'bg-purple-500/20 border-2 border-purple-500/40 text-purple-400'
                        : 'bg-navy-700/50 border-2 border-white/10 text-gray-400 hover:border-white/20'
                    }`}
                  >
                    Q/A
                  </button>
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  {type === 'mcq' ? 'Multiple choice with 4 options' : 'Simple question and answer'}
                </p>
              </div>

              {/* Question */}
              <div>
                <label className="text-sm font-medium text-cyan-400 mb-2 block">Question</label>
                <textarea
                  value={question}
                  onChange={(e) => setQuestion(e.target.value)}
                  placeholder="Enter your question..."
                  className="w-full bg-navy-700/50 border border-white/10 rounded-xl px-4 py-3 text-white placeholder:text-gray-500 outline-none focus:border-cyan-500/50 resize-none"
                  rows={3}
                  required
                />
              </div>

              {/* Conditional Fields Based on Type */}
              {type === 'mcq' ? (
                <>
                  {/* MCQ Options */}
                  <div className="space-y-3">
                    <label className="text-sm font-medium text-cyan-400 block">Options</label>

                    {['a', 'b', 'c', 'd'].map((letter, index) => (
                      <div key={letter} className="flex items-center gap-3">
                        <input
                          type="radio"
                          name="correctAnswer"
                          value={letter}
                          checked={correctAnswer === letter}
                          onChange={(e) => setCorrectAnswer(e.target.value)}
                          className="w-4 h-4 accent-emerald-500"
                        />
                        <input
                          type="text"
                          value={[optionA, optionB, optionC, optionD][index]}
                          onChange={(e) => {
                            const setters = [setOptionA, setOptionB, setOptionC, setOptionD]
                            setters[index](e.target.value)
                          }}
                          placeholder={`Option ${letter.toUpperCase()}`}
                          className="flex-1 bg-navy-700/50 border border-white/10 rounded-lg px-3 py-2 text-white placeholder:text-gray-500 outline-none focus:border-cyan-500/50"
                          required
                        />
                      </div>
                    ))}
                    <p className="text-xs text-gray-500 mt-1">Select the radio button for the correct answer</p>
                  </div>

                  {/* Explanation (optional for MCQ) */}
                  <div>
                    <label className="text-sm font-medium text-cyan-400 mb-2 block">Explanation (Optional)</label>
                    <textarea
                      value={explanation}
                      onChange={(e) => setExplanation(e.target.value)}
                      placeholder="Explain why this is the correct answer..."
                      className="w-full bg-navy-700/50 border border-white/10 rounded-xl px-4 py-3 text-white placeholder:text-gray-500 outline-none focus:border-cyan-500/50 resize-none"
                      rows={2}
                    />
                  </div>
                </>
              ) : (
                <>
                  {/* Q/A Answer */}
                  <div>
                    <label className="text-sm font-medium text-purple-400 mb-2 block">Answer</label>
                    <textarea
                      value={answer}
                      onChange={(e) => setAnswer(e.target.value)}
                      placeholder="Enter the answer to this question..."
                      className="w-full bg-navy-700/50 border border-white/10 rounded-xl px-4 py-3 text-white placeholder:text-gray-500 outline-none focus:border-purple-500/50 resize-none"
                      rows={4}
                      required
                    />
                  </div>
                </>
              )}

              {/* Submit Button */}
              <button
                type="submit"
                disabled={submitting}
                className="w-full bg-gradient-to-r from-cyan-500 to-blue-500 text-white font-semibold py-3 rounded-xl hover:from-cyan-400 hover:to-blue-400 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
              >
                {submitting ? (
                  <>
                    <div className="w-4 h-4 border-2 border-white border-t-transparent rounded-full animate-spin" />
                    Creating...
                  </>
                ) : (
                  <>
                    <Check size={18} />
                    Create Flashcard
                  </>
                )}
              </button>
            </form>
          </motion.div>
        </motion.div>
      )}
    </AnimatePresence>
  )
}
