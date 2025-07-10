<?php
include('../conexion.php');

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['id'])) {
    $id = intval($_POST['id']);

    $stmt = $conn->prepare("DELETE FROM miembros WHERE id = ?");
    $stmt->bind_param("i", $id);

    if ($stmt->execute()) {
        echo json_encode(["ok" => true]);
    } else {
        http_response_code(500);
        echo json_encode(["ok" => false, "error" => $stmt->error]);
    }
    exit;
}

echo json_encode(["ok" => false, "error" => "Invalid request"]);
exit;
?>
