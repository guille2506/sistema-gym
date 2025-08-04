<?php
session_start();
include('../conexion.php');

$admin_id = $_SESSION['admin'] ?? null;
if (!$admin_id) {
    echo json_encode(['status' => 'error', 'mensaje' => 'No autorizado.']);
    exit;
}

$codigo = $_POST['codigo'] ?? '';
$monto_pagado = floatval($_POST['monto'] ?? 0);
$recargo_restante = floatval($_POST['recargo'] ?? 0);
$metodo_pago_id = $_POST['metodo_de_pagos_id'] ?? null;
if (!$metodo_pago_id) {
  echo json_encode(['status' => 'error', 'mensaje' => 'Selecciona un método de pago.']);
  exit;
}

if ($codigo === '' || $monto_pagado <= 0) {
    echo json_encode(['status' => 'error', 'mensaje' => 'Datos incompletos.']);
    exit;
}

// Buscar al miembro
$stmt = $conn->prepare("SELECT id, planes_id FROM miembros WHERE (codigo = ? OR dni = ?) AND admin_id = ? LIMIT 1");
$stmt->bind_param("ssi", $codigo, $codigo, $admin_id);
$stmt->execute();
$res = $stmt->get_result();

if ($res->num_rows === 0) {
    echo json_encode(['status' => 'error', 'mensaje' => 'Miembro no encontrado.']);
    exit;
}

$miembro = $res->fetch_assoc();
$miembro_id = $miembro['id'];
$planes_id = $miembro['planes_id'] ?? null;

// Buscar nombre del plan
$plan_nombre = 'Plan desconocido';
if ($planes_id) {
    $planStmt = $conn->prepare("SELECT nombre FROM planes WHERE id = ? LIMIT 1");
    $planStmt->bind_param("i", $planes_id);
    $planStmt->execute();
    $planStmt->bind_result($plan_nombre);
    $planStmt->fetch();
    $planStmt->close();
}

// Actualizar recargo
$update = $conn->prepare("UPDATE miembros SET recargo = ? WHERE id = ?");
$update->bind_param("di", $recargo_restante, $miembro_id);
$update->execute();

// Insertar en caja
$detalle = "Pago de recargo del plan $plan_nombre";
$tipo = "pago";

$insertCaja = $conn->prepare("
  INSERT INTO caja (admin_id, miembro_id, monto, detalle, tipo, metodo_pago_id)
  VALUES (?, ?, ?, ?, ?, ?)
");
$insertCaja->bind_param("iidssi", $admin_id, $miembro_id, $monto_pagado, $detalle, $tipo, $metodo_pago_id);
$insertCaja->execute();

echo json_encode([
    'status' => 'ok',
    'mensaje' => 'Recargo registrado correctamente.',
]);
exit;
