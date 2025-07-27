document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".btn-editar-plan").forEach(btn => {
        btn.addEventListener("click", async () => {
            const id = btn.dataset.id;
            const nombre = btn.dataset.nombre;
            const precio = btn.dataset.precio;

            const { value: formValues } = await Swal.fire({
                title: "Editar plan",
                html: `
                    <input id="input-nombre" class="swal2-input" placeholder="Nombre del plan" value="${nombre}">
                    <input id="input-precio" type="number" class="swal2-input" placeholder="Precio" value="${precio}">
                `,
                focusConfirm: false,
                showCancelButton: true,
                confirmButtonText: "Guardar",
                preConfirm: () => {
                    const nuevoNombre = document.getElementById("input-nombre").value.trim();
                    const nuevoPrecio = document.getElementById("input-precio").value.trim();

                    if (!nuevoNombre || !nuevoPrecio || isNaN(nuevoPrecio)) {
                        Swal.showValidationMessage("Completá nombre y precio válidos");
                        return false;
                    }

                    return {
                        id: id,
                        nombre: nuevoNombre,
                        precio: nuevoPrecio
                    };
                }
            });

            if (!formValues) return;

            // Enviar por AJAX
            try {
                const res = await fetch("componentes/editar_plan.php", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: new URLSearchParams(formValues)
                });

                const json = await res.json();

                if (json.ok) {
                    Swal.fire("Actualizado", "El plan fue editado correctamente.", "success").then(() => {
                        location.reload();
                    });
                } else {
                    Swal.fire("Error", json.error || "No se pudo actualizar.", "error");
                }
            } catch (err) {
                console.error("Error al actualizar plan:", err);
                Swal.fire("Error", "Error de conexión.", "error");
            }
        });
    });
});
