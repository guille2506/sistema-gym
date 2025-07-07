    document.addEventListener("DOMContentLoaded", function () {
    const botonesEliminar = document.querySelectorAll(".btn-eliminar");

    botonesEliminar.forEach(function (btn) {
        btn.addEventListener("click", function () {
            const id = btn.dataset.id;

            Swal.fire({
                title: '¿Estás seguro?',
                text: "¡No podrás revertir esto!",
                icon: 'warning',
                showCancelButton: true,
                confirmButtonText: 'Sí, eliminar',
                cancelButtonText: 'Cancelar',
                confirmButtonClass: 'btn btn-primary w-xs me-2 mt-2',
                cancelButtonClass: 'btn btn-danger w-xs mt-2',
                buttonsStyling: false
            }).then((result) => {
                if (result.isConfirmed) {
                    fetch('eliminar_miembro.php', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: 'id=' + encodeURIComponent(id)
                    })
                    .then(response => response.text())
                    .then(data => {
                        Swal.fire({
                            title: 'Eliminado',
                            text: 'El miembro ha sido eliminado.',
                            icon: 'success',
                            confirmButtonClass: 'btn btn-primary mt-2',
                            buttonsStyling: false
                        }).then(() => {
                            location.reload();
                        });
                    })
                    .catch(error => {
                        Swal.fire({
                            title: 'Error',
                            text: 'Hubo un problema al eliminar.',
                            icon: 'error',
                            confirmButtonClass: 'btn btn-primary mt-2',
                            buttonsStyling: false
                        });
                    });
                }
            });
        });
    });
});

// Función global para cambiar estado
function cambiarEstado(miembroId) {
    Swal.fire({
        title: 'Cambiar estado',
        input: 'select',
        inputOptions: {
            1: 'Activo',
            2: 'Inactivo'
        },
        inputPlaceholder: 'Seleccionar estado',
        showCancelButton: true,
        confirmButtonText: 'Guardar',
        cancelButtonText: 'Cancelar',
        preConfirm: (nuevoEstado) => {
            return fetch('cambiar_estado.php', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'id=' + miembroId + '&nuevo_estado=' + nuevoEstado
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('Error al cambiar el estado');
                }
                return response.text();
            })
            .catch(error => {
                Swal.showValidationMessage(`Error: ${error}`);
            });
        }
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: 'Estado actualizado',
                icon: 'success',
                timer: 1500,
                showConfirmButton: false
            }).then(() => {
                location.reload();
            });
        }
    });
}
