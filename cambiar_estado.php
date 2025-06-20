<?php
include('conexion.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $id = $_POST['id'] ?? null;
    $nuevo_estado = $_POST['nuevo_estado'] ?? null;

    if ($id && $nuevo_estado) {
        $stmt = $conn->prepare("UPDATE miembros SET estado_id = ? WHERE id = ?");
        $stmt->bind_param("ii", $nuevo_estado, $id);
        $stmt->execute();
        $stmt->close();
        $conn->close();
        echo "OK";
    } else {
        http_response_code(400);
        echo "Datos incompletos.";
    }
} else {
    http_response_code(405);
    echo "Método no permitido.";
}
?>
