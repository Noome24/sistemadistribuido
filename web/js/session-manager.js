/**
 * Gestor de sesión que maneja el cierre automático cuando se cierra la ventana
 */
class SessionManager {
  constructor() {
    this.contextPath = this.getContextPath()
    this.sessionCheckInterval = null
    this.windowBlurTimeout = null
    this.pageHiddenTimeout = null
    this.lastActivity = Date.now()
    this.isWindowClosing = false
    this.hiddenStartTime = null
    this.init()
  }

  /**
   * Obtiene el context path de la aplicación
   */
  getContextPath() {
    // Intentar obtener desde una variable global si existe
    if (typeof window.contextPath !== "undefined") {
      return window.contextPath
    }

    // Obtener desde el script actual
    const scripts = document.getElementsByTagName("script")
    for (const script of scripts) {
      if (script.src && script.src.includes("session-manager.js")) {
        const url = new URL(script.src)
        const pathParts = url.pathname.split("/")
        // Remover 'js/session-manager.js' del final
        pathParts.pop() // session-manager.js
        pathParts.pop() // js
        return pathParts.join("/") || ""
      }
    }

    // Fallback: obtener desde la URL actual
    const currentPath = window.location.pathname
    const pathParts = currentPath.split("/")
    if (pathParts.length > 1) {
      return "/" + pathParts[1]
    }

    return ""
  }

  /**
   * Inicializa los event listeners
   */
  init() {
    console.log("Inicializando SessionManager con contextPath:", this.contextPath)

    // Detectar cierre de ventana/pestaña - SOLO cuando realmente se cierra
    window.addEventListener("beforeunload", (event) => {
      this.isWindowClosing = true
      this.handleWindowClose()
    })

    // Detectar cuando la página se oculta/muestra
    document.addEventListener("visibilitychange", () => {
      if (document.visibilityState === "hidden") {
        this.handlePageHidden()
      } else if (document.visibilityState === "visible") {
        this.handlePageVisible()
      }
    })

    // Detectar actividad del usuario para resetear timers
    this.setupActivityTracking()

    // Verificar sesión periódicamente
    this.startSessionCheck()
  }

  /**
   * Configura el seguimiento de actividad del usuario
   */
  setupActivityTracking() {
    const events = ["mousedown", "mousemove", "keypress", "scroll", "touchstart", "click"]

    const updateActivity = () => {
      this.lastActivity = Date.now()
    }

    events.forEach((event) => {
      document.addEventListener(event, updateActivity, true)
    })
  }

  /**
   * Maneja el cierre de ventana - SOLO cuando realmente se cierra
   */
  handleWindowClose() {
    if (!this.isWindowClosing) {
      return // No hacer nada si no es un cierre real
    }

    console.log("Detectado cierre REAL de ventana, cerrando sesión...")

    // Usar sendBeacon para asegurar que la petición se envíe
    const url = `${this.contextPath}/auth`
    const formData = new FormData()
    formData.append("action", "logout")

    if (navigator.sendBeacon) {
      const success = navigator.sendBeacon(url, formData)
      console.log("SendBeacon resultado:", success)
    } else {
      // Fallback para navegadores que no soportan sendBeacon
      try {
        const xhr = new XMLHttpRequest()
        xhr.open("POST", url, false) // Síncrono para asegurar que se ejecute
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
        xhr.send("action=logout")
        console.log("Logout síncrono completado")
      } catch (error) {
        console.error("Error en logout síncrono:", error)
      }
    }
  }

  /**
   * Maneja cuando la página se oculta
   */
  handlePageHidden() {
    // No hacer logout si es por cambio de ventana/aplicación
    if (this.isWindowClosing) {
      return // Ya se está manejando el cierre
    }

    this.hiddenStartTime = Date.now()
    console.log("Página oculta (cambio de pestaña/ventana), iniciando monitoreo...")

    // Limpiar timeout anterior si existe
    if (this.pageHiddenTimeout) {
      clearTimeout(this.pageHiddenTimeout)
    }

    // Solo cerrar sesión si:
    // 1. La página está oculta por MÁS de 15 minutos (no 5)
    // 2. Y no hay actividad reciente del usuario
    this.pageHiddenTimeout = setTimeout(() => {
      if (document.visibilityState === "hidden") {
        const timeSinceActivity = Date.now() - this.lastActivity
        const timeHidden = Date.now() - this.hiddenStartTime

        // Solo cerrar si lleva más de 15 minutos oculta Y sin actividad por más de 10 minutos
        if (timeHidden > 900000 && timeSinceActivity > 600000) {
          // 15 min oculta, 10 min sin actividad
          console.log("Página oculta por 15 minutos sin actividad, cerrando sesión...")
          this.performLogout()
        } else {
          console.log("Página oculta pero con actividad reciente, no cerrando sesión")
        }
      }
    }, 900000) // 15 minutos
  }

