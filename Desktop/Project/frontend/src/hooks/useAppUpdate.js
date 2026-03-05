import { useRegisterSW } from 'virtual:pwa-register/react'

export function useAppUpdate() {
  const { needRefresh: [needRefresh, setNeedRefresh], updateServiceWorker } = useRegisterSW()

  function applyUpdate() {
    updateServiceWorker(true)
    setTimeout(() => window.location.reload(), 500)
  }

  function dismiss() {
    setNeedRefresh(false)
  }

  return { needRefresh, applyUpdate, dismiss }
}
