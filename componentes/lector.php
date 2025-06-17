<?php
include('../conexion.php');
header('Content-Type: application/json');

$codigo = trim($_POST['codigo'] ?? '');

$response = [
    'status' => 'error',
    'mensaje' => '❌ Código no válido o usuario no registrado.'
];

if ($codigo !== '') {
    $stmt = $conn->prepare("
        SELECT nombre 
        FROM miembros 
        WHERE (codigo = ? OR dni = ?) 
          AND estado_id = 1
    ");
    $stmt->bind_param("ss", $codigo, $codigo);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows === 1) {
        $stmt->bind_result($nombre);
        $stmt->fetch();
        $response['status'] = 'ok';
        $response['mensaje'] = "✅ Acceso permitido. Bienvenido, $nombre.";
    } else {
        $response['mensaje'] = "❌ El código/DNI ingresado no es válido o el usuario está inactivo.";
    }

    $stmt->close();
}

echo json_encode($response);
