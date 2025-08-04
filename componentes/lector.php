<?php
session_start();
$admin_id = $_SESSION['admin'] ?? null;
if (!$admin_id) {
    echo json_encode(['status' => 'error', 'mensaje' => 'No autorizado.']);
    exit;
}

include('../conexion.php');
header('Content-Type: application/json');

$codigo = trim($_POST['codigo'] ?? '');

$response = [
    'status'  => 'error',
    'mensaje' => '❌ Código no válido o usuario no registrado.'
];

if ($codigo !== '') {
    $stmt = $conn->prepare("
    SELECT m.id, m.nombre, m.apellido, m.sexo_id, m.estado_id, m.admin_id,
           IFNULL(p.nombre, 'Sin plan') AS plan,
           IFNULL(m.recargo, 0) AS recargo,
           m.clases_disponibles,
           DATE_FORMAT(m.fecha_de_vencimiento, '%Y-%m-%d') AS fecha_vto
    FROM miembros m
    LEFT JOIN planes p ON m.planes_id = p.id
    WHERE (m.codigo = ? OR m.dni = ?) AND m.admin_id = ?
    LIMIT 1
");


    $stmt->bind_param("ssi", $codigo, $codigo, $admin_id);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows === 1) {
        $stmt->bind_result(
            $miembro_id,
            $nombre,
            $apellido,
            $sexo_id,
            $estado_id,
            $admin_id_miembro,
            $plan,
            $recargo,
            $clases_disponibles,
            $fecha_vto
        );
        $stmt->fetch(); 

        // ...el resto del código


        // Chequear si ya ingresó hoy
       // 👇 COMENTADO: Chequeo si ya ingresó hoy
/*
$check = $conn->prepare("SELECT id FROM registro_ingreso WHERE miembro_id = ? AND admin_id = ? AND DATE(fecha_ingreso) = CURDATE() LIMIT 1");
$check->bind_param("ii", $miembro_id, $admin_id);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    $response = [
        'status' => 'warning',
        'mensaje' => "⚠️ $nombre ya registró su ingreso hoy.",
    ];
} else {
*/
    // ✅ Registrar ingreso directamente
    $insert = $conn->prepare("INSERT INTO registro_ingreso (admin_id, miembro_id) VALUES (?, ?)");
    $insert->bind_param("ii", $admin_id, $miembro_id);
    $insert->execute();

    // ✅ Validar si la fecha de hoy es mayor o igual a fecha de vencimiento
    $hoy = date('Y-m-d');
    if ($fecha_vto !== null && $hoy >= $fecha_vto) {
        $clases_disponibles = 0;
        $updateClases = $conn->prepare("UPDATE miembros SET clases_disponibles = 0, estado_id = 2 WHERE id = ?");
        $updateClases->bind_param("i", $miembro_id);
        $updateClases->execute();
        $updateClases->close();
    }

    // ✅ Descontar clase si quedan
    if ($clases_disponibles > 0) {
        $clases_restantes = $clases_disponibles - 1;

        // ✅ Si llega a 0 después de descontar, actualizar estado_id y fecha
        if ($clases_restantes <= 0) {
            $nuevoEstado = 2; // Inactivo
            $nuevaFechaVto = date('Y-m-d');
            $updateClases = $conn->prepare("UPDATE miembros SET clases_disponibles = 0, estado_id = ?, fecha_de_vencimiento = ? WHERE id = ?");
            $updateClases->bind_param("isi", $nuevoEstado, $nuevaFechaVto, $miembro_id);
        } else {
            $updateClases = $conn->prepare("UPDATE miembros SET clases_disponibles = ? WHERE id = ?");
            $updateClases->bind_param("ii", $clases_restantes, $miembro_id);
        }

        $updateClases->execute();
        $updateClases->close();

        if ($clases_restantes === 0) {
            $response['mensaje'] = "❌ Sin clases disponibles. Debe renovar el plan.";
        }
    }


        $avatar = $sexo_id == 2 ? 'assets/images/users/avatar-5.jpg' : 'assets/images/users/avatar-2.jpg';
        $estadoCuota = ($recargo > 0) ? "Debe recargo \${$recargo} ❌" : "Cuota al día ✅";
$esActivo = ($estado_id == 1 && $clases_disponibles > 0);

        $response['datos'] = [
            'nombre' => $nombre,
            'apellido' => $apellido,
            'plan' => $plan,
            'avatar' => $avatar,
            'estadoCuota' => $estadoCuota,
            'vencimiento' => $fecha_vto,
            'activo' => $esActivo,
            'codigo' => $codigo,
            'clases' => $clases_disponibles
        ];


        if ($response['status'] !== 'warning') {
$response['status'] = 'ok';
$response['mensaje'] = $esActivo
    ? "✅ Acceso permitido. Bienvenido, $nombre."
    : "❌ Usuario inactivo o sin clases disponibles.";

        }
//activar eso despues
        // $check->close();
    } 

}

echo json_encode($response);
exit;
