<?php
include(__DIR__ . '/../conexion.php');

$tipo  = $_GET['tipo']  ?? '';
$desde = $_GET['desde'] ?? '';
$hasta = $_GET['hasta'] ?? '';

$condiciones = [];
$params = [];
$types = '';


if ($tipo === '' && $desde === '' && $hasta === '') {
    $condiciones[] = "estado = 'abierto'";
}

if ($tipo !== '') {
    $condiciones[] = "tipo = ?";
    $params[] = $tipo;
    $types .= 's';
}
if ($desde !== '') {
    $condiciones[] = "fecha >= ?";
    $params[] = $desde . ' 00:00:00';
    $types .= 's';
}
if ($hasta !== '') {
    $condiciones[] = "fecha <= ?";
    $params[] = $hasta . ' 23:59:59';
    $types .= 's';
}

$sql = "SELECT 
    SUM(CASE WHEN tipo IN ('pago','ingreso') THEN monto ELSE 0 END) -
    SUM(CASE WHEN tipo = 'extraccion' THEN monto ELSE 0 END) AS total
    FROM caja";

if (!empty($condiciones)) {
    $sql .= " WHERE " . implode(" AND ", $condiciones);
}

$stmt = $conn->prepare($sql);
if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$result = $stmt->get_result();

$totalCaja = 0;
if ($result && $row = $result->fetch_assoc()) {
    $totalCaja = (float)$row['total'];
}

echo "$" . number_format($totalCaja, 2, ',', '.');
