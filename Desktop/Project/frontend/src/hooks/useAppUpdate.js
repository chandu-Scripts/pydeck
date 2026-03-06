import { useEffect } from 'react'
import { useRegisterSW } from 'virtual:pwa-register/react'

export function useAppUpdate() {
  const { needRefresh: [needRefresh, setNeedRefresh], updateServiceWorker } = useRegisterSW()

  // If we just refreshed due to an update, suppress the banner
  useEffect(() => {
    if (needRefresh && sessionStorage.getItem('pydeck_just_updated')) {
      sessionStorage.removeItem('pydeck_just_updated')
      setNeedRefresh(false)
    }
  }, [needRefresh, setNeedRefresh])

  function applyUpdate() {
    sessionStorage.setItem('pydeck_just_updated', '1')
    // Wait for new SW to take control before reloading
    navigator.serviceWorker.addEventListener('controllerchange', () => {
      window.location.reload()
    })
    updateServiceWorker(true)
  }

  function dismiss() {
    setNeedRefresh(false)
  }

  return { needRefresh, applyUpdate, dismiss }
}
