document.addEventListener("DOMContentLoaded", () => {
  const inputBuscar = document.getElementById("buscar-usuario");
  const resultadoDiv = document.getElementById("resultado-lector");

  const detalleDiv = document.getElementById("detalle-miembro");
  const avatarImg = document.getElementById("avatar-miembro");
  const nombreH4 = document.getElementById("nombre-miembro");
  const planBadge = document.getElementById("plan-miembro");
  const cuotaSpan = document.getElementById("cuota-miembro");
  const vtoSmall = document.getElementById("vto-miembro");

  if (inputBuscar) inputBuscar.focus();

  function mostrarMensaje(texto, tipo = "info") {
    if (!resultadoDiv) return;
    resultadoDiv.textContent = texto;

    resultadoDiv.classList.remove(
      "alert-success",
      "alert-danger",
      "alert-info",
      "alert-warning"
    );

    switch (tipo) {
      case "ok":
        resultadoDiv.classList.add("alert-success");
        break;
      case "error":
        resultadoDiv.classList.add("alert-danger");
        break;
      case "warn":
        resultadoDiv.classList.add("alert-warning");
        break;
      default:
        resultadoDiv.classList.add("alert-info");
        break;
    }
  }

  function mostrarDetalle(datos) {
    if (!detalleDiv) return;
    if (!datos) {
      detalleDiv.style.display = "none";
      return;
    }

    if (avatarImg)
      avatarImg.src = datos.avatar || "assets/images/users/avatar-2.jpg";
    if (nombreH4) nombreH4.textContent = `${datos.nombre} ${datos.apellido}`;
    if (planBadge) planBadge.textContent = `Plan: ${datos.plan || "Sin plan"}`;
if (cuotaSpan) {
  if (datos.estadoCuota.includes("Debe recargo")) {
    cuotaSpan.classList.remove("text-success");
    cuotaSpan.classList.add("text-danger");

    // Extraer monto
    const match = datos.estadoCuota.match(/\$\d+/);
    const montoRecargo = match ? match[0] : "$...";

    // Crear botón para pagar recargo
    const btnPagar = document.createElement("button");
    btnPagar.className = "btn btn-danger btn-sm";
    btnPagar.textContent = `Pagar recargo de ${montoRecargo}`;
    btnPagar.onclick = () => {
      const form = document.createElement("form");
      form.method = "POST";
      form.action = "PagarRecargo.php";

      const input = document.createElement("input");
      input.type = "hidden";
      input.name = "codigo";
      input.value = datos.codigo;

      form.appendChild(input);
      document.body.appendChild(form);
      form.submit();
    };

    // Limpiar contenido actual y agregar el botón
    cuotaSpan.innerHTML = ""; 
    cuotaSpan.appendChild(btnPagar);
  } else {
    cuotaSpan.classList.remove("text-danger");
    cuotaSpan.classList.add("text-success");
    cuotaSpan.textContent = datos.estadoCuota || "";
  }
}


    
    if (vtoSmall) {
      const fecha = datos.vencimiento ? `Vence: ${datos.vencimiento}` : "";
      const clases =
        typeof datos.clases !== "undefined"
          ? ` | Clases disponibles: ${datos.clases}`
          : "";
      vtoSmall.textContent = fecha + clases;
    }

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
        mostrarMensaje(datos.mensaje, datos.datos.activo ? "ok" : "error");
        mostrarDetalle(datos.datos);

        if (!datos.datos.activo) {
          // 🔊 Sonido solo para miembro inactivo
          const sonidoError = document.getElementById("audio-error");
          if (sonidoError) sonidoError.play();

          mostrarBotonesRenovacion(datos.datos);
        } else {
          // ✅ Si está activo, mostrar opción de adelantar cuota
          mostrarBotonesAdelanto(datos.datos);
        }
      } else {
        // No se encontró al usuario, pero no reproducimos sonido aquí si ya lo hicimos antes
        mostrarMensaje(datos.mensaje || "No encontrado.", "error");
        mostrarDetalle(null);
      }
    } catch (error) {
      console.error("Error lector:", error);

      const sonidoError = document.getElementById("audio-error");
      if (sonidoError) sonidoError.play();

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

//renovacion de cuota

function mostrarBotonesRenovacion(datos) {
  const contenedor = document.getElementById("botones-renovacion");
  if (!contenedor) return;
  contenedor.innerHTML = "";

  const fechaVto = datos.vencimiento || "";
  const activo = datos.activo;

  const btn = document.createElement("button");
  btn.className = "btn btn-primary";
  btn.textContent = activo
    ? `Adelantar cuota desde ${fechaVto}`
    : `Renovar desde ${fechaVto}`;

  btn.addEventListener("click", () => {
    const url = new URL("admin-gym/renovacion.php", window.location.origin);
    url.searchParams.set("codigo", datos.codigo); // clave para cargar el miembro
    url.searchParams.set("accion", activo ? "adelanto" : "renovacion");
    window.location.href = url.toString();
  });

  contenedor.appendChild(btn);
}

function mostrarBotonesAdelanto(datos) {
  const contenedor = document.getElementById("botones-renovacion");
  if (!contenedor) return;
  contenedor.innerHTML = "";

  const fechaVto = datos.vencimiento || "";

  const btn = document.createElement("button");
  btn.className = "btn btn-outline-primary px-4 py-2";
  btn.textContent = `Adelantar cuota desde ${fechaVto}`;

  btn.onclick = () => {
    const url = new URL("admin-gym/renovacion.php", window.location.origin);
    url.searchParams.set("codigo", datos.codigo);
    url.searchParams.set("accion", "adelanto");
    window.location.href = url.toString();
  };

  contenedor.appendChild(btn);
}
