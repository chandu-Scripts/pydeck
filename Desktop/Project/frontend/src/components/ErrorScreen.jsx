import { WifiOff } from 'lucide-react'

export default function ErrorScreen({ onRetry }) {
  return (
    <div className="fixed inset-0 flex items-center justify-center bg-navy-900">
      <div className="flex flex-col items-center gap-4 px-8 text-center max-w-sm">
        <div className="w-16 h-16 rounded-2xl bg-rose-500/10 border border-rose-500/20 flex items-center justify-center">
          <WifiOff size={28} className="text-rose-400" />
        </div>
        <div>
          <h2 className="text-white font-semibold text-lg mb-1">Connection Failed</h2>
          <p className="text-gray-400 text-sm leading-relaxed">
            Could not reach the server. Check your internet connection and try again.
          </p>
        </div>
        <button
          onClick={onRetry || (() => window.location.reload())}
          className="mt-1 px-8 py-2.5 bg-cyan-500/20 border border-cyan-500/30 text-cyan-400 rounded-xl font-medium hover:bg-cyan-500/30 transition-colors cursor-pointer"
        >
          Retry
        </button>
      </div>
    </div>
  )
}
