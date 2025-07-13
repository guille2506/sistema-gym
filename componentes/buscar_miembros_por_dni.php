<?php
include('../conexion.php');

header('Content-Type: application/json');

$dni = $_GET['dni'] ?? '';
if (!$dni) {
    echo json_encode([]);
    exit;
}

$sql = "SELECT id, nombre, apellido FROM miembros WHERE dni = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("s", $dni);
$stmt->execute();
$result = $stmt->get_result();

$miembros = [];
while ($row = $result->fetch_assoc()) {
    $miembros[] = $row;
}

echo json_encode($miembros);
$stmt->close();
$conn->close();
