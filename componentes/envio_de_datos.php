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
    $planes_id            = $_POST['planes_id']             ?? null;
    $monto = isset($_POST['monto']) && is_numeric($_POST['monto']) ? (int)$_POST['monto'] : 0;
    $fecha_de_vencimiento   = $_POST['fecha_de_vencimiento']   ?? null;
    $recargo = isset($_POST['recargo']) && is_numeric($_POST['recargo']) ? (int)$_POST['recargo'] : 0;





    $estado_id            = 1;
    $metodo_de_pagos_id   = $_POST['metodo_de_pagos_id']    ?? 1;

    $codigoGenerado = "$apellido@$nombre@$telefono@$email";

    $sql = "INSERT INTO miembros
(nombre, apellido, dni, telefono, telefono_emergencia, email, codigo, estado_id, metodo_de_pagos_id, sexo_id, planes_id, monto, fecha_de_vencimiento, recargo)
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";



    $stmt = $conn->prepare($sql);
    $stmt->bind_param(
        "sssssssiiiiisi",
        $nombre,
        $apellido,
        $dni,
        $telefono,
        $telefono_emergencia,
        $email,
        $codigoGenerado,
        $estado_id,
        $metodo_de_pagos_id,
        $sexo_id,
        $planes_id,
        $monto,
        $fecha_de_vencimiento,
        $recargo
    );


 if ($stmt->execute()) {
        $miembro_id = $conn->insert_id;

        $detalle = "Pago de inscripción del plan";
        $tipo_operacion = "pago";
        $sqlCaja = "INSERT INTO caja (miembro_id, monto, detalle, metodo_pago_id, tipo) 
                    VALUES (?, ?, ?, ?, ?)";
        $stmtCaja = $conn->prepare($sqlCaja);
        $stmtCaja->bind_param("idsis", $miembro_id, $monto, $detalle, $metodo_de_pagos_id, $tipo_operacion);
        $stmtCaja->execute();
        $stmtCaja->close();

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