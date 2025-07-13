<?php
include('../conexion.php');
header('Content-Type: application/json');

$term = $_GET['term'] ?? '';
$term = "%$term%";

$sql = "SELECT id, dni, nombre, apellido FROM miembros 
        WHERE dni LIKE ? OR nombre LIKE ? OR apellido LIKE ? 
        ORDER BY nombre ASC LIMIT 10";
$stmt = $conn->prepare($sql);
$stmt->bind_param("sss", $term, $term, $term);
$stmt->execute();
$result = $stmt->get_result();

$miembros = [];
while ($row = $result->fetch_assoc()) {
    $miembros[] = $row;
}

echo json_encode($miembros);
