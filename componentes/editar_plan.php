<?php
header('Content-Type: application/json');
session_start();
include('../conexion.php');

if (!isset($_SESSION['admin'])) {
    echo json_encode(["ok" => false, "error" => "No autorizado"]);
    exit;
}

$id     = $_POST['id']     ?? null;
$nombre = $_POST['nombre'] ?? '';
$precio = $_POST['precio'] ?? '';

if (!$id || $nombre === '' || $precio === '') {
    echo json_encode(["ok" => false, "error" => "Datos incompletos"]);
    exit;
}

$stmt = $conn->prepare("UPDATE planes SET nombre = ?, precio = ? WHERE id = ?");
$stmt->bind_param("sdi", $nombre, $precio, $id);

if ($stmt->execute()) {
    echo json_encode(["ok" => true]);
} else {
    echo json_encode(["ok" => false, "error" => $stmt->error]);
}
$stmt->close();
$conn->close();
