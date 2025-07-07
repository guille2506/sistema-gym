document.addEventListener("DOMContentLoaded", () => {
  const urlParams = new URLSearchParams(window.location.search);
  const montoUrl = urlParams.get("monto");
  const planIdUrl = urlParams.get("plan");

  const inputMonto = document.getElementById("monto");
  const selectPlan = document.getElementById("planes_id");
  const inputFecha = document.getElementById("fecha_de_vencimiento");

  let montoOriginal = montoUrl ? parseFloat(montoUrl) : 0;

  if (montoOriginal && inputMonto) {
    inputMonto.value = `${montoOriginal}`;
  }

  if (planIdUrl && selectPlan) {
    selectPlan.value = planIdUrl;
  }

  if (inputFecha) {
    const hoy = new Date();
    const en30Dias = new Date(hoy);
    en30Dias.setDate(hoy.getDate() + 30);
    inputFecha.value = en30Dias.toISOString().split("T")[0];
  }

  actualizarPagoYRecargo(montoOriginal);

  inputMonto.addEventListener("input", () => {
    const valor = parseFloat(inputMonto.value.replace(/\$/g, "") || 0);
    actualizarPagoYRecargo(valor);
  });

  function actualizarPagoYRecargo(montoIngresado) {
    const pagoValor = document.getElementById("pago_valor");
    const pagoPorcentaje = document.getElementById("pago_porcentaje");
    const barraPago = document.getElementById("barra_pago");

    const recargoValor = document.getElementById("recargo_valor");
    const recargoPorcentaje = document.getElementById("recargo_porcentaje");
    const barraRecargo = document.getElementById("barra_recargo");

    if (montoIngresado >= montoOriginal || montoOriginal === 0) {
      if (pagoValor) pagoValor.textContent = montoIngresado;
      if (pagoPorcentaje) pagoPorcentaje.textContent = "100%";
      if (barraPago) {
        barraPago.style.width = "100%";
        barraPago.setAttribute("aria-valuenow", "100");
      } else {
        const porcentaje = Math.round((montoIngresado / montoOriginal) * 100);
        const recargo = montoOriginal - montoIngresado;

        document.getElementById("recargo").value = recargo;
      }

      if (recargoValor) recargoValor.textContent = "0";
      if (recargoPorcentaje) recargoPorcentaje.textContent = "0%";
      if (barraRecargo) {
        barraRecargo.style.width = "0%";
        barraRecargo.setAttribute("aria-valuenow", "0");
      }

      document.getElementById("recargo").value = 0;
    } else {
      const porcentaje = Math.round((montoIngresado / montoOriginal) * 100);
      const recargo = montoOriginal - montoIngresado;

      if (pagoValor) pagoValor.textContent = montoIngresado;
      if (pagoPorcentaje) pagoPorcentaje.textContent = `${porcentaje}%`;
      if (barraPago) {
        barraPago.style.width = `${porcentaje}%`;
        barraPago.setAttribute("aria-valuenow", porcentaje);
      }

      if (recargoValor) recargoValor.textContent = recargo;
      if (recargoPorcentaje)
        recargoPorcentaje.textContent = `${100 - porcentaje}%`;
      if (barraRecargo) {
        barraRecargo.style.width = `${100 - porcentaje}%`;
        barraRecargo.setAttribute("aria-valuenow", 100 - porcentaje);

        document.getElementById("recargo").value = recargo;
      }
    }
  }

  // --- Botón de envío ---
  document
    .getElementById("btnEnviar")
    .addEventListener("click", manejarFormulario);
});

