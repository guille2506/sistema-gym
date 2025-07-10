document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("btnOperacion");

  if (!btn) {
    console.warn("Botón 'btnOperacion' no encontrado.");
    return;
  }

  btn.addEventListener("click", async () => {
    const res = await fetch('componentes/lista_miembros.php');
    const miembros = await res.json();

    const options = miembros.map(m => `<option value="${m.id}">${m.nombre} ${m.apellido}</option>`).join("");

    const { value: formValues } = await Swal.fire({
      title: "Nueva operación",
      html: `
        <select id="miembro" class="swal2-select">${options}</select><br><br>
        <input id="monto" class="swal2-input" placeholder="Monto">
        <input id="detalle" class="swal2-input" placeholder="Motivo">
        <select id="tipo" class="swal2-select">
          <option value="ingreso">Ingreso</option>
          <option value="extraccion">Extracción</option>
        </select>
      `,
      focusConfirm: false,
      preConfirm: () => {
        return {
          miembro_id: document.getElementById("miembro").value,
          monto: document.getElementById("monto").value,
          detalle: document.getElementById("detalle").value,
          tipo: document.getElementById("tipo").value
        };
      }
    });

    if (formValues) {
      const res = await fetch('componentes/cajaOpeaciones.php', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams(formValues)
      });
      const json = await res.json();
      if (json.ok) {
        Swal.fire("Operación guardada", "", "success").then(() => location.reload());
      } else {
        Swal.fire("Error", json.error, "error");
      }
    }
  });
});
