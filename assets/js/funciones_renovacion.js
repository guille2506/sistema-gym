let montoOriginalGlobal = 0;

document.addEventListener("DOMContentLoaded", () => {
  const inputMonto = document.getElementById("monto");
  const selectPlan = document.getElementById("planes_id");
  const inputFecha = document.getElementById("fecha_de_vencimiento");
  const inputClases = document.getElementById("cantidad_clases");
  const inputGrupo = document.getElementById("grupo_familiar");
  const btnEnviar = document.getElementById("btnEnviar");

  // Establecer fecha por defecto
  if (inputFecha && inputFecha.value === "") {
    const hoy = new Date();
    hoy.setDate(hoy.getDate() + 30);
    inputFecha.value = hoy.toISOString().split("T")[0];
  }

  // Manejo del cambio de plan
  if (selectPlan) {
    selectPlan.addEventListener("change", () => {
      const option = selectPlan.options[selectPlan.selectedIndex];
      const precio = parseFloat(option.dataset.precio || 0);
      const descuento = parseFloat(option.dataset.descuento || 0);
      const clases = parseInt(option.dataset.clases || 0);

      let precioFinal = precio;

      if (descuento > 0) {
        precioFinal = precio - (precio * descuento / 100);
      }

      montoOriginalGlobal = precioFinal;
      if (inputMonto) inputMonto.value = precioFinal;
      if (inputClases) inputClases.value = clases;
      if (inputGrupo) inputGrupo.value = descuento > 0 ? `Descuento ${descuento}%` : "";

      actualizarPagoYRecargo(precioFinal);
    });
  }

  if (inputMonto) {
    inputMonto.addEventListener("input", () => {
      const valor = parseFloat(inputMonto.value.replace(/\$/g, "") || 0);
      actualizarPagoYRecargo(valor);
    });
  }

  if (btnEnviar) {
    btnEnviar.addEventListener("click", manejarFormularioRenovacion);
  }

  // Inicial
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
    pagoValor.textContent = montoIngresado;
    pagoPorcentaje.textContent = "100%";
    barraPago.style.width = "100%";

    recargoValor.textContent = "0";
    recargoPorcentaje.textContent = "0%";
    barraRecargo.style.width = "0%";
    if (recargoInput) recargoInput.value = 0;
  } else {
    const porcentaje = Math.round((montoIngresado / montoOriginal) * 100);
    const recargoCalc = montoOriginal - montoIngresado;

    pagoValor.textContent = montoIngresado;
    pagoPorcentaje.textContent = `${porcentaje}%`;
    barraPago.style.width = `${porcentaje}%`;

    recargoValor.textContent = recargoCalc;
    recargoPorcentaje.textContent = `${100 - porcentaje}%`;
    barraRecargo.style.width = `${100 - porcentaje}%`;

    if (recargoInput) recargoInput.value = recargoCalc;
  }
}

async function manejarFormularioRenovacion() {
  const codigo = document.getElementById("codigo")?.value.trim();
  const nombre = document.getElementById("nombre")?.value.trim();
  const apellido = document.getElementById("apellido")?.value.trim();
  const telefono = document.getElementById("telefono")?.value.trim();
  const dniInput = document.getElementById("dni");
  const dni = dniInput ? dniInput.value.trim() : "";
  const tarjetaInput = document.getElementById("tarjeta_miembro");
  const tarjetaValor = tarjetaInput ? tarjetaInput.value.trim() : "";
  const sexoId = document.getElementById("sexo_id")?.value;
  const planesId = document.getElementById("planes_id")?.value;
  const inputClases = document.getElementById("cantidad_clases");
  const grupoFamiliar = document.getElementById("grupo_familiar")?.value || "";
  const select = document.getElementById("planes_id");
  const planNombre = select?.options[select.selectedIndex]?.dataset.nombre || "";
  const monto = document.getElementById("monto")?.value;
  const fecha_vto = document.getElementById("fecha_de_vencimiento")?.value;
  const recargo = document.getElementById("recargo")?.value;
  const metodoPago = document.querySelector('input[name="metodo_de_pagos_id"]:checked');

  if (!codigo) return mostrarAlerta("Código faltante", "El campo código es requerido para la renovación.");
  if (!sexoId || !planesId || !monto || !metodoPago) {
    return mostrarAlerta("Campos requeridos", "Completá todos los campos obligatorios.");
  }

  const hoy = new Date();
  const nuevaFecha = new Date(fecha_vto);
  const tipoRenovacion = nuevaFecha > hoy ? "Adelanto de cuota" : "Renovación de plan";

  const body = {
    codigo,
    nombre,
    apellido,
    telefono,
    dni,
    sexo_id: sexoId,
    planes_id: planesId,
    plan_nombre: planNombre,
    monto,
    fecha_de_vencimiento: fecha_vto,
    recargo,
    metodo_de_pagos_id: metodoPago.value,
    tarjeta_miembro: tarjetaValor,
    tipo_renovacion: tipoRenovacion,
    cantidad_clases: inputClases?.value || 0,
    grupo_familiar: grupoFamiliar
  };

  try {
    const res = await fetch("componentes/actualizar_renovacion.php", {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify(body)
    });

    const json = await res.json();

    if (json.success) {
      Swal.fire({
        title: "¡Listo!",
        text: json.message || "Renovación realizada exitosamente.",
        icon: "success",
        confirmButtonText: "Aceptar",
        confirmButtonClass: "btn btn-primary",
        buttonsStyling: false,
      });
    } else {
      mostrarAlerta("Error", json.message || "Algo salió mal.");
    }
  } catch (err) {
    console.error("Error al enviar:", err);
    mostrarAlerta("Error de red", "No se pudo conectar con el servidor.");
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
