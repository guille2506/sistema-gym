<?php
header('Content-Type: application/json');
include('../conexion.php');
session_start();

$admin_id = $_SESSION['admin'] ?? null;
$codigo = $_GET['codigo'] ?? null;

if (!$admin_id || !$codigo) {
    echo json_encode(['ok' => false, 'error' => 'Faltan datos']);
    exit;
}

$stmt = $conn->prepare("SELECT * FROM miembros WHERE (codigo = ? OR dni = ?) AND admin_id = ?");
$stmt->bind_param("ssi", $codigo, $codigo, $admin_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 1) {
    $miembro = $result->fetch_assoc();
    echo json_encode(['ok' => true, 'miembro' => $miembro]);
} else {
    echo json_encode(['ok' => false, 'error' => 'Miembro no encontrado']);
}
