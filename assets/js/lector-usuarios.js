document.addEventListener("DOMContentLoaded", () => {
  const inputBuscar   = document.getElementById("buscar-usuario");
  const resultadoDiv  = document.getElementById("resultado-lector");

  const detalleDiv    = document.getElementById("detalle-miembro");
  const avatarImg     = document.getElementById("avatar-miembro");
  const nombreH4      = document.getElementById("nombre-miembro");
  const planBadge     = document.getElementById("plan-miembro");
  const cuotaSpan     = document.getElementById("cuota-miembro");
  const vtoSmall      = document.getElementById("vto-miembro");

  if (inputBuscar) inputBuscar.focus();

  function mostrarMensaje(texto, tipo = "info") {
    if (!resultadoDiv) return;
    resultadoDiv.textContent = texto;

    resultadoDiv.classList.remove("alert-success", "alert-danger", "alert-info", "alert-warning");

    switch (tipo) {
      case "ok":     resultadoDiv.classList.add("alert-success"); break;
      case "error":  resultadoDiv.classList.add("alert-danger");  break;
      case "warn":   resultadoDiv.classList.add("alert-warning"); break;
      default:       resultadoDiv.classList.add("alert-info");    break;
    }
  }

  function mostrarDetalle(datos) {
    if (!detalleDiv) return;
    if (!datos) {
      detalleDiv.style.display = "none";
      return;
    }

    if (avatarImg)  avatarImg.src = datos.avatar || "assets/images/users/avatar-2.jpg";
    if (nombreH4)   nombreH4.textContent = `${datos.nombre} ${datos.apellido}`;
    if (planBadge)  planBadge.textContent = `Plan: ${datos.plan || "Sin plan"}`;
    if (cuotaSpan)  cuotaSpan.textContent = datos.estadoCuota || "";
    if (vtoSmall)   vtoSmall.textContent = datos.vencimiento ? `Vence: ${datos.vencimiento}` : "";

    detalleDiv.style.display = "block";
  }

  async function validarCodigo(codigo) {
    if (!codigo) return;

    try {
      const respuesta = await fetch("componentes/lector.php", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: "codigo=" + encodeURIComponent(codigo),
      });

      const datos = await respuesta.json();

      if (datos.status === "ok") {
        mostrarMensaje(datos.mensaje || "Miembro encontrado.", "ok");
        mostrarDetalle(datos.datos);
      } else {
        mostrarMensaje(datos.mensaje || "No encontrado.", "error");
        mostrarDetalle(null);
      }
    } catch (error) {
      console.error("Error lector:", error);
      mostrarMensaje("❌ Error de conexión con el servidor.", "error");
      mostrarDetalle(null);
    }
  }

  if (inputBuscar) {
    inputBuscar.addEventListener("input", () => {
      const valor = inputBuscar.value.trim();

      if (valor.includes("@")) {
        validarCodigo(valor);
        setTimeout(() => (inputBuscar.value = ""), 100);
      }
    });

    inputBuscar.addEventListener("keydown", (e) => {
      if (e.key === "Enter") {
        e.preventDefault();
        const valor = inputBuscar.value.trim();

        if (valor.length < 3) {
          mostrarMensaje("Ingresá al menos 3 caracteres.", "warn");
          return;
        }

        validarCodigo(valor);
        inputBuscar.value = "";
      }
    });
  }
});