async function manejarFormulario() {
  const nombre = document.getElementById("nombre").value;
  const apellido = document.getElementById("apellido").value;
  const telefono = document.getElementById("telefono").value;
  const telEmergencia = document.getElementById("telefono_emergencia").value;
  const email = document.getElementById("email").value;
  const dni = document.getElementById("dni").value;
  const sexoId = document.getElementById("sexo_id").value;
  const planesId = document.getElementById("planes_id").value;
  const monto = document.getElementById("monto").value;
  const fecha_de_vencimiento = document.getElementById(
    "fecha_de_vencimiento"
  ).value;
  const metodoPago = document.querySelector(
    'input[name="metodo_de_pagos_id"]:checked'
  );
  const recargo = document.getElementById("recargo").value;



  // --- Validaciones ---
  if (!sexoId)
    return mostrarAlerta(
      "Sexo no seleccionado",
      "Por favor, seleccioná una opción en el campo sexo."
    );
  if (!planesId)
    return mostrarAlerta(
      "Plan no seleccionado",
      "Por favor, seleccioná un plan."
    );
  if (!monto)
    return mostrarAlerta("Monto no ingresado", "Por favor, ingresá un monto.");
  if (!metodoPago)
    return mostrarAlerta(
      "Método de pago no seleccionado",
      "Por favor, seleccioná un método de pago."
    );
  if (!dni)
    return mostrarAlerta(
      "Oops...",
      "No estás ingresando el DNI. Si no lo quiere dar, ingresá cualquier número!"
    );



  // --- Generación de código PDF417 ---
  const contenido = `${apellido}@${nombre}@${telefono}@${email}`;
  try {
    const canvas = document.getElementById("codigoPdf417");
    bwipjs.toCanvas(canvas, {
      bcid: "pdf417",
      text: contenido,
      scale: 4,
      height: 12,
      columns: 3,
      rows: 12,
      includetext: false,
      compact: false,
      paddingwidth: 3,
      paddingheight: 3,
      backgroundcolor: "FFFFFF",
    });

    setTimeout(() => {
      const ctx = canvas.getContext("2d");
      const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
      const tempCanvas = document.createElement("canvas");
      tempCanvas.width = canvas.width;
      tempCanvas.height = canvas.height;
      const tempCtx = tempCanvas.getContext("2d");
      tempCtx.fillStyle = "#FFFFFF";
      tempCtx.fillRect(0, 0, tempCanvas.width, tempCanvas.height);
      tempCtx.putImageData(imageData, 0, 0);
      const dataURL = tempCanvas.toDataURL("image/jpeg", 1.0);

      const link = document.createElement("a");
      link.href = dataURL;
      link.download = "codigo-barra.jpg";
      link.click();
    }, 100);
    

    // --- Envío de datos ---
    const formData = new FormData();
    formData.append("nombre", nombre);
    formData.append("apellido", apellido);
    formData.append("dni", dni);
    formData.append("telefono", telefono);
    formData.append("telefono_emergencia", telEmergencia);
    formData.append("email", email);
    formData.append("metodo_de_pagos_id", metodoPago.value);
    formData.append("sexo_id", sexoId);
    formData.append("planes_id", planesId);
    formData.append("monto", monto);
    formData.append("fecha_de_vencimiento", fecha_de_vencimiento);
    formData.append("recargo", recargo);

    const res = await fetch("/admin-gym/componentes/envio_de_datos.php", {
      method: "POST",
      body: formData,
    });

    const json = await res.json();
    if (json.ok) {
      Swal.fire({
        title: "¡Listo!",
        text: "El usuario fue guardado y el código generado.",
        icon: "success",
        confirmButtonText: "Aceptar",
        confirmButtonClass: "btn btn-primary",
        buttonsStyling: false,
      });
    } else {
      mostrarAlerta("Oops...", "Error al enviar los datos.");
    }
  } catch (err) {
    mostrarAlerta("Oops...", "¡DNI o Email ya registrados!");
  }
}

// --- Función reutilizable para alertas ---
function mostrarAlerta(titulo, mensaje) {
  Swal.fire({
    title: titulo,
    text: mensaje,
    icon: "warning",
    confirmButtonClass: "btn btn-primary w-xs mt-2",
    buttonsStyling: false,
  });
}

console.log("hola")