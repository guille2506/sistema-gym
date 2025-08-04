let montoOriginalGlobal = 0; // Se usará como base para calcular recargo

document.addEventListener("DOMContentLoaded", () => {
  const urlParams = new URLSearchParams(window.location.search);
  const montoUrl = parseFloat(urlParams.get("monto") || 0);
  const planIdUrl = urlParams.get("plan");
  const descuentoUrl = parseFloat(urlParams.get("descuento") || 0);
const clasesUrl = parseInt(urlParams.get("clases") || 0);
const inputClases = document.getElementById("cantidad_clases");
if (inputClases && !isNaN(clasesUrl)) {
    inputClases.value = clasesUrl;
}

  const inputMonto = document.getElementById("monto");
  const selectPlan = document.getElementById("planes_id");
  const inputFecha = document.getElementById("fecha_de_vencimiento");

  // ✅ Seteo inicial desde URL
  if (!isNaN(montoUrl) && montoUrl > 0) {
    let montoConDescuento = montoUrl;

    if (!isNaN(descuentoUrl) && descuentoUrl > 0) {
      montoConDescuento = Math.round(montoUrl * (1 - descuentoUrl / 100));
    }

    montoOriginalGlobal = montoConDescuento;
    if (inputMonto) inputMonto.value = montoConDescuento;
    actualizarPagoYRecargo(montoConDescuento);
  }

  // ✅ Seleccionar plan
  if (planIdUrl && selectPlan) {
    for (let i = 0; i < selectPlan.options.length; i++) {
      if (selectPlan.options[i].value == planIdUrl) {
        selectPlan.selectedIndex = i;
        break;
      }
    }
  }

  // ✅ Fecha de vencimiento
  if (inputFecha) {
    const hoy = new Date();
    const en30Dias = new Date(hoy);
    en30Dias.setDate(hoy.getDate() + 30);
    inputFecha.value = en30Dias.toISOString().split("T")[0];
  }

  // ✅ Actualiza montoOriginal al cambiar de plan
selectPlan.addEventListener("change", () => {
    const selectedOption = selectPlan.options[selectPlan.selectedIndex];

    const nuevoMonto = parseFloat(selectedOption.dataset.precio || 0);
    const descuentoSelect = parseFloat(selectedOption.dataset.descuento || 0);
    const clasesTotales = parseInt(selectedOption.dataset.clases || 0);

    let montoConDescuento = nuevoMonto;
    if (!isNaN(descuentoSelect) && descuentoSelect > 0) {
        montoConDescuento = Math.round(nuevoMonto * (1 - descuentoSelect / 100));
    }

    montoOriginalGlobal = montoConDescuento;
    if (inputMonto) inputMonto.value = montoConDescuento;
    actualizarPagoYRecargo(montoConDescuento);

    // ✅ Actualizar automáticamente cantidad de clases
    const inputClases = document.getElementById("cantidad_clases");
    if (inputClases && !isNaN(clasesTotales)) {
        inputClases.value = clasesTotales;
    }
});

  // ✅ Escucha cambios manuales del monto
  if (inputMonto) {
    inputMonto.addEventListener("input", () => {
      const valor = parseFloat(inputMonto.value.replace(/\$/g, "") || 0);
      actualizarPagoYRecargo(valor);
    });
  }

  // ✅ Activa botón de enviar
  const btnEnviar = document.getElementById("btnEnviar");
  if (btnEnviar) {
    btnEnviar.addEventListener("click", manejarFormulario);
  }

  // ✅ Inicializa valores visuales
  actualizarPagoYRecargo(parseFloat(inputMonto?.value || 0));
});

function actualizarPagoYRecargo(montoIngresado) {
  const pagoValor = document.getElementById("pago_valor");
  const pagoPorcentaje = document.getElementById("pago_porcentaje");
  const barraPago = document.getElementById("barra_pago");

  const recargoValor = document.getElementById("recargo_valor");
  const recargoPorcentaje = document.getElementById("recargo_porcentaje");
  const barraRecargo = document.getElementById("barra_recargo");
  const recargoInput = document.getElementById("recargo");

  const montoOriginal = montoOriginalGlobal;

  if (montoIngresado >= montoOriginal || montoOriginal === 0) {
    if (pagoValor) pagoValor.textContent = montoIngresado;
    if (pagoPorcentaje) pagoPorcentaje.textContent = "100%";
    if (barraPago) {
      barraPago.style.width = "100%";
      barraPago.setAttribute("aria-valuenow", "100");
    }

    if (recargoValor) recargoValor.textContent = "0";
    if (recargoPorcentaje) recargoPorcentaje.textContent = "0%";
    if (barraRecargo) {
      barraRecargo.style.width = "0%";
      barraRecargo.setAttribute("aria-valuenow", "0");
    }

    if (recargoInput) recargoInput.value = 0;
  } else {
    const porcentaje = Math.round((montoIngresado / montoOriginal) * 100);
    const recargoCalc = montoOriginal - montoIngresado;

    if (pagoValor) pagoValor.textContent = montoIngresado;
    if (pagoPorcentaje) pagoPorcentaje.textContent = `${porcentaje}%`;
    if (barraPago) {
      barraPago.style.width = `${porcentaje}%`;
      barraPago.setAttribute("aria-valuenow", porcentaje);
    }

    if (recargoValor) recargoValor.textContent = recargoCalc;
    if (recargoPorcentaje)
      recargoPorcentaje.textContent = `${100 - porcentaje}%`;
    if (barraRecargo) {
      barraRecargo.style.width = `${100 - porcentaje}%`;
      barraRecargo.setAttribute("aria-valuenow", 100 - porcentaje);
    }

    if (recargoInput) recargoInput.value = recargoCalc;
  }
}

