<?php
include(__DIR__ . '/../conexion.php');

$sqlTotalCaja = "SELECT 
    SUM(CASE WHEN tipo = 'pago' OR tipo = 'ingreso' THEN monto ELSE 0 END) - 
    SUM(CASE WHEN tipo = 'extraccion' THEN monto ELSE 0 END) AS total 
    FROM caja";

$resultCaja = $conn->query($sqlTotalCaja);
$totalCaja = 0;

if ($resultCaja && $rowCaja = $resultCaja->fetch_assoc()) {
    $totalCaja = $rowCaja['total'] ?? 0;
    
}
?>
