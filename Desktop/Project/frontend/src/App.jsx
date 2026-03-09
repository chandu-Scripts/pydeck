import { Component } from 'react'
import { Routes, Route, Navigate, useLocation } from 'react-router-dom'
import { AnimatePresence } from 'framer-motion'
import { useAuth } from './contexts/AuthContext'
import Layout from './components/Layout'
import BlockedUserScreen from './components/BlockedUserScreen'
import Login from './pages/Login'
import PathSelection from './pages/PathSelection'
import TopicGrid from './pages/TopicGrid'
import SubtopicGrid from './pages/SubtopicGrid'
import SubtopicDetail from './pages/SubtopicDetail'
import Concept from './pages/Concept'
import MCQFlashcard from './pages/MCQFlashcard'
import Flashcard from './pages/Flashcard'
import RecallSession from './pages/RecallSession'
import Analytics from './pages/Analytics'
import Profile from './pages/Profile'
import CommunityFlashcards from './pages/CommunityFlashcards'
import AdminPanel from './pages/AdminPanel'
import Playground from './pages/Playground'
import Settings from './pages/Settings'
import ThemeColor from './pages/ThemeColor'
import FontSize from './pages/FontSize'
import Notifications from './pages/Notifications'
import ChangePassword from './pages/ChangePassword'
import ChangeEmail from './pages/ChangeEmail'
import Language from './pages/Language'
import DataPrivacy from './pages/DataPrivacy'
import DailyGoal from './pages/DailyGoal'
import StudyReminder from './pages/StudyReminder'
import CardShuffleLoader from './components/CardShuffleLoader'
import ErrorScreen from './components/ErrorScreen'

class ErrorBoundary extends Component {
  state = { hasError: false }
  static getDerivedStateFromError() { return { hasError: true } }
  componentDidCatch(err) { console.error('App error:', err) }
  render() {
    if (this.state.hasError) {
      return <ErrorScreen onRetry={() => { this.setState({ hasError: false }); window.location.reload() }} />
    }
    return this.props.children
  }
}

function ProtectedRoute({ children }) {
  const { user, loading, isBlocked } = useAuth()

  if (loading) {
    return <CardShuffleLoader />
  }

  if (!user) return <Navigate to="/login" />
  if (isBlocked) return <BlockedUserScreen />
  return children
}

function App() {
  const location = useLocation()

  return (
    <ErrorBoundary>
    <AnimatePresence mode="wait" initial={false}>
      <Routes location={location} key={location.pathname}>
        <Route path="/login" element={<Login />} />
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          <Route index element={<Navigate to="/paths" />} />
          <Route path="paths" element={<PathSelection />} />
          <Route path="paths/:pathId" element={<TopicGrid />} />
          <Route path="topics/:topicId" element={<SubtopicGrid />} />
          <Route path="subtopics/:subtopicId" element={<SubtopicDetail />} />
          <Route path="concept/:subtopicId" element={<Concept />} />
          <Route path="quiz/:subtopicId" element={<MCQFlashcard />} />
          <Route path="study/:topicId" element={<Flashcard />} />
          <Route path="recall" element={<RecallSession />} />
          <Route path="analytics" element={<Analytics />} />
          <Route path="profile" element={<Profile />} />
          <Route path="community" element={<CommunityFlashcards />} />
          <Route path="admin" element={<AdminPanel />} />
          <Route path="playground" element={<Playground />} />
          <Route path="settings" element={<Settings />} />
          <Route path="settings/theme" element={<ThemeColor />} />
          <Route path="settings/font" element={<FontSize />} />
          <Route path="settings/notifications" element={<Notifications />} />
          <Route path="settings/password" element={<ChangePassword />} />
          <Route path="settings/email" element={<ChangeEmail />} />
          <Route path="settings/language" element={<Language />} />
          <Route path="settings/privacy" element={<DataPrivacy />} />
          <Route path="settings/goal" element={<DailyGoal />} />
          <Route path="settings/reminder" element={<StudyReminder />} />
        </Route>
        <Route path="*" element={<Navigate to="/login" />} />
      </Routes>
    </AnimatePresence>
    </ErrorBoundary>
  )
}

export default App
