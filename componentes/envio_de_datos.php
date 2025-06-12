<?php
header('Content-Type: application/json');
include('../conexion.php');

if ($_SERVER["REQUEST_METHOD"] === "POST") {
    $nombre = $_POST["nombre"] ?? '';
    $apellido = $_POST["apellido"] ?? '';
    $dni = $_POST["dni"] ?? '';
    $telefono = $_POST["telefono"] ?? '';
    $telefono_emergencia = $_POST["telefono_emergencia"] ?? '';
    $email = $_POST["email"] ?? '';

    $codigoGenerado = "$apellido@$nombre@$telefono@$email";

    $stmt = $conn->prepare("INSERT INTO miembros (nombre, apellido, dni, telefono, telefono_emergencia, email, codigo) VALUES (?, ?, ?, ?, ?, ?, ?)");
    $stmt->bind_param("sssssss", $nombre, $apellido, $dni, $telefono, $telefono_emergencia, $email, $codigoGenerado);

    if ($stmt->execute()) {
        echo json_encode(["ok" => true]);
    } else {
        echo json_encode(["ok" => false, "error" => $conn->error]);
    }

    $stmt->close();
    $conn->close();
    exit;
} else {
    echo json_encode(["ok" => false, "error" => "Método no permitido"]);
    exit;
}
?>
