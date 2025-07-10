<?php
include('../conexion.php');
$result = $conn->query("SELECT id, nombre, apellido FROM miembros ORDER BY apellido ASC");

$miembros = [];
while ($row = $result->fetch_assoc()) {
    $miembros[] = $row;
}
echo json_encode($miembros);
    