document.addEventListener("DOMContentLoaded", () => {
  const inputMonto = document.getElementById("monto");
  const recargoTotal = parseFloat(document.getElementById("recargo_total").value || 0);

  const pagoTexto = document.getElementById("pago_valor");
  const pagoPorcentaje = document.getElementById("pago_porcentaje");
  const barraPago = document.getElementById("barra_pago");

  const recargoTexto = document.getElementById("recargo_valor");
  const recargoPorcentaje = document.getElementById("recargo_porcentaje");
  const barraRecargo = document.getElementById("barra_recargo");

  const inputRecargo = document.getElementById("recargo");

  function actualizarBarras() {
    let pagado = parseFloat(inputMonto.value) || 0;
    if (pagado > recargoTotal) pagado = recargoTotal;

    const porcentajePago = Math.round((pagado / recargoTotal) * 100);
    const porcentajeRecargo = 100 - porcentajePago;

    // Actualizar textos y barras
    pagoTexto.textContent = `$${pagado}`;
    pagoPorcentaje.textContent = `${porcentajePago}%`;
    barraPago.style.width = `${porcentajePago}%`;

    recargoTexto.textContent = `$${recargoTotal - pagado}`;
    recargoPorcentaje.textContent = `${porcentajeRecargo}%`;
    barraRecargo.style.width = `${porcentajeRecargo}%`;

    if (inputRecargo) inputRecargo.value = recargoTotal - pagado;
  }

  if (inputMonto) {
    inputMonto.addEventListener("input", actualizarBarras);
    actualizarBarras(); // inicial
  }

  const btnEnviar = document.getElementById("btnEnviar");
  if (btnEnviar) {
    btnEnviar.addEventListener("click", async () => {
      const form = document.getElementById("form_recargo");
      const formData = new FormData(form);

      try {
        const response = await fetch("componentes/procesar_recargo.php", {
          method: "POST",
          body: formData,
        });

        const data = await response.json();

        if (data.status === "ok") {
          Swal.fire({
            icon: "success",
            title: "Éxito",
            text: data.mensaje,
          }).then(() => {
            window.location.href = "panel.php";
          });
        } else {
          Swal.fire({
            icon: "error",
            title: "Error",
            text: data.mensaje || "Ocurrió un error al procesar el recargo.",
          });
        }
      } catch (err) {
        console.error("Error al enviar:", err);
        Swal.fire({
          icon: "error",
          title: "Error",
          text: "Error en la conexión con el servidor.",
        });
      }
    });
  }
});
