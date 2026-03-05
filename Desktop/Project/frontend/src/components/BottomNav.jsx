import { NavLink } from 'react-router-dom'
import { Home, BarChart3, User, Terminal } from 'lucide-react'

const navItems = [
  { to: '/paths', icon: Home, label: 'Home' },
  { to: '/analytics', icon: BarChart3, label: 'Analytics' },
  { to: '/playground', icon: Terminal, label: 'Code' },
  { to: '/profile', icon: User, label: 'Profile' },
]

export default function BottomNav() {
  return (
    <>
      {/* Mobile bottom nav */}
      <nav className="fixed bottom-0 left-0 right-0 z-50 lg:hidden">
        <div className="bg-navy-800/90 backdrop-blur-xl border-t border-white/5">
          <div className="flex items-center justify-around h-16 max-w-md mx-auto">
            {navItems.map(({ to, icon: Icon, label }) => (
              <NavLink
                key={to}
                to={to}
                className={({ isActive }) =>
                  `flex flex-col items-center gap-1 px-4 py-2 transition-colors ${
                    isActive ? 'text-cyan-400' : 'text-gray-500 hover:text-gray-300'
                  }`
                }
              >
                <Icon size={22} />
                <span className="text-[10px] font-medium">{label}</span>
              </NavLink>
            ))}
          </div>
        </div>
      </nav>

      {/* Desktop sidebar */}
      <nav className="hidden lg:flex fixed left-0 top-0 bottom-0 w-64 z-50">
        <div className="flex flex-col w-full bg-navy-800/80 backdrop-blur-xl border-r border-white/5 p-6">
          <div className="flex items-center gap-3 mb-12">
            <div className="w-10 h-10 rounded-xl bg-gradient-to-br from-cyan-400 to-cyan-600 flex items-center justify-center">
              <span className="text-lg font-bold text-white">Py</span>
            </div>
            <div>
              <h1 className="text-lg font-bold text-white">PyDeck</h1>
              <p className="text-[11px] text-cyan-400">Master Python</p>
            </div>
          </div>

          <div className="flex flex-col gap-2">
            {navItems.map(({ to, icon: Icon, label }) => (
              <NavLink
                key={to}
                to={to}
                className={({ isActive }) =>
                  `flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
                    isActive
                      ? 'bg-cyan-500/10 text-cyan-400 border border-cyan-500/20'
                      : 'text-gray-400 hover:text-white hover:bg-white/5'
                  }`
                }
              >
                <Icon size={20} />
                <span className="text-sm font-medium">{label}</span>
              </NavLink>
            ))}
          </div>
        </div>
      </nav>
    </>
  )
}
