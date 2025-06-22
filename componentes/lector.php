<?php
// Registra en log sin romper el JSON
// file_put_contents('debug_lector.log', date('Y-m-d H:i:s') . " - POST recibido: " . json_encode($_POST) . "\n", FILE_APPEND);

// IMPORTANTE: NO mostrar errores en pantalla
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
error_reporting(E_ALL);

include('../conexion.php');
header('Content-Type: application/json');

$codigo = trim($_POST['codigo'] ?? '');

$response = [
    'status'  => 'error',
    'mensaje' => '❌ Código no válido o usuario no registrado.'
];

if ($codigo !== '') {
    $stmt = $conn->prepare("
        SELECT m.nombre, m.apellido, m.sexo_id, m.estado_id, IFNULL(p.nombre, 'Sin plan') as plan
        FROM miembros m
        LEFT JOIN planes p ON m.planes_id = p.id
        WHERE (m.codigo = ? OR m.dni = ?)
        LIMIT 1
    ");

    if (!$stmt) {
        $response['mensaje'] = "❌ Error en la preparación de la consulta.";
        echo json_encode($response);
        exit;
    }

    $stmt->bind_param("ss", $codigo, $codigo);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows === 1) {
        $stmt->bind_result($nombre, $apellido, $sexo_id, $estado_id, $plan);
        $stmt->fetch();

        if ((int)$estado_id === 1) {
            $avatar = $sexo_id == 2
                ? 'assets/images/users/avatar-5.jpg'
                : 'assets/images/users/avatar-2.jpg';

            $response = [
                'status'  => 'ok',
                'mensaje' => "✅ Acceso permitido. Bienvenido, $nombre.",
                'datos'   => [
                    'nombre'   => $nombre,
                    'apellido' => $apellido,
                    'plan'     => $plan,
                    'avatar'   => $avatar
                ]
            ];
        } else {
            $response['mensaje'] = "❌ Usuario inactivo.";
        }
    }

    $stmt->close();
}

echo json_encode($response);
exit;
