-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 20-06-2025 a las 05:05:09
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
  `metodo_pago_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `monto` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `miembros`
--

INSERT INTO `miembros` (`id`, `nombre`, `apellido`, `dni`, `telefono`, `telefono_emergencia`, `email`, `codigo`, `fecha_registro`, `estado_id`, `metodo_de_pagos_id`, `sexo_id`, `situacion_id`, `planes_id`, `monto`) VALUES
(24, 'Guillermo', 'illanes', '44844220', '1231323123', 'asda', 'demo@evershop.io', 'illanes@Guillermo@1231323123@demo@evershop.io', '2025-06-16 23:59:29', 1, 1, 1, 1, NULL, NULL),
(25, 'Guillermo', 'illanes', '123123123123223', '1231323123123', 'asda32', 'demo@evershop.io12', 'illanes@Guillermo@1231323123123@demo@evershop.io12', '2025-06-17 00:05:32', 1, 1, 1, 1, NULL, NULL),
(26, 'Guillermo', 'illanes', '242524123', '1231323123', 'asdasdasd', 'demo@evershop.io343', 'illanes@Guillermo@1231323123@demo@evershop.io343', '2025-06-17 00:07:14', 1, 2, 1, 1, NULL, NULL),
(32, 'Guillermo', 'illanes', '44844220123', '1231323123', 'asda', 'demo@evershop.io234', 'illanes@Guillermo@1231323123@demo@evershop.io234', '2025-06-17 00:17:07', 1, 2, 1, 1, NULL, NULL),
(33, 'Guillermo', 'illanes', '4484422034', '1231323123', 'asda', 'demo@evershop.io34', 'illanes@Guillermo@1231323123@demo@evershop.io34', '2025-06-17 00:18:00', 1, 3, 1, 1, NULL, NULL),
(34, 'Guillermo', 'illanes', '44844220545', '12313231232', 'asdasdasd', 'demo@evershop.io432', 'illanes@Guillermo@12313231232@demo@evershop.io432', '2025-06-17 02:15:55', 1, 3, 2, 1, NULL, NULL),
(35, 'Guillermo', 'illanes', '4484422067', '1231323123', 'asdasdasd', 'demo@evershop.io67', 'illanes@Guillermo@1231323123@demo@evershop.io67', '2025-06-17 02:18:37', 1, 3, 2, 1, NULL, NULL),
(47, 'Guillermo', 'illanes', '448442203434', '1231323123', 'asda', 'demo@evershop.io123', 'illanes@Guillermo@1231323123@demo@evershop.io123', '2025-06-19 22:50:15', 1, 2, 1, 1, 2, 0),
(48, 'Guillermo', 'illanes', '4484422045345', '1231323123', 'asda', 'demo@evershop.io6745', 'illanes@Guillermo@1231323123@demo@evershop.io6745', '2025-06-19 22:53:53', 1, 3, 1, 1, 3, 312312);

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
(1, 'Efectivo'),
(2, 'MercadoPago'),
(3, 'Tarjeta');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planes`
--

CREATE TABLE `planes` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `planes`
--

INSERT INTO `planes` (`id`, `nombre`) VALUES
(1, 'plan1'),
(2, 'plan2'),
(3, 'plan3'),
(4, 'plan4');

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
  ADD KEY `fk_caja_miembro` (`miembro_id`),
  ADD KEY `fk_caja_metodo_pago` (`metodo_pago_id`);

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
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `miembros`
--
ALTER TABLE `miembros`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

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
  ADD CONSTRAINT `fk_caja_metodo_pago` FOREIGN KEY (`metodo_pago_id`) REFERENCES `pagos` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_caja_miembro` FOREIGN KEY (`miembro_id`) REFERENCES `miembros` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

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
