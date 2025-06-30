// Funciones para consultar APIs de RENIEC y SUNAT
class ApiConsulta {
  constructor() {
    this.baseUrl = window.location.origin + window.location.pathname.split("/").slice(0, -1).join("/")
  }

  async consultarDNI(dni) {
    try {
      const response = await fetch(`${this.baseUrl}/api/consulta/dni/${dni}`, {
        method: "GET",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      })

      const data = await response.json()

      if (response.status === 401) {
        // Sesión expirada, redirigir al login
        window.location.href = data.redirect || "/login"
        return null
      }

      return data
    } catch (error) {
      console.error("Error al consultar DNI:", error)
      return {
        success: false,
        error: "Error de conexión",
      }
    }
  }

  async consultarRUC(ruc) {
    try {
      const response = await fetch(`${this.baseUrl}/api/consulta/ruc/${ruc}`, {
        method: "GET",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
      })

      const data = await response.json()

      if (response.status === 401) {
        // Sesión expirada, redirigir al login
        window.location.href = data.redirect || "/login"
        return null
      }

      return data
    } catch (error) {
      console.error("Error al consultar RUC:", error)
      return {
        success: false,
        error: "Error de conexión",
      }
    }
  }

  // Función para autorellenar formulario con datos de DNI
  autorellenarDNI(data, formPrefix = "") {
    if (data.success && data.data) {
      const info = data.data

      // Campos comunes para DNI
      this.setFieldValue(formPrefix + "nombres", info.nombres || "")
      this.setFieldValue(formPrefix + "apellidos", (info.apellidoPaterno || "") + " " + (info.apellidoMaterno || ""))
      this.setFieldValue(formPrefix + "dni", info.numeroDocumento || "")
    }
  }

  // Función para autorellenar formulario con datos de RUC
  autorellenarRUC(data, formPrefix = "") {
    if (data.success && data.data) {
      const info = data.data

      // Campos comunes para RUC
      this.setFieldValue(formPrefix + "razonSocial", info.razonSocial || "")
      this.setFieldValue(formPrefix + "ruc", info.numeroDocumento || "")
      this.setFieldValue(formPrefix + "direccion", info.direccion || "")
      this.setFieldValue(formPrefix + "estado", info.estado || "")
      this.setFieldValue(formPrefix + "condicion", info.condicion || "")
    }
  }

  // Función auxiliar para establecer valor en campo
  setFieldValue(fieldName, value) {
    const field = document.getElementById(fieldName) || document.querySelector(`[name="${fieldName}"]`)
    if (field) {
      field.value = value
      // Disparar evento change para validaciones
      field.dispatchEvent(new Event("change", { bubbles: true }))
    }
  }

  // Función para mostrar loading
  showLoading(buttonElement, originalText) {
    if (buttonElement) {
      buttonElement.disabled = true
      buttonElement.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Consultando...'
      buttonElement.dataset.originalText = originalText
    }
  }

  // Función para ocultar loading
  hideLoading(buttonElement) {
    if (buttonElement) {
      buttonElement.disabled = false
      buttonElement.innerHTML = buttonElement.dataset.originalText || "Consultar"
    }
  }

  // Función para mostrar mensajes
  showMessage(message, type = "info", containerId = "messages") {
    const container = document.getElementById(containerId)
    if (container) {
      const alertClass = type === "error" ? "alert-danger" : type === "success" ? "alert-success" : "alert-info"

      const alertHtml = `
                <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
                    <i class="fas fa-${
                      type === "error" ? "exclamation-circle" : type === "success" ? "check-circle" : "info-circle"
                    } me-2"></i>
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            `

      container.innerHTML = alertHtml

      // Auto-eliminar después de 5 segundos
      setTimeout(() => {
        const alert = container.querySelector(".alert")
        if (alert) {
          alert.remove()
        }
      }, 5000)
    }
  }
}

// Instancia global
const apiConsulta = new ApiConsulta()

// Funciones de conveniencia para usar en formularios
async function buscarPorDNI(dni, formPrefix = "", buttonElement = null) {
  if (!dni || dni.length !== 8) {
    apiConsulta.showMessage("El DNI debe tener 8 dígitos", "error")
    return
  }

  const originalText = buttonElement ? buttonElement.textContent : ""
  apiConsulta.showLoading(buttonElement, originalText)

  const resultado = await apiConsulta.consultarDNI(dni)

  apiConsulta.hideLoading(buttonElement)

  if (resultado && resultado.success) {
    apiConsulta.autorellenarDNI(resultado, formPrefix)
    apiConsulta.showMessage("Datos encontrados y cargados correctamente", "success")
  } else {
    const errorMsg = resultado ? resultado.error : "No se encontraron datos para este DNI"
    apiConsulta.showMessage(errorMsg, "error")
  }
}

async function buscarPorRUC(ruc, formPrefix = "", buttonElement = null) {
  if (!ruc || ruc.length !== 11) {
    apiConsulta.showMessage("El RUC debe tener 11 dígitos", "error")
    return
  }

  const originalText = buttonElement ? buttonElement.textContent : ""
  apiConsulta.showLoading(buttonElement, originalText)

  const resultado = await apiConsulta.consultarRUC(ruc)

  apiConsulta.hideLoading(buttonElement)

  if (resultado && resultado.success) {
    apiConsulta.autorellenarRUC(resultado, formPrefix)
    apiConsulta.showMessage("Datos encontrados y cargados correctamente", "success")
  } else {
    const errorMsg = resultado ? resultado.error : "No se encontraron datos para este RUC"
    apiConsulta.showMessage(errorMsg, "error")
  }
}
