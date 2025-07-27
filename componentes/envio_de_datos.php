<?php
header('Content-Type: application/json');
include('../conexion.php');
session_start();

if (!isset($_SESSION['admin'])) {
    echo json_encode(["ok" => false, "error" => "No autorizado"]);
    exit;
}

$admin_id = $_SESSION['admin'];

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $nombre               = $_POST['nombre']                ?? '';
    $apellido             = $_POST['apellido']              ?? '';
    $dni                  = $_POST['dni']                   ?? '';
    $telefono             = $_POST['telefono']              ?? '';
    $sexo_id              = $_POST['sexo_id']               ?? null;
    $planes_id            = $_POST['planes_id']             ?? null;
    $monto                = (isset($_POST['monto']) && is_numeric($_POST['monto'])) ? (int)$_POST['monto'] : 0;
    $fecha_de_vencimiento = $_POST['fecha_de_vencimiento']  ?? null;
    $recargo              = (isset($_POST['recargo']) && is_numeric($_POST['recargo'])) ? (int)$_POST['recargo'] : 0;
    $metodo_de_pagos_id   = $_POST['metodo_de_pagos_id']    ?? 1;
    $codigo_input = $_POST['tarjeta_miembro'] ?? '';
    $codigo = trim($codigo_input) !== '' ? $codigo_input : "$apellido@$nombre@$telefono";
    $estado_id = 1;

    $sql = "INSERT INTO miembros 
        (admin_id, nombre, apellido, dni, telefono, codigo, estado_id, metodo_de_pagos_id, sexo_id, planes_id, monto, fecha_de_vencimiento, recargo)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        echo json_encode(["ok" => false, "error" => "Error SQL miembros: " . $conn->error]);
        exit;
    }

    $stmt->bind_param(
        "isssssiiiiisi",
        $admin_id,
        $nombre,
        $apellido,
        $dni,
        $telefono,
        $codigo,
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

        // Registrar operación en caja
        $detalle = "Pago de inscripción del plan";
        $tipo_operacion = "pago";

        $sqlCaja = "INSERT INTO caja 
            (admin_id, miembro_id, monto, detalle, metodo_pago_id, tipo, miembro_nombre, miembro_apellido) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        $stmtCaja = $conn->prepare($sqlCaja);
        if ($stmtCaja) {
            $stmtCaja->bind_param(
                "iidsssss",
                $admin_id,
                $miembro_id,
                $monto,
                $detalle,
                $metodo_de_pagos_id,
                $tipo_operacion,
                $nombre,
                $apellido
            );
            $stmtCaja->execute();
            $stmtCaja->close();
        }

        echo json_encode(["ok" => true]);
    } else {
        echo json_encode(["ok" => false, "error" => $stmt->error]);
    }

    $stmt->close();
    $conn->close();
    exit;
}

echo json_encode(["ok" => false, "error" => "Método no permitido"]);
exit;
