-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 04-08-2025 a las 03:43:35
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `gimnasio2`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL,
  `estado` enum('activo','inactivo') DEFAULT 'activo',
  `plan_id` int(11) DEFAULT NULL,
  `pais_id` int(11) DEFAULT NULL,
  `provincia_id` int(11) DEFAULT NULL,
  `usar_tarjeta` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `admin`
--

INSERT INTO `admin` (`id`, `usuario`, `contrasena`, `estado`, `plan_id`, `pais_id`, `provincia_id`, `usar_tarjeta`) VALUES
(1, 'admin1', '1', 'activo', 1, NULL, NULL, 0),
(2, 'admin2', '2', 'inactivo', 4, NULL, NULL, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin_planes`
--

CREATE TABLE `admin_planes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio_mensual` int(11) NOT NULL,
  `limite_miembros` int(11) DEFAULT NULL,
  `limite_almacenamiento` int(11) DEFAULT NULL,
  `incluye_soporte` tinyint(1) DEFAULT 0,
  `activo` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `admin_planes`
--

INSERT INTO `admin_planes` (`id`, `nombre`, `precio_mensual`, `limite_miembros`, `limite_almacenamiento`, `incluye_soporte`, `activo`) VALUES
(1, 'Free Trial', 0, 50, NULL, 0, 1),
(2, 'Básico', 5000, 200, NULL, 0, 1),
(3, 'Medio', 10000, 1000, NULL, 1, 1),
(4, 'Premium', 20000, NULL, NULL, 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caja`
--

CREATE TABLE `caja` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `miembro_id` int(11) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `metodo_pago_id` int(11) NOT NULL,
  `tipo` enum('pago','ingreso','extraccion') DEFAULT 'pago',
  `miembro_nombre` varchar(100) DEFAULT NULL,
  `miembro_apellido` varchar(100) DEFAULT NULL,
  `estado` enum('abierto','cerrado') DEFAULT 'abierto'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `caja`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `nombre_estado` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`id`, `nombre_estado`) VALUES
(1, 'Activo'),
(2, 'Desactivado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `facturas`
--

CREATE TABLE `facturas` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `miembro_id` int(11) NOT NULL,
  `caja_id` int(11) NOT NULL,
  `numero_factura` varchar(50) DEFAULT NULL,
  `tipo_comprobante` enum('A','B','C') DEFAULT 'C',
  `fecha_emision` timestamp NOT NULL DEFAULT current_timestamp(),
  `total` decimal(10,2) NOT NULL,
  `estado` enum('emitida','anulada') DEFAULT 'emitida'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembros`
--

CREATE TABLE `miembros` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `dni` varchar(20) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `codigo` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado_id` int(11) DEFAULT NULL,
  `metodo_de_pagos_id` int(11) DEFAULT NULL,
  `sexo_id` int(11) DEFAULT NULL,
  `situacion_id` int(11) DEFAULT NULL,
  `planes_id` int(11) DEFAULT NULL,
  `monto` int(11) DEFAULT NULL,
  `fecha_de_vencimiento` date DEFAULT NULL,
  `recargo` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `clases_disponibles` int(11) DEFAULT NULL,
  `clases_usadas` int(11) DEFAULT 0,
  `grupo_familiar_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `mensaje` text DEFAULT NULL,
  `leida` tinyint(1) DEFAULT 0,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `nombre_metodo` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `nombre_metodo`) VALUES
(1, 'efectivo'),
(2, 'trasnferencia'),
(3, 'Efectivo y MercadoPago');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `paises`
--

CREATE TABLE `paises` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `precio` int(11) DEFAULT NULL,
  `clases_totales` int(11) DEFAULT NULL,
  `descuento_grupo` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `admin_id`, `nombre`, `precio`, `clases_totales`, `descuento_grupo`) VALUES
(1, 1, 'Full Pass o pase libre (precio Lista)', 37000, NULL, 0),
(2, 1, '10% menos en grupo familiar de 3 personas', 37000, NULL, 10),
(3, 1, '20% menos grupo familiar de 4 a 5 personas.', 37000, NULL, 20),
(4, 1, 'Full Pass o pase libre (descuento efectivo)', 35000, NULL, 0),
(5, 1, '10% menos en grupo familiar de 3 personas', 35000, NULL, 10),
(6, 1, '20% menos grupo familiar de 4 a 5 personas.', 35000, NULL, 20),
(7, 1, 'Pase 12 clases (precio lista)\n', 34000, 12, 0),
(8, 1, '10% menos en grupo familiar de 3 personas', 34000, 12, 10),
(9, 1, '20% menos grupo familiar de 4 a 5 personas.', 34000, 12, 20),
(10, 1, 'Pase 12 clases (efectivo 💴)\n', 32000, 12, 0),
(11, 1, '10% menos en grupo familiar de 3 personas', 32000, 12, 10),
(12, 1, '20% menos grupo familiar de 4 a 5 personas.', 32000, 12, 20),
(13, 1, 'Pase 8 clases (precio lista)\n', 32000, 8, 0),
(14, 1, '10% menos en grupo familiar de 3 personas', 32000, 8, 10),
(15, 1, '20% menos grupo familiar de 4 a 5 personas.', 32000, 8, 20),
(16, 1, 'Pase 8 clases (efectivo)\n', 30000, 8, 0),
(17, 1, '10% menos en grupo familiar de 3 personas', 30000, 8, 10),
(18, 1, '20% menos grupo familiar de 4 a 5 personas.', 30000, 8, 20),
(19, 1, 'Clase Prueba', 5000, 1, 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `provincias`
--

CREATE TABLE `provincias` (
  `id` int(11) NOT NULL,
  `pais_id` int(11) DEFAULT NULL,
  `nombre` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_ingreso`
--

CREATE TABLE `registro_ingreso` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) NOT NULL,
  `miembro_id` int(11) NOT NULL,
  `fecha_ingreso` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `registro_ingreso`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sexo`
--

CREATE TABLE `sexo` (
  `id` int(11) NOT NULL,
  `nombre_sexo` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `sexo`
--

INSERT INTO `sexo` (`id`, `nombre_sexo`) VALUES
(1, 'Masculino'),
(2, 'Femenino');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `situacion`
--

CREATE TABLE `situacion` (
  `id` int(11) NOT NULL,
  `nombre_situacion` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `situacion`
--

INSERT INTO `situacion` (`id`, `nombre_situacion`) VALUES
(1, 'Al día'),
(2, 'Debe cuota'),
(3, 'No pago cuota');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `suscripciones`
--

CREATE TABLE `suscripciones` (
  `id` int(11) NOT NULL,
  `admin_id` int(11) DEFAULT NULL,
  `plan_id` int(11) DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `estado` enum('activa','vencida','cancelada') DEFAULT 'activa'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD KEY `admin_plan_fk` (`plan_id`),
  ADD KEY `fk_admin_pais` (`pais_id`),
  ADD KEY `fk_admin_provincia` (`provincia_id`);

--
-- Indices de la tabla `admin_planes`
--
ALTER TABLE `admin_planes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `caja`
--
ALTER TABLE `caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `miembro_id` (`miembro_id`),
  ADD KEY `metodo_pago_id` (`metodo_pago_id`),
  ADD KEY `fk_caja_admin` (`admin_id`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `numero_factura` (`numero_factura`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `miembro_id` (`miembro_id`),
  ADD KEY `caja_id` (`caja_id`);

--
-- Indices de la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD KEY `estado_id` (`estado_id`),
  ADD KEY `metodo_de_pagos_id` (`metodo_de_pagos_id`),
  ADD KEY `sexo_id` (`sexo_id`),
  ADD KEY `situacion_id` (`situacion_id`),
  ADD KEY `planes_id` (`planes_id`),
  ADD KEY `fk_miembros_admin` (`admin_id`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `paises`
--
ALTER TABLE `paises`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_planes_admin` (`admin_id`);

