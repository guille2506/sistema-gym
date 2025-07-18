<?php
header('Content-Type: application/json; charset=utf-8');
include('../conexion.php');

$tipo   = $_POST['tipo']   ?? '';
$estado = $_POST['estado'] ?? ''; 
$desde  = $_POST['desde']  ?? '';
$hasta  = $_POST['hasta']  ?? '';

$sql = "UPDATE caja SET estado = 'cerrado' WHERE estado = 'abierto'";

$params = [];
$types  = '';

if ($tipo !== '') {
    $sql .= " AND tipo = ?";
    $params[] = $tipo;
    $types   .= 's';
}
if ($desde !== '') {
    $sql .= " AND fecha >= ?";
    $params[] = $desde . ' 00:00:00';
    $types   .= 's';
}
if ($hasta !== '') {
    $sql .= " AND fecha <= ?";
    $params[] = $hasta . ' 23:59:59';
    $types   .= 's';
}

$stmt = $conn->prepare($sql);
if (!$stmt) {
    echo json_encode(['ok' => false, 'error' => $conn->error]);
    exit;
}
if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}
if (!$stmt->execute()) {
    echo json_encode(['ok' => false, 'error' => $stmt->error]);
    exit;
}

$filas = $stmt->affected_rows;
echo json_encode(['ok' => true, 'msg' => "Se cerraron $filas operaciones."]);
