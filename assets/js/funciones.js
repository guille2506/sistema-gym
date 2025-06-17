



//generacion de usuarios.AgregarUsuarios.php

document.addEventListener("DOMContentLoaded", () => {
  document.getElementById('btnEnviar').addEventListener('click', manejarFormulario);
});

async function manejarFormulario() {
  const nombre = document.getElementById('nombre').value;
  const apellido = document.getElementById('apellido').value;
  const telefono = document.getElementById('telefono').value;
  const telEmergencia = document.getElementById('telefono_emergencia').value;
  const email = document.getElementById('email').value;
  const dni = document.getElementById('dni').value;


  
const sexoId = document.getElementById('sexo_id').value;
if (!sexoId) {
  Swal.fire({
    title: 'Sexo no seleccionado',
    text: 'Por favor, seleccioná una opción en el campo sexo.',
    icon: 'warning',
    confirmButtonClass: 'btn btn-primary w-xs mt-2',
    buttonsStyling: false
  });
  return;
}



const metodoPago = document.querySelector('input[name="metodo_de_pagos_id"]:checked');
if (!metodoPago) {
  Swal.fire({
    title: 'Método de pago no seleccionado',
    text: 'Por favor, seleccioná un método de pago.',
    icon: 'warning',
    confirmButtonClass: 'btn btn-primary w-xs mt-2',
    buttonsStyling: false
  });
  return;
}


  const contenido = `${apellido}@${nombre}@${telefono}@${email}`;

  if (!dni) {
     Swal.fire({
          title: 'Oops...',
          text: 'no estas ingresando el dni si no lo quiere dar ingresa cualquier número!',
          icon: 'warning',
          confirmButtonClass: 'btn btn-primary w-xs mt-2',
          buttonsStyling: false,
          footer: '<a href="">Why do I have this issue?</a>',
          showCloseButton: false
     });
    return;
  }

  try {
    const canvas = document.getElementById('codigoPdf417');

    bwipjs.toCanvas(canvas, {
      bcid: 'pdf417',
      text: contenido,
      scale: 4,
      height: 12,
      columns: 3,
      rows: 12,
      includetext: false,
      compact: false,
      paddingwidth: 10,
      paddingheight: 10
    });

    const formData = new FormData();
    formData.append("nombre", nombre);
    formData.append("apellido", apellido);
    formData.append("dni", dni);
    formData.append("telefono", telefono);
    formData.append("telefono_emergencia", telEmergencia);
    formData.append("email", email);
    formData.append("metodo_de_pagos_id", metodoPago.value);
    formData.append("sexo_id", sexoId);



    const res = await fetch("/admin-gym/componentes/envio_de_datos.php", {
      method: "POST",
      body: formData
    });







    //sweet alerts
    
    const json = await res.json();
    if (json.ok) {
            Swal.fire({
          title: '¡Listo!',
          text: 'El usuario fue guardado y el código generado.',
          icon: 'success',
          confirmButtonText: 'Aceptar',
          confirmButtonClass: 'btn btn-primary',
          buttonsStyling: false
     });
    } else {

     Swal.fire({
          title: 'Oops...',
          text: 'error a la hora de enviar datos!',
          icon: 'warning',
          confirmButtonClass: 'btn btn-primary w-xs mt-2',
          buttonsStyling: false,
          footer: '<a href="">Why do I have this issue?</a>',
          showCloseButton: false

     });
    }

  } catch (err) {
Swal.fire({
          title: 'Oops...',
          text: 'Estas ingresando DNI o Gmail ya registrados!',
          icon: 'error',
          confirmButtonClass: 'btn btn-primary w-xs mt-2',
          buttonsStyling: false,
          footer: '<a href="">Why do I have this issue?</a>',
          showCloseButton: false
     })
  }
}

