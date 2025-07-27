-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 27-07-2025 a las 05:18:02
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
(2, 'admin2', '2', 'inactivo', 4, NULL, NULL, 1);

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
  `miembro_apellido` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `caja`
--

INSERT INTO `caja` (`id`, `admin_id`, `miembro_id`, `monto`, `detalle`, `fecha`, `metodo_pago_id`, `tipo`, `miembro_nombre`, `miembro_apellido`) VALUES
(4, 1, 73, 4.00, 'Pago de inscripción del plan', '2025-07-25 22:47:32', 2, 'pago', 'moto', 'illanes'),
(5, 1, 75, 1.00, 'Pago de inscripción del plan', '2025-07-26 00:28:22', 2, 'pago', 'moto', 'arana'),
(6, 1, 76, 1.00, 'Pago de inscripción del plan', '2025-07-26 00:42:04', 2, 'pago', 'Jonathan', 'Palma'),
(7, 1, 77, 10.00, 'Pago de inscripción del plan', '2025-07-26 00:51:17', 1, 'pago', 'nora', 'arana'),
(8, 1, 78, 10.00, 'Pago de inscripción del plan', '2025-07-26 01:15:30', 1, 'pago', 'maria', 'alaria'),
(9, 1, 78, 10.00, 'Pago de inscripción del plan', '2025-07-26 01:15:30', 2, 'pago', 'maria', 'alaria'),
(10, 1, 80, 10.00, 'Pago de inscripción del plan', '2025-07-26 01:16:10', 1, 'pago', 'maria', 'alaria'),
(11, 1, 80, 10.00, 'Pago de inscripción del plan', '2025-07-26 01:16:10', 2, 'pago', 'maria', 'alaria'),
(12, 1, 82, 10.00, 'Pago de inscripción del plan', '2025-07-26 01:30:03', 3, 'pago', 'maria', 'alaria'),
(13, 1, 83, 2500.00, 'Pago de inscripción del plan', '2025-07-26 20:44:22', 3, 'pago', 'moto', 'illanes'),
(14, 2, 85, 500.00, 'Pago de inscripción del plan', '2025-07-26 20:57:28', 3, 'pago', 'holi', 'las'),
(15, 1, 86, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:23:17', 3, 'pago', 'qlia', 'qlio'),
(16, 1, 87, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:23:28', 3, 'pago', 'qlia', 'qlio'),
(17, 1, 88, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:23:36', 3, 'pago', 'qlia', 'qlio'),
(18, 1, 89, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:23:45', 3, 'pago', 'qlia', 'qlio'),
(19, 1, 90, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:23:55', 3, 'pago', 'qlia', 'qlio'),
(20, 1, 91, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:04', 3, 'pago', 'qlia', 'qlio'),
(21, 1, 92, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:22', 3, 'pago', 'qlia', 'qlio'),
(22, 1, 93, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:29', 3, 'pago', 'qlia', 'qlio'),
(23, 1, 94, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:34', 3, 'pago', 'qlia', 'qlio'),
(24, 1, 95, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:40', 3, 'pago', 'qlia', 'qlio'),
(25, 1, 96, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:47', 3, 'pago', 'qlia', 'qlio'),
(26, 1, 97, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:24:56', 3, 'pago', 'qlia', 'qlio'),
(27, 1, 98, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:25:05', 3, 'pago', 'qlia', 'qlio'),
(28, 1, 99, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:25:19', 3, 'pago', 'qlia', 'qlio'),
(29, 1, 100, 5000.00, 'Pago de inscripción del plan', '2025-07-27 01:25:36', 3, 'pago', 'qlia', 'qlio');

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
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `admin_id`, `nombre`, `apellido`, `dni`, `telefono`, `codigo`, `fecha_registro`, `estado_id`, `metodo_de_pagos_id`, `sexo_id`, `situacion_id`, `planes_id`, `monto`, `fecha_de_vencimiento`, `recargo`, `created_at`, `updated_at`) VALUES
(70, 1, 'moto', 'illanes', '2', '1', '2', '2025-07-25 22:38:42', 1, 2, 1, NULL, 4, 4, '2025-08-24', 0, '2025-07-25 22:38:42', '2025-07-25 22:39:25'),
(71, 1, 'moto', 'illaens', '3', '1', '3', '2025-07-25 22:39:27', 1, 2, 1, NULL, 4, 4, '2025-08-24', 0, '2025-07-25 22:39:27', '2025-07-25 22:39:27'),
(72, 1, 'hoal', 'illanes', '4', '1', '4', '2025-07-25 22:42:15', 1, 2, 1, NULL, 4, 4, '2025-08-24', 0, '2025-07-25 22:42:15', '2025-07-25 22:42:15'),
(73, 1, 'moto', 'illanes', '5', '1', '5', '2025-07-25 22:47:32', 2, 2, 1, NULL, 4, 4, '2025-08-24', 0, '2025-07-25 22:47:32', '2025-07-25 22:57:02'),
(75, 1, 'moto', 'arana', '6', '1', '1', '2025-07-26 00:28:22', 1, 2, 2, NULL, 3, 1, '2025-08-25', 0, '2025-07-26 00:28:22', '2025-07-26 00:28:22'),
(76, 1, 'Jonathan', 'Palma', '7', '1', 'Palma@Jonathan@1', '2025-07-26 00:42:04', 1, 2, 2, NULL, 2, 1, '2025-08-25', 0, '2025-07-26 00:42:04', '2025-07-26 00:42:04'),
(77, 1, 'nora', 'arana', '8', '1', 'arana@nora@1', '2025-07-26 00:51:17', 1, 1, 2, NULL, 3, 10, '2025-08-25', 0, '2025-07-26 00:51:17', '2025-07-26 00:51:17'),
(78, 1, 'maria', 'alaria', '9', '1', 'alaria@maria@1', '2025-07-26 01:15:30', 1, 2, 2, NULL, 1, 10, '2025-08-25', 0, '2025-07-26 01:15:30', '2025-07-26 01:30:33'),
(80, 1, 'maria', 'alaria', '10', '1', 'alaria@maria@1', '2025-07-26 01:16:10', 1, 1, 2, NULL, 1, 10, '2025-08-25', 0, '2025-07-26 01:16:10', '2025-07-26 01:30:30'),
(82, 1, 'maria', 'alaria', '11', '1', 'alaria@maria@1', '2025-07-26 01:30:03', 1, 3, 2, NULL, 2, 10, '2025-08-25', 0, '2025-07-26 01:30:03', '2025-07-26 01:30:03'),
(83, 1, 'moto', 'illanes', '12345', '1', 'illanes@moto@1', '2025-07-26 20:44:22', 1, 3, 2, NULL, 1, 2500, '2025-08-25', 2500, '2025-07-26 20:44:22', '2025-07-26 20:44:22'),
(85, 2, 'holi', 'las', '12', '1', '1', '2025-07-26 20:57:28', 1, 3, 2, NULL, 3, 500, '2025-08-25', 500, '2025-07-26 20:57:28', '2025-07-26 20:57:28'),
(86, 1, 'qlia', 'qlio', '13', '1', 'qlio@qlia@1', '2025-07-27 01:23:17', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:23:17', '2025-07-27 01:23:17'),
(87, 1, 'qlia', 'qlio', '14', '1', 'qlio@qlia@1', '2025-07-27 01:23:28', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:23:28', '2025-07-27 01:23:28'),
(88, 1, 'qlia', 'qlio', '15', '1', 'qlio@qlia@1', '2025-07-27 01:23:36', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:23:36', '2025-07-27 01:23:36'),
(89, 1, 'qlia', 'qlio', '16', '1', 'qlio@qlia@1', '2025-07-27 01:23:45', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:23:45', '2025-07-27 01:23:45'),
(90, 1, 'qlia', 'qlio', '17', '1', 'qlio@qlia@1', '2025-07-27 01:23:55', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:23:55', '2025-07-27 01:23:55'),
(91, 1, 'qlia', 'qlio', '18', '1', 'qlio@qlia@1', '2025-07-27 01:24:04', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:04', '2025-07-27 01:24:04'),
(92, 1, 'qlia', 'qlio', '19', '1', 'qlio@qlia@1', '2025-07-27 01:24:22', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:22', '2025-07-27 01:24:22'),
(93, 1, 'qlia', 'qlio', '20', '1', 'qlio@qlia@1', '2025-07-27 01:24:29', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:29', '2025-07-27 01:24:29'),
(94, 1, 'qlia', 'qlio', '21', '1', 'qlio@qlia@1', '2025-07-27 01:24:34', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:34', '2025-07-27 01:24:34'),
(95, 1, 'qlia', 'qlio', '22', '1', 'qlio@qlia@1', '2025-07-27 01:24:40', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:40', '2025-07-27 01:24:40'),
(96, 1, 'qlia', 'qlio', '23', '1', 'qlio@qlia@1', '2025-07-27 01:24:47', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:47', '2025-07-27 01:24:47'),
(97, 1, 'qlia', 'qlio', '24', '1', 'qlio@qlia@1', '2025-07-27 01:24:56', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:24:56', '2025-07-27 01:24:56'),
(98, 1, 'qlia', 'qlio', '25', '1', 'qlio@qlia@1', '2025-07-27 01:25:05', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:25:05', '2025-07-27 01:25:05'),
(99, 1, 'qlia', 'qlio', '26', '1', 'qlio@qlia@1', '2025-07-27 01:25:19', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:25:19', '2025-07-27 01:25:19'),
(100, 1, 'qlia', 'qlio', '27', '1', 'qlio@qlia@1', '2025-07-27 01:25:36', 1, 3, 1, NULL, 1, 5000, '2025-07-27', 0, '2025-07-27 01:25:36', '2025-07-27 01:25:36');

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
  `precio` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `admin_id`, `nombre`, `precio`) VALUES
(1, 1, 'Clase Prueba', 5000),
(2, 1, 'Full Pass o pase libre', 37000),
(3, 1, 'Plan Básico A', 1000),
(4, 1, 'Full Pass  (descuento efectivo)', 35000),
(5, 1, 'Pase 12 clases (precio lista)', 34000),
(6, 1, 'Plan Básico B', 1000);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT de la tabla `facturas`
--
ALTER TABLE `facturas`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=101;

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de la tabla `provincias`
--
ALTER TABLE `provincias`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `registro_ingreso`
--
ALTER TABLE `registro_ingreso`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

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
