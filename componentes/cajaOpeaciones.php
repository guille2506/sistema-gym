<?php
include('../conexion.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $miembro_id = $_POST['miembro_id'] ?? null;
    $monto = $_POST['monto'] ?? null;
    $detalle = $_POST['detalle'] ?? '';
    $tipo = $_POST['tipo'] ?? 'ingreso';
    $metodo_pago_id = $_POST['metodo_pago_id'] ?? 1;

    if ($miembro_id && $monto && $detalle && $tipo) {
        $sql = "INSERT INTO caja (miembro_id, monto, detalle, metodo_pago_id, tipo)
                VALUES (?, ?, ?, ?, ?)";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param("idsis", $miembro_id, $monto, $detalle, $metodo_pago_id, $tipo);

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
