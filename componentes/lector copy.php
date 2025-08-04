<?php
session_start();
header('Content-Type: application/json');
include('../conexion.php');

$admin_id = $_SESSION['admin'] ?? null;
if (!$admin_id) {
    echo json_encode(['status' => 'error', 'mensaje' => 'No autorizado.']);
    exit;
}

$codigo = trim($_POST['codigo'] ?? '');
$response = [
    'status'  => 'error',
    'mensaje' => '❌ Código no válido o usuario no registrado.'
];

if ($codigo !== '') {
    $stmt = $conn->prepare("
        SELECT 
            m.id, m.nombre, m.apellido, m.sexo_id, m.estado_id, m.admin_id,
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
            $miembro_id, $nombre, $apellido, $sexo_id, $estado_id,
            $admin_id_miembro, $plan, $recargo,
            $clases_disponibles, $fecha_vto
        );
        $stmt->fetch();

        // 🔁 Validar si ya ingresó hoy
        $check = $conn->prepare("
            SELECT id FROM registro_ingreso 
            WHERE miembro_id = ? AND admin_id = ? AND DATE(fecha_ingreso) = CURDATE() LIMIT 1
        ");
        $check->bind_param("ii", $miembro_id, $admin_id);
        $check->execute();
        $check->store_result();

        if ($check->num_rows > 0) {
            $response = [
                'status' => 'warning',
                'mensaje' => "⚠️ $nombre ya registró su ingreso hoy."
            ];
        } else {
            // ✅ Registrar ingreso
            $insert = $conn->prepare("INSERT INTO registro_ingreso (admin_id, miembro_id) VALUES (?, ?)");
            $insert->bind_param("ii", $admin_id, $miembro_id);
            $insert->execute();

            $hoy = date('Y-m-d');

            // ⚠️ Si está vencido, dejar sin clases
            if ($fecha_vto !== null && $hoy >= $fecha_vto) {
                $clases_disponibles = 0;
                $update = $conn->prepare("UPDATE miembros SET clases_disponibles = 0, estado_id = 2 WHERE id = ?");
                $update->bind_param("i", $miembro_id);
                $update->execute();
                $update->close();
            }

            // ✅ Descontar clase si tiene
            if ($clases_disponibles > 0) {
                $clases_restantes = $clases_disponibles - 1;

                if ($clases_restantes <= 0) {
                    $nuevoEstado = 2;
                    $nuevaFechaVto = date('Y-m-d');
                    $update = $conn->prepare("
                        UPDATE miembros SET clases_disponibles = 0, estado_id = ?, fecha_de_vencimiento = ? WHERE id = ?
                    ");
                    $update->bind_param("isi", $nuevoEstado, $nuevaFechaVto, $miembro_id);
                } else {
                    $update = $conn->prepare("UPDATE miembros SET clases_disponibles = ? WHERE id = ?");
                    $update->bind_param("ii", $clases_restantes, $miembro_id);
                }
                $update->execute();
                $update->close();

                if ($clases_restantes === 0) {
                    $response['mensaje'] = "❌ Sin clases disponibles. Debe renovar el plan.";
                }
            }

            // ✅ Datos visuales
            $avatar = $sexo_id == 2
                ? 'assets/images/users/avatar-5.jpg'
                : 'assets/images/users/avatar-2.jpg';

            $estadoCuota = ($recargo > 0)
                ? "Debe recargo \${$recargo} ❌"
                : "Cuota al día ✅";

            $esActivo = ($estado_id == 1 && $clases_disponibles > 0);

            $response['datos'] = [
                'nombre'       => $nombre,
                'apellido'     => $apellido,
                'plan'         => $plan,
                'avatar'       => $avatar,
                'estadoCuota'  => $estadoCuota,
                'vencimiento'  => $fecha_vto,
                'activo'       => $esActivo,
                'codigo'       => $codigo,
                'clases'       => $clases_disponibles
            ];

            $response['status'] = 'ok';
            $response['mensaje'] = $esActivo
                ? "✅ Acceso permitido. Bienvenido, $nombre."
                : "❌ Usuario inactivo o sin clases disponibles.";
        }
        $check->close();
    }
    $stmt->close();
}

echo json_encode($response);
exit;
