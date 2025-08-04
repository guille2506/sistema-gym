<?php
session_start();
header('Content-Type: application/json');
include('../conexion.php');

// 🛡️ Verificamos sesión
if (!isset($_SESSION['admin'])) {
    echo json_encode(['success' => false, 'message' => 'No autorizado']);
    exit;
}

$admin_id = $_SESSION['admin'];

// 📋 Función para log interno
function escribirLog($mensaje) {
    $logPath = __DIR__ . '/log_renovacion.txt';
    file_put_contents($logPath, "[" . date("Y-m-d H:i:s") . "] $mensaje\n", FILE_APPEND);
}

escribirLog("🔍 Iniciando renovación...");

$input = json_decode(file_get_contents('php://input'), true);
escribirLog("📥 JSON recibido: " . json_encode($input));

// 🧱 Validar campos requeridos
$campos_requeridos = [
    'codigo', 'nombre', 'apellido', 'telefono', 'sexo_id',
    'planes_id', 'monto', 'fecha_de_vencimiento',
    'recargo', 'metodo_de_pagos_id'
];

foreach ($campos_requeridos as $campo) {
    if (!isset($input[$campo])) {
        escribirLog("⚠️ Falta el campo: $campo");
        echo json_encode(['success' => false, 'message' => "Falta el campo: $campo"]);
        exit;
    }
}

// 🔽 Extraer datos
$codigo            = $input['codigo'];
$dni               = $input['dni'] ?? null;
$nombre            = trim($input['nombre']);
$apellido          = trim($input['apellido']);
$telefono          = trim($input['telefono']);
$sexo_id           = (int)$input['sexo_id'];
$planes_id         = (int)$input['planes_id'];
$plan_nombre       = 'Plan desconocido'; // Valor por defecto
$tipo_renovacion   = $input['tipo_renovacion'] ?? 'Renovación de plan';

$stmt = $conn->prepare("SELECT nombre FROM planes WHERE id = ? AND admin_id = ?");
$stmt->bind_param("ii", $planes_id, $admin_id);
if ($stmt->execute()) {
    $resultado = $stmt->get_result();
    if ($fila = $resultado->fetch_assoc()) {
        $plan_nombre = $fila['nombre'];
    }
}
$stmt->close();

$monto             = (float)$input['monto'];
$fecha_venc        = $input['fecha_de_vencimiento'];
$recargo           = (float)$input['recargo'];
$cantidad_clases   = (int)($input['cantidad_clases'] ?? 0);
$grupo_familiar_id = $input['grupo_familiar_id'] ?? null;
$metodo_pago_id    = (int)$input['metodo_de_pagos_id'];
$tarjeta           = trim($input['tarjeta_miembro'] ?? '');

escribirLog("➡️ Código: $codigo");
escribirLog("➡️ Plan ID: $planes_id - Nombre: $plan_nombre");
escribirLog("➡️ Fecha de vencimiento: $fecha_venc");
escribirLog("➡️ Monto: $monto | Recargo: $recargo | Método de pago: $metodo_pago_id");

// 🔎 Buscar miembro
$stmt = $conn->prepare("SELECT id FROM miembros WHERE (codigo = ? OR dni = ?) AND admin_id = ?");
$stmt->bind_param("ssi", $codigo, $dni, $admin_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows === 0) {
    escribirLog("❌ Miembro no encontrado con código/dni: $codigo");
    echo json_encode(['success' => false, 'message' => 'Miembro no encontrado']);
    exit;
}

$miembro = $result->fetch_assoc();
$miembro_id = $miembro['id'];
escribirLog("✅ Miembro encontrado. ID: $miembro_id");

// 🧾 Actualizar datos del miembro
$updateSQL = "
    UPDATE miembros SET
        planes_id = ?, 
        monto = ?, 
        clases_disponibles = ?, 
        grupo_familiar_id = ?, 
        fecha_de_vencimiento = ?, 
        fecha_registro = NOW(), 
        estado_id = 1
    WHERE codigo = ? AND admin_id = ?
";
$stmt = $conn->prepare($updateSQL);
$stmt->bind_param("idisssi", $planes_id, $monto, $cantidad_clases, $grupo_familiar_id, $fecha_venc, $codigo, $admin_id);

if (!$stmt->execute()) {
    escribirLog("❌ Error al actualizar miembro: " . $stmt->error);
    echo json_encode(['success' => false, 'message' => 'Error al actualizar al miembro']);
    exit;
} else {
    escribirLog("📝 Miembro actualizado correctamente.");
}

// 💸 Registrar en caja
$detalle = "$tipo_renovacion del plan $plan_nombre";

$stmt = $conn->prepare("
    INSERT INTO caja (
        admin_id, miembro_id, monto, detalle, metodo_pago_id, tipo, miembro_nombre, miembro_apellido
    ) VALUES (?, ?, ?, ?, ?, 'pago', ?, ?)
");
$stmt->bind_param("iidsiss", $admin_id, $miembro_id, $monto, $detalle, $metodo_pago_id, $nombre, $apellido);

if (!$stmt->execute()) {
    escribirLog("❌ Error al registrar en caja: " . $stmt->error);
    echo json_encode(['success' => false, 'message' => 'Error al registrar el pago en caja']);
    exit;
} else {
    escribirLog("💰 Registro en caja insertado correctamente.");
}

// ✅ Validación final de fecha
if (!preg_match('/^\d{4}-\d{2}-\d{2}$/', $fecha_venc)) {
    escribirLog("❌ Fecha inválida recibida: $fecha_venc");
    echo json_encode(['success' => false, 'message' => 'Fecha de vencimiento inválida']);
    exit;
}

echo json_encode(['success' => true, 'message' => 'Renovación exitosa']);
