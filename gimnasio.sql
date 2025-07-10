-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 09-07-2025 a las 18:47:04
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
-- Base de datos: `gimnasio`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `admin`
--

CREATE TABLE `admin` (
  `id` int(11) NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `contrasena` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `admin`
--

INSERT INTO `admin` (`id`, `usuario`, `contrasena`) VALUES
(1, 'maxi', '2506');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `caja`
--

CREATE TABLE `caja` (
  `id` int(11) NOT NULL,
  `miembro_id` int(11) DEFAULT NULL,
  `monto` decimal(10,2) NOT NULL,
  `detalle` varchar(255) DEFAULT NULL,
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `metodo_pago_id` int(11) NOT NULL,
  `tipo` enum('pago','ingreso','extraccion') NOT NULL DEFAULT 'pago',
  `miembro_nombre` varchar(100) DEFAULT NULL,
  `miembro_apellido` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `caja`
--

INSERT INTO `caja` (`id`, `miembro_id`, `monto`, `detalle`, `fecha`, `metodo_pago_id`, `tipo`, `miembro_nombre`, `miembro_apellido`) VALUES
(1, 77, 4645.00, 'Pago de inscripción del plan', '2025-07-08 23:45:38', 2, 'extraccion', NULL, NULL),
(2, 79, 4645.00, 'Pago de inscripción del plan', '2025-07-08 23:46:54', 2, 'pago', NULL, NULL),
(3, 80, 4645.00, 'Pago de inscripción del plan', '2025-07-08 23:47:15', 2, 'pago', NULL, NULL),
(4, NULL, 4645.00, 'Pago de inscripción del plan', '2025-07-08 23:51:20', 2, 'pago', NULL, NULL),
(5, NULL, 67.00, 'Pago de inscripción del plan', '2025-07-08 23:56:53', 2, 'pago', NULL, NULL),
(6, NULL, 67.00, 'Pago de inscripción del plan', '2025-07-08 23:58:18', 2, 'pago', NULL, NULL),
(7, NULL, 67.00, 'Pago de inscripción del plan', '2025-07-08 23:58:58', 2, 'pago', NULL, NULL),
(8, NULL, 67.00, 'Pago de inscripción del plan', '2025-07-08 23:59:30', 2, 'pago', NULL, NULL),
(9, 87, 4565.00, 'Pago de inscripción del plan', '2025-07-09 16:27:35', 2, 'pago', NULL, NULL),
(10, 88, 34534.00, 'Pago de inscripción del plan', '2025-07-09 16:29:41', 0, 'pago', 'ricardo', 'illanes'),
(11, NULL, 34534.00, 'Pago de inscripción del plan', '2025-07-09 16:30:28', 0, 'pago', 'ricardo Merengue', 'illanes Arana');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `estado`
--

CREATE TABLE `estado` (
  `id` int(11) NOT NULL,
  `nombre_estado` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `estado`
--

INSERT INTO `estado` (`id`, `nombre_estado`) VALUES
(1, 'Activo'),
(2, 'Desactivado');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `miembros`
--

CREATE TABLE `miembros` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `dni` varchar(20) NOT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `telefono_emergencia` varchar(20) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `codigo` varchar(100) DEFAULT NULL,
  `fecha_registro` timestamp NOT NULL DEFAULT current_timestamp(),
  `estado_id` int(11) NOT NULL,
  `metodo_de_pagos_id` int(11) NOT NULL,
  `sexo_id` int(11) NOT NULL DEFAULT 1,
  `situacion_id` int(11) NOT NULL DEFAULT 1,
  `planes_id` int(11) DEFAULT NULL,
  `monto` int(11) DEFAULT NULL,
  `fecha_de_vencimiento` date DEFAULT NULL,
  `recargo` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `nombre`, `apellido`, `dni`, `telefono`, `telefono_emergencia`, `email`, `codigo`, `fecha_registro`, `estado_id`, `metodo_de_pagos_id`, `sexo_id`, `situacion_id`, `planes_id`, `monto`, `fecha_de_vencimiento`, `recargo`) VALUES
(57, 'Guillermo', 'illanes', '12312312312346', '1231323123', 'asdasdasd', 'demo@evershop.io434', 'illanes@Guillermo@1231323123@demo@evershop.io434', '2025-06-20 23:45:12', 1, 2, 1, 1, 3, 35, '2025-07-20', 0),
(58, 'Guillermo', 'illanes', '4484422056', '1231323123', 'asda', 'motsaa007@gmail.com23', 'illanes@Guillermo@1231323123@motsaa007@gmail.com23', '2025-06-20 23:51:39', 1, 2, 1, 1, 3, 35, '2025-07-20', 0),
(60, 'Guillermo', 'illanes', '44844220568', '1231323123', 'asda', 'demo@evershop.io78', 'illanes@Guillermo@1231323123@demo@evershop.io78', '2025-06-21 00:13:15', 1, 0, 1, 1, 3, 0, '2025-07-21', 0),
(62, 'Guillermo', 'illanes', '44844220', '1231323123', 'asda', 'demo@evershop.io23', 'illanes@Guillermo@1231323123@demo@evershop.io23', '2025-06-21 18:59:27', 1, 0, 1, 1, 3, 15, '2025-07-21', 15),
(65, 'Jonathan', 'Palma', '10927395', '2324456356456', 'no da', 'JonathanPalma@gmail.com', 'Palma@Jonathan @2324456356456@JonathanPalma@gmail.com', '2025-06-24 15:32:25', 1, 2, 1, 1, 4, 456, '2025-07-24', 0),
(66, 'nora ', 'arana', '4484422065656', '2342345', '.', 'yella@gmail.com43243', 'arana@nora @2342345@yella@gmail.com43243', '2025-06-24 16:16:41', 1, 0, 2, 1, 4, 15000, '2025-07-24', 20000),
(73, 'Guillermo', 'illanes', '448442208989', '1231323123', 'asda', 'demo@minimals.cc77', 'illanes@Guillermo@1231323123@demo@minimals.cc77', '2025-07-08 23:27:03', 1, 1, 2, 1, 4, 35000, '2025-08-07', 0),
(75, 'Guillermo', 'illanes', '123123123123', '4454589', 'asda', 'motsaa007@gmail.com2306', 'illanes@Guillermo@4454589@motsaa007@gmail.com2306', '2025-07-08 23:41:12', 1, 2, 2, 1, 4, 344, '2025-08-07', 0),
(76, 'Guillermo', 'illanes', '1231231231236', '4454589', 'asda', 'motsaa007@gmail.com23065', 'illanes@Guillermo@4454589@motsaa007@gmail.com23065', '2025-07-08 23:42:54', 1, 2, 2, 1, 4, 344, '2025-08-07', 0),
(77, 'Guillermo', 'illanes', '123123123123654', '1231323123', 'asda', 'motsaa007@gmail.com5324', 'illanes@Guillermo@1231323123@motsaa007@gmail.com5324', '2025-07-08 23:45:38', 1, 2, 2, 1, 3, 4645, '2025-08-07', 0),
(79, 'Guillermo', 'illanes', '1231231231236548', '12313231237', 'asda', 'motsaa007@gmail.com53245', 'illanes@Guillermo@12313231237@motsaa007@gmail.com53245', '2025-07-08 23:46:54', 1, 2, 1, 1, 3, 4645, '2025-08-07', 0),
(80, 'Guillermo', 'illanes', '12312312312365485', '12313231237', 'asda', 'motsaa007@gmail.com532456', 'illanes@Guillermo@12313231237@motsaa007@gmail.com532456', '2025-07-08 23:47:15', 1, 2, 2, 1, 3, 4645, '2025-08-07', 0),
(83, 'Guillermo', 'moto moto ', '5667567', 'asdsa56', '75', 'motsaa007@gmail.com4356', 'moto moto @Guillermo@asdsa56@motsaa007@gmail.com4356', '2025-07-08 23:57:59', 1, 2, 2, 1, 4, 67, '2025-08-07', 0),
(87, 'ricardo', 'illanes', '55676793', '43445', '45345', 'demo@evershop.io2357', 'illanes@ricardo@43445@demo@evershop.io2357', '2025-07-09 16:27:35', 1, 2, 2, 1, 3, 4565, '2025-08-08', 0),
(88, 'ricardo', 'illanes', '4484422056778', '55656', 'asda5', 'demo@evershop.io4', 'illanes@ricardo@55656@demo@evershop.io4', '2025-07-09 16:29:41', 1, 0, 1, 1, 3, 34534, '2025-08-08', 0);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pagos`
--

CREATE TABLE `pagos` (
  `id` int(11) NOT NULL,
  `nombre_metodo` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `pagos`
--

INSERT INTO `pagos` (`id`, `nombre_metodo`) VALUES
(0, 'transferencia'),
(1, 'Efectivo'),
(2, 'MercadoPago'),
(3, 'Tarjeta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `precio` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `nombre`, `precio`) VALUES
(1, 'dia libre', 555),
(2, '1 mes pase libre', 20),
(3, '2 Meses pase libre ', 30),
(4, '3 Meses pase libre\n', 35000);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `registro_ingreso`
--

CREATE TABLE `registro_ingreso` (
  `id` int(11) NOT NULL,
  `miembro_id` int(11) NOT NULL,
  `fecha_ingreso` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `sexo`
--

CREATE TABLE `sexo` (
  `id` int(11) NOT NULL,
  `nombre_sexo` varchar(20) NOT NULL
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
  `nombre_situacion` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `situacion`
--

INSERT INTO `situacion` (`id`, `nombre_situacion`) VALUES
(1, 'Al día'),
(2, 'Debe cuota');

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `usuario` (`usuario`);

--
-- Indices de la tabla `caja`
--
ALTER TABLE `caja`
  ADD PRIMARY KEY (`id`),
  ADD KEY `miembro_id` (`miembro_id`),
  ADD KEY `metodo_pago_id` (`metodo_pago_id`);

--
-- Indices de la tabla `estado`
--
ALTER TABLE `estado`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `dni` (`dni`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `fk_miembro_estado` (`estado_id`),
  ADD KEY `fk_miembro_pago` (`metodo_de_pagos_id`),
  ADD KEY `fk_miembro_sexo` (`sexo_id`),
  ADD KEY `fk_miembro_situacion` (`situacion_id`),
  ADD KEY `fk_planes_id` (`planes_id`);

--
-- Indices de la tabla `pagos`
--
ALTER TABLE `pagos`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `planes`
--
ALTER TABLE `planes`
  ADD PRIMARY KEY (`id`);

--
-- Indices de la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ingreso_miembro` (`miembro_id`);

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
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `admin`
--
ALTER TABLE `admin`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `caja`
--
ALTER TABLE `caja`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=90;

--
-- AUTO_INCREMENT de la tabla `planes`
--
ALTER TABLE `planes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `caja`
--
ALTER TABLE `caja`
  ADD CONSTRAINT `caja_ibfk_1` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `caja_ibfk_2` FOREIGN KEY (`metodo_pago_id`) REFERENCES `pagos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `miembros`
--
ALTER TABLE `miembros`
  ADD CONSTRAINT `fk_miembro_estado` FOREIGN KEY (`estado_id`) REFERENCES `estado` (`id`),
  ADD CONSTRAINT `fk_miembro_pago` FOREIGN KEY (`metodo_de_pagos_id`) REFERENCES `pagos` (`id`),
  ADD CONSTRAINT `fk_miembro_sexo` FOREIGN KEY (`sexo_id`) REFERENCES `sexo` (`id`),
  ADD CONSTRAINT `fk_miembro_situacion` FOREIGN KEY (`situacion_id`) REFERENCES `situacion` (`id`),
  ADD CONSTRAINT `fk_planes_id` FOREIGN KEY (`planes_id`) REFERENCES `planes` (`id`) ON DELETE SET NULL;

--
-- Filtros para la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  ADD CONSTRAINT `fk_ingreso_miembro` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
