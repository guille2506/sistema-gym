<?php
include('../conexion.php');

ini_set('display_errors', 1);
error_reporting(E_ALL);


if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $miembro_id = $_POST['miembro_id'] ?? null;
    $monto = $_POST['monto'] ?? null;
    $detalle = $_POST['detalle'] ?? '';
    $tipo = $_POST['tipo'] ?? 'ingreso';
    $metodo_pago_id = $_POST['metodo_pago_id'] ?? 1;
    $miembro_nombre = $_POST['miembro_nombre'] ?? null;
    $miembro_apellido = $_POST['miembro_apellido'] ?? null;



    if ($miembro_id && $monto && $detalle && $tipo) {
        $sql = "INSERT INTO caja (miembro_id, monto, detalle, metodo_pago_id, tipo, miembro_nombre, miembro_apellido)
        VALUES (?, ?, ?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("idsisss", $miembro_id, $monto, $detalle, $metodo_pago_id, $tipo, $miembro_nombre, $miembro_apellido);



        if ($stmt->execute()) {
            echo json_encode(["ok" => true]);
        } else {
            echo json_encode(["ok" => false, "error" => $stmt->error]);
        }
        $stmt->close();
    } else {
        echo json_encode(["ok" => false, "error" => "Datos incompletos."]);
    }

    $conn->close();
    exit;
}

echo json_encode(["ok" => false, "error" => "Método no permitido"]);
exit;
