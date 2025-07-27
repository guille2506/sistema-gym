document.addEventListener("DOMContentLoaded", () => {
  // --- Elementos del DOM ---
  const form          = document.getElementById("formFiltros");
  const btnMostrar    = document.getElementById("btnMostrar");
  const btnOperacion  = document.getElementById("btnOperacion");
  const btnCerrarCaja = document.getElementById("btnCerrarCaja");

  const totalCajaDiv   = document.getElementById("totalCaja");
  const contenedorCaja = document.getElementById("contenedorTotalCaja");
  const tbodyCaja      = document.getElementById("tbodyCaja"); // <tbody id="tbodyCaja">

  function getFiltrosQS() {
    const fd = new FormData(form);
    return new URLSearchParams(fd).toString(); // tipo=...&desde=...&hasta=...
  }

  // --- Actualizar tabla (lista de movimientos) ---
  function actualizarTabla() {
    const qs = getFiltrosQS();
    fetch(`componentes/lista_caja.php?${qs}`)
      .then(res => res.text())
      .then(html => {
        if (tbodyCaja) {
          tbodyCaja.innerHTML = html;
        }
      })
      .catch(err => {
        console.error("Error al cargar lista:", err);
        if (tbodyCaja) {
          tbodyCaja.innerHTML = `
            <tr><td colspan="10" class="text-danger text-center">Error al cargar la lista.</td></tr>
          `;
        }
      });
  }

  // --- Actualizar total de caja ---
  function actualizarTotal() {
    const qs = getFiltrosQS();
    if (contenedorCaja) contenedorCaja.style.display = "block";

    fetch(`componentes/TotalCaja.php?${qs}`)
      .then(res => res.text())
      .then(html => {
        if (totalCajaDiv) totalCajaDiv.innerHTML = html;
      })
      .catch(err => {
        console.error("Error al calcular total:", err);
        if (totalCajaDiv) totalCajaDiv.textContent = "Error.";
      });
  }

  // --- Carga inicial (al abrir la página) ---
  actualizarTabla();
  actualizarTotal();

  // --- Click en Mostrar (submit del form) ---
  if (form) {
    form.addEventListener("submit", (e) => {
      e.preventDefault();     // no recargar la página
      actualizarTabla();      // recargar filas filtradas
      actualizarTotal();      // recargar total filtrado
    });
  }

  // --- Cerrar Caja (día actual) ---
  if (btnCerrarCaja) {
    btnCerrarCaja.addEventListener("click", () => {
      Swal.fire({
        title: "¿Cerrar caja del día?",
        text: "Se marcarán como cerradas las operaciones abiertas de hoy.",
        icon: "warning",
        showCancelButton: true,
        confirmButtonText: "Sí, cerrar",
      }).then((r) => {
        if (!r.isConfirmed) return;

        fetch("componentes/cerrar_caja.php", { method: "POST" })
          .then(res => res.json()) // hacé que cerrar_caja.php devuelva {ok:true,msg:"..."}
          .then(json => {
            if (json.ok) {
              Swal.fire("Caja cerrada", json.msg || "", "success").then(() => {
                actualizarTabla();
                actualizarTotal();
              });
            } else {
              Swal.fire("Error", json.error || "No se pudo cerrar la caja.", "error");
            }
          })
          .catch(err => {
            console.error(err);
            Swal.fire("Error", "Error de red.", "error");
          });
      });
    });
  }

  // --- Generar nueva operación ---
  if (btnOperacion) {
    btnOperacion.addEventListener("click", async () => {
      let miembroSeleccionado = null;
      let listaMiembros = [];

      const result = await Swal.fire({
        title: "Buscar miembro",
        html: `
          <input id="buscar-miembro" class="swal2-input" placeholder="Nombre, Apellido o DNI" autocomplete="off">
          <div id="resultados-miembros" style="text-align:left; max-height:150px; overflow-y:auto; margin-top:5px;"></div>
        `,
        showCancelButton: true,
        confirmButtonText: "Siguiente",
        focusConfirm: false,
        preConfirm: () => {
          const input = document.getElementById("buscar-miembro");
          const inputValue = input.value.trim().toLowerCase().replace(/\s+/g, " ");
          if (!miembroSeleccionado && listaMiembros.length > 0) {
            const match = listaMiembros.find((m) => {
              const full = `${m.nombre} ${m.apellido}`.toLowerCase();
              return full === inputValue || m.dni === inputValue;
            });
            if (match) miembroSeleccionado = match;
          }
          if (!miembroSeleccionado) {
            Swal.showValidationMessage("Debés seleccionar un miembro.");
            return false;
          }
          return miembroSeleccionado;
        },
        didOpen: () => {
          const input = document.getElementById("buscar-miembro");
          const resultados = document.getElementById("resultados-miembros");
          input.focus();

          input.addEventListener("input", async () => {
            if (input.getAttribute("data-selected") === "true") return;
            const term = input.value.trim();
            if (term.length >= 2) {
              const res = await fetch(`componentes/autocomplete_miembros.php?term=${encodeURIComponent(term)}`);
              listaMiembros = await res.json();
              resultados.innerHTML = "";
              listaMiembros.forEach((miembro) => {
                const div = document.createElement("div");
                div.textContent = `${miembro.nombre} ${miembro.apellido} (${miembro.dni})`;
                div.style.padding = "5px";
                div.style.cursor = "pointer";
                div.style.borderBottom = "1px solid #eee";
                div.addEventListener("mousedown", () => {
                  miembroSeleccionado = miembro;
                  input.value = `${miembro.nombre} ${miembro.apellido}`;
                  input.setAttribute("data-selected", "true");
                  resultados.innerHTML = "";
                });
                resultados.appendChild(div);
              });
            } else {
              resultados.innerHTML = "";
              listaMiembros = [];
            }
          });

          input.addEventListener("keydown", (e) => {
            if (e.key === "Enter" && listaMiembros.length === 1 && !miembroSeleccionado) {
              e.preventDefault();
              miembroSeleccionado = listaMiembros[0];
              input.value = `${miembroSeleccionado.nombre} ${miembroSeleccionado.apellido}`;
              input.setAttribute("data-selected", "true");
              resultados.innerHTML = "";
            }
          });
        },
      });

      if (!result.isConfirmed) return;

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
        showCancelButton: true,
        confirmButtonText: "Guardar",
        focusConfirm: false,
        preConfirm: () => {
          const monto = parseFloat(document.getElementById("monto").value);
          if (!monto || monto <= 0) {
            Swal.showValidationMessage("Ingresá un monto válido mayor a 0");
            return false;
          }
          return {
            miembro_id: miembroSeleccionado.id,
            monto,
            detalle: document.getElementById("detalle").value,
            tipo: document.getElementById("tipo").value,
          };
        },
      });

      if (!formValues) return;

      // Guardar en caja
      const res = await fetch("componentes/cajaOpeaciones.php", {
        method: "POST",
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
        body: new URLSearchParams(formValues),
      });
      const json = await res.json();

      if (json.ok) {
        Swal.fire("Operación guardada", "", "success").then(() => {
          actualizarTabla(); // recargar lista con filtros actuales
          actualizarTotal(); // recargar total con filtros actuales
        });
      } else {
        Swal.fire("Error", json.error || "No se pudo guardar", "error");
      }
    });
  }
});
