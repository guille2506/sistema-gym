<?php
$host = "localhost";
$user = "root";      
$pass = "";   
$db   = "gimnasio2";

$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Conexión fallida: " . $conn->connect_error);
}
?>
