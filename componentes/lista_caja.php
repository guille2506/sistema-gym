<?php
include('../conexion.php');

$tipo = $_GET['tipo'] ?? '';
$desde = $_GET['desde'] ?? '';
$hasta = $_GET['hasta'] ?? '';

$sql = "SELECT c.id AS caja_id, m.id AS miembro_id, m.nombre, m.apellido, m.sexo_id,
        pl.nombre AS nombre_plan, c.monto, c.detalle, c.fecha, c.tipo, p.nombre_metodo
        FROM caja c
        INNER JOIN miembros m ON c.miembro_id = m.id
        LEFT JOIN planes pl ON m.planes_id = pl.id
        LEFT JOIN pagos p ON c.metodo_pago_id = p.id
        WHERE 1";

$params = [];
$types  = '';

if ($tipo !== '') {
    $sql .= " AND c.tipo = ?";
    $params[] = $tipo;
    $types .= 's';
}
if ($desde !== '') {
    $sql .= " AND c.fecha >= ?";
    $params[] = $desde . ' 00:00:00';
    $types .= 's';
}
if ($hasta !== '') {
    $sql .= " AND c.fecha <= ?";
    $params[] = $hasta . ' 23:59:59';
    $types .= 's';
}

$sql .= " ORDER BY c.fecha DESC";

$stmt = $conn->prepare($sql);
if (!empty($params)) {
    $stmt->bind_param($types, ...$params);
}
$stmt->execute();
$res = $stmt->get_result();

if ($res && $res->num_rows > 0):
    while ($row = $res->fetch_assoc()):
        $avatar = ($row["sexo_id"] == 2) ? 'assets/images/users/avatar-5.jpg' : 'assets/images/users/avatar-2.jpg';
        $fecha = date("d M, Y H:i", strtotime($row['fecha']));
        $badgeTipo = $row['tipo'] === 'pago' ? 'bg-success-subtle text-success'
            : ($row['tipo'] === 'ingreso' ? 'bg-info-subtle text-info' : 'bg-danger-subtle text-danger');
?>
        <tr>
            <td>
                <div class="form-check fs-16 ms-1">
                    <input type="checkbox" class="form-check-input">
                </div>
            </td>
            <td>#<?= $row['miembro_id'] ?></td>
            <td>
                <img src="<?= $avatar ?>" class="avatar-sm rounded-circle me-2" alt="...">
                <?= htmlspecialchars($row['nombre'] . ' ' . $row['apellido']) ?>
            </td>
            <td><?= $row['nombre_plan'] ?? 'Sin plan' ?></td>
            <td>$<?= number_format($row['monto'], 2, ',', '.') ?></td>
            <td><span class="badge <?= $badgeTipo ?> py-1 px-2"><?= ucfirst($row['tipo']) ?></span></td>
            <td><?= $row['nombre_metodo'] ?? 'N/A' ?></td>
            <td><?= $row['detalle'] ?? '-' ?></td>
            <td><?= $fecha ?></td>
            <td>
                <div class="d-flex gap-2">
                    <form method="post" action="perfil.php">
                        <input type="hidden" name="id" value="<?= $row['miembro_id'] ?>">
                        <button type="submit" class="btn btn-light btn-sm">
                            <iconify-icon icon="solar:eye-broken" class="align-middle fs-18"></iconify-icon>
                        </button>
                    </form>


                    <form method="post" action="cambiar_estado.php" class="d-flex align-items-center gap-1">

                        <button type="button" class="btn btn-soft-primary btn-sm" onclick="cambiarEstado(<?= $miembro['id'] ?>)">
                            <iconify-icon icon="solar:pen-2-broken" class="align-middle fs-18"></iconify-icon>
                        </button>

                    </form>



                    <form method="post" action="eliminar_miembro.php" class="form-eliminar-miembro" id="form-eliminar-<?= $miembro['id'] ?>">
                        <input type="hidden" name="id" value="<?= $miembro['id'] ?>">
                        <button type="button" class="btn btn-soft-danger btn-sm btn-eliminar" data-id="<?= $miembro['id'] ?>">
                            <iconify-icon icon="solar:trash-bin-minimalistic-2-broken" class="align-middle fs-18"></iconify-icon>
                        </button>

                    </form>

                </div>
            </td>
        </tr>
    <?php
    endwhile;
else:
    ?>
    <tr>
        <td colspan="10" class="text-center">No hay movimientos en la caja.</td>
    </tr>
<?php endif; ?>