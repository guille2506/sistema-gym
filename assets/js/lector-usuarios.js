document.addEventListener("DOMContentLoaded", () => {
  const inputBuscar = document.getElementById("buscar-usuario");
  const botonEscanear = document.getElementById("btn-escanear");
  const resultadoDiv = document.getElementById("resultado-lector");

  const detalleDiv = document.getElementById("detalle-miembro");
  const avatarImg = document.getElementById("avatar-miembro");
  const nombreH5 = document.getElementById("nombre-miembro");
  const planSmall = document.getElementById("plan-miembro");
  const cuotaSmall = document.getElementById("cuota-miembro");
  const vtoSmall = document.getElementById("vto-miembro");

  inputBuscar.focus();

  const validarCodigo = async (codigo) => {
    try {
      const respuesta = await fetch("componentes/lector.php", {
        method: "POST",
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: "codigo=" + encodeURIComponent(codigo),
      });

      const datos = await respuesta.json();
      resultadoDiv.textContent = datos.mensaje;
      resultadoDiv.style.color = datos.status === "ok" ? "green" : "red";

      if (datos.status === "ok") {
        avatarImg.src = datos.datos.avatar;
        nombreH5.textContent = `${datos.datos.nombre} ${datos.datos.apellido}`;
        planSmall.textContent = `Plan: ${datos.datos.plan}`;
        detalleDiv.style.display = "block";
        cuotaSmall.textContent = datos.datos.estadoCuota;
        vtoSmall.textContent = `Vence: ${datos.datos.vencimiento}`;
      } else {
        detalleDiv.style.display = "none";
      }
    } catch (error) {
      resultadoDiv.textContent = "❌ Error de conexión con el servidor.";
      resultadoDiv.style.color = "red";
      detalleDiv.style.display = "none";
    }
  };

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
      if (valor.length >= 6) {
        validarCodigo(valor);
        inputBuscar.value = "";
      }
    }
  });

  inputBuscar.addEventListener("keydown", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      const valor = inputBuscar.value.trim();
      validarCodigo(valor);
    }
  });

  botonEscanear.addEventListener("click", () => {
    inputBuscar.focus();
  });
});