  /**
   * Maneja cuando la página se vuelve visible
   */
  handlePageVisible() {
    console.log("Página visible nuevamente")

    // Limpiar el timeout de página oculta
    if (this.pageHiddenTimeout) {
      clearTimeout(this.pageHiddenTimeout)
      this.pageHiddenTimeout = null
    }

    // Resetear el flag de cierre
    this.isWindowClosing = false
    this.hiddenStartTime = null

    // Actualizar actividad
    this.lastActivity = Date.now()

    // Verificar sesión al volver a ser visible
    this.checkSession()
  }

  /**
   * Realiza el logout de forma asíncrona
   */
  async performLogout() {
    try {
      const response = await fetch(`${this.contextPath}/auth`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "action=logout",
        credentials: "same-origin",
      })

      if (response.ok) {
        console.log("Logout automático exitoso")
        window.location.href = `${this.contextPath}/login`
      }
    } catch (error) {
      console.error("Error en logout automático:", error)
    }
  }

  /**
   * Verifica si la sesión sigue activa
   */
  async checkSession() {
    try {
      const response = await fetch(`${this.contextPath}/auth?action=checkSession`, {
        method: "GET",
        credentials: "same-origin",
        cache: "no-cache",
      })

      if (response.ok) {
        const data = await response.json()
        if (!data.hasSession) {
          console.log("Sesión expirada, redirigiendo al login...")
          window.location.href = `${this.contextPath}/login`
        } else {
          console.log("Sesión activa para usuario:", data.username)
        }
      } else {
        console.error("Error verificando sesión:", response.status)
      }
    } catch (error) {
      console.error("Error verificando sesión:", error)
    }
  }

  /**
   * Inicia la verificación periódica de sesión
   */
  startSessionCheck() {
    // Verificar cada 10 minutos (menos frecuente)
    this.sessionCheckInterval = setInterval(() => {
      console.log("Verificación periódica de sesión...")
      this.checkSession()
    }, 600000) // 10 minutos
  }

  /**
   * Detiene la verificación periódica de sesión
   */
  stopSessionCheck() {
    if (this.sessionCheckInterval) {
      clearInterval(this.sessionCheckInterval)
      this.sessionCheckInterval = null
    }
  }

  /**
   * Cierra la sesión manualmente
   */
  async logout() {
    console.log("Cerrando sesión manualmente...")

    try {
      const response = await fetch(`${this.contextPath}/auth`, {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "action=logout",
        credentials: "same-origin",
      })

      if (response.ok) {
        const data = await response.json()
        console.log("Logout exitoso:", data)
        window.location.href = `${this.contextPath}/login`
      } else {
        console.error("Error en logout:", response.status)
        // Redirigir de todas formas
        window.location.href = `${this.contextPath}/logout`
      }
    } catch (error) {
      console.error("Error cerrando sesión:", error)
      // Redirigir de todas formas
      window.location.href = `${this.contextPath}/logout`
    }
  }

  /**
   * Limpia todos los timeouts y intervals
   */
  cleanup() {
    if (this.windowBlurTimeout) {
      clearTimeout(this.windowBlurTimeout)
    }
    if (this.pageHiddenTimeout) {
      clearTimeout(this.pageHiddenTimeout)
    }
    this.stopSessionCheck()
  }
}

// Inicializar el gestor de sesión cuando el DOM esté listo
document.addEventListener("DOMContentLoaded", () => {
  console.log("Inicializando SessionManager...")
  window.sessionManager = new SessionManager()
})

// Limpiar al descargar la página
window.addEventListener("unload", () => {
  if (window.sessionManager) {
    window.sessionManager.cleanup()
  }
})

// Función global para cerrar sesión
function cerrarSesion() {
  if (window.sessionManager) {
    window.sessionManager.logout()
  } else {
    console.log("SessionManager no disponible, usando logout directo")
    window.location.href = `${window.contextPath || ""}/logout`
  }
}