async function manejarFormulario() {
  const nombre = document.getElementById("nombre").value.trim();
  const apellido = document.getElementById("apellido").value.trim();
  const telefono = document.getElementById("telefono").value.trim();
  const dniInput = document.getElementById("dni");
  const dni = dniInput ? dniInput.value.trim() : "";

  const tarjetaInput = document.getElementById("tarjeta_miembro");
  const tarjetaValor = tarjetaInput ? tarjetaInput.value.trim() : "";
const cantidadClasesInput = document.getElementById("cantidad_clases");
const grupoFamiliar = document.getElementById("grupo_familiar").value.trim();
const cantidadClases = cantidadClasesInput ? cantidadClasesInput.value : 0;

  const sexoId = document.getElementById("sexo_id").value;
  const planesId = document.getElementById("planes_id").value;
  const monto = document.getElementById("monto").value;
  const fecha_vto = document.getElementById("fecha_de_vencimiento").value;
  const recargo = document.getElementById("recargo").value;
  const metodoPago = document.querySelector(
    'input[name="metodo_de_pagos_id"]:checked'
  );

  // Validaciones mínimas
  if (!sexoId)
    return mostrarAlerta(
      "Sexo no seleccionado",
      "Por favor, seleccioná una opción."
    );
  if (!planesId)
    return mostrarAlerta(
      "Plan no seleccionado",
      "Por favor, seleccioná un plan."
    );
  if (!monto) return mostrarAlerta("Monto no ingresado", "Ingresá un monto.");
  if (!metodoPago)
    return mostrarAlerta(
      "Método de pago no seleccionado",
      "Seleccioná un método."
    );
  if (typeof usarTarjeta !== "undefined" && usarTarjeta) {
    if (!tarjetaValor) {
      return mostrarAlerta(
        "Tarjeta faltante",
        "Ingresá el número de tarjeta del miembro."
      );
    }
  }

  const dniFinal = dni || tarjetaValor;

  const formData = new FormData();
  formData.append("grupo_familiar", grupoFamiliar !== "" ? grupoFamiliar : null);
  formData.append("nombre", nombre);
  formData.append("apellido", apellido);
  formData.append("dni", dniFinal);
  formData.append("telefono", telefono);
  formData.append("metodo_de_pagos_id", metodoPago.value);
  formData.append("sexo_id", sexoId);
  formData.append("planes_id", planesId);
  formData.append("monto", monto);
  formData.append("fecha_de_vencimiento", fecha_vto);
  formData.append("recargo", recargo);
  formData.append("tarjeta_miembro", tarjetaValor);
  formData.append("cantidad_clases", cantidadClases);


  try {
    const res = await fetch("componentes/envio_de_datos.php", {
      method: "POST",
      body: formData,
    });

    const json = await res.json();
    if (json.ok) {
      Swal.fire({
        title: "¡Listo!",
        text: "El usuario fue guardado.",
        icon: "success",
        confirmButtonText: "Aceptar",
        confirmButtonClass: "btn btn-primary",
        buttonsStyling: false,
      });
    } else {
      mostrarAlerta("Oops...", json.error || "Error al enviar los datos.");
    }
  } catch (err) {
    console.error("Error en la conexión o ejecución del fetch:", err);
    mostrarAlerta(
      "Oops...",
      "¡Error de conexión con el servidor o datos inválidos!"
    );
  }
}

function mostrarAlerta(titulo, mensaje) {
  Swal.fire({
    title: titulo,
    text: mensaje,
    icon: "warning",
    confirmButtonClass: "btn btn-primary w-xs mt-2",
    buttonsStyling: false,
  });
}