--
-- Indices de la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pais_id` (`pais_id`);

--
-- Indices de la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `miembro_id` (`miembro_id`);

--
-- Indices de la tabla `sexo`
--
ALTER TABLE `sexo`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `situacion`
--
ALTER TABLE `situacion`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  ADD PRIMARY KEY (`id`),
  ADD KEY `admin_id` (`admin_id`),
  ADD KEY `plan_id` (`plan_id`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `admin_planes`
--
ALTER TABLE `admin_planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `caja`
--
ALTER TABLE `caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=158;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `paises`
--
ALTER TABLE `paises`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT de la tabla `provincias`
--
ALTER TABLE `provincias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=188;

--
-- AUTO_INCREMENT de la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `admin`
--
ALTER TABLE `admin`
  ADD CONSTRAINT `admin_plan_fk` FOREIGN KEY (`plan_id`) REFERENCES `admin_planes` (`id`),
  ADD CONSTRAINT `fk_admin_pais` FOREIGN KEY (`pais_id`) REFERENCES `paises` (`id`),
  ADD CONSTRAINT `fk_admin_provincia` FOREIGN KEY (`provincia_id`) REFERENCES `provincias` (`id`);

--
-- Filtros para la tabla `caja`
--
ALTER TABLE `caja`
  ADD CONSTRAINT `caja_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `caja_ibfk_2` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `caja_ibfk_3` FOREIGN KEY (`metodo_pago_id`) REFERENCES `pagos` (`id`),
  ADD CONSTRAINT `fk_caja_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `facturas`
--
ALTER TABLE `facturas`
  ADD CONSTRAINT `facturas_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `facturas_ibfk_2` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `facturas_ibfk_3` FOREIGN KEY (`caja_id`) REFERENCES `caja` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD CONSTRAINT `fk_miembros_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `miembros_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `miembros_ibfk_2` FOREIGN KEY (`estado_id`) REFERENCES `estado` (`id`),
  ADD CONSTRAINT `miembros_ibfk_3` FOREIGN KEY (`metodo_de_pagos_id`) REFERENCES `pagos` (`id`),
  ADD CONSTRAINT `miembros_ibfk_4` FOREIGN KEY (`sexo_id`) REFERENCES `sexo` (`id`),
  ADD CONSTRAINT `miembros_ibfk_5` FOREIGN KEY (`situacion_id`) REFERENCES `situacion` (`id`),
  ADD CONSTRAINT `miembros_ibfk_6` FOREIGN KEY (`planes_id`) REFERENCES `planes` (`id`);

--
-- Filtros para la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD CONSTRAINT `notificaciones_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `planes`
--
ALTER TABLE `planes`
  ADD CONSTRAINT `fk_planes_admin` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `planes_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `provincias`
--
ALTER TABLE `provincias`
  ADD CONSTRAINT `provincias_ibfk_1` FOREIGN KEY (`pais_id`) REFERENCES `paises` (`id`) ON DELETE CASCADE;

--
-- Filtros para la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  ADD CONSTRAINT `registro_ingreso_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `registro_ingreso_ibfk_2` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`);

--
-- Filtros para la tabla `suscripciones`
--
ALTER TABLE `suscripciones`
  ADD CONSTRAINT `suscripciones_ibfk_1` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `suscripciones_ibfk_2` FOREIGN KEY (`plan_id`) REFERENCES `admin_planes` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
