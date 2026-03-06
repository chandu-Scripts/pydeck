import { useEffect } from 'react'
import { useRegisterSW } from 'virtual:pwa-register/react'

// Persists across component mounts/unmounts within the same page session
let sessionDismissed = false

export function useAppUpdate() {
  const { needRefresh: [needRefresh, setNeedRefresh], updateServiceWorker } = useRegisterSW()

  useEffect(() => {
    if (needRefresh && (sessionDismissed || sessionStorage.getItem('pydeck_just_updated'))) {
      sessionStorage.removeItem('pydeck_just_updated')
      setNeedRefresh(false)
    }
  }, [needRefresh, setNeedRefresh])

  function applyUpdate() {
    sessionDismissed = true
    sessionStorage.setItem('pydeck_just_updated', '1')
    updateServiceWorker(true)
    window.location.reload()
  }

  function dismiss() {
    sessionDismissed = true
    setNeedRefresh(false)
  }

  return { needRefresh, applyUpdate, dismiss }
}
