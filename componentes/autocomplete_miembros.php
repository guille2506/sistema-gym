<?php
include('../conexion.php');

$term = $_GET['term'] ?? '';
$term = strtolower(trim(preg_replace('/\s+/', ' ', $term)));
if (strlen($term) < 2) {
    echo json_encode([]);
    exit;
}

$termLike = "%{$term}%";

$stmt = $conn->prepare("
    SELECT id, nombre, apellido, dni
    FROM miembros
    WHERE 
        LOWER(CONCAT(nombre, ' ', apellido)) LIKE ? OR
        LOWER(CONCAT(apellido, ' ', nombre)) LIKE ? OR
        LOWER(nombre) LIKE ? OR
        LOWER(apellido) LIKE ? OR
        dni LIKE ?
    LIMIT 10
");

$stmt->bind_param("sssss", $termLike, $termLike, $termLike, $termLike, $termLike);
$stmt->execute();

$result = $stmt->get_result();
$miembros = [];

while ($row = $result->fetch_assoc()) {
    $miembros[] = [
        'id' => $row['id'],
        'nombre' => $row['nombre'],
        'apellido' => $row['apellido'],
        'dni' => $row['dni']
    ];
}

echo json_encode($miembros);
