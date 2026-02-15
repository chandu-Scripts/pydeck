import { Outlet, useLocation } from 'react-router-dom'
import BottomNav from './BottomNav'

export default function Layout() {
  const location = useLocation()
  const hideNav = location.pathname.startsWith('/study/')

  return (
    <div className="min-h-screen bg-navy-900 relative">
      <div className="absolute inset-0 bg-gradient-to-br from-navy-900 via-navy-800 to-[#0d1a2e] pointer-events-none" />
      <div className="relative z-10 pb-20 lg:pb-0 lg:pl-64">
        <div className="max-w-2xl mx-auto lg:max-w-5xl">
          <Outlet />
        </div>
      </div>
      {!hideNav && <BottomNav />}
    </div>
  )
}
