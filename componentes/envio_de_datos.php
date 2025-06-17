<?php
header('Content-Type: application/json');
include('../conexion.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre               = $_POST['nombre']                ?? '';
    $apellido             = $_POST['apellido']              ?? '';
    $dni                  = $_POST['dni']                   ?? '';
    $telefono             = $_POST['telefono']              ?? '';
    $telefono_emergencia  = $_POST['telefono_emergencia']   ?? '';
    $email                = $_POST['email']                 ?? '';
    $sexo_id              = $_POST['sexo_id']               ?? null;


    $estado_id            = 1;                             
    $metodo_de_pagos_id   = $_POST['metodo_de_pagos_id']    ?? 1; 

    $codigoGenerado = "$apellido@$nombre@$telefono@$email";

    $sql = "INSERT INTO miembros
            (nombre, apellido, dni, telefono, telefono_emergencia, email, codigo, estado_id, metodo_de_pagos_id, sexo_id)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    $stmt->bind_param(
        "sssssssiii",
        $nombre,
        $apellido,
        $dni,
        $telefono,
        $telefono_emergencia,
        $email,
        $codigoGenerado,
        $estado_id,
        $metodo_de_pagos_id,
        $sexo_id
    );

    if ($stmt->execute()) {
        echo json_encode(["ok" => true]);
    } else {
        echo json_encode([
            "ok"    => false,
            "error" => $stmt->error    
        ]);
    }
    $stmt->close();
    $conn->close();
    exit;
}

echo json_encode(["ok" => false, "error" => "Método no permitido"]);
exit;
?>



