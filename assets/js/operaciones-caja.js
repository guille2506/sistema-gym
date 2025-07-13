document.addEventListener("DOMContentLoaded", () => {
  const btn = document.getElementById("btnOperacion");

  if (!btn) {
    console.warn("Botón 'btnOperacion' no encontrado.");
    return;
  }

  btn.addEventListener("click", async () => {
    let miembroSeleccionado = null;

    await Swal.fire({
      title: "Buscar miembro",
      html: `
        <input id="buscar-miembro" class="swal2-input" placeholder="Nombre, Apellido o DNI">
        <div id="resultados-miembros" style="text-align:left; max-height:150px; overflow-y:auto; margin-top:5px; scrollbar-width: none; -ms-overflow-style: none;"></div>
        <style>#resultados-miembros::-webkit-scrollbar { display: none; }</style>
      `,
      showCancelButton: true,
      confirmButtonText: "Siguiente",
      preConfirm: () => {
        if (!miembroSeleccionado) {
          Swal.showValidationMessage("Debés seleccionar un miembro.");
        }
        return miembroSeleccionado;
      },
      didOpen: () => {
        const input = document.getElementById("buscar-miembro");
        const resultados = document.getElementById("resultados-miembros");

        input.addEventListener("input", async () => {
          const term = input.value.trim();
          if (term.length >= 2) {
            const res = await fetch(`componentes/autocomplete_miembros.php?term=${encodeURIComponent(term)}`);
            const data = await res.json();

            resultados.innerHTML = "";
            data.forEach(miembro => {
              const div = document.createElement("div");
              div.textContent = `${miembro.nombre} ${miembro.apellido} (${miembro.dni})`;
              div.style.padding = "5px";
              div.style.cursor = "pointer";
              div.style.borderBottom = "1px solid #eee";
              div.addEventListener("click", () => {
                miembroSeleccionado = miembro;
                input.value = `${miembro.nombre} ${miembro.apellido}`;
                resultados.innerHTML = "";
              });
              resultados.appendChild(div);
            });
          } else {
            resultados.innerHTML = "";
          }
        });
      }
    });

    if (!miembroSeleccionado) return;

    const { value: formValues } = await Swal.fire({
      title: "Nueva operación",
      html: `
        <p><strong>Miembro:</strong> ${miembroSeleccionado.nombre} ${miembroSeleccionado.apellido}</p>
        <input id="monto" type="number" min="1" class="swal2-input" placeholder="Monto">
        <input id="detalle" class="swal2-input" placeholder="Motivo">
        <select id="tipo" class="swal2-select">
          <option value="ingreso">Ingreso</option>
          <option value="extraccion">Extracción</option>
        </select>
      `,
      focusConfirm: false,
      preConfirm: () => {
        const monto = parseInt(document.getElementById("monto").value, 10);
        if (!monto || monto <= 0) {
          Swal.showValidationMessage("Ingresá un monto válido mayor a 0");
          return false;
        }

        return {
          miembro_id: miembroSeleccionado.id,
          monto: monto,
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
        Swal.fire("Operación guardada", "", "success");

        const totalCajaDiv = document.getElementById("totalCaja");
        if (totalCajaDiv) {
          const r = await fetch("componentes/TotalCaja.php");
          const html = await r.text();
          totalCajaDiv.innerHTML = html;
        }
      } else {
        Swal.fire("Error", json.error || "No se pudo guardar", "error");
      }
    }
  });
});
