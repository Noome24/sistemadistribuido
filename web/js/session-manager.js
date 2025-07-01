/**
 * Gestor de sesión que maneja el cierre automático cuando se cierra la ventana
 */
class SessionManager {
  constructor() {
    this.contextPath = this.getContextPath()
    this.sessionCheckInterval = null
    this.windowBlurTimeout = null
    this.pageHiddenTimeout = null
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

    // Detectar cierre de ventana/pestaña
    window.addEventListener("beforeunload", (event) => {
      this.handleWindowClose()
    })

    // Detectar cuando la página se oculta (cambio de pestaña, minimizar, etc.)
    document.addEventListener("visibilitychange", () => {
      if (document.visibilityState === "hidden") {
        this.handlePageHidden()
      } else if (document.visibilityState === "visible") {
        this.handlePageVisible()
      }
    })

    // Detectar cuando la ventana pierde el foco por mucho tiempo
    window.addEventListener("blur", () => {
      this.windowBlurTimeout = setTimeout(() => {
        console.log("Ventana sin foco por 30 segundos, verificando sesión...")
        this.checkSession()
      }, 30000) // 30 segundos sin foco
    })

    window.addEventListener("focus", () => {
      if (this.windowBlurTimeout) {
        clearTimeout(this.windowBlurTimeout)
        this.windowBlurTimeout = null
      }
      this.checkSession()
    })

    // Verificar sesión periódicamente
    this.startSessionCheck()
  }

  /**
   * Maneja el cierre de ventana
   */
  handleWindowClose() {
    console.log("Detectado cierre de ventana, cerrando sesión...")

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
    console.log("Página oculta, iniciando timer de 5 minutos...")

    // Limpiar timeout anterior si existe
    if (this.pageHiddenTimeout) {
      clearTimeout(this.pageHiddenTimeout)
    }

    // Solo cerrar sesión si la página se oculta por más de 5 minutos
    this.pageHiddenTimeout = setTimeout(() => {
      if (document.visibilityState === "hidden") {
        console.log("Página oculta por 5 minutos, cerrando sesión...")
        this.handleWindowClose()
      }
    }, 300000) // 5 minutos
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

    // Verificar sesión al volver a ser visible
    this.checkSession()
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
          // Sesión expirada, redirigir al login
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
    // Verificar cada 5 minutos
    this.sessionCheckInterval = setInterval(() => {
      console.log("Verificación periódica de sesión...")
      this.checkSession()
    }, 300000) // 5 minutos
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
    window.location.href = `${window.location.pathname.split("/")[1] ? "/" + window.location.pathname.split("/")[1] : ""}/logout`
  }
}
