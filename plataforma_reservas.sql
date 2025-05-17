CREATE DATABASE  IF NOT EXISTS `plataforma_reservas` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `plataforma_reservas`;
-- MySQL dump 10.13  Distrib 8.0.42, for Win64 (x86_64)
--
-- Host: localhost    Database: plataforma_reservas
-- ------------------------------------------------------
-- Server version	8.0.42

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `asignacion_sede`
--

DROP TABLE IF EXISTS `asignacion_sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asignacion_sede` (
  `id` int NOT NULL AUTO_INCREMENT,
  `fecha` date NOT NULL,
  `idusuario` int NOT NULL,
  `idsede` int NOT NULL,
  `entrada` tinyint(1) DEFAULT '0',
  `salida` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idusuario` (`idusuario`),
  KEY `idsede` (`idsede`),
  CONSTRAINT `asignacion_sede_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `asignacion_sede_ibfk_2` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asignacion_sede`
--

LOCK TABLES `asignacion_sede` WRITE;
/*!40000 ALTER TABLE `asignacion_sede` DISABLE KEYS */;
INSERT INTO `asignacion_sede` VALUES (4,'2025-05-12',5,2,0,0);
/*!40000 ALTER TABLE `asignacion_sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `asistencia`
--

DROP TABLE IF EXISTS `asistencia`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `asistencia` (
  `idasistencia` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `fecha` date NOT NULL,
  `hora_entrada` time DEFAULT NULL,
  `hora_salida` time DEFAULT NULL,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `observaciones` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  PRIMARY KEY (`idasistencia`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `asistencia`
--

LOCK TABLES `asistencia` WRITE;
/*!40000 ALTER TABLE `asistencia` DISABLE KEYS */;
/*!40000 ALTER TABLE `asistencia` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chatbot_log`
--

DROP TABLE IF EXISTS `chatbot_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chatbot_log` (
  `idchatbot` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `pregunta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `respuesta` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idchatbot`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `chatbot_log_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chatbot_log`
--

LOCK TABLES `chatbot_log` WRITE;
/*!40000 ALTER TABLE `chatbot_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `chatbot_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `estado` (
  `idestado` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tipo_aplicacion` enum('reserva','servicio','incidencia','pago','reembolso','taller','usuario') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idestado`),
  KEY `idx_estado_tipo` (`tipo_aplicacion`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,'pendiente','Reserva pendiente de validación','reserva'),(2,'aprobada','Reserva aprobada por el administrador','reserva'),(3,'rechazada','Reserva rechazada por el administrador','reserva'),(4,'disponible','Servicio disponible para reservas','servicio'),(5,'reservado','Servicio reservado por un vecino en este horario','servicio'),(6,'en_mantenimiento','Servicio inhabilitado temporalmente por mantenimiento','servicio'),(7,'bloqueado','Bloqueo especial por evento o actividad programada','servicio'),(8,'inactivo','Servicio fuera de operación de forma indefinida','servicio'),(9,'reportado','Incidencia registrada por un coordinador','incidencia'),(10,'en_progreso','Acción en curso para resolver la incidencia','incidencia'),(11,'solucionado','Incidencia resuelta satisfactoriamente','incidencia'),(12,'no_corresponde','Incidencia invalidada tras revisión','incidencia'),(13,'crítico','Incidencia urgente con prioridad alta','incidencia'),(14,'pendiente','Pago pendiente de validación','pago'),(15,'confirmado','Pago validado y confirmado','pago'),(16,'rechazado','Pago rechazado por el administrador','pago'),(17,'reembolsado','Monto devuelto al usuario','pago'),(18,'no_pagado','Reserva sin pago registrado','pago');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_perfil`
--

DROP TABLE IF EXISTS `historial_perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_perfil` (
  `idhistorial` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `campo_modificado` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_modificacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idhistorial`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `historial_perfil_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_perfil`
--

LOCK TABLES `historial_perfil` WRITE;
/*!40000 ALTER TABLE `historial_perfil` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario_atencion`
--

DROP TABLE IF EXISTS `horario_atencion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario_atencion` (
  `idhorario_atencion` int NOT NULL AUTO_INCREMENT,
  `idsede` int NOT NULL,
  `dia_semana` enum('Lunes','Martes','Miércoles','Jueves','Viernes','Sábado','Domingo') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idhorario_atencion`),
  KEY `idsede` (`idsede`),
  CONSTRAINT `horario_atencion_ibfk_1` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario_atencion`
--

LOCK TABLES `horario_atencion` WRITE;
/*!40000 ALTER TABLE `horario_atencion` DISABLE KEYS */;
INSERT INTO `horario_atencion` VALUES (1,1,'Lunes','08:00:00','20:00:00',1),(2,1,'Martes','08:00:00','20:00:00',1),(3,1,'Miércoles','08:00:00','20:00:00',1),(4,1,'Jueves','08:00:00','20:00:00',1),(5,1,'Viernes','08:00:00','20:00:00',1),(6,1,'Sábado','08:00:00','15:00:00',1),(7,1,'Domingo','00:00:00','00:00:00',0),(8,2,'Lunes','08:00:00','20:00:00',1),(9,2,'Martes','08:00:00','20:00:00',1),(10,2,'Miércoles','08:00:00','20:00:00',1),(11,2,'Jueves','08:00:00','20:00:00',1),(12,2,'Viernes','08:00:00','20:00:00',1),(13,2,'Sábado','08:00:00','15:00:00',1),(14,2,'Domingo','00:00:00','00:00:00',0),(15,3,'Lunes','08:00:00','20:00:00',1),(16,3,'Martes','08:00:00','20:00:00',1),(17,3,'Miércoles','08:00:00','20:00:00',1),(18,3,'Jueves','08:00:00','20:00:00',1),(19,3,'Viernes','08:00:00','20:00:00',1),(20,3,'Sábado','08:00:00','15:00:00',1),(21,3,'Domingo','00:00:00','00:00:00',0),(22,4,'Lunes','08:00:00','20:00:00',1),(23,4,'Martes','08:00:00','20:00:00',1),(24,4,'Miércoles','08:00:00','20:00:00',1),(25,4,'Jueves','08:00:00','20:00:00',1),(26,4,'Viernes','08:00:00','20:00:00',1),(27,4,'Sábado','08:00:00','15:00:00',1),(28,4,'Domingo','00:00:00','00:00:00',0);
/*!40000 ALTER TABLE `horario_atencion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `horario_disponible`
--

DROP TABLE IF EXISTS `horario_disponible`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `horario_disponible` (
  `idhorario` int NOT NULL AUTO_INCREMENT,
  `idhorario_atencion` int NOT NULL,
  `idservicio` int NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `activo` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`idhorario`),
  KEY `idhorario_atencion` (`idhorario_atencion`),
  KEY `idservicio` (`idservicio`),
  CONSTRAINT `horario_disponible_ibfk_1` FOREIGN KEY (`idhorario_atencion`) REFERENCES `horario_atencion` (`idhorario_atencion`),
  CONSTRAINT `horario_disponible_ibfk_2` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `horario_disponible`
--

LOCK TABLES `horario_disponible` WRITE;
/*!40000 ALTER TABLE `horario_disponible` DISABLE KEYS */;
INSERT INTO `horario_disponible` VALUES (1,1,1,'08:00:00','09:00:00',1),(2,1,1,'09:00:00','10:00:00',1),(3,2,1,'10:00:00','11:00:00',1),(4,2,1,'11:00:00','12:00:00',1),(5,3,1,'08:00:00','10:00:00',1);
/*!40000 ALTER TABLE `horario_disponible` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `log` (
  `idlog` int NOT NULL AUTO_INCREMENT,
  `idusuario` int DEFAULT NULL,
  `accion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tabla_afectada` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `valor_anterior` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `valor_nuevo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idlog`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `log`
--

LOCK TABLES `log` WRITE;
/*!40000 ALTER TABLE `log` DISABLE KEYS */;
/*!40000 ALTER TABLE `log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `media_servicio`
--

DROP TABLE IF EXISTS `media_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_servicio` (
  `idmedia` int NOT NULL AUTO_INCREMENT,
  `idservicio` int NOT NULL,
  `tipo` enum('imagen','video') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idmedia`),
  KEY `idservicio` (`idservicio`),
  CONSTRAINT `media_servicio_ibfk_1` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `media_servicio`
--

LOCK TABLES `media_servicio` WRITE;
/*!40000 ALTER TABLE `media_servicio` DISABLE KEYS */;
INSERT INTO `media_servicio` VALUES (1,1,'imagen','https://ejemplo.com/piscina1.jpg'),(2,1,'imagen','https://ejemplo.com/piscina2.jpg'),(3,2,'imagen','https://ejemplo.com/gimnasio1.jpg'),(4,3,'imagen','https://ejemplo.com/cancha-futbol1.jpg'),(5,4,'imagen','https://ejemplo.com/cancha-voley1.jpg'),(6,5,'imagen','https://ejemplo.com/salon-eventos1.jpg'),(7,6,'imagen','https://ejemplo.com/taller-artesanal1.jpg');
/*!40000 ALTER TABLE `media_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notificacion`
--

DROP TABLE IF EXISTS `notificacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notificacion` (
  `idnotificacion` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `titulo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `mensaje` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `leido` tinyint(1) DEFAULT '0',
  `fecha_envio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idnotificacion`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `notificacion_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notificacion`
--

LOCK TABLES `notificacion` WRITE;
/*!40000 ALTER TABLE `notificacion` DISABLE KEYS */;
INSERT INTO `notificacion` VALUES (2,4,'Nueva reserva pendiente','Tienes una nueva reserva que aún no ha sido confirmada, revísala en Mis Reservas',0,'2025-05-17 20:30:20');
/*!40000 ALTER TABLE `notificacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pago`
--

DROP TABLE IF EXISTS `pago`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pago` (
  `idpago` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `monto` decimal(38,2) DEFAULT NULL,
  `metodo` enum('online','banco') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `comprobante` longblob,
  `idestado` int NOT NULL,
  `fecha_pago` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idreserva` int DEFAULT NULL,
  PRIMARY KEY (`idpago`),
  UNIQUE KEY `UKt51rgbdjlpfbmmkbd0scxapv4` (`idreserva`),
  KEY `idx_pago_idusuario` (`idusuario`),
  KEY `idx_pago_estado` (`idestado`),
  CONSTRAINT `FKg26xbgqq86wkv7finesrxwrft` FOREIGN KEY (`idreserva`) REFERENCES `reserva` (`idreserva`),
  CONSTRAINT `pago_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `pago_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pago`
--

LOCK TABLES `pago` WRITE;
/*!40000 ALTER TABLE `pago` DISABLE KEYS */;
INSERT INTO `pago` VALUES (1,3,60.00,'online',NULL,15,'2025-05-13 04:40:00',NULL),(2,4,50.00,'banco',NULL,18,'2025-05-13 04:40:00',NULL),(3,4,15.00,'banco',_binary '�\��\�\0JFIF\0\0\0\0\0\0�\�\0�\0\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||�\n\n\n\"\"$$6*&&*6>424>LDDL_Z_||��\�\0@ \"\0�\�\00\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0�\�\0\0\0\0�gϻp^�\�\�RP,�2\�35%�����	@,(\0�e\ZΆv�q��k#{\�\�SZ��d��^~�YϢ1����Ԋ%�Ǌ^��۞�Ѩ�Fu�,\"�(�L�L���sPgR3�\�\0���-\�ԁ�&���\�g9%�\0\0%\0\Z\�.��\\�B\\R\�5ӗmMS�s.jgR1m$\�9�٠\�3���Ʊ\�zŖ�D�Qe\0��RP\0A�\�܊�!wK	Imn\�y\�\�Ibʥ�L�1�dgY\"����T(\0҈C@��ef��5ۇ}gy\�z\�2\�D�W:�X�5��^�wnz\�U��EZ�\�(���D��@�)�Y\"��\�Z\�m�$4\�*h�,ĖQ\0\0KB\r%�U\0��X/~�\�X\�Ϧs,\\�&ubnJq\�\�Ƶ�\�\ZΈ�R�����\0\0�YD�Y�,$U�\0\n4�\0k:.u�\�N}:`��΋e5\�\\ŀ\0	D\0P-�	K-3wu�KH\�Эw��5���ϮY��\�\�Y�\�\�\�ӏK\�((�Q\0���Ae-��Ā�\�\�\"[`�� �\�5��79\�%j\r0*\n�\0\n�\0�\�6\�.if��(�H5ۇ}\�垸�σ:\�\�޸u�\�\�7�M₥�܅�`\�[$Іeֳl@�����:.l-ͳ\\���1\�k5.ne3�|\�\r2]I\r3J�\�#L�24\�4�*CW#�f�3�\�,�gn]5�\\�\�|�\�7��?h\�#L��\�7�%-�����J\�#R\r25qS�\�K�[�TԂ��-\�CW�s\�=#\��/?r�=}#\���.}�ǯP�\�\�</p�=\��}\�\��\�</p�Ox�\�\��\�\���??`���\��#\���\�<{�����J�\�\�\��\�\�%�\�\����</t���#\�O#\�_+\�<�H�C\�}c\���\��4�4�C\��5�=\�<\�\�\�8�.\���N\��8\���;�\���\�\�;^��\�\�\�#��;�\���\�8�׌;8�\�#��\�x\���\�\�;�\���\�xC��\�8�\��\�^\���\�\�\�#��\�\�\���;�+���<\�\��ӻ�\�\�N\���\�xS����V\�N�\�c\r\�4\"��5�\�\�qi\"��4��\\�2\�\�C-[L�2\�\�D\�E\�Jʓ-%ʈ\n��lR(�%�)\"�\�\"��*���ZH�\�iq�؎^��v5�MM�9��3c\r�60\�\�c\r�60\�\�c\r�60\�\�c\r�60\�\�c\r�60\�2\�\n�\�s�v|�#��\�\�\�+IJ,���(�\"�BP�E��O\n\�v|^3\�\��ze�\�:�\�\�s�\�c\�\0\0\0\0\0\"\0\0 \0I@\�o�\�\�\�\�6z\�8�r\�>��\��]��\��\�Z�����\�M\�\�\�ͫb�J�\0\0\0\0\n�`�ȹ\�z�\�әx^\�\�\��*_�\�\�\�ܰ��IjCL\�l\r�4\�\�4�#H*\n���*\n�\n���Z�;�\��\�OG��	5�Mz\��w��\0+��׮=8�ޱk�Ƭ\�z�zƵ5s�-�ز��\0\0Ie����z�ރߝfP�\��~	}~��\�6�m\�\rH�P��\\�ʌ�����L]-S\r�69�2\�\�p\�V�uN>o\�N�\03���޾�\�v\�\�\�\�\'�\�W\�{<��w��\�ղ\�oQ��\�\�\�[1v1v�:n���\�\�Nn���\�\�9NË��a/~���fP����Ϛ�=��逮z���,��)`\0YP\0�\0�\�?�\��w\�|߿�\r����\0[�n��;����������\�|\���};\�릱�Zƫ��\�Yޱ�Mk\Z�\�j�E�\nY@\0�@�id���>�w�B/\��>k\��\�ۦ���\�K�`*PPB\�E\�\�(@����ϩ\�\�7)\�^�߆�\��>iۇ�\�x>�\�\�\�Dߛ����\��zN�Ʊ\�w57�kS���M\�\�5e�ت�Y@\0X(H�A>Z#]��>�:s���?\�x&��n=�a.i J$��(��\0���ec\�\�\�C�:��\0\�*\�\�\�\�\�ߗ��\��}_S\��\\wߟ\�\�V�tN�7�o?�\�|�\�׾z\�Ӧ��Zƫ��\�Y\�kSW:�e�eTYi,(\0X\0,>X��\�\��|�c4\���&��~�b\�*K	*$�K��\0\0AE����|\�}9j\�6}\�9u��\�\��ϋ\�\�\\�_oy�^\�\\��w|z���Ʊ�y����^\��\�k7sSzƵ:k��7slֳl�*\�PR\n�\0\0,�$�9�>�7�\�/�\�\�����鄪̰B$�J  P\0YB�<��=���[\��g\�\�\��\�:\�kR�@���R\��~o�\�\�������\�����\��\�C�?�\�|f~��v\�\�zƗZƬ\��\�SzƬ\�ε-�\�\n\�)@\0\0�>X��\�\���\�%�w�k\�\���:a*�,!!,�\0/�\�\�^ۖ,Z\��j\�6}�<\�{\�\�:3�J��@\�s\����x�y�~w��\�k\��\�gO&:򗮣^oV�t�~�\0�=Z\�u޳SzƵ7�kSw:�V]KeD�(@\'�/�\��\�\�H��\�\�s\�\�Qa\���%�z<���.j�$�K\0\0�Zϓ�<배Q(�\r랬�\�g�:\��]J�\�,�\�<�}\�M��?gΏ�\���\0[=yy��&��\�\�4��o�\�|�cٮ[\�צ��ֳl\���\�޳�gV[-��T\0\0��r\��n1�>�ή�\�s\�\�Z�/�\�\�\�\���:f\�+2�,�\0\0TYk\�Ӈ�:�Ŕ\0\r\�},�\�_�7�����nhԁ\'�\�\�\\�?;\��5\����g�~�=1ێ�uq��\0.򹾯�\�λk\Z\���\�\�\�=5��\�R\�]J\n�\0*,L�\�g�=z��#=.��\�r\�\�U�/�\�\�\�\����e,�\��!\0 VT\�\\^�]f��\0Q,\0YM��<w\�\�\�\�=,\�]@�K,������|:������>O��n\�_�\��7\�z\��ϣq\�\�\�=��toQ��K���\��\0��.��\�#���g\�,ͺ�_�˗YVX�/o�__�\�\�\�\�&u	,�,R���Z�?g�^�!e��X\0���\�K<z��e\�{M%\�B\�\��s\�?�ٛ\�\�μ�\�K�\Z�q\�]\\���z%�&��[lZ�\0@\"�(�\��\0��\�O92ק\�\�_\���\0C:�/�\�\�\�\��z�D�\�,$\"�J\"�E��~~�\�Ҁ\0�(� �}l�_G�7q�4�Ĳ\�\�\�\��Ξly�^.>�.�\�^z�zW\�\�\�\�\�\�T�\�Z\n�\0��\0*,oG=Op�\��\�?\���\0C\Z�/�\�\�_O�\�\�\�K,�\�K\"��+\�\�\�\�΂�\0\0\0�\�v�\�{��\�{�Il�Od��\�~\�s\�\��}4\�\�\�zU\�Ռ\��P(\0R,����\�Y��\��zk��\�\�\�\�[/�\�\�\�\���7�̹Ȁ�b�\0.:y��\�\�\n\0�\�\�|���^Iz��\0@k#�\'[<z\�\�^��\�\��+\�\�RPB\0\0\n�\0 (�>`̾oLW\�\�\�P/�\�嗷�\�\�ܰ�2\�K\"J X�\0�/�\�\�\�J\0\0.\�,\�ӟYz�}�\�וκX��\0sN\�o[<w�ޚ\�\�Z�b(\0 \0\0�(�K\0\0\0,��2\�_�\�x�\��y�\�\��{w\"\�ɝH\�\��F\r�T\�ɹ��\��e:y�>AןYus�g^OV�\'N:κ\0\0���},�k\\��מ\�\�R�\0\0\0�\� \0K\0\0\0�&h>\�>����>yz{|>\�\�K&l �)`\0\�\�\���f�[�`�l�^\�c}3�e�\�\�׏\�O/Nκ\0\0�;x�\Z<[\�3�F�n\�\�\�(\0\0\0\0��\0\0\0(�bf\�O��%�G	u\��{�\�l̰�!,*Qǿ�/|h��͹{%��\�\�<�jk���\�sMx��Ϳ?\\\�b�\0d<�9q_o>��N�oY\�Ͳ�\0\0\0\0\0\0	I`\0\0>]&VS\�\�P[ÿ��\0��vgY�2\��\� �g�k\�eG�u\�\���1\�\�t\�ӧ�S~j\�N}eՖ\�\0,�\�/�\�#Ͽ\'�h,\0~O|<�\�\�Wo>��N��\�m��\0\0\0\0\0\0\0@\0��j>�YAo\�c?G\��\r�Գ9��$�@@YASϜ�δ�O?\��?�^\�/\�λ�^�^�_�]�\�ԥ�\0\�\�p�ܔ,x=�8׿\�\�]q\�\�Mg���\\�s���K\0\0\0\0\0\0\0(�\�Vj>�Υ������vgY�2\��`\"�e`�z�ޜ\�MO\��x9��}\'��\�]�\�\�s��\�\�VZ\0��\�xwU��\�^O\�\'+\��\�YѪ�@\0\0\0\0\0\0\0(K\0>hee���nP[ϧ8\���o\�\�gY�3Y���`\0��>z�Άu\�>g9ߟ�\�\�:y]0��\�s�\�[�(�a\�P�\��<�\�i}<5�\�8�\���\�u�@\0\0\0\0\0\0\0\0\0�\0>hee���t���s�_O\�}=�u�&l\�` \0\��y��\�O7�\���\�\�\��^=Eߛ\\��흹�\�\�\�A��z	K,���_�9�G�\�v��f�EΈ���\0\0\0\0\0\0\0\0���e��9ún7�\���_\�\�gY�gY �J \0YO3��:\�u�˴�\�\�TJ���\�\��\�\�e�Q��zX����~�I<�E\�,��zGIP��\rYH�\0\0\0\0\0\0\0\0\0��fYc\�חU�YX\�c\��>_\�\�K53�d��\0\��{<ެ\�5�%�\�\�\�Y��󤥦aޥX��x\�%�=�^ȼ�\�\\]�\�Ϭj�@B\�\�ID�, \0\0\0\0\0\0\0�>hee�^]VYegY<\�W\�}Z�\�L\�YY,� _W�^���,\0^z<�n]٫y��Yh�,[=#ɾ�4\�\�g�\�E�\n�	e\0\0\0\0\0\0\0\0\0\0P�����9��	l��}o���MgS9�d�\0�YI\��p\��\�l\n\0\r�\�\�3\�e�y\�z&�\0�w\�<\�O\�\�^�:|�\�7Uz\'�/E�P\0\0 \0\0\0\0\0\0\0\0\0\0>`ee��חU͖T�\���Oֵ�gY\�\�e��	PP�o��:й\n\0�OG�\��bW�IK=\�hy��9\�Wg�kK*h�\0\0�:\0\0\0\0\0\0\0\0\0\0\�e��x��6Y@��o��\�K5�gY�Pg\\7�\�\�΃Y\0\0:�z�?j��oL>7�ۓxǌ��evz\�\�P*k4,\0\0@\03�(\0\0\0\0�@\0\0\0>pfYOn�qbZ\��^ԳY\�u��\�\0�\��\��u΀�\0\0@\0�~C\�\�\�\�[\�>$�]��\�\��[ \�\�\0,\0�B�\0\0\0\0E%��%\0\0\�}ޏ7�^vY@�}��\�K5�gYY* \0χ\�\�:�\�\0\0\03WofSϷ�\�	\�WI\�Y�R���\\\�J\0\0\03�Ҁ\0�\0\0,@\0K�%_g�\�헕�QO\��Z\�,\�q�ed�\0\�\�\�\�Ωn`�\0\0	�~�\�9}?\'�^�:|\�\�\�\��TR�J \0Τ4	@\0\0��,\0\0\0\0\0\0\0\�%\�\��}	x\�eYO\���\0^\�,\�q�ea 7\�8{<��\�,K\0�,�E�L\�\'�������\�t�(�\0�\0$��\0\0\0��X\0\0\0\0\0\0\0\0��S\��~wҚ\�e�e<_\�}{l�Y\�7��\�\����}=sJ,�(�/�\�>O^��\�\')\�V\�\�]ZfR��\0\0 \0K	�\�\�\0\0\0K	@\0\0\0\0\0\0\0\0\�{�?��e�ؖ\�\��}��\�\�g\�VK x�L븹���r��|�~��\�\�s\�\�^mv&\�٧KP�\"�,Z\0\0J$�Ԣ\0\0\0�d�\0\0\0\0\0\0\0\0>pbP\���Gח\�&�h�}��\�Y\�q�\�`��\�\�έ�\�)~t�Q<}/\�:qϡt�\�]\ZeJ,\�\\\�\0�(�:!\n\0\0(͔P%%���A\n\0\0\�\0\�\��\�f_0�k:<?W\�}[w�gY\�7��\'>�S�=�h�p\�\���u:�<zu1\�\�\�\�F�Yl�K�e\n\�\"�\0\"\��`�\0\0\"\�\0\0\0�*P\0\0���]}���#\�&�Ώ\��_V\�\�Y\�s�\�`��\��\��\�Pf\��j^\�\�\�\�8w�ײV\�\��(�J*T�\0\0l,��\� \0KQ\0\0\0\0��\0>p`�>ܗ\�&�h��_��\�\�gY\�7�	xq�κ\�\���s7\�1��\"\�\�Y\�Ԋ�k4��@��b��\�X@\0@6\n`�J \0\�@�\0\0�@�e	k\�%��υ�e򉦳O\���Nޙ\�u�\�x!�|>�\'�:c\�\�\�v�\�g�\�\�]e\�I\�WF�*\�C`�D���`)\r�\0�@gY4PP\0\0�Y,R\0\0(\0\0\0>u&�w\�}\�|�ie<K\�}\�gy\�w�y�\�z9u\\c��\�5\�V]�{%ti� ���X\0��VT\\\�\0@�kP\0\0��\0\0��\0牀�}�\0���\�&�S\��~�{gY\�s�\��\�|�\�\�\�\�\�ߗ^\Z������-�İ���\0$�K\0�@\0	PՔK\0\0,\nH\n��\0\0�}\����VU���\�\�gy\�7�͌�κy7\�\�Hi앺�\�\�Ŕ�\0  �W\Z��K\0\0�-\�,�K�\�-΄�(�:\0K\0\"�@\0\0�ဇ\��_u|\�ie<�\��}\�w�\�\\_%ΰ\�\�V\����%��	f�p\�K�\0	��, \0�&�A\0\0YD�:��(��\0硊E}χ�〚YO7�\�\�_Nu�\�?;\��Iyun[^�tT,�$�4��B�@K l\�\�,!%�R�@�]\�A���e\�� �J@��\0�K@\0\�&z��s��\0aNlޗ�9�|}\��NWy�\�|\�\�G�V\�ł��&�5r*\n�,.�\�,��%�4\�,D���Ƭ�\0 ��W6��\Z�r��D6*���\0@X*\n���m�\�\�\�\��\�V<\�\�sm_7����:MN;\�x\��Og3��88\�@�n<��\�+\�W\��`\�=|\�>�9��ҏ-\�|��\�<�\�O3\�\�\��\�\�_#��|��\�\�:\�|\�O=\��8\��9\�D<��C\�zl\�鳆}88\��9^\�3��8N\�\�ގWt\�\�\�\�:I\r06\�M�\�ۜ:�\�D��/\��?Qq[sN>�7�\�S<�\�z\��\�Ks��}x�/=�:���\�\�΁=�u�ǯ#������@8v\�\�P��r��/>�3ӗbP\�\�\Z5Br\�\�;\�G>�\�_?rP\�T\�hq\�\�=2lc|��\'�΃�\�:M.�3�fM�M}O�펳�^�\�5\�\�\�\�l�f\�V|\�\�\���\�\�;\�=`\��C\�L\�;<�}/0�8T\��\�}Sͣ��==;\�#��\�\�;8�\�哻�\�\�;^\�\�;8���\�\�;8ӫ�\�\�:��\�C�\�:��C��\�\�:^4\�\�:9��P\�9�4\�׷\��q*^]x����3Y[��(�9݋%0\�\�A(\�\�^Z\�\"Ӟz�Z\�\�C-�5	h�S7v���\�z,\�\�9^���\�\�9:�N���8�.�\�\�8�.\�\�\�9:�N��\�\�\�9΃���\�,η�:��\�_[ʗ\�|��_�}�Z�\�$=�\�%�<�\��h��p�_=�=o�<�=��<c\��c\�=�\�d�\�{\��9\�wlSW55skz�ŕ(�\n\0�����\"��\0\0@\0\0�>�qy�C=3��YBK�*�u�-�(�\�:h\�uH�Δ\�uD\�͢,\�r���t�nk\�|\��\�\�\�7qM\�[7�{�o\Z�{Ƭ�6\�eE���\0\0�\0�J��,�\0\0\0(\�}2\�˟d<<~��_�^.\�\�\�N��\�NK\�wyh\��\�}0��\�\�<\�\��K\�=/0�q\��.8�����a\��{�w�\�֦ѫ�I��V[)l�QJ�@\0\0\0\0\0�܊\0\0��\\\�\'�\�旀���\0�r_��\�;\�n]�zWM<���\�Nmu87��$\�+\�\�N-d��WN�\�\�\�N�����?C5�\�)�kR]]L\�Z�JjR\�!P\0\0\0\0\0\0\0 *\r%A \0\�e\�9>oO�^X\0(\'>��\�gY\�Iۏ[�\�9t\�;\����z<��\�d\�\��p;�\�\�ϣ\�\�<��?�\�\��y�s�.��Mf:t\�ԟS��N{\�L\�Z\�\�3m3j���\0\0,\0\0\0\0\0�\0\0-\�*\0\0\�5\�y�>i|�\ns\�\�~v5�t�yj\�\�|�l��\�\�\�\�\�9\�\�\�p\�\�Pǣ�1\�\�I�\�}ï+MnR�\�1�Z%��H�,\n*\0\0,	@\n��\0\n��@:\�\r\�?kɣ\�\�\�e�\\6�7+-Ӝ\�#\�\�覾m�$�\�\�\���\�+徘��\�����o�>[\�C\�>����\�%�\�οEf\�e�\�\�#L�H�24\�Z��*\n���*\n��* � �*\n��\0\n��\�\�#\�/<�\�\'�z\\\�Yh\���\�\�˾�\�-\�!LU\����E1���\�ԃY\�Uj&�d\�+Y$\�J��\�YT�N{ΔB5��\�Qƥ�RMdѓY\�M\"��\�4�\r`C\�\���e\�N=�K�\�\rLq\��\�.5\�;\�\�\��o\�\�:B�\�c\�	/�\�\�/޼��\�\'C�\�_k:��c\�|~���\�\�\��#ܔc\�|ސ�t;�3\�=p���ޕ<\���}\�A�N\�@�u<�f�����y�\�\�]k3\�|�\�$\�o��ϗ\�\�\�O^<\�\�|;_F�\�;t�N��׎�\�W׏0�\�(\�\�\�F��\�\�\�c\�τ=|��\�\�\�W\��C׿�t�S׿�\�\�?%=\���ݟ�\��=]<4���\�\��S\�\�\�w/0�\�\�e�Ӿ�t�o\�ON��\�\�\�o?4=\��\�������\��\�\�OGO4/8��/E�\�y�-�^W�~�ޘ\�\�Ӊ|Ӽ^.\�\�\�8�ָ;#��\�\�8;��\�;�\�\��;\�ヸ\�\�^ヸ�\��3Ў\�<�\�<\�H�=#\��+\�<�\�<\�H�P�=#\��+\�<\�\�<�P�=p�C\�=p�C\��+\�>z[���\'��s\�\�P�>O_�~͗�3�\�\\\�\0\0\0�\0\0\0,\0\0\0\0�\0\0P\0K\0\0@\0�\0\0\0K\0@>z��\�\�=���%Ϗ\�\�_��\�3�\�\\\�\0\0\0�\0 \0\0��\0\0\0\0\0�\0\0\0B�\0\0,\0�\0�\0B�J:z���\�˯)BY\����\�\�zfcx�\�\0\0\0�\0� \0\0B\�\"�\0\0J\0\0\0\0JT�\0\0\0\0\0 \0\0� \�\���O\�&���/o�_��\�f7�2\�,\0\0\0\0\0�\0\0\0\0\0 \0B��@\0@\0\0\0\0\0>|��M�|ޓ\�p\�\�Z%�w�_��\�f7̐P\0B\0\0\0\0\0\0\0\0��\0\0\n�\0P\0�\0\0\0\0@�ќ���w>��\�\�͡g�\�\�\�\�7�\\��!D\0\nK\0\0\0\0 \0\0\0\"�\0\0,\0\0@�\0\0�,\0�\0 �A�5\�\�\�~��\�\�ʥY\��x��N���\0,P\0\0@\0��\0�\0\0\0!(�\0\0,\0\0�\0�A\0\0X/n=W\�y�^\\�Y\��x%�8垙\�岲]04\�\�(\�\�#L\r�4\�\�#L�06�\�\�\��\�\�\�l\r�4\�\�0\�l\r3\r�724\�t\�724\�\�L�H+#L���5 �+*�*`חE�^_W�[�~�ʗ\�s\�\�\�N�8:Ӌ��.�8�h\�\�N\�^n\�\�;D\�\�\�\�NN�\�:�N\�\�;d\�\��\�:�Wt\�:S��\�\�s�Nn�2\�\�\�^mӛZ9�#�2\�3�1uLM�.�4��#-\�\�yH\�#C*2�\�7�Ɨ\��=~L�o\��_�|�s\�F��P\�\�%7�@cy4�\�jR���:J\�:�B1�]H�c|Β�u��l\Z΀2d\�,�7�Ii,��}	`\�\�ة�r;f�u	�h\�\��\�7 \��r_\�x�~c\�i~�\�\�\�\�r\�\�\�/\"_W_�O}����\��\���s¯s\�=\�\n_s\�=\�\�=���C\��C\��\�\���t�c\�=��\��<C\��k\�=�\�=��<h�O �O!}o���\��\\�\�\��[\�=o ����<j�O!=o ��e���\��\��\�H\0K�W:�sU\�\�	\r �*\n���*\n���+#L����*\n�Ԃ��ZȨ*\n��\"��\rH* �*\n�� �*\n�B��\�`K�c|\�]��\'�\��\�ݍY-��s�j�2\r!�f]�J9��%9�΂7�h\�Q\�\�:	L(\�!ˮ\rYFu	@YJ\�y4>�\Z�\�}3�\0\0\0+\�.Q@AӞ\�=\�|���\'򹷔(ʗ6�\�I5t\"�(K	ABT%�l\n��Y	���4�#Y\rH4��r\Z\�B\�5X��޳K�\0�X=�L<\�@�\�@�\�@\�{9�C\�{]W��\�.���\�z�N���\�\�N���\�\�9:�W�\�\�9���\�:���\�\�.\�\�\�9:�S�\�\�8�.\�\�\�9:��\�Nヵ^�8;�\�\�=��\�=$�=%�=#\��3\�<\�H�=#\�\�B\0J\"��(���,\0\0�\"���\"��(�\0P��\0\0\0\0\0,\n��*\n��*\n\�tȨ*CL�|\�\�z�#��\�\�;8S��\�\�;8\�\�\�;�\���\�\�;�\��\�;8�\�(\�\�\���\�\�;8E\�\�N\�#�\�:���\�\�:���C��:�ë�:9��p\�9��c�\�:9��\�\�:9���\�\�:Lnu7$4�\��\�A<\�@�=%�=#\���\���\��3\�<\�\�<\�\�<�P�C\��+\�3\�<\�ԏ+\�<�P�#\��3\�<\�\�3\�_3ҏ+\�<\�H�=0�\��3\�3\�<\�H�=#\��3\�<\�H�=0�\��3\�<\�@�\��3\�<\�L_;\�<\�I<\�@�\��E\�\�\\\�\���>��Cُ\�\�>\��\�\�F�\�S�����H�\�?H�\��+�c�ͫ�͏\�?5\�?2O\�?2?L��O?2?L��?O/��L�7����#\�>@������O��C\�<Y=ϟ�>p�3\�l�\\��\�?<?C?>?@���\�S\�>�o�>\���\� �O�O�>1~\�⏵>0�3㏰�\�>\�\�n_���_�<}\�=\�\r_�Z�\�k��\�\�5�\�\�\�dʫ3H\�7���K	DD\0\n ���\�\�\�ۏ@�׷\�\�M�Rɒ\�dD$y\�Ƀ���e(�\�\�\�2�ţ-�b\�,Kr^�<�λYq��(��\\\�\�\�\��w�|n��\�\�Ք\0�3��\\M\\\�N��JX��P�,�*��g�\�\�庌\�E׫\�\�@�gC\�\�Y35|\�_��J\�@U\0�\�\�B¥b�(�\"�,\"\�*2\�w�\�},\����<�u}<\�%�5r)s#s\"܎��\\��\�E, H�,\"ʖRŏW\��?C��Ir�p\�P\\\�R*\�&w�9\�\��\�Ǯ`�Ae\0YR\�V� L�3T\�\�l	5	5	e /n=s�\��\�\�\\�{@��%Yd5j �\�\�X�55 \0),%��o���o\�H��\rE��\�\�:dĸ>-g�%(B\�*R��X�I`�,�2Q(�4��t�z�t�Mg\�\�k:$�J�%�P\0�EU@)@�\�JH\0��Ӟ\�\�r\�\�\�\�賤��P\�\��\'>�\�\�\�:\���E�k:��-\�5�L[(!`�\�e\���J%���\'\\\�;qȖdH��u!i\rH-��,�*))2��@��\�\�\���g�N׆��\�\���;NX=\�=9�\�\�6w��\�\n�(-\�4�\�R\�`�Rl\�P͔J$�R\�K\0\ZƎ�X\�\�՗�s,Π\0�P�*�b	i(�HJ�\0�\��}��w�}[��|ޚ�\�\�CYE�ѝM\��q�y:s\�,\�����-�W#D��k!-2�\�	seK\0�\�\0�\�\0\0\0\0\0\0!n�.�\�\�ay���ߝ�L�\�\�5�d`�\0��\��S\�kG\�m�\'n\�\�<1����N�үC�e\�j\�i4���m�>\�{Z�\��	�B���E�@\�%�%\'G�7ќ}�}O�\�<pU5�\0*|��\�~\��\0��\0�M�j�\\�W�p,#�4�A_\�cO0\�ꈓ.\�\nk}��|\�W٬�\�Vk�\��G\�L�Ti\�S��\0j\��I^v�4\�1\�C�`�؜��p��\�\�\�Nx\�dlY؉\�*YS��\�8��p5\�L�\0JMr%\�,�h\���\�\�M.s�K0B�\�=�\0�0�K,���\�K1\�,�7�[� \�$ĐG����/88\�zo>>�$���\�i@\�2O<U�\0\� \0IƧ\Z�(\r�y֔=7\�\� �� �z\�M1�4�\�\�Z��I\�\�?�\�jvh,�\�,���\�1\�,��\�h��ZZVs\�\��\�\�\�)\�I]_IAPA}��\�:�\�p\��ˑRQ�\�����\�\"_\�sAǛA4\�M4ߎ\Z�\0sc\�D癥ռ����.�!j�\�O\�>�\�\�%g8\\ro�yخ\��_�Y�y�\r\�<��\0\0J6��qwק��\��\�9\�\�׷JPz$\Z�f�hC�\�\0�埩K]8x��[}L��\�;�2�Y�T@[17��=0]?\�5�\�uѤ\0UX\0�|�7&���IA\�Rx��\�P\r,�@�K\�\'IN�}\0\0\�ܣ(mO�i\�~��!h䍿\0C\�ҵ�<�)�\��\0�q\0/\r\�\�`EN�gA�\��\0\0A\0����\�\�\�T(S\����%c�ڜJ\�D\�c7W��A���\��;�y���\0(�\�?e8B\�\\\"��yM��\rp=z02\�K���\�A\�<�<�<�\�^�4Մ^��\�P�\�79g�\�+\\���i�\�W=N<\�O(����\�\��\�@�^��Ȗ�\0�\0r\rⲠ\�!\�6�|M��K<\�K1�/js��\�\�MuN�p���@\�\�\�>�8C��C0�\�;D�\�+,�\0o6\�Y�s��t-N�eV�\��]H<�\0M(Y�ۻ�\nՆ�6\�M��\�\Z�Ԉ�n�0�G��\�<��8\0.\�V�\"\�` �ty��AY�\�J< P��K<��<�\�q%�¤NO�C��\�@F�]6\�-\r\"�\�	���\�\�\�\�*�&bcO<��qG\��\�}�)W\�}�\�\�\�N9\��\�>mJ�-�\�=�\�u�ev�<�\��m�\�r��\�\�Ž�jP�\�_0��\�U\�r\�	�\'W<�\�A�}\��\0�O\�[\�\������L[\�b<�E[���U�\�<\�A\�\0�2\�=ĝ�J���|�Ga�\�Z��\�\��\�<\�\�M\0Q�-I\�[\�ʣJ��I���\��\�=\�\�A�tn\�R|�9ĀA<�\�,��\0	g;/]Z���\�}D\�eR|�\�<�\�Q\0\0�\�>\�\�\�YР��<R\"<�Y�\�GA@\�=��u�\�\0�=\�\��,����\�VlT���bלQr\�-\�\�(\�\�y�\�P�\0A\�*�\�[��\�*D���Z\�DkV\r]xw\�0\00\0�\�h�z��8j\0P-x\�\�Q�Xz\�}�\�D\0�@\0\�\0<w�k����\�!Ғ�1�`�\0<\'\�|\�TA \0�\�hD%�X	&�0AR\�b�\Zm5o\�b\�\0\�]\�\�@\0\00\0 <6�J!���$L\�UW��4P<\�m�@�\0�\0ƮV \�[���\�A\�yL|$}\�\0S\�q%\Z\0-\"\0\0�Tj�`�\�(	g���E\�\�b\�\�S\�Q�=A|s\�\�\0ʨDJ\�r��\�\�iV�\�o�\�8\� \�Ag\�U�\�<�\�<��p\�l�ɼ��\��\0\�@\�9�	B=a�i,u�\�}�\�}�Ϣ����[��\�Ew�h��}�\�<%[Uw\�AUmFAT<� TJ\�(�Ŷk�QlĹu�Վu4^\�q\�U�AA\0��Q�⍴���\�\�\�\�T�\�iR�H4<A��M$P U�\�Y\n�|0�pGh\�<UL=GP|!EmS\�\0��}�\�]  ��G֠���X�\�\�BdTRX\�}��\r7U�w\�yG[B ML$[Z��F��\0\r��8�\�]�(�M}\�A�\�W\������k��\�:ƟE(\nh�O\\��W�\0\�$g\�A44�\���6:^\�5�\�\�I����\�)\�\�(��i�8#��\�ADO>��e�\��\0C\�U��\�B�\�T�\Z\�<-\�\0�\�i��YTH\�\�&\�i�� А}&EDD���(!@4�-�F6\�㠉�f2\�qTXb��5�E�B}��,\�\�B�\�O\�\�D�\�\�D\�H>�\�Aux�\�o\�f\�,�\�l��\0\�8��\�O�>�3͞B\�	�h�\�c���J�{\�	LU(�\�6�\0z\�<��5\�u�\�H)C�A�\�5`I\�\�e[/,�o0\� ��^����\0\���	AA��X��\�%�qCO\�\��\�(A�$q�\r��\�߱=\����\�)ಅ]R� �޳ü4\�/<\�0\�\�\Z�j�\�\r�\�/<AB�ꤍ\�D���U�O�0�\0\0\�0c\�\�\\k�V��醋i��\�W�\Z\�I;W`\��\�eӌ7\�}8R��\��6\�J��J!���\Z$���44�\0��\0C�Q�\�i\r1�̰�z�&�\�\��\�Q�)cE\�Y�	}Gy�]<�u���/~�׵YT\�\�-d7\�\�\�}w�A}u�؊X?�\0\r7�\�mv\�l;\��ܞ�=\��\�\�\�e��AW\�}�\�K\n���\0��u�\�\r�ۿ�\�\�wg�|\�=�\0qM4\\0�Y\�yj�2�t�]\�M4�`7?M\�\�8C,0\��\��\�<��\�\0�?<\�\�g�I�\�0�\�H�-��b��9}ql�L1�\�a���Y+\�\�\�!�8+���\����\��\��\�\�~���(��\�D�oV/�3\��t�����A\n\�YE�\0a\� }�R��\�Ư5�.>���z<u5\�\03�>y\�\�?Ü8\�N=\�\\�¨d\�[�n�\0\�(3˂o��mg\�} ���J\0��\��,��\�,�\0<�(,��AF�m�\�@\�\0\�O(S\�M�#Iy\Z\�\0O����C_}a\�AAO<\�\0s�<�O8\��K/� \0ҡ�\�/�#��\�A}T\�8�O\0s��^aW�}�$�\0z ����	\�M��M7�\0r�\��q��4d�?8.�O�	o�� ��\�\�\�\�i\�\� Sy�\�\�s\�#��7�T��\�O<�$�� ָAW��\�\r\�\�A7��>?t�\�.�8��\�+�/=\�[Q\�\�;���!��\� �\�)�#�ǚY&L\"��C2Zg\�M1E\�\�l�H�\�E�B?�\� �\�-\�mw�IEU\n�n�V]v\��\�~�]Dw\�\�7A�Vꣃb�,����\��\�q\r4�\�%�;\�f0�<Q�QPN��\�n��,�8\�\�Q]\�4\� �\�v\�f?\�\r?�=�\0\�[q\�X�\��\0\�~k���\�I֗\�¶\�%�:5��`���\�u�\�\\��a1Nc(�\�a��,�O	\r\'�\�\�\�v\�|\�\�O=\�<��p0\�/}0Į#\�O8\�t�\�!\�Lw\����0\�\Z�<�\�\0\�0\�,�\�u�%��\�\�6\�#��m\�L;-�w>�\���\�,0\�-\�68��\����h%�Op\�=���\0�ϸ\��0\�\�1\��\�U�/��\�\��(\�\�)�+#I\��\��D\"\�,G\�\�\��\�AC	CPQ�-R�%g�\�Jc\�\��i��3\�<���\0(\��HL�\��*S\�j�\�:\�\r \�J�mML�ӛm{\�R\�;�4��\�O-����ŧ�L\rě2�?3\�H��\�M$+̪\��y塻#�v\�\�Ud2\�����m\�f�\�#\�F�\n&4�����?Lq\�\�a�X$��ʘwʸe�\0e����\0\�\0\�|\�\�?�s\�+\�,�<�jK�}g��6��\�\��3�\�;@\�Eh��<)*��k�W��Ma��y�,U0�\�g&\�p\�\�\�\�T!	#�\n6P-�\�(\�%\�hW���\�\0�\�\0\0\0\0\0\0\�\�\�Zu\�S�\�\0�\'9i	\�\�	+q�O?��CIi�Wң��}&�N\����h\�a/:z�}Z\�\�\�e�/�sLn�ńg\�\�qC\'O.��\�\��\�Bؔqv5n���\'q����\�T�\�H:\�#),��MuW�Li\�\�4����\�a��L��\0u�zBcSqG\ZDPK]�wv+��\�\'�<x��#0�9]\�\0\�e<a,U�\0���\��C��:�\�+\��\����tYtU\�\��E�=\�7�=5�[\���\�\�	TcU\'�\�I\�\Z�\n)\�UG��\�u�ƙ$��\� I�\�\�\�(\�10$�	\r$\�Ȩ\�\�N�ڃI0�Qh\�>r�\�~��Wo��k�\�o�F\n�՗��O�/(\�\�}ZUÃ\��\�]�?�\�\�\�<�\�$�f3�9���\�u\ry��F�\rg��W�I�0�Lt0\�O�Dtd�M5\Z��c�k\�yN���^\� ���Ѓ`~����k<i�\\A\�\�\�}��\�s\�\�n\�\�3\�m�\0�D�8oM`����\�K���,\�\��\0���~+ֶy\��4�-.;�Z\�\�4;;sxԑ�y\�\"w\�c3-A�QIOS\"��\"\�$���\0��\�qT�YlF��\�j\�`4)m�\Z���r\"ҡz��p��\�\��G��,MA��:i�Иf\�=�8\�T�\�7�~(��\�Me\r2�݌\�0�5\�NgO�U\�\"�amy�n\�\�(�)<g\�\�0\�\�����-\0\�vy�$Q�OY\�\�cr?vK+o���Q��@����\�CB\��\�Vx\�Ǐ%\�e{�������I��[�\�,R�\�V\���/�Oԭ%\0\�\�|2wZݹ�U��(�\�zJ\�+G\��/.�:�?\�F��~\�b]��p�\������\��\���\��ə�\�\�L��8�\�\�x\�\�.�\�\\\\Y\��j\�H.�\�o\�!j|�\09\�t2\�[\����Zmpz�\�Y��\�\�G,g�k��/�$0�\�Ӯ$XM�������z}nW�\�K!S\�ׂ9\�8\�I_\�\�X\�HJSN0\'\�n\�m;)ވ\�:��R��b�\�\���._/�Ot<bX����<\�p�U��Y�\�R\�\�y6�|J\Z��\'\�w>\�5��4|vo\�ǑV*A\�f�9�,�OXb�_7\�S��H�\�/��Qa�\n\�_�8v��\���H�A\�Ɖ�\�i%#\�\�aS�9?\�VP\0L��B��5�P\�－\�R�j\��\0�\�C\0�,:t�L�\0\��\�l�˰R(��<�ņX��\�_F\�t(\��dmz�׭H(\0�8�\�\"\�s\�\�~����!/e0;+kaOgx\�G\�H\�	��\�\0��\01<�\�v�䞫4�p\�\0��\nI�\�G\� <��\�\��j`��-SrZ��\�j|8u\�_	�\ZarAJ\�\�m�\��\�3�	$\�\�&��\�2���P\�`��\��2\0�C+d�p!�\�Cz\'�ߐ\��9�A��\n��=�\�2~X��5�r\�\�;�\0E\n:�\�N��NQ���Z\'���/π\�P�2\�.\�`\�\�\��@-7�\0�\�P4�$\���r�/\��\�\�P?�Xy\�-=��K\�ϼ�\��C@Q��\�o-\�N��\�Q��\�ot�>��\����\0��\0:׾?9�~=�\�c��\��\�\�n��8e\�1/�0�B���\0s\�\�\��\����C\�^���y\�<����I�1Ͱ\��\n�\�P\0w�\0\��9H<\'\�g�l�\�	/,�\"�uH2���I�[\��}�\��E۴�5wm|�\�l/�*Z�۶\�^��dA\0l&0\�\r�D���9\��\���SE�Ok�\�_��mqx���=w\�_\�0\�	\�k\�u�\�S�O\�U֔�\��G_4͠u��!\�\��I\��\0�\�ud\0��\�cKx׼\\6�X��\�E\�(�9y�M�\�A\0\04\�	YW��[d\�}6V����E\Z}\�F`!�Q�\�u��\�_\Z@ff���K��Qo\��\�I\�\�x�\�\nE\�iD|��\0I7^\��,m+�=�9�d\�\�UJ\�\�ñ)��M@E�\�M5n�J��\�M2!�\�\\ABJ-\�,��\�}��/B^	�E�h&a�\�s���\'\�\�פv�\\\�\�ڽ\�\�v\�E�\�N�1�n,З��\� \�_i�ڵ`�\�\�\�4<$�l�97t\�Z�$�Ibt�\�\�Zf\�r%~ �H�_�d��(�B\�}5\��\�\�t��Û�Wm~�]\��k�P);5�\�@�\'���޴@I0\��\��r.a%CT\�\�W���d\��^�\\�|Ü�{��6��\�W#U\�vN�(py��\�\�k\�m�P0��9y��욘Zw�R���V\�m\"�K�\�MV\�Z\�l\�dVf6�SQ��*�Kg��_\�p%dw�\\CM��PQf<�\�&\�\'I\�R*�OY\��Sη\�5\"@\�N6z,?\�\r\'\�*�txa�ч\�\�c?A\�\�\��{�\�\�_��<HW�7A5���`O��E\�\�=1�h�eWÃE\�\r�\0��\�\"\Z\��u6�z\�{�h1[)%��Lt�\�41�����[��\�y�\�X`�p���4͆��d�]e\�$K\�1�w^݇\ri9!����s\�a���Af�V=�O\�t��8�������4\�(�m�\0W�x�\�O��O5޳Ĉ<j\�\�b\�2�\Z2(r� \n\�eЀ\�%�U\�̲��s\�\�\��b\"\�+�?Y5Վ�O�Q��׵\\�p�2�^Uq\�t9����|�*]�þ����S\���/s\�x?x!_]&TT�y>��p]V@m�Ì�\0\��0�N���ٛ/\�NV\�ш%��\�\�k`x&gd?=$�\�WQ^�\0\�8����C�rO�$\�a6\�%n�\�\�IaJ1̽l2�\0t\�.O>\�\'5�I̬\�ㇸ�w�\���4YD�\��0\�\�\�\�\��(�m�P�٤�\0<�<י\�\�}:�d]C�[h\�z\0�\�5\�\�\�34��/,\�\���;\�<\�܇\�<\�/OF<�0qv�\���\�8�¤������U\�zi�T$���XX�\n&\�\�aV�Iw\���|>J\�&C;>\�|\�g���B>);޸$�\�\�ivD\�\�)&�)�\�S�N\0�\�ĺ\�pD{?�o�\�\�k�Kb�\�WA�B3\0��q�S�y��޼Q-ポx\�\�?\�穖��XS\0No\�ႄ%�\�=�\��\0\�\�h�)�\���\�j�\�1w\Z\'rN��\��Ǚ��q\��\��\�z\�/�3�0֑�\0xx`Xk9�ؾ\�\�;�t(i��\0�{g\�y:%�\�r\�>� 	��$\�\�_\\�O\����\���r\�X�\�5M\�\�4�Jח��\nC\�u]2l(3�)���|ԑG2\�0�KS�����Ƴ�\0�Fg\�-��\�t�A�<���(s.ӎ�\�D�ёr\r7�p]�\�A6\�!�\�z\�\���X!�nIu\�%\��	ܟ>�	Á?��\0��*b}�������7\�T�\�,\�\�q�\��o���4��\�W�Ϝ]߾ʖ�,��J�e�\�^ho\�߳\�6�}< 	�r��-��n�U|Њ�0��{��Bð�\�Ny�[����(\�=A\Z�d \Z�(=\�\�\���̹��\�~kh�\�\�\�	3ѿ-4\�\��B�\�\�\�\�?\�����	Yk�fw\�Qa�[j�\�\�xٹ\�\�#�sc�v��\'.�&�(�\�Y���ϲ��?�|U�oq\���L	���y��K\��\�0\0 <\�\�ԥ-`��.���\�\�;!�\���#�����\0,�4\�\�\�\\���<q�y��d�(\��\�R�M�BS�\0\�\�k\�4�\����s?\�1\"\�0&���\�6��Uq4��\�<&\�\�xܕu� \��#/\�\�\�t�Z���O���\�p��=.؇\�\�\�C,�dRt��]�&\�2}�\�Z \��ߵ��\�&\�#\�6��@�Qr1\0Ø.+�\\�w��\�\�L\�	r@�&P����\�\"�\0lCm��U\n�ᥠ��\�\�2\�8\�Mf��E\0�w��r\�4�A�\�D~`3o5\�F&\�\�M\� �/<1�\�\'���ˋ$2	\�\�*\�7p5LT�!\�q^;�Q\�1\�y.$\�*Nĳm\rmOJ\rPŒ,>�NO\�\�\�ۛ�\�^�\�\�\��\�\�N(\�A�\�`Ϡ*08\�\�7|\�<�\�R\�;�1ivkPho�Ye�\�\02\0\0\0\0\0 !102Q3@APRa\"qBb#C��\�\0?\0s3hs�\�w�W�\�\�:4]ȏM�\�B-\Z�\�+�=YM\�e\�\�\r=��e�6�]D?%\�e�vP�{QB%4�^\�ʐ\�nߘ�\�g�\�I��Lx\�\�i\"\'g�p��5Q��\�\�\�\\\�P�Q\\7\�Qٗ�\�\�B5�\�y\"z�^kὖ\��({^ݙ�\0\�\\�b����sq�\�\�\�y(|�Cٱ\���\�,b�e���\0\�^\���\Z1�\�\�\�55m]\"D�pYe���\'Ċ�{>��4=b�#_�b�&���\�|\�̏N;,�2\�/��vV�S¿\���<#��	�Ǆ�\��\0\��\�\��&x%\�\�vx(���Gݞ\n>\��q�g���<}\�\�\�\�ɞ	{�vT>Ƚ\��\�\�׹\�׻#\�T]\�%�\�\�v;�\0&/�\��L�\����\0Ώ\�\�_\�\��\��_\�x7�\r�G��\�\�\�x?\�\�\�\�x9~G���\�\'\�xMOs\�\�\��<.�\��\�xm_b�)QEQEQE�QEQEQE��bQE��1F(��b�`��\�\"\�fFFFFL\�ə3&d̙������22fFfL\�͙�\�\�\�ޝ\�;\�33333333�33Ffh\�5\�\�v��Ģ�(��(��(�QL��(�`\�*���\�m[QEVպ)\r�%�\�\�\�\�J\��蹳\�\�\�v�wr�\�S\�1=��\�=�&�!m!��\�А�֋�)�0�s�Uɚڐ׸$5M�2,��+\�c붧TAR)(��(��QEQH�b�E�9�Q\�;4\��SR\Zq�3S�E�֚�\�\�ؓ�R;LVJK\�\"$H�	$QF&&&&&,�\�ڟB���#B7�#[��\�9%!i�0D\�I�=\�q\Zqm	�dY/9\��!\�^vHL[�#BU\�ԅ�5 ��ԜdД��i\�i\�jH\�P�\�t{&E�bb���\�\����h��I�\\\�	�d\".���j\�WD�v-$KMQ��\�\�jp���t\Zqm12,�\"\��\�Ki�\r?J���dY=:v�\�Od!\ZR�IZ\Z(hׁ�	�#�i*SB\"\�11yl{jtF��yh���\"p�k�		�LL�!+T=��\�\Z�t\�\Z\�Җ�\�(�ɦ\",�\"ȿ-�mO��\�[�!\Z��	r\�5ѓ���Ќ�!����~�IH\����U#�i�S_]�ȑdX�\�F��\n��%\�mN���yh���&N.\�B2�&i\�\��6�H\�\�MY	)踾���1	� .$(�V�d�\�\�iz��\�M��;T\�Eő����9S5U\�I\"d��5u\�?��E�:s�6�\�:mT���d.\"$�̖ڝ\r/B�7Qd:q�|�(��2�,�F���qjݚ\�Z�i�ԇb�̨AR�(Ǭ�\�Ԡ\�\\�i�FP�\Z�\�yu\�S��\�[?!\Z��v��.,�\"&iO�M\�Fq}:�MH�IԾ�M������\\Ke�щ\��\0{O��菔�����Lj�	��2�\�\� ������Cr�VbbbbQEy�\�G��\0/\�mN���;?#�#տ.\��\nGy$�,فE\ry��\�E���\�\�iz#�\�D\�D�N�T\'(\�u\�\\\�\�,��,��[6=�}&��;>4j}D)s\'�\�ёr�\�]xl\�$4\�\�\"�~rُmOK4~|�\�|�\�DH�SMjG�FM<eׅ2��\�.�\"�N[jz��\�\�I�\�D\�2\"54֢�dd\�\�]W\nd����\�鑕���\��3G\�\�|h\�uAr\�8\�^\�|ضLL\�\�SV�22�K�\nf��J\�QI\�\�#+/\�e����?#5]\�!\Z�\�w2	:�������\�D�\�]55k�8�b\"�\���C\�\�c\�\�\�ݢ�ҍȊ5)O脩qY(\�+��c\�~�h|8�|M\�d6ו��B\"%͑ᔾ�K�=\��=�\�gg�Q\��\�:�H��?\�#N4��>�\������KizYپ��\�!\Z�ti+��.Q\"-\�*䄸\�Ki�Yپ���F�i1E.�DȈH����\�=�ѝ�\�-��&i�W��sbBD�\\��\�=�\�\�gê\�T�F}D�J�	y\�崽,\�\�c\�\�w8�n�tؗ\�_.\�t[K�\�~�\0�k��|�\�p^\�d�f]6}\��\����u\�5\��]2�P΢_4�-�C����\�\�ƈt^[gQ/�}6}\�\���\�\�w4�\�\�\�m�|\�\�;/�_\�ς<\�ߑLCt6\�ľu�߳t���\�t���q����&%�Ϧ���������Dzy\r\�nLJ�}�߳�\�y��B\�n��b_`}7\�\�g�\�s�|wE\��\��\�\�g�\�n�\�*\\M�ؐ�\��=�?�{=�_D.�-\�vľU�ϣ߳z��\�\\\�\�\�ؗ\���\�1�d9���\�}��߳�\�1���C�ݺGQ.��߳�\�1���f\�\�ą��\��c۳�Ic\�=�:�}�\�{v�-�Ј\�ؗ��\��\��\0_\�\�|�\�GQ/�Ye��h�\�fD\�\�k,�\�,�\�,L�\�\�����+ٖX�e\�|L{iu{?�\\v-�,\�\�\�e��\�e�^\�Ye�X�^\�\�O�,�\�\�\�,�\�\�\�,\�Ȳ\�,�Y{_\�e�Ye���Y{��6~R�\�(Ģ�11111111111111112,ox�\r��tw�\��\�3#\",�\�\�+\�\�)����\�\�lqlqf�!112?-�;��\�F�ف��;�wGv`wgv``�얛#�\�8�4�e�U�����^\\2t�22.�4QE1�\�\���0�DĊ��p\�zY,�\���\�b�\n%QE|��g\�dD\�1�48�0(��f\�1\�\�Q܊S(�S1f,Ĕe�!	ݾ\�|W��Ye��e�6^\�\�W\�Q�EQEQEQEQEQF;Ϧ�ˊ\�,�\�,�\�,��\�,�\��o��/y�\�\�z\�\�Ͳ\�,�\�\�\�,�\�ϭ��\rV\�\�Gf�H��(��H�R1E#b�Q��1���}�c\�cc�\�\�\�>\��0��LQ�L�L\"`�Q�0F�#`�\"`�\�|X\��\��\��\0�vj[�\��\0�|��w\�o�#�	m�\0�~\�-��p�\�\��Kg뉒-#$d�E�$Z2E�ђ2E�$d���2FH\�#$d���2FH\�#$d���2FH\�#$Y�2FKvKn���\�\�ʷ\�\�\�\�\�Eq�Ke\��K��|���?\�1Ǚ����0f&&&,\���\�\����\�\���3`\��0f����3``\������^Ey��\�\�\�W\�,�\�,r�\�\�;\�w�ٝ\��gxf��\��;\�\�\��{3�^\�\�\�/fw�\�W�;\�\�\��\�;\��;\��;\�w�\�\�#�G{\�\�#�^\�\�ޯ\�ޯ\�\�#�Gzw��w��w�\�\�~�\�~�\��\�\�QEQEQE\"�(��(�QH��H�R(�bbQEbQH��E	QE�dYe��,�Z-##$Z2E�Ye�\�-Ye�_�Z-Y{Ye�Yh�Yh�;9�\�e2�L�S)�\�e2��)�\�eH�S9�\�g2�\�\�s9�\�\�#�R9�\�g3�\�\�s9�\�{s9�\��\�\�\'\�\�5\�Gfzڋ)��R)\rYfH\��e�2�~�^ůc�\�uL}��\�\'��<K�C\�/�G���<L��������#\�~��i:)��H�R)�E\"�H�Q.Fffgy�N\�\��������E$�\n�5~$��G)$%I/\"�+��\�\�>��\�-���KZY>QBI*H��qב\������ͧK/*��\�SMI\r4�읖Z���\�\�\�0��U%��#349\"\�%��5�\��\���^E�\�{Y|\Z�\�\�\��4��\�X\�X\�&6Yc~Kt���{��IyTVω��G	~�\�\�c{�2|\�/\�\�ͽ&�T\�(��a\�B�+��ke�h�Zo\�[2^Z\�}\r4ᯯݏ�=Q�^E\�e�\�Ki\�\\3�)gi��\�(\�5ώ\�ЖzW\�\�\�ݕ�\�\��\�\02\0\0\0\0 !1Q02@Aq\"3aPRB�#����\�\0?\0\�m6\�\\�I1{HkJ$2��\�\�6\��ޏTX�EV�|���a��l�[!�\�\�~\�����6n�{k��c�}�\\��l�kW\�lnΨ�^�{�B��1\�ur)-�\�^\��1/ow.U\�Ŭc):H\�\�z˹\'ך�(@��Ǣz-2�D�Æy_N\�LXa�t]I�\\���\Z\��>J\�KZ+J\�\�ȭC�dc���\'\�}�h��(h\�m\Z(���\�Dq\�^/�qQ\�G2�q׃�q\��?���\�G\�s�q\�\�8\�\�#�<�)%�d�\��нMu���_<\��\�Ge\�\�TqQ\�GU\�⣋\�ĉĉĉ�&��Y~ݗ\�z\�e\�|���YzYe�\�l�[73s6�J(\�R6�i�ڍ�\�j6�M�ڍ�ڍ�\�lF\�i�Q�M�\�l6�\�\r�\�i�\�m6��\�ͬ\�l6\�S$RzYb�-\�e�Ye�Ye�^�D`�\�x\�6�J汲\�/K\\�ȶڢs\��iZ/~\�\�l�AMٓ\�cº�~��i�\�\��+\�\�Վ(q(k\�\"ڶ�	�%�^\��6.j+\�DD�\�M�D�|\�ڊ��ݶaǖm(E�\�\�\�\��\�\���4\�kF�1�\�E\�L=\�7���\�,�Ye\�e�Ye�Ye�F\�1�ib�\�\�o�=w�\�n\�]�\\��E�\�pI<�߂\�QI#���=3�8?���ǭ�Ye�Ye��_r=�\��\'�H\��\�\��X�\�=�\�\�+\�ҳ$\�7�\�D���ȵ$�ѡ��y��{��?{i\\�g\�^�\�\�iu��3W	}�3YBq�}S0\�S�d�4K,P�ź)d��\��5x\���$1�\�_�0�����\�\�\�\�	�t}\�Dz�D՞��e��\�#lrJn?�zoU�v\'�%�VFmH�\�Y�8e�X�2R�c\Z$4?q\��?��{A!�ܩ�%��c=n��^<�\��\0\�G&)\�L�\�e��VH8��5�c�t��\Z\Z�:a�>O܊�\"z5�D\'�S\�N#\�$I�z}�/\�ĺE�F)Z�S=4�Sx3\�*\�����SZ1�����\�\�d�?m��\��}uk\�MIS\�N#C$H�XV\\mQ�]^):�a�H��!\���3Af\�(��\�n.\���1�|ҕk\"�\�DGL?3\'\�轖c\�\�\�\�;Dd��F�����\�0��\�K!=ь\�\�\��`�ƈ�-It��\�\�\�l�R.\�z2C�Y6\�RjU�\�GL?4d��m�TR\�i�h��\�(�CG�\�\�\�(\�\�Y%�N��\��T\�8ܝ�p4\��\�I6<�g�̤\�\Z2Lc\�d\�{d���\�b��\'\��qW$M�\�v��2RD\�2H�=~�\�,�\�/�\0��цd�Ũƿr�\�K\�=<!$\��V\�G�\0��\\\�R�َSuq=\'��e�r\�\�r�\�l�\�cFH転=�\��F_����ul}��i\�-ID�$z\�N�aq��c\�fPy0\��\0\�T�2xrc\�b��I+0z��?�\0Da*I!I!\�\�\���d\�{�\�Ƙ~h\��~\�:A�MWT\'d�IG\�X8y\����d\�\�*Y1�J�y1`ŉ%Y�\�Y~\�2h��>0�i�挿9{r\��\�i\�;�Q%^�G$n)\�\�\�(ƒ7��e��W�~Dݨ\�挿9{PW$I\�\�lN�d�d�G��v�RC�E}ZG�w�/�3$��b]\��;���&�\��\ZMn�nn�b�!���wB\�\���^\�\�X.��\����\�qMn�nZpb�.��^\�\�O���h\����R�O��]�F<��E5�.\�4[���RV�G\�tGL_4f�I{8\�ȓ����\�(5�D=Z1\�x\�wL�mn�nV�r\�\�i48�\�=>莘�h\����qt����Ѭ\�t��\�\�\"\�\�\�v�\0$�L��\"\\��lt�,�i�c\�\�\��\Z�h@��L4g�Y{5X֟�q\\]G�}�\0\'\�^�l%�$\�ٍt�C\�-\�\�I\�5{cV7�+H|���%�\�J䑑\�-?N\�\�\�,RM�\�}��i\�\�\�bU>X\���\�z֋[�.\�H������\n��\�&`\��e�R�fJ�\�\�E\���=Nie\�):\�ĭ�]�\�\�W\�o�ǭ�w�>H\���\\��A�\�\�0b�J�*m��?Tj)F\�n\�1������}�\�T5�\���#\��\0���\��\0n8\�\�\�&�\�ɑ�96\�@����}��/\���\���\�ȫ�FW�\�d{dc}_a�V�G��]�s\�|�\0��͉\\��\��}\�\��o�\�7�r��\�]�\0��]\�\�>�B\�ƪ|�V\�1F��\�|ե�:#\�Dz���!sIm\�\���߰\�\�!w\�w=Gu�抹$e\�#�\�\�\�o\�Q�#\�w�\�EɅ\\���?aj�\�o\�\�\�~4F�~4\\��A�b�H��߲����k��?\Z-X�\0l\�E�:E\r�bu�\�?l��W$d}y��I�\"�\�\�P��s�q�-p�\�~	w\�C��Q\'^�\�\\\��\\�~yP�JΑD��\�:\��@B\�]#\�Z�t�\��/�\�\�H+�2;�2GH��}��\����\\?v>\�W�GH�\��5�\�\'�CE�V\��oD���_ծ\�\�/�@B\�n�\\�3�F����w�<~u\��P\�\�\�\��JΑCw���.\��O\�\�Db\�ln�JΑC~\���\�~u\��Q�脫\Z\�+:E\r��\�~u��Έ�\�\n\'d_��_[G\�~u��ΐ_�[:!�m�nҊ\�%2�/�\0��c�\�J+J(����\ZҊ(������Ҋ\�\"���ֹQl�_\r\"\�~\��%��5H���\�-h���\�\�\�EP�(�\"�(�h��(��(��(��EiEQEQEQEQEX�}���6Y�\�n7�\��y�\�n7�\�\�z7#r7#y�\�$QHe	r�:s�f\�l63`\�P\�\�ZW%{���e�\�e���Ye�YbDD\�kE\rc�^$�,��\�#�\�#8�Ⳉ\�\�7\�$\��xf\��f\��7O��~\r\�<�x!)_T]�b��\�\�66?��~X��\�M��	����\��*>\n���\�\����2ȱ\�!\�r7\r\�M���\�d\�_2��\0��]��c\�F�qe��\�.H|��$A~\��֩s9%�2e���\��*\�\�\�dE\�b\�4�4�+8�<�|�N>O\'\'�����<��i�!�\�VO2�L�\�٢�(�J(H�+JҊ+Z\"��+�5iZQE\�e�Y��\�,\�Ye�Ye�^�Ye\�u%�zW\�|��QZQZP��QEiZ\�EsQ^\�Cȗɔ%��QEQZQBEP���i�\�QEm6�QE\�W&7V\�\��,�\�_�-�\�e�\�l�Yl�[72\�\�\����\�\�/&�y7Kɺ^M��n��t��\�\�\�?&��7\�ɾ^M��o��|��7\�\�#|��7�s7\�\�\�\�\�!\�\�̏m!�\�E��=�G����h�ս!�m1�\'�\���܏m1�g�\���܏m1|g�\���\��G���O��\0[�\��m1v�\��|;�\�/�~\r��\�QE2�L�S)�\�e2�L��L\�ͬ\�ͬ�me3k)�ͬ�S)�ͬ�S6��L�me2����v\�q>��Ye�\�l�n-�Ye�\�,�s72ٹ��l�\�be��l\�Ye�Ye�\�-��a܏m#ً\�\�QDz1*]\�\�\�T\�*TZ-y-y7#r�nF\�n7#r7#r7#r�nF\�nF\�nF\�q�\�nѸ\�n7#q�ލ\�܍\�\�r7\�\�\�y����Ye\�e�%�?y�1�z\'�e�\�\�v�M�\�l	\�jH\�(\�(\�(\��G�\0\�8/�����\0�p_�#��\0\��\0H\��G�\0\�8��p�#�������/(\�K\�yG^Q�~Q\�~Q���pe\�\�\�\�/\�\'\�\'\�\�\'\�\'\�\�\'\�\�\�/\�/\�/\�\�g�\��/K/[,�\�,�\�/K\�\�/K,�\�\��l�\�ҍ�\�k(�i�\�ͬ\�mf\�mf\�mf\�mfҍ�\�l6��)�S(\�\�e2�F\�me	�S)����h܍ȴnF\�nF\�nF\�nF\�nF\�nF\�nF\�nF\�nE�r7\"ѹ�E�\�h܋E�E�mrZ-�饣�\\_\��./�\0�g�(=��:i\�\����&\��\0f\�l��l��mF\�mB��\�^�\�\��!\�\�C\�/�81�p�p�\�G\n#\�/��/E����\�X׃�\�5��C�Ǭ���\�Dȿq�+Y굓�>����\'ʛF<ݓ4m(\�\�ޣb�ݍ�lo[�1K\�\��\0j7\nD��L�\�hő��\�&��3fP��9[mꑷ��\�ͬH^\�\�\\��\�n\�2ִ�\�a�:l�I��eiBE$Q\\��wEm�\�˿2�OE\�a�\�	�\�\"�Z׳�2.�\�\�?b�,LL\\�\'�j�2/Dȋ�r�yu�_�E*)��ڍ�\�P��\�!.D�z�DK\"G\�C0�\�?e�\'��Y�m\���h]��\�E\�X\�\'�\�\0F\0\0\0!1 AQ\"02@Ra3BPqr4b����#`�s�CS�Ѣ\�D$�����\�\0\0?W+�\�B>\0j>�@\�fS�M\�P�Qؒ�^pg\�\�\�\�ok�S�\�)\�U��B�ħ\��9�>I�@v\'��\Z\�\'�\�I�mG=dF*gtoB�\noʩ[�U٠\�>\'!�\�\�og\�瀟Q\��d�\��c��q\��nZΦ�m\�3\�UJ��P\�f�~5{5�\�\�\�\nofuJ�Zpo\�\�\�\�#Q\�\Z�J�\�|t&\�=�NO�\�Qs\�g�$\Z�\��w%;\�����k��\�n%5�\�\� ;�3�{��=�\�Js�̪�\�\�\r\�2�\�\���P\�w\��.M\�S�\�*��\�R�\�k?��L�	�#�b|QCrTꥒ;����3>h7�j��\�\�,o�-q�\�\r�R��a�Pl(\�<DkP\�wI�s�\�\�>>i�]��V��xYS�>�()\�\'\�J�\\T\���Q|�U�G4\"��.|�S��C\\\�X�V+��\�A\��Py(<�J\�C�(<�J\�C�(w%��\�A\�ܔK�aMA�aA�=\�Py(<����X�Bu�\��X�D\��X�DJ\�\�6G�%�k*{	R�\\\�N��\�j�Z�V�U�\�j�Z�V�U��\�j�Z�V�P�P�P�B�\n(P�B�\n(P�B�\n(P�B�\n(P�B�\n(P�B�Z�V�J\�\�Z�Z�X9+%`VKfճf\�-�[0�al\�م�f\�-�[ �)\nB��)\nB��\n櫂�+��+��j�+��\n櫚�\n�\n�j���\n�\n�\n�j�+¼+¼+¼+¼+¼+¼+¼+¼+¸+��+��+¸+گ\n\�\n\�\n\�\n\�\n\�\nB��)\nB��)\nB�`�Շk\n�APTAPTAPU�ZT(P�Z�V�T(V�P�B�\n(P�B�\n�(P�B�\n(P�B�\n(P�B�\n(P�P�V�iPTAPT�\�b�X�V+�\�b��*J�����������M�Z�V+�\�j�\n(P�B�P�B��\�ƨQ�\Z\�Tk�\n<(P�B�P�B�\nj�\Z\�B�\�*n߄B��N��(On	���`B�\n(V�V�T(P�B�\n(P�B�\n(P�B�\n(P�B�\n59\�\��EުG5�pM�\n�*{xP�B�\n<�\\���\ZƳ�SޟQ\Z��\�\0\�����s��W)R�J���\��=ޯ������\�P�I\�\�o4j0�[F�[Fy�\�\rg\����P�{��f�\���ҭ��`d�5�\0[\n~U��\�cO\�ɞP�\0\�*G�5���\�\'*�E4\"�w�?�\�4?n�\0�v{�i9��5�r�J�*\�r�J�*T�SኪU�r�mu�z��Q��Bn�I�\'\�i4�u%1\�>��w})ۅi\r���҆�U���\n\��V7����J%���(\n�\�@\�rV�JЭj�+B�+B�Z�Z�\�hV�}U�\�g��Z�V�}U��\�iN�\�\�W�s\�r��Qػ�-�<�稭*�\�T](P�B�APTAPV+�\�b�X�{YS��}\��)ۅT\�O/�T\���\�ܑ�\�\0�G:�h5\�\�\�2�:]\��{�\���h�?T\r앤S\�Ք>\r�}\��)ۅU\�O-�����m$\�5N\'�с:�g\�T\�f	T\�\�7��i\r�q�\���\�s�s�������OV�K\�0�����Z����K`p�Lt:>\r�}\��N\�9*��\�7-h\��m K5{Z_%U����`��վ�q�2�\�9x7�\�T~\�\�l.w3�,m\�Z�{��\�h�I�V���O�\Zq\�\�	���\�J���\�>��\'nW�<��\�\\�T��K�a���gTr:�J��\�~P��vS\�Ttq�)�W\�B��\��\0ڥ�1��\�P\0\rZU;\�z�A��t_�\�;p��\�d<\\��*{Z̑�\\E�Tm�NŲ�V�~�Tqj�\�\�\�Y�\'Uvl�J~	�}\��O\�*�x*]\�\�\�\�Oan�{R�\�^���\�iLL\��\�X稄\�r\Z��wӞ!Pw�h�\0z$�\�\�\�wF徥@���+��@��![���\�8�v\�*�\�`ETA:\�7eY���?\�[�Nݭ\�\n�tx�\� ��`\��\�N�{Z��y�\�\�x-�\�QNE\r\�&�\�J��C\�L�\'\�\�\�K�<S̽\r@��{J\�=�f�\��T��Lu\���\�\�Ui�Q1\�	���䟻_0�wG�8\�]�\n <\'����\�*6\npU\�\�7%PtuQN��5\�T\�eܕ\�c\�T~�M?v�aQ\���\�\Z��\�Q\�9�=�\�\�ۂ\"\�&�)����F\�rVX�\'\�߀\��\�4��k\��G��q����)�<\'4��ΣU\�b!i��!Pt:�Vk\�\�\�\�\�\'Z\�<]m:�<;\�\�}�]ǫOr�\�)\'\�\�\�Q\�qz\�4<\'R�\�\�f\�q�S���0�*��d�ơ�$�̱\�*N�Wk]\�3�r~�F�	h�̧��\�\�S�\�$�\�#5G�<C�4�g؂�\����\n���� ]�ʧ\�hχ\�9���5\�\���\�a:�:#�aT�\0Pu{�\�kr��;�����t�G�<Es\�T\�d\n{C\�\"*{�<�F\�Y\rt�\�\\�QN@��.ij�\�P3��Z{e���^�\�\�q�ڗ\�?v��\�\"��Bn]�)\�DB\�\�	ʨ\�0�Z;\��\�pV\�\�_�c�\�n�<f\�\�\�W�D;�\�}�/�~wG�\���)\�\"!�`\�!H\n��\�S]-�D\�]^j��M�\�\�Bc�n<ZS-�U,Z\�\�kK査�*\�\�\�iT�\�Oe؍@�{\n\�\�9��;N`�\'0�?Ti\��^�=돢}w�\�zj	\�,ʡ8\�\�\�l��\r��x<niK\�O\�\�\���\�\0*c\�Q�b5�\�{n	�Wb�4��.\�.�t��\�cDby*�MZ���\�\�d;�4 xV櫋蹨�?-aԥ�\'\�\�\n�pxz��7/\0ҪS�B�߮\�e8*̷#*w\n\r@a�@s\�N�Txa�Ze;+�\�XF�V��2����᭪7t����\��/�M)�\��o��\�9�R��-ϐA�J�\�9ɔ�P\n<E2�՘!�\��ƗT$pH�LUa\r\�\�G\�\rP\�1\�\�\�R�\�;\Z\�⺳�R$��U\�\0AA��8\�:<\\�P\n<<�$_L\�Eί\�-+�ߞ~\��\�\�A0a\�\Z\�Q��\�$#!ʠil�IP�I\�&\�\�V�P�G�:\�ѳ��K\�7绤d�n\��\���+\\�3�\�*\�\�UW1\�\���s\�\nj\�j�\n<pZ7y�\0 ���wt���\�䛋�;\\�3�\�;��o%`V�T(P�ǅ�����/0�CsH\�h\��\�j�b�;\�qU9�1�\�*�\�>�=�W6q-ZV.p�FKF\�\\\�f]���8\�\���*�#P\�5Z\�\��M\'sN!3D\�z�s\�\�{�»�\�S�M\�V��`��\� UFF�\�-0�Z2u\�~[��Z/pxG`ҙ�\�[��q\�5ԧn#$\�Of\nS\�\Z�\�/\�q�-\�#%��<%c\�T\�b\�i\�ܩN\�#$\�Of\nUFF�~\�\�_�\��\�\�2Z/s�7랴&e\�\�OPީL�\�\�5\�ق�!=��~\�\�Cٷ\�_%�w<!\�\�v5�\0j٪�\���]=�+�ڥ�gwJɟ-\��-�\�\�a�Sϱfj��j���\Zg\�5\�ق�	\�-(�Ot�{|�k\�Np�Hv,��hv$\�i�D\�Og+I\�\�S6�n\�^׉\n\�g�~J��g\�v�uh�\�X\�\�3-��PvOB�N㰧���\�\nsM3\�\�\�\�Q���k�F)\�ia\�\�@�~{�S��[���D\��<߹Z�&{�\��\�ly�֌:��wPU\�CP\�\�C�\�e5\�\�=�\�\nn�E���	��\�DB�#\�*����ݯ\�Z	�~~\n��Lc��M�\';��� 25�%m.��hΑ�<�0b��\\��\�ҩ�{	ܫm��\��\����J\�U�\��n\�\��- \��0פ��/\n�v�=�\��Ù���y�5�\�MMC��V\�U6o\�g�$\�8¦�\�\�t�\�L(�N��ٕR�$�\�\\�z#\�\�4Ї�x-\�\��n\�\�/[�e��\�c�\�\'զ�t;\�S�q�E�k�b��7��P3\�\�L���8AO5C\�H���:T�\�\�\�x��{\�B{�\�\�q�\�Gϒ�N8���\�\�vf\�n\�\��>7\�iu�ML�����\�U\nn�\�\Z�kH=x\�5Υ@�\�\�L�\�\�жZ\��z�\�.��\0�X�9�*�1��j\��7ݛ�[��>>��Hni\ZSEG0\�#�sł8�5S�q>�!\�T�=SZ\\d\���\�6\�h?[\�ϒ�R\��_\�S��r@ >�}ٻ�{�C\�\�t��T�\Z\�`��6�~�LkڴZ.\r2SDj�i8\��J��\�5�\�N�w׽��ˣ\�׵\�\rO��1ͦ\�uUs�\�T�q��K}�݀��T\�:\�\\��6��a�\�\�\����f�nZ����)��\�S:by��UL@\�_4jocR�`�Miq�\�U�{a3G\"\�\�ˏ\�gUߑN�1Uj\\s���>a\�\�t����~�}\��;�rZn�$\�_�K}�]��]\�\r�9b�eB%��e\Zۚ���\�;\n��kK���ܫm����~Es�\�h�8�uS��\�\n�6��\�\�\�\�hy��U0©\rzs*9���F��እ֪*#]>h\�IA\r�\���.2w��^��N[%�\�\��{mwU\�9&F�-%=\�_\�\�\r��\'��N19�>���ڙ-�\����0\�}&?�\�Lѩ�`f�cY\�\�:��J��\�4��F\�\�\�i\�Ϋ�\�u` \�\�p%��+$���)\�\�\��?��=\�\�S��\��\�\��wԎ\�L��\�w��f�n]�l�5\r\�0z���˻\"\�F*M3��:���\�g�\�P\��\�ӌOy�>���H\�T\�h��v\�$\�_شb������q�\�\�\�s\�7>i�C��oxj}Bg���\0fc�S�\�\�\�\��]\�T��ܩ�\�}��z\���Ɵ��n=\�\0^n;�Mj�\�\�\�ǒ��\�t�>�G�Z\�N$��d!\�x\'�\�?�Y\�\�P�\�\�T�A�\�\��t\�_�ʙ-ڻ�\�ASv9S\�7���/2To�*�\�%cH��#P7�\'Կ\�\�rPI�\�y�FY���>.\��\�*�4w�ѽ��z�j&\�\�\�=P5\rox`@�(n\�X\�\�@\�y�\'�\0\�c?��@��MT\��@vg\��v�\�\�\�ol{c�)���`\�V=mCS\�\�Jz�M�M�e�X\�b9�\�5�p�xz�Ժg/\�bO\��Vl\��\n�y٠;Q� �\��\��Z?�=�cTGb̉N\�\�\�J~�a\�8�\��Q�\�\"\\\\���\n�I\�\���X\�\�\�sP(\�\�3s�M���\0��\0\�Gq\�*\��\�A\�La؜)\�	\�\r�%\�<Xno\�\�&g\�y,\�\�#��\�8�y�t\�\�\�\����z�\����\��g��&\�\�՘\Z��\0^d�7�\�~ѭ����Y\�%�\�҉����R�я\�匜1\�\�!�����L\�\�\��@k���w~�\�;=\�d��}\�ظ\�J���.�a\Zn[,q@oi-.d8\�9�S7ikpi\�P�\Z�\�$\�\n���r\�\�r\�\�\�\�\0�|��37;?\��Ƕ?\�=���\������\�\�\�0\�DvS\�l�}����ӜFmz�F#0�P�1\�\�w�\\�����q>\�L\�\�\��@n�\�|@�\��S�\�9*x\�=��z�*cҙ\�\�\�\����᠔��s�]�\�p���2	ς�\�nvh\r�\�q��\�\��\'\�rL�\�\Z\�b\�B�^�\�-<8��\�m\�wE�١��\�7S\�K�q�O?E�ᇼ9.\��d�)���e0<1��������\�\�3\�\rg�y���\�\��\�\�:/\0��\\d\�Y\�w\�S�S\�K�\�\�<�\��y,\�9��T\�nvi����������\�rM��C-g�\�QQ�\�uֶ\�p�=\�F8��泑q���Y\�\���2M\�\�5��\��B�\��J�\�;���CY\�4�.�La\�V�ڬ-l�H�\�ڭm�`��nz�͵\�3	\�	v}n��XqU\�s�wUN�&\�f�\�\��\�\�\�_zoȪ�\��������2\�H��Q{mQ\��oa`c\�\�>�B �P5�S\�n\�w�x�:�G��\�9�<\�:d���c{a\�q��ޙ�*�x\�p_�چZ\��\�4�X�f��\�\�9\'9\�f\'\�<\n���G�@����8�S$\�\�\�[\�O�\�~�O�U{\�s�w�jnZ\���z���ҭJ�KZ\�0\�\�S�|\�fJ%>�h���]��\�<Y��W��g\�q\�p�T\�\\nvi��#�;E�\�%[�w]횛���\\\�\�SvzH&�S�#�q\�\n}\�]��Q��/�\�P�V�\�p�=\�F=ou\�`�:�G�{1q\�s\�L�s�Mo�\��\�\�4�n�\��jnZ\��\0z�C�\�S�0O4�g�\��\�\�`\�\�\'��z\�\�\�}p\��U>��w8�l$\�\�\�[\�\�\�4�\�����Sڵ7-gz��HcغaQҋ��S�\�2�9@Χ<4J�z\�=ot�>�8u}\��P��\�\�y�t\�7;4\��Q\�q�>�G\��\�\�_j\�ܵ�\� \��0\�+9ͤ�\���[[dڴ��\�\��J�0pZ-2\�\rk�	�*�s\rٷ�\�\�]�>\�E38a\�7��x�\�\�\�$\�\�\�[�C\�i}\�ԫ��k{F�\�;�Yެe\�\�\�5Zo/\�\�\�rTtW��\�q�8*r\�c�\0#\�>�\�sNy�<}\�p>�8a\�7��$\��\�d���k|@�U?mG\�U�۵�\���wF��:\�C��e�\�?,Ӝdc��\�7�\\_y����$˸D\�d���k|O�3\�\���~�\�~�~i�Ѭ\�\�0¨�w\��VN�z�OIs�l\�\�p�ΣXZp8f�\���\���Y\�Wy��B1HI\�\�\n�L�s�[\�\�i}Ai\�\���\�\Z\�\�r\n�\�~�\�\�F	\�j��l�恐N�\Z9�\'T7q�]\�Ш�\�\�\�7��G�pN/\�})N.L���\�\���\�3\�\�;�S\�gv���n]���Iow\�o/T\�nl}\���+�Wy��B��\�]��*t\�7;4\Z��\�\�\�3\�H\�n\��O�5�\�`\�_�HI��W��C\�!P;�@\�$ʫV�\�=\�\��_�\n���\�\�^�{>2\�j�2M\�4�\�\�|#�~���\�\�3\n�pk;�\�1Q��6�z\�}j11[�\�5���x)U�\�H\"\�a8�z\�C��\�W\�g��\0N8�dU:x\�\�\�q�~}ߘU�|�t�K�5�\� \��:���0�Nq8dQ�\�=^�\�\"\�\����\0I�3��\��\�\�S�\�;4���\�\�dߖw��\�uDܵ6�]\�*\�u*\�<y���:\����\0\0L�~������T�\�f�\��\�\�|\�>j�u�-���G�5�o0ҩb\�[Q�!\�\��U)\�厃=muZd\���\��_�\n�a�S?\�N����s\�R\�sA�=��.\�T\�3廤�>\�k:�CU��0���\�6�CKq3�9��L\�\�\�\��l�ǘN|�\���\ng��3��\\)�\��T\�\�\'4\��C���3����g\�wIT=�u�zA�\�f\rܬ\�\�D]\�\'\�?C�\0�Maq=_��\�\'LD\��q�*T��4\���l|C������\�IT=�u�u*\n\�Hi�B�G:Ƿ!�4\�5:���q�_�[\��(\�a�S\�U�1<���\Z~�\�5���e���S��?�\�ZNJ��n���\�9Q\�\�+4��\�8��8��!>�L	���-\�}�\0�OW\�g�	\��\�\�\�S�\�\�#\�C?���S��?�\�ZNKG�M\�ui��5<\�\�Y�\0&�\0\�e\��_�\nkn$[����\�5�\�\�9O��K�\���WwJ>\�wI\�h\�ɺΪ\�^�C@�V��\�c�s�:\�C�\0�Mi$�~���\��kq�\��T�q9�\�c��\�l<3�����[�NKF�M\�QY�Usm\".\��w��?�\�-�\��B{��\Z1\�<U*\\Nh�q�#���S�n\�-\�7YU�S*��\�\�\�u���\0��ˉ�M�\0!=\�\�g׊�K�\��;a\�\�n<)\�ߺ\��n\�-\�7sM�\r��\���\0\�4���\�\��\��5���T�q9�>?\�\�L��?�\�}�\�\�\�\�\�<�Sa2#\�g�	\�\r�3\�\�R�\�\�\�Gl<��(x	R�Q=R��J_-\�#%��!��4�\�\��\�?ʨ�\�\Z\��N���\�\�q\�l<t�R�NR��\0\�i�r�\\�U\�Gw�½\\���	\�E�\�Sg��:籝@\�ʕ*uJ�R�N\�R�J�(�*T\�*T\�§��Z�V�\�3Lk���e�(>e�(>eZc5D�\�~\�\���2{	��e��A�e\�\'%`;����\�\�I͋��ӛe�����N~� \�\�9�Òh\�\�(7�J���)\�\"�r9�\�r#�Vg��7�\��\�O\�$7t�i��\�E�w[ ?tYc�\n\�s�\�I���;�\�?���>\�*g\�J\".\� N<@Pg?~ێd�\�6m\�f	Q\�\�J8�Mc�.T!8c\�Bm\�g�X\�x�e\�ݔ\�bp�\�\�0�\�\�zK�ǉB\�:\�J\�y\�vW_�\�~\�ߏ\\\��\�=\�]|:\�\�\�<P.ìr\���eMLz\�%5q\�\���\�_\�>�\0SW\�f��~\n\�~��\�9+\�c\�W\��+���º����H\������~|%m��ඵ��V�)�j��5�<�\��V\��V\��J\�)[oB�ޅm�\n\����+o\�V\�\�ޅm�\�Ȧ�\�\�\�Q�c[�Le��y��]n�}{\'\�[�\�\n�!�3\�\Z38\�el�}\�Ll�O(R�q\�ul=��%l�}\�Od1\��\�4�q\��:\�\�S[qwֶc��mu1�B�\���\�\�}@F�3\�S[%ޏ��|\�[�>kd?hO�\Z\�\�d��� g\�)�.�z\�\�O�����\�\�ª��\�d\�-��\0\�*�g�y[!�9O\�\���\�\�FC\\y\�\�|elG>2�2@<�[,�\�\n޵��\ZY\�\�=��7����l�ǌ�l��[�\�g׷�#G<S\�y���\0i[<�\�)��\�l��Vu��\�8\��>�hq\'�\�\�l\��\0)Ml�\0��ٻ\�XC��[\'�N�@?%�q�XF���\�i3d)����\��V;�- \�Z\�\'\�\Zn\�ZM\�\�l\���\�#\�n�l\�\�G\�n\�2F\�Ȧ�\�\�\�Q\�\ro!�$�e���P&uT-\r%\�&�\0\�\0\rE\��\���Glt�cr��֒P2�\�\�`O9ݥQ���\�~\r8Ja��\�n\Z�\�\�\� D�%R{NM�P&u9͸4�ځ\�-@���9q\�\�4\�D��@�{\0+5h�\�P�\0\�(Tm\�\�\r\r\�\�53\�&��ȧ48BUԚ	�	C[�:�\�a\\�\r�Ply\�pl�(=��8\"$&�j\�\�p\�9&�\�7v��\�\Z\��\n�fw$� �c��H��\�kH$��R�jSD\07\�\�\�\�p\�!S�gǶ\�\�\�\���N\�\�R�d�\�9�G�e2ӟ\�r\�\\y�Z��ʖ��#�\�\�t|կ5��\�e�bU6\�a��N9	�\Z\']F\�\�X���[�@a0fO\�\�6�T�R��i&\�\�T���d�rR�\�H\�rV�4u�j\�P\�2�y�\�`|w\�?κ�u\��w�c\�c\�]o2\�y�[̺\�e��\�\�\��h\�5\��\��\��\���5�5\�T;\�\�k�\�9A�\�uA�c�\�9X\���P|\�A�\�T1P|\�c\�c̬y�y�y�|\�2ǚǚǚ�\�c\�]o2\�y�_̺�e\��.��S̿�\���\���0��6�\�s���jz)�覧\�SS\�MNAMNA]S�WT\�\�<�]S\�?UuO\'\��\�\���\�\��?u{�����O\�^�\0\"��E{���y\��+\�\�W�ʯw�^\�\"��V\���%m	F\�k�\�uy�9�9�\�Z0WJ\�rW;��ܓ\�Ls\�$\�!\\|�\�\�Wz+�%q\�<�ǒ�ܕ\�䯫�\0l~���O\�5\�\�\"\�J\�rW?\�\\�\0Es���������~���V��\��\n\�z+�/�ɿ��������������\�z+�\�w��ފ\�+��r�\�\�w%s�+�\�IRT�)�Wa\�R\�*�y\��+�\�W;Ȯw��������ϑ\��\0�\�\�r��;�W�~��\0\�\�\�m�ߢ\�N�\�r?�\�7��Ѿ��\�7\�m��[Fs[Fs[Fs[Fs[Fs[J|\�ќ\�\�毧\�^\�j�sW����\�\�\�g5sy�\��0D�A\���QR=]\�5`�(\n�@P\n��(\n��(\n��(\n��P\n�`�X(��`�P\n�\n(P�B�\n(P�B�Q�\n\n�\n(P�V�}�\�Eo��\�[\��VJ�\�+�+�\�T��1\�\�\nT�R�#\�R�J�*T�R�J�*T\�*T�R�J�*T����0\�P\�P\�\�:Ю*�+ʼ�\�SjBڕ�+l��m�\�hVЭ���\�hV\�^\�!\n�\�^\�j�RU\�F�P�O{�\�W�^\�yW�^\�+jV\�^�W+��R�x|27F�JV\�*Ѭ7X\Z\�5\�\�B�D�\�ҥOf>�*­*v�\��5���5��ߔJs��U\���M�*{�݈[�`�	ԡX�V+�\�b�X�V��\�b�Z�V+U�\�j�X�V+U�\�jr����BwFhnƱ�*������ҩ~%ҩrr\��\0\�3\�\Z\�\�L�\�\�R�t\�^W.�K\�\�өy\\�u/#�N�\�r\����]:��˧R�t\�^G.�K\�\�өy\\�u?#�N�\�rv�ӓJ5\\x(\'4\Z�w��\�\�;\'�iGWVʩD�0�V+�\�`V�j�+�Z�Z�F�\�\�\r@ |Z�eW�u�A\��ZW\rD�\�a<���\�]��c�-@\�6\�B)��;\�P\�Tm�E0K\�\�n�!B�(��Nʯp\�\�	�മ\Z��쟩����\�O\�\�\�3U��\0�r�\�\�|�\�~�\0䊥ܩ�\�f�:�Z�T(Q�R�vU{�_L\��p\�\�\�d�L\�*��U?f�C5[���\�\�j�\��\0\�K�S\�\�f�=\�~H\n>1S��\�;����ZW\rNL�O\�\��\�ES�u5\�n�\0䜩{:��j��ER�u5T\�\r\�w\�|n�eS�Q\�*\�M\�8-%�\�D.�1�qP�5B8�Y\�=\\5\�5_\�a+F\�\�\�?>J>9S�~�9.��\0Eџ\�.�\�Eѝ\�3��ѫy�F�\��\��\�ky\�赼\�tZ�p�-o8]��.�W\�D�\��U�\�*y\�D�\�]��t7�\�\�\�=���Th��\�4\�\"Ьg�~�\��Gƶ\�t�\�\�\r[f��(P��O-V�Kf\�)VJ����V�EZGj��V;�V�J\n�i\�U��V�J����V�J+O%:��\�\Zqs\�&\�\��W����\�\�\�o0�\n�\�㚸+��+�5p\�\nT�\nT�R�J�*T�\�:\�J�>T��j�h�C�.\�%[�P����\�D\"\n7+$\�Qh9�D\�\���cwAV7sf\�[�c]�V5B�f\�J���\�-�G\rfU��\�\�D\�Vͼ�(\�`�A�(\�l\�fT\nl�G��\n���\�\n+��\��68\�\�\�tO5;�(\���\0��L�P�?E���BcKc\�\�f\�Zy�\�\�Q�J-<ժ\n\r<\�+J�i\�V�}T+\�V�j\�i\�]\�Z�<եZ\�j\�Zy�U��j�sP�]\�A栠\�\�A\�t��j#�+jy��<˯lJ�sPT?���v�P�����j7���\�u��W_\�b�\�n\�+.X�|�V(\��,V(�j\�u�%�7rX�y,y)<��ʺܗ�(&w¯�T{��2Z/f�L/\�p��\�\�SjSwu\�\�m�\�oꃚ\� \�\�!\Z����<���B�2`<N�i\�\�q\�ks )�9\�eH\�.l\��3�!\�\�{�WȪ\�nT\�h�u\�4\��\�y�\�\n�ZLe�l\�ʣ8�\�<N��}��d\����GV=5\��\�\��yr\�{^z�\�*�\�\�\�\��\0Z\�4��Ե�_{�\�ǹʹ|\�C�Ga�\rd\�\�����\�	פ4� &2�M<8c�Z\�g<+��\�[��2�AK��\����l7w�-\�,\�H9\�t�tR\�r�{�T˯ \�[�ItT��q\�\�h\�q�J�\�\�\�HS�D�u�⸦����Z>N\�L���\�k��x!9\��\nS\�$;�)	�\�ϙHE\�vT�i\�#��\�1\�t�R\�v�\��j���\n��&:fy�\n\��)\�W\�p*B���[�\�sW�\0R\'T�j�\�a\�)\nB�\�n*U�\0\�#�)Ot[ԢpT\�sA:��\�\Z�\�c�\�\�\0�:Z��\\�\�S�C�9\�y����Sqw�\�]\�h\��p\�\�]?=E�p\�Ot4�51�N��ᱩ\�N�n�e�����\�FZ��\0�\�qC0�d�d\�ʙ-�u\�vn�\0p!��\0p�{��C&�p�\0ğ\�}\rG\���{\��PͿYM�?\�M�\0l�t�\0���\0S\�\�s\����\�\�\�=ϥˇ�4rw\���\0�Q\��\0��m�\�o��\0$2\�\��a?���Q\�\�\�3\�&�\0\���7\���\�Nʧ\�\�\�\���q�\0ȇ��97\��9p�\0Ɲ����\��ڸ�\0\�C\���\�\�\�d>�r?@N��\0\�g���m�\0q7\��\0�\�>��G��\�\��\���О�\�\�\�����}!:z\�P\\\�8c\�	\������\��\"O[J]9�\�H�W\�<М\�W:3�S���\0�v8�R\�g��H���\�c��9Ϻ�ݎ<\'x�s��\�\�a�	�5s��R\�O�.~8�I\��W��с�ќ�:ȌuT��{F���Z�@Oh��{RhVi��4)yV�tz^U��\�[\n^U��\�[\n|�%��\�l)�[\n|�%��\�l)�[\n|�%��\�l)�[\n|�\�S[\nkaO\�l)��?U\�\�\�;=V��`\�\�鮏Mtv-�����tv.�\�\�غ;Gb\�1l�;Gb\�\�]���tv.�\�\�ں;WGj\�\�]��5tf��9��9��9��9��9��\�?�\���a\�?�\������]\�l=V\�\�l=WG�]ׂ\������\��a\�:\���a\�`V��\�Ss(w�\�W�v�M\�*5\�E�\��Z7�(l7Ss(w����\�\�T\�n?%��b��\�q�\�\�\�\������%W�w��\�\�\r\�\�C4N:�Ӿ��\0�U\�\�\�{d?�\Zs�\����\�W�wޟ���\���n����\�(w�#�\�����}*�x\�?%Gۡ��\0j�	M\�J��G�/��\0���V\�\�\�{t5�\�V\�J\�\�\'f�/��\0�\�V\�\�d��t5�\�V\�y{\�١�\�>��\0[�w��\�\�u�\�V���{\�\�2Z\�?\�w�\�T��o�\�s�;��y;�KA�\��U~�\�vI�\�7�a��C��i\�2Z\��U���\�3\�k?ڣY\\��\�|�~�\�\�7ۄ2\���O�S�-#��\�~��\�\�~�Mi\�Òx#���}\�\�;ۇ$>�5����\�\�;ۇ%1\\+\�ڳ\�֟�-�<�\\\�j\��W7���\�\�\�o5{y�\�\�^\�j��W����\�\�\�o5{y�\�\�^\�j��W����\�\�\�o5{y�\�\�^\�j��W����\�\�\�o5{y�\�\�^\�j��W����\�\�\�o5{y�\�5{y�\�\�^\�j��W����\�\�\�o5{y�\�\�^\�j�\�^\�j��W����\�\�\�\�\�\�o5sy��5p\�\�Ú��\�\�\�\�Ú�sWj\�\�\\9��5p\�Ԏj\�\�\\9�Ԏj\�\�\\9��=\�z����\�\�?\�*�\�\��\��VH�B��Q�\�?��\�\��\n3V�\0*\�\�[��\�[�+sV�\0*ܕ�\�\�[�\����V\���\�-\�[��rV\��V\��U�ʷ%o��V\��U�ʅ·5\n?�\n?��*3Q��P��P�B�\��v��~�G洌�J��{~j�x|���~Jՙr�F!Z�0*\�j�V�\�=��B�4`�Q�V�2��Ta�+p����j\�����Z�M+Tc�\�G�V�d~J\��Tb�\������\�\�U�1�Ej#�V�@a�+Tf�Q���V�?�j�aZ��U�+Tf�Q���V���\���/�\�3\�+L\�\�U�-n0L�\�\�F\�]<#q\����\�{�F(n\\ۣ�\�H<7Z\"wC�8nܐp9n\\\�L\�h��\�sE3����\�\�y gY )l\�D��\�-Q�\�\�;\������n�w��U�o\�[��\�#r1�ֶ\�;�l�\�\r3�D� nl�Ӻ\rǲ\�\�k!ӸD��7-\�p�A����q�\�5�!l�\�N\�l\�cm\Z\�!l�ӹB�\�NF�=�/�i9\�����\���\�e\�-��y*T�m��~ڒ�AK�)w%.\�ܕAQű�Ҵ\�Ĵ���~\�4���N�ɋ�i\'\�b�+{�t��lp䶯�-��\�h�\02\�T�-�_0[Z�`��y���\�mS�[Z�\�\�\�\�֧0�\�9��NkmS�[j�\�\�T\�\��\�ڧ0�\�\�ڧ5�0�\�\�\��\�\�?�\�?�\�?�[g�[g�[g�l�kl�kl�kl��5�5�5�z\�=m�\�-�\�\�\�l�kl���\�?\�m\�\�\��[g�-��\���n�\0E�rۻ\�m�\�\�[gz-��\�ދn\�w�۹mܶ\�[w-��\�ދn\�w�۹m\�ە�w�۹m\�\�\�[w-��ح��ح��\�\�l\�r\�9m�\�U\�DF�\�\�vT�R�J�R�J�*T�S�uJ�*wg��:�Om>{q��q\�F3��\�\�\�Ѯ�p��\0D���\�rC�\�\�\�\�q��1�\\n�\�c\�\�s�#�\�v\�\r־\\F\�\�\\7/<�25�w.\�4\�\�L+�Ѹ_�dkq�q��㖉\'s�u\�ܚd�kuN;��S�	\�:\�n8\�8n\�;�8��kOb@+-\�\�a�Ŀ�V��\0S[�\�5K��\��)RP*\��)\�\\T�\0*\�?¸�⁏\�\\T��W\"U\��W���\�\\�%r.�\\�@\�\�R�D��\�9\\�5w�\"�E\�\�\��WqW���r�\\�S��]��8ʹ\\��\�U\�qW�\\�W!\�_\�+B�\0��� B\r�V�j�Z�V+�\�j�Z�?��ZU�ҭV�iV�iV�U�Z�*\�iV�iPT\nZTiV�\�ZU�A�\�iV�APTAPuiPT\n�APT(V�iV�iV�<K��h�\�s\�-���\�`\�r\�9l�[-��\�\�\�qCB�\�\�\�]�5\�\�s]��tz�e\�\�y�G�\�]��tz�e\�\�y�G�\�tz�\�G�\�tz�\�G�\�]�5\�\�y�G�\�tz�\�G�\�]��tz�\�G�\�tz�\�G�\�l*s]�5��\�l*s[\n�\�§5��\�tz�\�§5��\�l*s[\n�\�§5��\�l\�l\�l*s[�[\n�\���\���\���\���\���\���\���\���\���\���\���\���\���\��\�\���\��\�\�Gw5�w5�w5�w5\�\�\�l\�tws]�]\�\�Gw5\�\�5\�\�5\�\�5\�\�5\�\�5\�\�5\��WG�]\�tU\��WG�]\�tU\��WG�]\��\0\�l�RT�%IR�IRU\�\\T�%\\U\�IW%\\U\�\\U\�\\U\�\\U\�\\T�qWqWqWqWqWqWqWqWIA\�\\U\�\\U\�\�r�\\U\�\\U\�\�r�\\�W+�\�\�r�\\�W+�\�\�r�*\�r�*\�*\�r�*T�R�J�R�Oe��u\�\�~��|6=�\n�P��*B�\n@P@PB��(\n��(\n��\n��\nЭ\nЭ\nЭ\nЭ\nЭ\nЭ\nЭ\nЭ\nЭ\nЭ\n�(\nЭ\nЭ\n��\n��(\n��(\n��(\n��(\n��(\n��,��`�Xkó\�L\�WJg\"�]?U\�)�����[v��S��L\�W\�Z?\�_ihߋ�_ihߋ�_ihߋ�_hh\�\��/�4~g�_ih\�\�\�\�ѹ�\�}��s?��GE\�E���\�?��GF�\�}��y�\�\�Ѽ\��_h\�\�c�/�4o1�\�\Z7���\�\r\��/�4o7\�\�Ѽ߲�CF��˧\�\�\�}��y�\0e���\���\�\Z/��_hh�\�}����\0e���\���\�\Z7��_hh�\�}��y�\0d4\��\�Q�.�K�\�T���K�\�T���K�\�4���V٫jնj\�5mض\�]\"�\����O�\����O�\�4������e\��o7\�~�\���O\��˧\��c�.����\�~�\�?�\��?����\�\�EӨs?�\�\�9�Ө�+�P\�EӨz���\���N�\�uU\�\����G�.�G�.�G�/�(�%��ľУ\�˧\�\�\���.N_hS�}�O\�\���?)]=�R�{|�t\�\�+�!]7�.��?u\�?\�g\��\�L>O\�t\�\��\�L>O\�B�N\�SP�\�\n�B\��y��`�M%ZT���\�H\�`|p:�Gd\�%V�`�Q\�\�N�A�#���\�ɵN\�s\n�@P���\n(Q���q>>P*(V\��\�m%Tyq�Q\�\�J�x��7��\�b�X�V+\�\�]�\��\�5\�;\�-�\�\�ʫmn)\�\�\0�\0�P�QF8\�\�\�\�c�wI\0\'�\�\�B�`\�u\�\�\�\�6\�\�/:�V.�#�<6�8�*rV?�����\�ɳ*T\�\�Xk\��|@\�\�\�\�J�\\\�>��h\��#��\�\�G\�#~P\�:�V2�\�c�\0�k��E�	+I\�\rGz(+,�)\�:�\'Y�t{���:�F쫕\�F\�Q?�q�zN�y��\�9�=��\�x5Q8n\�\�k�F�R�y�C]!75\����f\��D��j\�zw�;$s�E7C�\��U�J���ߞ��ҏ�\�G��dv�\��O\�S\�˱�\��J>�Z.�Gm>)��Z�\�\�[B��m\�^�W��\�-�[P�\n��.>?\�u����;�q@\�(r�(r\�b�ܝn\�5G�\'\�M�:;�\�S�:ə�Q�*T\��@P�B�\�\n��/\�\�\�έA�U�h)�j�\n\�j��Ą|<\��\�\0+\0\0\0\0\0\0\0!1AQa 0q@�����P�`�\�\��\�\0\0?!�\�\�2:#�5\�<w�⢫��D\�%at2Sa\�U�#���	6\�!\�\���BDu!�E#�\�Ԗ@�=p@��!\�\r\�z\\F8h\�BV@��)��Ԕ��e���\�B!u%q��UX\"����eDA(�%I&�TB&~��� k@]0X\�\�.� la+Q�2ZY�\":\�\�CB\�D�HTo�\�l*�\�LQ*</Ih��\Z0\�nD\�h\�ҩ�K�,�\�9n�?*iUF����بj�d��QQ�-\�\�\�\� \�b��H��(\�\�記\�\\��\�mW\�H�#\"�\�O[t��8D\nK\�(r\�4� �M�v$e��!йQ����F\"cU2\�?\�@�]+ע)���N���\�ۂ:R�qF��D�::A `H\�\�Վf\�!\"҄>��)(��\"\�\�*!/J�QtH�CBY\Z�\0\�C�\�\�H#����a���W\"�gԍ=-T�\n+*�\"10\�5\�c	\�BKS\n�\�ɒ\�$�\�=�T#\�ꨍ�A)I��b\�\"�4l�31\�\�A{�|m�\�YL��e�Һ��\�A�Clc\�TO}t\�,\rщa\�M\�\\�\�X\��6YP�\�|cr\�\�ḆZ��ݻ!��O@�� ܺ1\�Q\rY\�.�\'\�ď�\rp\�\"�\���~\�+Yrn<�\�u�OD\�0H\��B&\�w\Z@�\�\�\�2z\'�k4]2&*Hخu�I#Y��FIj�\���B&��\�\'�Dnâd�ST2I$��F$�\�2\�$�I$�I$�I$�H�$�I4��6))&��UAi#\r�2n^\�\�j\�KR�`\��I$�I*��I$�I$�H\�\�z$�i$\�2z\�l��bI\�;%��<Y\�9G(\�\�rA\�9\�0䜃�r�Q\�\��d�|ŋ���C�[����\�dm#x��KJZf���\\IŘ��^�7�\�C�\�>��\�F\�Cٗع}��/[�H\�H�I�$��2MI4I$�I�\�Gb;\'�\�x\'�\'����\0�\0�\0�i�<i�<O\��#�\�Gb؆\�\�Rq\'�U�\��\�8N\�\�G)\�r�\�9\�s�\�)\�r��)\�r�9\�s�\0	[��������?[\�&\�O��\�s��)\�r�\�=>c�\�9j��\�X�bňD\"�B!!\�\�=k��\�s�!=\�\�Or{�ܖ\�%�\�y�G�\�y�g�\�y�g�\�y�g�\�y�G�\�y�g�\�y�g�\�y�g�\�y�ܞ\��<ɓޙ\�Kr[�\'�2D\�vB� ���\�ɞ\�~F�}�m\�b\\�,Z���,&�,X�U�Rŋ-K,X�j[�ŋ\��_��pE\�^ ����Ӂ @�@�D\"�B B!�D\"�@�@��B B!!!� B!�u�A\�u�\"(��J�tbi���aҿ\�R@�I$�$�I\'�t17���\�\�>��=>��\0����:Bu�nd�\��I$���A\�g�$H�d\�d2HdEb�&=��!bݘ�\�\�\�GG�y�bfG\�g`\�\":* �d�I��=�I��\�\�6\��\�\�\�+��dh\�q�JH\�1�CT�rE�D\�\�\�\�\�\��\0�J-5P;\�#�LTF�\�D�����8�g�1�\�hv.\�LLLLLLLLB���lG�\��\ZĒ�\"D��\"D�$�I�L�%�X\�,���$��Zm\�#a�lLLLBbbbbb\'ժ&]r.E���\�\�=7\��o��qp#�\�c�p��\�y��s3��̎\�\�\�dwdwl�!��\�\��g�kq�ٻ���\�)�\� I�	\\�\0\��\�!lNn�I	�	�*�\�F\�6���l#a\�xؾ\��=�\�_b��<I=\"�gх&1v\��\�v�\�`tR\�d�d.\�ݚȬRYE�\�R�s�\�\�\�LL�111	��\�\�-�U+>��c\�b�q�\�wbø�M/\�D����\0x_b\�r�_�(�[��~ZA</�aɯ�J����B�\�!ա�9��c�\'%\"��4�\0Z�n\�ٍ\�`�p\�\�}KO\�\'\�Jʔ��^\0\�|\�4ٹ�\�oW��\�J���ٲ�Bb��!2}J2�\��՟��\�\�ZY\�̋�CO˂\�J/(�����/�~�v�\0E\�}\"b��1.��d$!\n��B�T��`}\�X� E	\��\0�\r\�\rf���?���biN\�\�\����WsXxc�+7\"\�1\n�B��R-C�F\��Aɱ�4��=���\',,\�\�i\Z\�(�wb��\�$w,d\Z�B�!^�R�\�x>\�@i�893\��zY�\�&���=�S�\n\�\'��\���b��j�\�፛Grdb��LB�\n��C���\�U`@5\r��N(\'\�hK9p��,F�����#9\�yq+�\���*!B�+\���}N\�\�*Z\�T���PO�\�2\��\�\�\�G\�0+�t��j\\ۆ�2�%!B��2�e\��}�S�#��� j	��)��k�\0\�4h���F��\r5\�\"Q\\p&!TB�E\�Q���C����\�Z���\��\Z�b\�.cA�\�K|\�B\�4���7Q\�c��n�&*!11\n�\�\�Q�_L�`�\�\� ^�NR9&\'A1v\Z9P+C8Wf�Eg\rl�s\�ri1i\�\Z�\�#bэ\"�!1\n�\�Ie~�R�?(ϣC�F:�Ϣy\�\\G \Z�\�@�a�HGz\�M�{M\���Y\"#\�K �Ƶ\"\�Q�c#!B�\�!��[�\�MJ�P����40t\�\�&\��1�\�{C�\'\�d����D�\0C9r ���X\�(�*!B}8Jh�~�d��Q�\��42]�DB�r\�j3�h����`� 5\�7E=����jh5dy�\��*�B\�IŤȸԨ\��hf��\�,\'sC+#\Z��C�#s\�pL��\�h�=IĈC���\�CLB��.�<5�f%\��Uu_CGF~�\���wT\�#\Z(0�_D\�\�i�4/q�dQ�a*\�dJ�Y �w���/�{E��\�b�BL�ˢI\�BO\�R�\�ӥ��T2L���\�Pi�PO��N(����\Zzɪ\�CB[\��*.i�ش{K�JIxDF]\�*\����c�XYt\�\�U��\��i\�\�Ѫb@Қ�P\�Ԧ��^FIO\�#E�!%�	\�A&�8y��Z\�F\�F�h$$*/A�\\FPǭ[�\�]3�FH�\Z�����6La�\�\�c\rql\�5�\r�X\�\�\�>\��$2�BB				z�\0}��\�%\��\0ơ\�C��y�f]>E\�(5a>�4+PLյ\�蒜���J�\��/z$$$$A�\ZK*��\��\�U�\�\�9/O�T�\�Bb},t\�\nҚ4��q\�̋AX��\0\��Y;d�؊��	G���\�vHdc\��T�PJ@��L��d\��\��r\�a�ţ��4EH�LŔ\�SL��UuA�CXOH�dr&\'ҾKq]gda-݈\���ARB �L\�ҷ\���O�|��\�\�\�\�\�	�,�8�*���AR;W�\�t>�_��^����[�!\r��۸����12kG�hQ\�H\�\��Y�(�US���\� ;(\";��Q%�i�vfR���\'�\�\�-��E�,9\�\nmWw.	���1�<\�B]���R\Z\�:�Kv\��\�X�	�Z\�\��\��4~D}\'B3�?@\��\�YBX\�Z2=\��\0��g,L�ᑗ\�[�L]}�]qGs[��;3P�e��%;�\�\��	�\0���LUc쵞\�H�6	��\�\�\�B�e���B�lD\�c��`A2�T_OЌ\�\n����X�	\\��EB\ZI��p��aP&O�h�\�\��#?L��.��RT�5�1�\�\�\��p&B4\��	\\���g\�\���\�\��OO�!包֙j\�\��mDP�\�`�\\�/�Т��W\��#\'F\�G\�G�	V\���vv5�9U~�\�Lp�~z��5�O�\�ŀi�u?\�Q�O�\�FC��>�fwȬ���pY�4Q\�\�\�%�Yh��E\�&8\�BvXȉL�kǃİ��\�ɋף\�[Ќ���	�]\�Ky;	2\�&�s�s��f2~{�b	�Q\�G�\�OlĿ\�M�\��\�\�\�f_5}�: j��a�қ��\�z�\'U��n\Z��p�F\�B+��;�@�\�\�ڌhB6�\�g�-p`O&\�X�\0\�5�F�\'Tf2��y�l$-T\�p�5\r�N\�\�$#�߁.\�HW|#]lJ:��1�Ͷ4�Y~�x[�\���$�\��T6ao#\�\�\�H_�hϡЌ�ܫw\�ȫ�\����;�Z,�$]|�Qv�a\Z\�bQ\�k8!�\�+�Ii\�A?�,�ε�54��G\��\�c\�\��ё\�X�\�&8&\�WF:j�L\��\�F\�l#\\lJ:ds9E���\'�P\�q!�\�\\�O\�JZ�\���N��厨\�~z���d �����\�#�g��]JpF��1R�;���A�(\�d\re9;\���	��#A���&w�%��\\G5�����\Z/\�Q��\0!\���\�\��v-���2\�HUm�b\�\�rBչ7\"B\�\�\r�jLI.��\Zr�#6����;f!�^��~̰�\�şq\�~��\0�(#�\�\�\�}�::>\�C2^\�F�\�\�\�m+wq%%>5\�TIBhl�\�\�\r�j�%\�\�殏�9�>~���HM\�\�\�e��\0Ҡ\�0�S�Q��Tt}\�*&sW�\�\����\�2\�G1\\�h;\���P#R\�Q҄m�K,�\0�\Z��\��\�6-7	��� �6{�K>\�_$�\�\�(%EgªQ\�&s\�Q�}/�Q �� ;b+\n!�\�cQEոo����H�GP��Zh�(\�f���^\"\��P2	|�\0\�M*\��neTg�t}�{���<{�(�y\�\��v pIc^\�-�f��Z\��/�b\�\�\�<p���o���*�-S��-�FW\"\�L�ζ\��Έ\�\��K��A7E�M\�br��\�K�횾?\�DƏ����k�1<\��¢�V?�,�beTe�ci<�\'����\�˥<y\�S�P���\�\�l�U.Aj\�C�\"\�;L�x1\�\��~�\�����cRR\��SK�,+�\�ф2�\�C�yf\���QQ��;�]kF���Fúˮ\'3?\"�m\�7�%n\�9O3�Q]�g��~UU��c\�\�		\�JY�*HtT\�\�\�&۲J�T�;\�7Z\�\�\�?ղ���P�\�\�ߣC�\r@gі�`ci\�p%\�EؑI�\"H�t%\��4��\�\n2�9T���\�ͻή~Ŕ\��)�k?\�4�n\�\��7\���e\�Gڜ\�\�\�۰CKQ!~ʕ\�]Lj�YH�~Gк\�\�\�\�	3#>gؽ��LO+\��/�Ga.\�?�#5\��g�X\�\�\�]�\�27\��	uJ�3|�H\�-\�\�fC�\0@�!�\�\�\�5\�����\�\���3t��1��|�	\�Y<P\�\�%Ӻ\�lI-�; \�\�d!%��O$\��\�\Z=�w��%�~�s_£DX{w��\�Q��N�8�G\�H8\�iP�!.�xH4h\�\�\�����&I\�\�l\�\�\�	&Ik\���*\�˽cO�=����(�Kf\�i2\�\� XYpƒ�L&EԼy�\�\�\n�\�kF1쪍.�s\�j\�[�I\�\�\�Ļ/C��P�\\\�j\�K�K\�%\�\�\�%�\'�\�-\�\�\�\�c\�0��VJ\�c��e\�Q\��\r��9Ǽx�\�t�\�\�5Y\�k\�XE�)��:\�\�n���*֩\�4�\�}�\�\�K�٧\�Az�e�>\�P0�\�<-\�B�ڢZ%a6C\�����p.[�x72�܍�Jl\�sڙmE.\�\ZW{R�\��S\�ue7-\�zF��\����vbI$_\���\'Jd�=\�c\�\0�k}\�תS\�t:}�\��＄���Na�Г\��E��E�9M�\�mr\0�=\�\�l-���\�\�x\Z޹P\�{��\�Y�O#�a;�bxhg6PE,E�*�(M5�\�h[\\q��̻r\�mЈWc\��G��؁@�wZ\�c\�a�k��\�a3\�K�\�T��L*[�\0B!2p\�ى ����$��\���[	C\�;4�\�\�U+\�t�т��\�\nn,Om��\�Jg�\�D����`T|\��]\�ۡ()fZ9=��\� ]֤{w�/Z�\�>\�F�\�0Q��eF�얃��E�,]�� 3\�\�\�\�cg\�;۹\�t(C�Bh\��\�[	UY��\�<�\�}�\�4>ᆎ�\�̎D��2M/�\�\�2�\�\�<��\0��\r�ŋ�s�\�P,h�ϋj	t>�r��^�\�:F�\�1\�\��g<˲\�񘴈m|nHT\�%��D�84\�a�$\�\�\�B/\��6\�7)d<9G��ڂ]K�ck��갰}�Z2A.²�Xnv�[��l2�\�T\n\�k�NC\�j|w.\�\���\�\�Y5Os9t-����\�\�{\�/V�Yz\�}k^\�K\�jKMv�n�f�,CJ��\0w\"X\�{�NG\�\�\���V3���ґB6\�����a�׃��h\�\�g\�TϨ>�p�.&m\�\"����r8\�\�Ɓ	\�\�\����TM��n{\\-��JϽ�>��h�ޝP>�f�e\�\�\�mŸ\�}\r��\\�\�\�r.F�~\�!e]\�\�\�[՜\�ߓT\Z-��l]\��u�\�*�t#\�Z��\�\�u\�\�΂O�2$K=CL��<�l�\�1��\Z\���\�r�AH�3\�\�\�\�\�b5]ݝ\�f\�{\�\�[\�d�C�\�E�\�A;\�$g��B~$�5\�\�[i�W˓\�lD%�����O�Џ�}n�ˁ/r*�$��1��\�Uh��!�����[�E/\�c8�Ej\�N6|�\��\�һ\�\�j\�1\�^�3�\�G\�>�����\��	6�I+^�S\�\�m\"���\�\�[��@\'�Y<(/G\���\�	U[�׽���{!c\�#$}\Z:g,=$\�$\�ad�\�2m�\�r������<��ڰ��=����C\�;wR\�r��^���Q#\�\���|�H�܇�]�H),�[��\�A��\�B\�kp\��#.��;\�~��\�G\��N�h5�6Gdܚ�	�[1$\�\'a�.u\�ʻ\�+*o\�U�\�ko#��B]|�\��NޕW�\�UG\��+v[�H�\�\�\�\'5�\�$>S��|���;��\�I��[�B�;p�x\�\�*	1\�\��\�:�\�}����Ֆ\�\�wKq�w\�\ńò���B.\�{^�<�ۍ=>j\�b}*:��32��FØ������\�k,X�]x춃\'�H�\�f\�\'+����\�b�\�\�\�B�h0\"�\�1L�\�A��E�aNź����E \�YG\�:�L�uY��{\�2\�a��s���?�1\�\�4����\�N\�Y\rDQI�(\�9�\02�\��u��1wX��o�}x\�}��.ĔJl�Is	ط\�\�B���\�-`��\0�D%M�\�\�\�1��O\�}3>(\��A���ɝ�Y�-k��\��k�\�Y��O��Ľ��\����}ǿ��gю��\�\�{�:\rr��\"\�\r�D1Fw\���\0���\�;wRP���}s\�UO\�Q������8va�\�=S����#\�׽0�\�=\�>�=+\�L:�\�cԮh�\Zy�\"N.\��\��|�]Lkw�\�}���1={\�;/�,4�F$��\0\�$�\�a�4��\�����\'��\'���Ļ8\��͝\�luY�.D���qB2��\")�&r��c�=w�\�	��ODђ�I I$�I#d���\�$�$�Q	!D�Q(�@�!D\Zd%\Z\rЙ$����I$�I$�I$�^{�\�ba�X��\�G\�B���\��-\�4G\�FT^\�t�O�T<]\�lu\�#Z�\�\0���y\��(]�&v,0\r|\�+oV#�͓�}AX\�\�`pO	l�H�\�a�\���3\�Z?db\\�\�\�\�v&K�\0\�@gv�j\�QM��M\�\�\�_#\�X|\�)�;c\�=�vG\�	\�\�U�/\�\�\��/7<J\��\�\�L��&Ήr\�\�f�\�\�Yr\�M�{\��	���A���6�\��dYz���Ě\'�\�\�n\�or\�-?p5-<\�=b\�/�g�`S���e�o7g������G:�\Z�Z6\�ϵ���\�\��4hM����.�\�o�-ՄA3�h�6m�E\r\�-\�cC\�F������\�I8\�}�\�l\"\�7\�Q���\�\�ƈ_aEl>�A��[��\�\��+>\��\�sΜ�0��/���kO�E��^\�N\��*K\���v\�5N�\0��IY�C]�܎��ð�MCivs\Z�z}\�)K��\� \�rͷ��٥\�~\��e*����v<~�O�\�X-\'p$f� �\�JF\�J\��4�\0\�77u\�\�$5q*C��\"\��\��\�\"\"O�3�2�\�\�C|��?���Ṓ[$��%��2\�Jr	�����\�\�,\�\�{\�#)b�@s�yr��\�Ki\�E��o\��s2֚{�Q�X4\�\��\rSA��l�2+:�[VPQe`w��\�\�\�\�\�Yqi�\�\ZD�\��½�~��\�}:\�\0z�\�4�\�MD��\"Vj��JF\�<��$��F\�\�\�<\��3\nh�em�2���D�aS\Z�P�Bj\�h\�I�N��搦b�\�\�5MSp5�\�$�Q\�Lވ!���a\"˃1\�E���6\�\"8�X{\�\�B���?\�Mİ�G!	+�n\�_�4��\�\� ���\�0OŨ���\�Ĉ�L\r�QnYf�@\�Bҗ\�\�&aLcZ.j�-�x6�lH!\n�Ny������2h���\0\�#R �6\�\���Qѓr�H}�lkE	�\r��\��\Z \�QEDLmQ#]�Z!tKNȭ\�\�Ȝ^\��$�\�K��b�M$�[V�p\\�N�EИD�\\�Ǹv��cJ�\�XN(Z�=\�,�Af\�W\r\\�V\�\n�:\�\�\�\�T��\�B\�tݏMhmVH��\�\��\'�F\�D�A�\�{�\�\�\�$�&O��AE �#�)�� �\��\r�\0\�\�9g0\��u\�r�\ZO\��\0X�\\N�\�\�<����7\��fvd� Pa<�w\�M�}\���ÿ� F��\�7\�)\�o!\�%u\�\�)�\0\��\��`� � �|��#�\"�\�2�N�\0�\��?\\��N/��\��\������\�!\�Z�?R�\�\��\Z9�\0(\�����a\�9�0\�	�4?\�\�\�D;f�\��J\�RX�\�ƽǼ��\�_s��p�N\�\��8�\0#\�\�Q\��\�ɲܜ/��\�q|��\�txM����\�h�\��h)\r�!\�8�G\�\�G8�\���\�\�S`{Ba \�\�w����3��s>NgE�\0DO�\02�֪=0P�\��&y�7���N\��N\�8�\��q\��\�\�\��?i%ܶ\�\�%	�ؔJ%	��E,Xi!\�*\�\�\0( p� @� @��(�\"@�=��r[��!\�C܇�-\�bDɓ\'O�\��\�\�<G��ËN���\�]\�>��E���+�H�I$�I$�i5B�\r��\�\"9΅��\0�:1Ti���[pO��-\�>\���\�\�&�<\�1�9��0\�2�!\�s\�9\�r��2U\�J$�h�� �0�2:�$0�䄬�N�Tb3w��bT�I	)ȅH ���QE1:I$��!P�闦x\�\"{C\"D8Pln�:*C�e�bP֪\�ЂԊ\�SCP#$�H��B�1�&����:eVu\'V}D�Iv��\"R�\'\��\�ـ{	\�!�B��O����rp|�J$\�\�&hP\�E�??�G\��\��h��~\�?E��\�G\��Q�h�\�~�?8ٌ���E�\�1�� �.��T�\�n��s��T<#\� @�J4�\�P@�{��],X	aTH� K�z\�\�\�1t�2#yڎq\�I��\n�l��!���2�V\�xB\�yN��j\�\n�A=\�\�\��P���꟔\�\�`����\�\�0\�S!�\�\'\�C\�$��\"�AG�s\�N\�1�\n\Z�f��\����?���H\����\�1>��\n(!A�,�\�sز&*+\�\�\���#~53�`}S�F�⬈\�`�DE`�D�/\\�܁��cD�mG�\0v�\�\�p�@�9��Bm��!26\�Y�m\�n=���.\�Ӳ�#�zT\��{\�ڒD��\�Dr�Z!\�/oYC#����qN\rD(<�	y�\�\\��h��%a\�\�$�I$�I$�i$�I$�M$�I��I$��\�iV�\�8�	uB\�Ob{3����;�\Z\�r�(LR�\�\�1�-�\��G;\�ɼ#�\��\��N&,ra\����G {L\�4,u�IC�q\�\�tr��p�J\�\�P�\nQ @� @�@�J @�Q(�J%�D�Q(�J%J%�E�MID\�/fP;\'e\�F\�$ ��obTI!��b D���\�L�\�\�Ֆ{�\�L\�s\��3�S��\�5*\n�	$AUxHsT@�e���\" �Q�\Zz�n��B-E�#IYlB\�o\�#&�!�\�e\�JI؆\�!v�	M� 5��e�$*+�{AZ�\�r]\�@\�\� �\�Hf]�P\��BAZ\�\\��~\\ܞ\��,\\���ѽ\��\����,\�H\�\�\���\"\�I��D\�vKq:\�Oq\�c�-\�턷�K3%�y�\�b2N &��E�\�̘\�؞\�JѤ\�W��¾vm\�\�a��\0(��S\�8\��3������f��5�\�^\�25�$\�\rdE\�h�Ou\�(w(�֍���}\�%CE�^O��\�1�\�Dͣz\ZȐ���V��e\�:?;E��\n$P�\�>\�@\�}h���[��c�Y�\�~��Ci7\Z�ˇ5m\"\�v\\�\�UhˁMka���\�Sv9�؝[Cm��X�6\�z ���H\�WCT\�[\"sT���btC\�A%\�M\�O�WE�+��ͽ%��\\� �R}ʣ1���+Q\�(�&���[}�I�\�I�>O\�ⲇ�g��,*IC�f�����2�a�\��EL���$�7�#ET\�I�5�\�c��#����m�L\�q<	J�\�÷�Hu��Ӵ)\')]-�Ւ\�qa\�Rra�\���6%	P\�$�I\�D�P\��\�&v\�˖\�0W\�}��O�\�>D�\�	P�쓱荓��\0B\�P�\�#Y%�C\�`\�,\'&cxC\��\�\�9�1��\�G2Q�L�\��*HDe&\�s!\�Ɉ#��\�G�\�2���\�8�\ZM�\�Yĸ\�\�q	Z&g\"\���ZD��\�ó��ǵM�\�Dr,�ٕ-��\�$\�3˒�>Nd8�\�\�6�����d7x���\�9\�fX\�C�H��I*\�}���1��j�Sh�6�Tbq�G�j���2=\�4\\B�n�-D�):Ah�qGaL\��1\�A^�E�\��u\�{�Ӓ\�_�\�Ir\�R��6\�\�tʆr��DM�3\�#&mK��\�\�\�\��)�\\�ēqY\�)7Q\�5e�\0t3\�\�)��\nb�3Z�NB�{���Xڠ\�V�pi�9�\n]\�\�=0�\�I�\\\�XD�\�\'T�\\v�\�\�KM\�\��x�6Wjəl����5����G\�)̙qqgHن��\�	M݅�\�.�\'X���\�\�\��z\�qt+��X\�\�\�\�\�Y��\n�_�ȴ/|�,`P��Cȗ�t.T�iP�B�	?{!��g\�l�\��������C�\0�C�\0���������\�nA�\�\����q?��\�rq?��G\�dd\��\�ڜ�s\�p<A��e��O>d�\�L6<����\�~Y?$\��E�is)�\'܆)~8�3��??\�\�\�}\�Md\�q!D\�&�6\�\��?�\'ܟr(\��ϡ>��w�I����9,��W\�l�\�̞,\�lB\��h�b9��o��\�\�9�fI��u�?\r\�g�J�Y��fLWBg�&	[�4�<!��{�\\�Fz1��Q\\�	5pJK\�h��3u{\Z1��R^\�W8!��\�G\��\��(\�j\�F�I^�\� �jh��>\�U\�4c���!��x�}Y\�h��>�U�4t?�GJJ�:�f	�\�E>E�F�\�A���\�6\�+=��������*���)xe�\Z���6�!�]W��Qo�	\�\Z�1\"8F\��O�\�Q�\0�P�8-i#N���\�a0���K�ġ��H�\'h\�}\�P0�*1�\0�ɼ	X4*ݓ�z?jf\�0љ�\�\�R\�Φ\\�;����~Ŧ�\0\�϶��2�1���\�#\����l��׻\�£���PlqKqD_�Bh=�\�8�\'\��q\�8g\�c�p	\�8\�C�q��8\0\��p�8\0\��p��8\0\��p�8\��p\�8�\0\�c�q�1\�8�\�c�p�\�8G\�#�q�1\�8G\n��{���5\Z̋hq�\Z\�|\�o�\��%����\�CX~��#/��W��\�\�yx\r>H��D�\�Ė�\�_\�4�#�D%{D�b�\r!�����\�\�g�?\�?�\r/\�E�\�}����\�\�ƟB3�J�>\�!��\ro\�����52!�!�\�k#E�[\�#\�\���\�$��!a\�A�\�b��+[VB��tFH���mKX�4\Zʹ�HR#��\�S�\���ڞ\�\�\�Cۯ?H�Z��\�2k\�!q/tC\�H$�!\� JgA���ﳐ�	� S�Dg\�H!\r_�?P\\�K��\�C�5^.�A\�o�FEπg�\�Nǖ�yk$���} ��]� k������,\�1j6+\�)?3\�Y-G�\�Hz��\��N�$OVy\�@\�rt2βZ��\'G\�K}&����?6O}Ss�Z\�\'��\�Ƅ�rt<�-Y�*_B_E\��cB{\�B�\�S\�RO�\�\�\'B]Y\����>�҉�\'���F��\�zP\�M����h��\��V(\�Y�\'I\r\�\�Q$�,\�y�8eZB��\��H\"(\�*!L\�d\�ކ}D�\�<b\�i:G&\�.H�t�܄�(jh�[�4�\�\nB��\�|�V(�J�[�A�\�\ZL\�L�D\�\�\�p\�S\���k\�FԟR,Q5\����$I�\�	BK��&��=,\��]Ϭ�\�.��[~�I�tNC\�[�F7g�ӆ(��\�\�2Gʶ��:6���\�\�Y٤�\�s֭��*\�P�\�B���\�C��Q�\�k\".%a\��)����8�\0\'\��,~>t\�\��GŜ_/\�F��\�bp,A_��ޏ֎?����Q�A�1�q�q�Q��8?�\��G�G\�����\��\�\�\�o���Xq>��a\��8�\�\�_\�\�|O��|\�\���\�_2�8�2�9>7�\��\��\�r|O�\��9W���\��9�\��?r?R<\�G�\��|/���r�Џ��\��<\'��H�|��x\�<g�\��|#\��s/��t\�$���)�ؒI\'�{@	&�\�	$�h�I$�I$�I�5$�I$�I$�I&�$�I$�I$�I$�h�I$�h�\�Ư\�\Z\�V�K�Y\�2vz�o\Z\�<c(bv]!\�n��)\�}+GЄ�Eo��I\��7	���\�c\Z�6#\�\�C�\�I\0\���Q�\�t6т\���dEѬz�%�[�\�\�uN\�>��\�ܫOn\����-RHD�Tm(����D�����k��7�-B�ؑ�\�)4��)3Y�ފ\�\"J��hV&�\'�%�M,\�IX��4�E<:\Z��K�\�\����\�]�O�7\�b؅-��l\���\�\����jIy-��\�df�M�XnЁ?\�h+^\�\��\�s�G��/q\�#c�N���8C.	�\�	���1;\�\�bO�_d�\��<t�ܙǁ{�\�$�5�Om`�+fIm��\�j�\�E\�{,h<\�3\�KcS�!G$�ԛ\"J��\�nі1�Ɖ��d\��*�LH~*���*֬z8�d�\�\�r_Ck\�bR\�?�v�%�O\�o\'��{{����!/�Z�1x?\�/�J<�<��\��%�`�a�\�\�f3y\'o$\�~*_����=\�=���\�1��:-��ڜz�h�C��W�8-\�Lo>\��JS\'�C�T� ��O\� f��\0ã�ȏ̎dr#��\�x\�\�X\�?�\�LH	�\�\r�L�\�=�5�\0��\�\�~\�K%�I����S\�yHn#����X �AAE\"�E �)AE �E\"�GLtE ��������I$�M&�I$�I$\�I$�I$�I$�I$�I$�I$�I$�I$�O�ԓI&�M$��.���\�Os�\�\�s\�!\�s�5C�\�9(r�!\�\�r�rR\�\�1݈\�=H�\"]\0H�2D�c\�iރ|\�-\�nO$2��C!�!�!�\� \\�C�r�\\�r\�ː˗.\\�rr\�\�e˗.\\�r�\\�.\\�r\�ː˗.\\��\\�C!�\�C!�\�d2�C!Еd�T%C��68�\�8�#��\�Gc�\�8�#�\�8�#�\�8�3�\�8N�\�8�\�8�\�8�\�8�\�8N#�\�8\n\\G\�qG\�qG\�q�G\�qT8\n8(FÀ�l X�\�X�bŋ%%TS��\�|LZs��\'\�G\�T�`\������\�[ZFr\�?\�r�G+\�s�G+\�r�G7\�r>G#\�~�?[��\�\�h_F~\�~�r�֏֙\��\'\��r��\�9Y\��Fs3��σ��s>g�\��\0�\�~G7\�s�G+\�\�\����3�\�\�R\�\�\\�\0�����\0@�\���\�@�\��H�D~����?�G���Ȏ\�i�\�pĉ\rRW\\\�\�\rbI�`\�Ea�Mf�ɣd�I$�I$�I$�����\�[�\�X�I$ln�\�wB7\"I$�H�\\�\'ٚM��\"�Or9��\�/bNΈle\�\��\"��4�@�+�@ꆽ\�2�uDm8*\r@@����ҋ��A�h-\�ԅO�qy=\�K{\n�ML��Al\�j\�\"ޝ�=�Fa�Pa�$Kd�D�\��#��R �GB��}r�\\�C�t���E�[B���!\�����M24�u$2\�\�\�hJ�U\�ރ\Z�K�\�Z�\� �\�(AE^��^�ڜ\"QD4X\�q4�\\wj��;\�d�\���Y�\�V\�bD\�# h4�W^�ֺ\�\�t�5\Z\�1�\�˓F\�	<&�ɰרؒX<*h\�#cYI��\�\rI�,7q�Arc\�\r: c\��uQ\Z\�� �\�GT�	��N�bd$@���q�o�\�d�D&M\'rIdHŉ�B\�/@�,{���E�!��\� 0m2E���ӂGMz$d\�A\�:���܎G�\�H�v]�&DI4��\�n�F1G\�B]�\�	\�\�Jd��4�����WB�\�hTUW�:f��\�fr��\"\�FKM�\���FI�ʹ,<�,%���dcV�$1�\�\�ѧ\\UAY\�\�t�n.;\�}2:I5b\�@\�o�~r	�@PȒ.\\HBcE\�#\Z>���UU=)�\"TԱh_M�0&2\0c���\����\�\�}��\�S鬚Z�D����6J.G�*!��d�D�\�/\"c4F����4%\�\�bԙA**7GI\�}��\�8M\n�=�?�\�A�4\��\�5q��ס;\�4�&:9\�Lc\�g�a�\�H�	\�}�!u\�V>Ԓ&:�W�ؤ�����}�{x\�\�(>�ԝ]CBTژ1W~�Ż\�\"�B\�Oe�_���\�A#\0�<ƈbF\�-H\r�cR��\�TQ�\�Y\"hmQ�\�ى\\\�\�x\"����u����,3\��\�&�\�2��C/\�ɓ\�4UUN�s%�f\�W$�f:?�\�\0*\0\0\0\0\0!1 AQaq0�����\�\���@P�\�\0\0?P\\CE�95/vB\r\�MT����\�e`%2��60���x�ԭʕ���H\'h��62���h&�\�\�\r�\�E�u�*\�t��\�\�NU�q\�Hk\�8J@�+�\�e�\�j�G\�\�8)\�\�f\�w\�\0+\�#P!\�Ns[�P�$(G\r\�\�&\�w-�h\�(�B\�Q�1\�*р�A�G�ĸ����WC�<\��M\�CI&\�\�\"�ƅ���E��\�\��\�1!\�V\Z!Vi��H\�\�k�\�����\�H7r�0 r�j�2u;`p\�V��\�|�动�mi	�Yw\�n.�|.\�\�+q`sձ:kk5��qL�L1\�wA�\�$��0�+L\"\�\�+!\�v\�L�\�!M�@�\�w;��0E�ڰ\��хT`d(_\�q\\9\�%0p@�\�%b\���\0��z%vD\�Ӧp�\�GIԴV6���b\�	�\"J��Į��\�\�E\�\�%R�9��C\�\�\r�Y�\�[�j\�T\�)-�\0O8��%�>�\0)MY\�v�\��\��SIS���@c�R\�Ů&\�\�Ma/\�#r\�\�	��jp\�!i{و��\�|c1I)�Y*T�R�t\Z殧e\�\0�\�t� \�7�B5\�R\�eƊ �f�\�q�\0���W\�%\�2P\�,\�	S�.[H��LF�JÂY�٫\�l\"$E�\�!o�sux+����\Z\0\�UW,Ij$b\�\�I��z���X�D�\�z�q7��p\�\�b��w���\�\�\0Z�E�Ǔ\�/<��j�b\�����\�\�\r1b^\r�2\�Ʉ\�\�*�S��0\"n\����9�\�,f�\�\r�l��\�p��\�10;�\�ejr\�\��q�.$\��!�\�Q(w;ӒW�\0\�\��\0a�PEt\0�\�v\�]@碻�*\�hc\��\�\�1\��T�zV\�I\nx�\�v;q\�T\�S(뷈�\�8IyX�w�#+\��ѵ�dR�\\�\�sg׀�p\�\�\"��\�\�b{\�5\nL�8�C�\�eq��l���	p0aV+\�%Դ�m\���0S̸�ĸ%��gh�.مC�ʗ�\'1\�a�J�.UjjUL6s&\�w�\�hŴp�r�Yw�s��\'QP�\�o\�\\\�B*T�e`�w\n�,�@\�I�$a\�1yb\��G�\��8�\�GA\�9A�)���l\nHo$zZ�l0\0\�`\�q>\�0	B=J\\F� n]KN\�v{\�\�+A[�VM�o� �<E&���@�\�Ma�pA�p5^�paN�b��<�\�>�\�\�㹂Q\r\�_��ʇ\�a\�/7y0�.\�2,�\�Y*���U��%��\�`��\�Yx.W���\�yb#j\�c���$-�x \�\"o	\�\np˃�t\�\�n\�q�P\�w\�h�\\�\��\�)NC�`�2Ȍy�ĸ\�a����\�p&u�𺜑\�n\�-⬯\�;b\�]��|��Ȑ��h{��\\��p\rB[Jq5�\�\\d,\�o)�Т\�\\R,\\\�hK\�X\�s�\�\Z1�5���R��g8 \�\�\�z�,��r�V,*K�b�M�)s�M4\�\�$crЄ%d\r�Fu\�Ə��\"\�\�A\�\�@���_\�Ҋ��\\��� ˋ..-�/\0��\Z%,ؔu.\\�a\rˆ�/Pe#*h@�֠a\�\�WQ�/x�I\�\Z\�2�\�\�S{�C\0°vM o8 ��V!;s6J���S\r�z\�\0S|�\��\�\�=\�i!�c\0�Q�\�P\��ʌ\"+\"��Y�\Za.^��\�2�0�X��^!�#��u�૳�\�\�4K����h�\0\�p/�\0\�C?��\�\�\�g�\��\�W�\�\�\�\�C�,�����S�\�w��U9K��m\�\0���(�5@\�G�V^\�2�rXB����|��A�\n2]Տ�\�/��L\�C��e��8�\����H[�\0��S\�\��O�/\�]8�\�\�b\�\'\'?��w\�Ȭ\�\�V��b�Ix@��� ���hV�3՞�< #\�\n�8�8=c\�>3�\�/\�Z|\'\�_\��\�x��\�Z^m\�^^|e|K����\��%\�\��K缴�\�\�|!\�/\�o\�|e�ߴ�ό�\�\�\�#\�W\�>�����LS\�\�OJzS׋\�!\�O^z3׏�zSя|`�<��:7r3\�\�S**U�|��&\�I\�OB>�\�=i\�OFzoVy�/t�O|\�\��\��Od��ol�\��cf��z�\���\�~gه\�=��\�\�\�\��\�\��!\�\�\�|\�\��`�	=\�Ҟ�\�\�z�\�=��%�%��\�~D��\�\�W�����T�(¾\�|���>R{\�\�G�\�\�\'�\ZzО�7��\�t\n/\�/6��fo�0�Z/\�q���߭u�\�/\��d\�\\H��g@\�݄�\�\'\�=�\�=�\�)\�=�\�1�2rZ���Ϟ|\�\�y����v{ܪ�ϼk\�הk\�י���\�\Z�MMJ0��CNSY*\Z��\�..����d�VEJ�LH�+ZU&�F���\�	��\"R����[\�W�G��R�\��+ܯs\�>�<�eDI�8\r\�f\�\�Ja��P�W��C�${��\�W�+\�(bJ]�`e#�=3\�,\�=8�P�\�\'�z��z���z�z�\�\'�z\�z\'�z��z\'�1\�=X��\���EG:�JJ@\��������)Y�{\�^b\��\�>r\�\�o\�_\�T�K\�d��\�*TT\�\")\�\�4�O	\Z$�$a\�\��\0�\�:V �p��X��0���.\\��Lܹno7B^|�b5$\�C!�q��u+\��O2�\�O�3\�>S�0���+\�\�+\�W̯�I_2�eqVW̦*\����+\�RV�����)+\�S̯�YL\�&�x���\'\�\�3�W\��\�\�\�|ϔ��{\��\��`\�5������\�o�(�yl�\��\�^�c�/-r�XT\'<T5�Z(\��\�9\"\�\'Y2��}3���T3�U+Y\�Z��\�ם�m�.����{\�u($4Ch9�@ꡚ�5�\��3\��\��\��\�i\�0R#\�\��\0\�+%]Ç�\�\�(�!�x�\0��=T7$�!�\�{b\�_2\�\�*�\'\�-\�\r~����t���˄?fK�S_g�\0�<D�_�p`X\��/x��W����\�e\�G6�Y�6#�\�\\\�~Z�M�b\�m�X]�\�~x�(\n+�.	^	p꿢g�seg�\Z�A��}\�\�\��+\�\\|уt|�\�=�\�=�\�=\�\�<�BA�$���IH�\�\�%˗\\�sR\�0jj��R%��}���S^�\0\02\�N0Z�@\�gsl�C4��;�.	oD@\n0pV/]\�뾗\ny\��Nx\�H�Z�i\�p��M��\���#W�c��?�\'��{�D��]�\��\0A�~bz�?�a\�1�y)\����+1\�9\�B��`8*��]9E l\n4\�<\��>�h�\�B0!\nh\�[\�v�\�HO|P�\�M\�#4�	\�C\�4��}	\�\�G񐷈@t|֚��`yg\�>y~H�Io��$�$�$����p\��c�~��\�\��\�\n|9<a�ǘ\�\�7�ǡ�A�\�y�5p�zq���[�\�[õ��\�D@Zk�k\�\�5\�\�d�\0\�ĹT/ݢky���ܠ�n>\�h�R\�tO���B^�5sS^%\"%��^\�\\/1��g>9�2\�\�֔�\�8r�\�S��gK�80A�O !\�J��\�\�J�����\�\�w(\� ���\�GJo߯\���=\��ɜ\��\0Ns0^O�\��l=K�\�\�\�8\�*Ģ���. \�\�\'~�\�aQf�\�\�sO\�O\�!�ra|*8eF�\�9z�&C\�=%��\�mpQ\�A�*�\��)���6n�Z�\�\�aE�_��T\Z����\�L!C/�]�+;x/�A�kN�Z�_�l�\n^ �FE�G�l�,!2�`0b�/�s\\o,1\�r���P\���p����N�X�\�\�u\��c��d&�i��~�ᆎ��\�~�\n|	dm��:kj\�\�\�:6�pw�\�[1���ɂ�� �\�\����,�.0%\��prD00�\�\�{\�Xs\�\�9��\�҆$c�Q\�\�]�@��s�`�\�C*�S%&�H\"�\�WZ\�m.\�d*p�\�\�\�P^:9OP	����\��\0P|֖#�qTK-���܎(h�(\�Ġ\�\Z�`�E\�G\�7�ss�g,\�ž\�0\�1\�9�s�p3\�L�\�k\�f \�v-�t󊎘(1+\r-\�P�>b\��X�\'5;\��*R5;�Z�\�M��Q/\�\�\�H,glP\�H\�,qࢄ!}GM��\�u\�R�\�BV��\0\�2U|��O\�i�\0�EP\\cc��^���N����\0m�\�fV\�&9\�\�\�q5	P\�M��\"W ��\r\�ϙP+\�M\�H6\0\�B\�؉5\�W*\�\r�\Z�	\�#��P\"�%\�\���0C��\�\�[\�>�\0��\�c�c�fw�\�R\�Du5��e\��\�ޤ���#{�jo\��Q�\'r\�N	mn\�\�Z��q��\�	Ȋ[�1\��GPc�\'Q\�E/7��^�\�2\��\�:�K�!9g2?I0\�1\�^\n��\�\�El\�Mb/�}�	j.�lB��Q=\�\�0Hu2���c}	���\Z\�\�Z\��\�ۗiu\�mMH�B\�z`\�b�\��rl��(��?xB!�r�\�\�\�0g)�·|\�\�~�X\�1\�2\�\�\�rt�\�^�5�R�\�Q/80zN#*���R\'ߓ�\���9hTZK�9���\�.\�\"5�tqb�1\�dPb�0B�ߨ\�\'y\�i�\',+��\�1�\�W��9 a�9Sr^N�;0\�RhĠ��SH�@-�\�T]��Dt���$T\��\�#y�oP���5#L�L�d1_i��i���\��\�\�1:0\�;\�d}�[�ǡÇ\��=a�jJC�`�I+v\��\�K�R\�\� R�7\�Rm�\�F\�^O\Z��^g�ir\�\0Т\r��\r=�Wvf↣yTX\�QG��P�2u[8�0ʨ�p}\��S�0ο\Zo�t\n1\�\�2�\�\�B\r������a\\��M1hR1�C� C\nj�eW�\�Z(�p�z>\�\�iu8\�8\Z��Ç\"�5��\�Bz��\�\�W\�X�\n\�xC\�t%�¯�\�^+5�`oyO؟�B<G1cxzG��/Q>��]W�q\�!	�VL�0\Z���S�\�YX�Z\�n�Ge��\�pR\n\�\�\�&�/\�	#\�0wE\�\\\�B�\�\�U)\�m<!N/�/bZJ�Y\�k�!\�oy\�ڜ΃\�c\����	E�v�\�K�\r\���i�\�L���e ��e\�hm\��%O,,�Q\�`\�\�E�bP���H�-\Z�r\�s0Gt���\�\�\'�E\�\�u�#�mǲ\�\������V.�wBN�_�\�N\�G�\�1\�zt�yݺy\�\�vُ�D�\�0!9��I#<YCoQF��T �>�X�p��r�\'C%\�\�\�S��(;\���0!*v�*\�j\��lj(�c���\0�����\��C���(d�<\�9c��F[ﰀC�7��\�\�\�\��\��er\��0\�%�\0\��W�_]�|�\�\�\�ۈjy��M��\�ie\�\\O����Ca^\����P��[�8W*`�\�\�%F_C�JIوZ\�\�9V}�\Z\�h�>g\�\�Ӵ�G�Ş#�IXa\�%�\�D��\�����(��\�J�\�,�1��`�K(�\�@\��\�K�/�l6\�\�\0ksi�]��B��i{\�}\�ua�\�/,@F���\��jGN�K���\\\�(�:���\\�\�.X��D\�\�\�\�V�\�?\�CP`�)\�\�?^�c/\��\�5�\�\Z��\�u�S\�q\�r2\�?r \�7Hػl>\�{c\�h�)gL.!�\�,���{�\n!��\Z�M\��%�����\�\�`B%8\rA�x��٬0G\�Z؇\�G\�b�o\�\�_A\Z�NUX<\�c\�zj�@Kp\�ԭq�\��5/D8�^Ut$3U\�\��ӧx,\�L@,���Xc�\�l.���\�ߊ�%袗\�ׂ���@���� &�=�o*̠��j,L\�\'�-\�I���v\"|�\r}:\�Uc\�r,�\�8cɑr63kaC\�\\\\2�\�x�\n�w�\�{�\���\r\�\�x��5�¸H %u�HM3����0&\�D9t6�\��\��G���1�0�pc<E\�\�d�?K\��T�Q3Y���r�\"�\"�\�`���$)e\��oD\�^0z\\ĔW\�A/W˃\���\�;\�<\�g0��\�O@$ C)\�\\ܽ�.��g�\�GF�����p�O?\�0\�዇��R�ɏ\Zʗ\�\nÖ=\0tVU2�1���jW�r��\�-4\�r�Z_��wm4�\����\0d��\�\�25щ	ۧ�Y\�?<&F\��\0{\�����`�\'�D�\'h\�ˌc�\�\\P���\�e�#	\�r\0\�K%��lB�$\�U��;\�@o\�q�\n8%G�\�+\�	 ��\�	P\�e��<��o,�<�\�g�~�#ǌ8�1��z�@���V5ӼZ(A�2\�A\���+0,0�\�ak�BQ�@ a �i��	R�Xr)i�Ɏ\�F7��*�\0�e���\�\�i\��B1#\�r\�\��j\�\�<7�\�-$�+�\Z<��Ԭ�q��\�hDVp�cT����(\�et�LF\�CMl:���\��3Ŝ�;\���j=�n���Ѭ>i\��\�Qk��D\��I`��\�q���e\"\0�\�o�<��C�\0�\��9\�+6\��~ȡГ:�<\�\\�\�w\����+�ʗU\�X%2�5�Jb�ݰ\���}fmX�]v\�29�\�.V��\�.MJ\�:�\�7\�Q�0��\0G�J��\0U\�\�n\�Dp�\�1���\�Xʼ�\�UeWV�Bw&�p�O��\'� .\�2�N��\�\�3\�Sk�\"�GEu\�A�^�\�R�w�J��\0U\�ߔ\�#\�&.n\��䄧)���\�xI.\�\�\�R�L�Mݐ ]\�3Q\�A�>�V�\\2\�H~�/Y\��ns\���Z!Ǆr&<t~<N\�����P\���u.L;�ÃJ<�U�`�`� zg��%� z\�Wy��^\\v�~�\��>\�#1�O&�\�N\n�7Q�b\�HD����\�\�\�U@��G�\�A\�>@\���;��\�^�si��\0]\�;F<`\�p� J;(J\��\�i<\r@�b!�����)\'7ۧ\�.hVu��a�F�j�2,z/}w\��\�X�s��⴮�ӈ\�NQ�\�\�!7Q�c�+s�^!�:�:Q^R\�+t\�E�_\�\�\�.�\�ò���`\�qP��\���h��Nx�\�#\�\��\�0�\�\�W�ܤ)ʜia�0�\�wqn\�`u\"\�;\�\\A�\��}]�@\�]\�\�\�\�%q�B{\�`ˆ.D\�\�r\��e_&o9�9��c\�\�;F81�gl1\�E;\0A|ĚE%\�ǒעY�\ns}-�\�o�P��ɼ(MP5��ŉ+�۴$�:\�٩��6Top�U����L�[�C8���MtWЬ���\�I2���D6F81��!-�ڱx)C\�\�xU;\�\�\\I�����+O�kD��Zl�\�C��)+>- \�/�\�\r2\�!!E�\�T\����K�\�=�u�\�Q� ���\09\�\�̈́py�p\�Fs�R]\�eV\�iތ���iP\�Z~%:M\�\�r��)4�|�\\��8\�a\�;{b�P�n*g	K�o�NĹ�ݺ��c��l\�q\�\�߆RԥY~T\Zٻ\��0\�\��bi�\Z�W[7\�æ��\�9F�\�+��y���*F,��8L0�\����d���\�Z|6v�ȯ�\�|�\�\��7�>0N&�\�����y\�\�\"�%\r\�.�X�\�q�O��i��u\� �o\����$K۴l\��J\��\�Wht\���W\�Q\�\�)��E\�9�����\�\0��8�<4�O.PXs4\�\�\�\'�\��f&��zR\��B\�\�lF;e�\�l�8b��\�#����%��g�\�\�\�|1��\�\�ei�L��tDz;N�\0E�Ӛȱ���\�ra��8nь��<\�3�A	~��C\ne��쬰)��*�4\�S\�(�	]B\�Gv%u�\0\'|����Ԥ5tpC\�c\�.4�ٺFf`0y�4���2�?��[�R]CX1SL�}\��\���\�9g��X�Q\�k�\�$xÒ!~m2K�\�\�^�\�!t�\�\�qN�\�=k�s��\��\�6èuT	\�k��x\�\0t�1�!�=�\�C\�\�\�t�F\�vS�Z\��\�\"�[\�R�0Q\n|~b=̇�\��醲��I��M��\�\"�Q\��\�?F8�G�\�F�\�:\�R�a�U�%�K\�ϲW�mhb�-!w�h�\�S7��(\�f�Y�\"\�po\0y{�a���\��j��\�mIh{�\�@7\�\�Fu+\�=�`7\�_A\�\\��\�:�\0\�ܵ�\�\�ѧ\'��@���\�ܼ�y\���^�zEʔ*�*W�\�nѓ� t�\�e \�=�J%Bw��\�\�7D�Px\�{�\�]�\n\\;�\�\�\�n\�\�\�d\����	\\Gg\�\�ܸK\��.9a�Ǐ\�\�򟡆\�6�\�,�X`@�\�,`)\�M\�\r%��hi]⮨jW\0:9o\��\�\�M���(\�\n\�T\�\Z!\� \��_i�iD\0:�V\�Z�n\�\��\"k���sk\��H�@Ԏ��੺�x�*\�\��\0\rtT:^�\��r\�\�`�)Ń�k#\�\�T�f\�6E����z]�iX��ȵyV�W0N�v\rAU�@\�M\n�z��\�b��A�7�\�J��;@Z\�65��\n��4�)�\�{ֻvQ��J�����\��\�a\�_F��\�\�1�ɞs��\�ÂV����\�\�K�\�T�t��B@�{\�5`B�}w�8��?�b��\�D\�\��\�c\�Ἴ>��\\�D\0\��?R):�S�k\��G@�E�v\�0�\�\��5\�t3�\���/�S�����ü���F�\n	ۨ�j�G`OPj!\��\0g�\�\��\�\�ըx�����`V��Q����\r<���(\�\�p��\�Jr\�`:[��\�t\�ѽ�k\��\0J\���\�\'(�\�q��8c�=�Z\�:KWJ���=��p4B@��v=[Xdt�%/t�]�#\�o��0\�\�\�\0+\�.\���\�r��@-�h�㵾dӾ\��J0�\�zFW\�\�/�\��w��.:z��9��Se5�b3Li��L\�\�\�?D\�X\�e\�8����\�]�HaX%#/\�\�\�[����y�RK�a})܉�~0򎖶\�\�̚\��C�\n�*�f�\�rG\�\�릺k���~�9�\�r|D�\rÕ�y�I\n�ctԯWi\�T!\�\�B\�[1��\'?\�ȱ?�b	\0\�\r@*�\0FgO$\��j7\�񜊮�P�\n\�\�\�\rs�-؀V�T8Ç�ax\�z\\v����o��_G�\�\\�\�\�\�\��b\�=�\�\�O;C@t9\�(�\�\�\��	\�u�1;߃�Jz��$0u\�\�n\�P8�&\�Qe�/QN�\\\'+�`�\0���В6������#;�\n$��1{�\��j�͇\�E9��@\�C9\�1�\�;\��M%�:վY�\�S�k����\� �\�&\�®��;�\�%\��=ؖ\�\�\��e`�!\��B��5KO\�D\�g�>2G!{\�־\��\�\�~��X���ۦ�y\�Xtw�#˓���5� )��X��IbW\��\�D?gX���\�\���C�N��,I\�1�\�Wv\�U;�\�X@;\�=v�bǳӲ9\��\0�`l\�\�}GW\�P1�:\��0�8�\�\�\�9��\��\�=\�xpⱠ�JG��\�\�JkヹNǙ��x� �\�Al}H�\�\�8\�xG\�\�$�酕X�^��[����~\\\'`�\�w�\�\�PADl�b<e\�C���F9z	�6��/H�㎟Q9d�\�\�T\�i��\"!.P�z\03R<��,\�U�;-\�\�\�%\0��$�ݣ\�̢��\�R\nU\�;\�U�t\��\�*T5���\��`\�\�$�w�\�]w\�\�A�-ᥟ���\�h��#�\0�ΧuԚ\�cLW�\�Ċ\�thz�K�x���+~OQ�	��07\r?3dAM۰w�\�_\0�\�UZ�R�T��w\�ۢ\�ɓ�?�{f�&�W9\"���Q�\��\���\�z�a\"\�Zŷ[3T1\��`\�x�\�HȨ�M\�Ø�h;\�{\���\0��Фf\�\�a�\�\��ۣ�o��J\�8����/E�5�w\�\Z\�]\�\0��\��r\��\�ÀÙy\�+�a�C�u\�\�piUКzB�b��؍�U;�\0\�\����s�x�\0�y~٨\�\�>!\�+��\�\����\0\'~�ǅ\��\�\�7\�Z\�+=�Qmy�P\�\�\�=1��@^!�\�~�\�lsKB9��&�\'u�\0��\�){�ݜ�~\��\��\�p,I�y5�\�\�v�,T�:ާ�\0����ȏ\�\�\�\�>\�#�\���\�	}n\�@�\�\�\�R�B-��\r!�=\�\�j?\�H�\0J�`���w�\0\�\0ԪS�\�C�~���\�=w�G�\�\�9\�$\�\�,^�\�\�Kv}k\Z�\0Z�\��yUO>Q(%�h\�\�\�?}�ފ�\�HjTSﲬ\�\�l�\0x4��C\�\r_�HL�H\�%���\0\����V:�K�]���0A\�ʀ��$�2u=\��`�	�\�\rhثsܞK,ae�u�#�Z�\0���\��J\�k�e�\0���:^�*|<tz�Cg�:Σ\����\�t<��~�r1Ó�[^`}+\�w(%Cj��\��<KAB�-\�ڊ�h\�5|\�{W\��\0�@\�1k��xz\����,��V0\�\�\����p\�S��\�F��(\�rsR<�}SҨX5�\��\�ivn�\��\�;�\�\rԻ�ڋC\�x���\�;�\�7j�\0\�ʀpK=)�\� ۗ�������N�Q\";vɎ�\0A\�4~����u��\0+�w\�a��cxs^q���^�ڜ\�s \�j-]�m�\����Cd��]���#�Wpq��שL.S�x��X\�֛�\�i�%Ei\�\�\�\�G\�}/Q�\�\�%\���5\�f9EO\�S_��\�5Y\'؎A�P�\"�Y�C�#@$I\�?(E8/c�\0��qPz��`��\0_T&\0X.\�+\�r�o����\��b��z�n\�!�\�\'\Z�>�\����s�\078\�4�s�\�\���\�&\�<C�b��5}�x���(�5b��\�C\�C��\�.6�\�V���)�t?�\���V�p b\�\�|�N\\a����b�\�˪̋���\��}\"���\�9&�~�p\��P=ٴt=�\�\�\0l[OpE��\�	c\\7v� �|!k䎡�\�_f���\0W\�^��e^\�٤m<��5S��\�ǥ��\�a�\�E����U��Ɏ\�N9GI\�\��3F�\�\0��\�<=>�\�#E�\ny���\�\�~�`�\�R�<�u\\�\�&��\����+\�79|�\0�0���C�dc�~����\�\�\�y\�i\�v\�;&�G	\��ѯ�S�\�S\r<H	w\�������c�s�q*w�@\�PD����C\�ve_\�H.\��VvMW�9��#�\0`R�\�f\�\�\'S��^�H\�w�9\�\�k�x\�\�:^c9K��\�G~�~�1�0\���Χ\0�+�\0�4P=w`1�\'݇��\�,\'@_\��=�@;Ù\\DJ��\�x$J���p�\\u�1X=N{\�7\�X#�j1\�Q��Ղ����\�\�i�\�\�\"\��\�T�\�\��UQV-\�m<EW\�ܞ`\�5�rQ;���1<�S�D�� ct�p��m�ȷw\�Ѳ	:\�\�EK��\�1\�}�s�\�y��_\�\��\����Q\�\�\�\�\�\�u�\r�D�,�\�*\nvgf(�\�z\��q@�]�;\�թ�\���8�O�P�2�9t\�0F1˗�j�:C�ȸV\�^�\�\�P�M\���#\�G����ь\��d\�E\����PCv�YwqO��Hqdk\�Vj\�P���)�J^�\�B���ʚ>���\�;�U�\��CICK媖�w\����r}3E#\�\�/\'\�ǟ�.-\�Xf~�p�p\�\�\n]�j\�N\�%���d�;\�\�\�p#\�\0�k\�F]Z<�\"��lG��/\�*\Z�*3p\���c\�k�\�\�X��c�\�f�\�c\�\��a�7.2�x�h?w��6��0\�\� �m�]��\��S���|�\�2\�\�\�\����I\�{׸mDE;�pU\�g�\�JeJ�\�%�09c\�5.�=e\�Pʆ��d}�G�],���9&����d�#\�3\�䟥��\�?��z�#8\��#�C��).\�5\�	X�\�i��\0��7���\�\�\npr\0jQ+5\�L��\�c��R0s\�\�.X�gl��)�c�\�25]w�\�\�_�\"\�\��9~�8\�w��R\�y�Bq�V_h\�!6�`v\�(ڔ�R�+}-�@�Li�\�\�?\�\n���\�!\�(t8t�82ǿ[\���߫�n^!ن�@��\\\rKE}��\�\�\�z�\0\�\�\�\�\\�Np\�M�<\�dB�B�-\�H�eZ;�\�\�6�\�i7ÍP\�H�\�K\�\�>K�A���\�]�ҿv/��;HB�\�A#\�w!\�\�S\�x\�c1�\�˒��s5q\�9y�\�x\�8�\�?\�r��\��\��^1�\�\\%e�2`\��\�k\�g�\�O\"\�N\�օ\�b�[\�\�`b�\�4�a\��E��1����\�\�\�4\�k\�\'\�0�{\'\�?�\�\�S�;�1\�\���4�����e��/$\�F�M.���SF�\�_4n#hxn\'��%Ša[�\'�\0\Z�A�v\'he\�\�pY(\'~�1�rO�J�e�C\�l��_�/I\r\�e���Sxw�r>c8/�IbW�\�\�\�h;<�?�h\�\0ISL�\�yl_���ZU�cO,�{g����AU\�@�K\�/O��Ō��Q\�\�Ó�\�S�\�x��r�\rto�\�\�r\�,_�\�\�@r�N���rҊ-ߴ\�\�LվcL�鬻\r�!\�t��\�\�\�ܜ��\�+\�\�\�r\�%\�p\�1\�\nC�\���\�\�(B2��\��٩\�<�\�\�b`�#��!%��V��\�h\�\'1�ῴ��I\n\rh\�\�QG�\��\rJ%EW�Lsr�\�1�MᏒs\�H���\\��\�c�\n\�s8\�|��\��g\�%\��\0���S����Ob\�m��^߰�\�<�\�\�O�&q4K)��\�|���H��\�\��1\�-A\�\��\\�\�\\_I-\�Ξ�\�\�q�Q o�\��\\2B8���\0�\�rs\��p\�.e ثq\0�\�/\�G(Ub� �\�o�ƄP\"���~=H`��c\�=oE\��4>\�\�\�f\�.����\�8_�\�c\�x��1\�:x�.w�~5\�\�9\�\Z��b֟\'B�a8��06i�67�\���z>`\����A��b�qe\��\�A��\�,���r���ectC-N\����O�0�{c�a;\�\�r���\�;��s�~�N,W6)^55C���\�c�}�\�n,�\0\�\\f\�\�<��a�\�\�\�\�\�b໗a\�\\c\�\�\�Ŋ	�,�Bp\Z�$�\\\\���lB�\�\�!\�\����_w��\�	I�s�\�\nJN�Up~��\�W����O�\�=1\�v	K.9X\�H4xqr\�\�Ë\�;\��L��c�\�!�^򑃼p\�D�CH�8!w�3�vx��\�,z�c�Kbd�\0q�t�\�YY�\Z�OԧW1�N�V�פ\�E�|��m\�!\�k�����&ݙ~�����w�f\��	���\�H\�g\�0����;;\�:\���X@�䏖\'���{\'� ��c\�\�Z���HH�J$`@}\�1���&\�DH12��v���L�L�����+++*\�Ky���\0R ��\n\Z)-q�g��\�ߏ\�)\�.`���\���<\�?\\\�m��� S얬\�Ri;D�\���\rzk�*Gk�6*\"(t8\�`)+�D��/`Z\��	��F�c���\�����:��\�W;�X�u��\�U����\�\�\�\Z�Yd>��[G�\�\�>quq��\\�8�I݊8\����\�\�B\�e\r��^��㑚>l ��w\0��G\ZF\�ԴR��\�n\��\��\r��%\�\r�<�%��x�-\r\�]��/��x���\�b�\\�,\r^��;�?R�\�\�\��|W�\��\��\�\�=��\��\�\�\�1^��9�Ux#��B\�\�ZvB�7�y\�}�z\�S�s�^\�?\�&�\�6\�\r\�|[\�$�\�վ?�|���ONԮO\�%\0:h\��E��G]���4�P�\�^)G�\���\�h�\�h�!��`B��9{\�s׾Ptr�o�	b�&�`J��	\��\�\�C���6\�K\�@�;s;O\�9�\�q`\�L7\�\�4���}��#���\�\�>\�\�\��@�0\�\�~t�4@������z��\�t1Z+��a��p�.\�\�hEl�+�$��\�,Qɠ\���v{\�Z#\��J��\��\Z\�%��zG˵�0�]�} 3Mq\�6\nSL|�8�\�=�����\�\�VhK\�%\�!��\'�i\�,� |��k�(K�\�1\�\n\��q��\�0k��\�\�\��\0\�\rQk<TW3t��.\��N\�sR�\�\�\Z\r\0\�p�;y�a\Z��Ֆi\�5��X\�Gz�R�+è(�U�\�vC]^\��pHn����O\�_����c�U*�쒳�\�����Di�\�m\��k����f\�7^\�\�q�}~I*���\\t�q\�\�f�\�\�\'*�$po\�\���\naLn�Qm�i���[@\�\�\��p{��U��\�-��ȫ�{�б�\�����qo��\"��\�9\Z`�il&�s+\r�n��\�h6b��\�)�W[�4�B�rsNNcI\�#d��7	qe�b�\���,��y1��R����\�F�8�G\��gYBK\�D <��P��\�e\�3�}���)�\��\�i��16/�qp\�5�^N\�S���G��A��[m�c���n\�i�/�FPh�L�7�A��\\��B�n�\"��\r\��+7mCЂ�Yq�gZ\\���\�i<MKa��YA�uݨ3�:W�b���\�X#�TU)e6�J�\�boה\Z�l0\�\0�{%騧�Gs�\�\�\�\�EĲ\'j\�<L\�\�a\'ap\�ZUo\�*ƀ\r�\�pPI䖗nj��\\3g�\�F\�RYb?�#V\�D��>P�>.k\�{��\�2%Vʈ\�,[9\� ���*��G�v@z,�r\�~9�5�O|Z\�Ia�#c\�oOE\�\���/\�l+�\��-��{�z\�[\�\\X2\��\�1�8z\��spOԨ�^\�\'�U�K�E�N4ڪ\�\�\�4y�b �\��\�L 0�$\r;�\0K\�\�`��=%\����K*\�J �A�&�\�P�XV�V\\�_C�<Q�\0��>\�\�Y�\�Zn胯3@P���;�D)*�!b\��{�qIK@�\�\�m�����<0\�@��$P.�.\�\�\�\�T\"[v��-n@$�{I#�\Z��	r\�\�O2B\"\"S\��?f<;�\n��\�\�\�R��5\�w����76Kf\�^�._2�r�rȉDd�D�qe˃,�y\�\�\�|\�p�\��\�\�\�KK@�\�e�2ҙL��L�S--,@���8g��͌��.ު\�A����C�/}�%Lց\��?$_<,s�r>\�\"\�z��G\�\'�3�8�x��\�\r\���[��\'\�(�\�\�\�;\��R�a��S�\��B\�\��Hi�MԊ��\�r�x�\0�\�\�0\���\'Y\�&\�\�\�jK��\�\�{߉��=\"a�9C�R�q\�R\�MΣ��\��0��b{L��?\�c��{�?�\�?���nT��\���#ؓف\�R���p[\�[�\'�d�ğؓ\�r$\�\��\�\'�\��\�;\�\�\�u����}�\0懅��\�@�V��@\�YX]	�wR�\�x�A\�xS��u\���\�\�\�u�v\�_�^\�\�Q�\�\�\�bj�\��\0�\���{/� ܇\�\�\�\�M�\0�\�*n�\0\�@^\�\�7\�c�4�\�Q�H��\�\����\�x>u\�\�\nE?���\��P^rqm؟��?	�R\��2\�O�	W�I�ZO\�o\'��7�qO�!�\�+�O\�S\���\�o\�\�\�4\��g��\�c\�~4��\�\�\�c�fiD?�+�DO\�,�$�D�����``-�\����\�\�fܓ\�=P�O\\m\�8��➹랹랹랹랸�c\��z\�➹gi_i\���x F�\"D�#\��)\�W\��\�y��>r\�`��h�!���ck��\�g\�>(�����\�\"?\�J���\0A\��<~�T�\0	\��\�/؟\��\�[��\�|\�<�\�\���>\�\�l\�)��po))\�\'̬��YY_2�̯���$\�����\�e|\��I_2�b\"|\�q�\�.2\�ӌ!`\�:���1x�y��8W�\�\�\�\� ��K�M4T�\��>9\�\�)��c�)\� �R��7a=DI��\\	e���{ig\�9$�\�W\�9���A��`��s�\�4J��XG�\"4�r\�n\�G0�\�@`	$��!5�H}5\�\�\�w�\reD\�X�҈�F�f܉*\0\�.\�\�6!7h�\�Fn�\�\�1\\lH�\n�\�<$�\�RR0�*�Ģ{ On���(��r����\�d�A�ˎW�h\�\�҇h�#\�Wv���D�@�����n\��W\�؎	�CnQhx�Z���\�;\�b�8c�iT�ʤ*\���s�asr\�Z\�D	\�Gd0\�$a,�K�\�g�0\��.^�}@�z��\�Z\��Zvx���\�Wpd\�R���ąUFIx.3��dUT\�\�\������\�6:x@��n)ˑ�����\�\�!*:�%\���U\�D\�\��\�+\� �>��\0-�̀\�\�o\��\03�/��\01\�G�/��\���q\�\�\�[�s���\��\0�&?�����\0�\�/�^1`�\0��\0<%��\\\��K\0��T\0�Gx<%�\�8�.˒V\�!�5�+\�q��UD�gwѼ��\�n���ۀ��pGa\�\�Sl0��z����\�%�ꞹ\�\'�\�\'�<P({\�|\�`�\�\�\�?��\�\�I0TR\�J���ʅ}\�P\�T�9\�X\�>zGW\�FR!\���+q�\\�\'4��\�`�N5��u\�\r\�J>�\�<_�)g䏢]�$¾\�5g\�&�\�PH\�n1��\Z��6�\�M! B\\䕼\�B}j\�\�\�1�\���R��\�\�qOO�����\���\'\�@c9\"ʏ�C\��\�ɖwt8\�ĕ\Z헅\��@�{0 ��*V�J\�8:L==�à\� 1}DX\�\'�j\�q�����(�;\����I�͏\���f~\�u�\�\�\Z��\�\�s?z\Z��/��^+�,Q\�U�}�I���`1R�N��\'~��pG��q\��\\�?\�8����\��C_<>Q�r;���\��\'\�DX��\�\\\�r�>�\��\08��\n|\�Ы���J\r\�)\�\�	$%0�R�J�\���\�R\�:׋�l=p\��8\�.E�\�rc�\\\�	t�ne*c�m�Zb\�\��$f\��,,,lS�r�\0=�[�\�sP�i\��\0�_�b�ql�\\��Z��\�\�\�\�\�\�˄%���\\�v\�\�\�\�\�˃����.^.\\st1\�|\0D䄴o�]\�\�\�\�8	B�x�1<�\�t{x�\���\0c\�\��q\����&=\���R1�\�\�54\����\�\���*��;\�˗�db٭\�m.��\��`p\\�U.\\\\.\\dX0~ۄT����E�\0�8��o�|Oc�_\�\��Dy�W���L\n\���?\�Ko\\KaO\�\�>��P��Tt\�\�~TKo\�G��T/A\�sD�\�<��5�ʏ9��O\�\�\��lK��EJ��r\n\��$��\0�U�\�LK�S�h�\�?��\�D�� \�\'�m�@���\��R\�샖{	\�~g�~\���I\� �1�\�H$dμz�L����{s~\�>\��>H\�\�{%\'�a��\"��e ;�F�\�6m)\ZD6,�\�R\�\�\�_ĺ��0%�c�̦��-\�u\"� �\�\�۰j-e�\�@�G]��8/��M#ql\n\"\�T�%-~�6\�E\Zn��\"4l�\�\�%�IO0@(	�\0GC��I\�\"\�Q\�EXh\0G\�=R��i1NЋA\n^���Q���\Z\�;E��\��X�D(�J\�D\n��=Qa;����\\�l<�\�\'�g��^\��.�螦 y ˴�\�!�ߔ��}\��`�o\�+)�{��\��+�*�\�-\�4#MX|\�.�i�A{�J��\�A\�w&�̨���`t_|HÀ\�RD@\�v�!;.C�{�\�T��Tc\�!A\�yE!;��\�ѾW[��ġoGh�!z�����u*\Z��J�{Oz#����\0��1���\�V,Ք\�G3\��<> @��b8H�\�l\�T�\�]5\�\�T�\�\\\�\Z\�lך��X\\��N\��Cm9�E�?��d��C\�\�� Qa)@\�\�[k�*h�}\�s�bɅe��\��M�/\�{`\�\�h\�=���l��PwT6rv�!�\�vDn�nz�w*+�\�D�\r׺�\0\��y@3\�\n\�h0iz0�B�.��\�ի3H�\�I}��\�V�\��\�\�,��\�c�)���6Rϼn*K\��\�Żb;:`\�}�8I	G#]��\�\�\�����\�\�<(_�_�7����dG��Sr\Z?�\"�;��\�	c��bB\�mJ:u�\�jR�\�p|\�T�!�*4\�X�\n�)p\�=�T��p�2W�p\�DD\�\�c/\rM�@ h[\�|\�\�5��!\�Fj��u\�9PU\0\�`���j)��#f�\�.5�#̳�����SXk\Z�B�\�P/+	c\�jrN%M&\��=Z�8\�\�ǘ\�NZHM.��7/�v�sK�h���uK�\�N\�t\�i�\�\�\�!S�qi�\��֩j\�\�Ƴ\�p\'�yN\�\�\�\�˥.\�X:\�@]/eᬲ�\�M\�\�jD4c͓��=\"\�\��|X�B��N�/!AA\�\���,�\0\n\�,��w\�-+�@\�@��`I\�ˌ\��\�R�Q\�\�\�İ\�\nE�\� ��5\�wg�\�!.���ư\�\�Na\�n t:_\�\�\Z=�uP\�e7\�/�q�WO��\�uc\�ʌ�\n*�P�D��\��\0r\�E\�)��(3^$+/�h\�\����$��e@\r\�\�\�\�\�Z�\�\�(�Q�m�1|��,L\0�?%\\��>Pf��5����q$���rsw����\�Mڛ\�r\�=�A��p%V�M�%Ex���46N�\�\�A\�)?L�h8�P5Ӟ�iLZY�f\�<ŭ��:^`B��\�UΪs\�5��\�R�(l\���tQ\�\�w�\�\�̡\���(��\������9�5�7(=R\�\�\�\�4<<\�7?|���\�\�B�s\�w\�\Z��߹��\�\�\�1�S>��=\�s\�\�}0�oi$r�W\�\�Y\��\�{%�\r����*Z\'\�q״��T�a<S���|CVAد܃ *G�\n�~ \�-Nϔ�\�qU�x�R\�ͯ�q\r�f�/Q�G\�\\ԋUݩr�\0�\�2*���RQ\0q�q4�\�(\�H]j�́�o\��hȷA\0bxE�!\�U�\�;D�)t D\�Ne,�ރ��Ӛk\�16)���G��fӖB�R͜\�1��\0lJ\��\�,�\�>(\�ß\�{o�3q��%\0/����\0r���\��DiNo\�\�,\�\�����5I*#z%A�\02sV���N\�\�E�IA\Z�\�=��T\�\��Ew��\0�2�ܴ߰�����!;y/�>�����~\�O\n�R��,�ҳS\�鄶{�\�\�߸�\�T�\�\�\��\�\\n\�c�9�\�D��r�\�\���ǐ\�^{��J�_�ėp��P�#^1j���D.�ֲ�u��b��\�{��\�\r�b�\�<x� 4�]�r�\�1JѼ�\�#I\�y\��0�\�*� �h�\�`\�Q\Z\���*7\n\r6\�\�!��\�\�\�\0\�D�o\"\�;\�C\�A����ϺeۊS]M��\0\�Pt�\�\�\'\�o\�	ߵ�Ga?!r֏\"�x�ظ\Z��q�)\�E�\�a&�\0x\�S�\0�n<r�\0\�(�Tv�\�I\�\\��\�\��\�}\�g��C�\�~\�V�U�\��\����S�˝�KW~o�3y�uۙ�Z��\�\nr�\Z\�\\x�\�p?\�y\�|�\�/̥(\�\�\��H���߈�\�ȿ	��\0\�y��M�g��\�;O\�x�	\�\���M;7Q�\�i�\�\��|�Z-]}\�uF����\�)߃��\�n����TmG$�\��9��ZzYŧH8\�\�\'\��\�Y�\���)��I�\����\�S\�����B\Z\�y�4(�\0\�^\�-v8\"\�\�к\�Xھ?\�WH\�C]\����q|���?x_�\�\�|4�}�j��\��o�kV�\�T\�\rvb�V�\0�:\�EKai\��o0%`�\�ѠCOxܯ��G��]��\�%�\�~�`\�Mo��\r\\����yኣZ{�&\�\��B�;\n\�\06G\�\�\n����\�V50[\�-;��KD�!���m\��\0m�S�\�o/\�\\6�4\�\�;WrP�V�s�M�@EQ,\�;�\�;˃�P\�\�g�x\�\�\�\���\�k�8\����Et���|`B\�\�=\�?q�\�\�\�5�%�C�3\\\���\�;u?F�t��\\\�r�U�;J\�\�˄��9��Z\�s\�D�\�Q�\0z\'7\�\'c �9qP\�\�\�ʿ��/Se\�\��	{�N�/3�^�\�\rEPJs4\�\�@\\�\'jqa��c�;\��ǎ�\���sW�Ї�\0\ne\�\�}+\����\�UŽ�\�٣�\n��\�Q�\�\�b#�4�(�x��\�\�}�\���\�>�ӿ���K�n���vhpGa��\�\\\��\��\�+x��F1�\�C�_�C�\�UG/K�$w�./\�e�\�E\�hu9&�\�:{\�G\�4��`6�c��\�,WK\���\�z+���\��9z\�=o@���D%�*X*�X�|�Y���\'4u�qLY>�\�\�ߠ�����;`\�z��\�\�\��\\OMJ\�\�\�ٯ\'���t���\�M&0s9\�k8p\��\"�z/�\0��ަ^��\�\�\�z\r]>e\�w7\0Cjר9H�\�2�~�9��;��O�8c�\�\�\�}|��\�~�\�\��\�,\�]��M�\�)o��+\�McE��\�������$9�\�\��\��8�\�7\�\�,2�v鿦Ǭ�9\�n�f\�\�\�7.k��gl�\�sx���-q\������j)�P\�\�OهX\�9#��/K�W\�Y\�v\�z\�K\�r\�\\b�3u;to&\�\�9�\�x�.n\�N�	G�Z\�\�\�\�\�X9b�oJC/.u\�ǡ\�}G��\��}.u��eaz;|b�\�dt\�\�rb\�&d��{����ֹ���eb��\�z\�q�\�\\2\�\�\�\�\��j�q\�Jg8�\�AP2g�X�ir��=��}n5������ї��\�gh\��\�,�w�{\�y*�\�\�K\�p\�\0w\�\\т�B���謹a�޷N��wұ\�s\�+�z	�\�;�!9%��\�ЏmJy�\�J�O������?��\�\�\�g�s�i�\��\�s�\0$\�\�\�\�������\0$��\����\��\�m�\��\0g5\��O\�\'�S�i��\0I����q�\��)�\��\�s$�\�a?��_�C�\���?\�\'�S�\���\�F��\'�\��\0q?��\�O\�\��S�)��{�q?��\�OK��u�����C��\�~\��\0��\�O\�%\�\'�\��\�U�\�?��\�b?��\�B��\'����%\�\'w�D\�\��\�\�2NI�R\�/��pH�\"\�̰�1�\�\'���1DNQ�\�\�u*_\���\�a��&&\�j�dH��\�GF���\�t\0k\�\�e�83\�,\"P�)\�9�\�*46\�Q��C\Z�Gߘ@R�_a9�\�\�\nlr�\�\��>�&\�&>\�\�,��k�.Q\��A> @O����8��\�4\�6\�\���\�\n?M�J�\���\Zq�`\��J��7�#@�\��\���aM>�\�EP�]g\�?`\�q\�r(\��\��\�t\� \�Gkzoo�;�\Z8��\�nv\�R��ض���*\��&\�H3a�q�\����F��\�\'�\�,me\Z\�\��MR�qU(\��\�+��F\��K��%p5_�f\�vK?D��g�|SÂ7��\�<��\'|�%*�Exq��]����e(ۯ\��_�% �\�`s\�\�%;WK}�\�o��;ZHv�}\�B\�\\�݁�AAʿ�l�����\�\Z�`6=�X�[��@)\�`�?�t\�$\0�J�<���ּ�ҿ���\�\�I\�\�6W���/#uV�\�@8�G���e~#l\�,�]�~\�Ȍ	K��\�%:�,\�q;_0 ����\Zwb� s\�\����M2!P@x3��x\�Uh\��\�\����ae\���Xs���ǈ�\�1}�i���M\"3��U\�\"��0\�l؀phe\�\�+i\�\�m\�ݣ�,#��\��\Z͂\�\�k��\�g\r��\�\�K9��\r���**\�jƧ~\"D�;Ø�ޓ�\�d\�s�\�\���0\�\�>\�r�̴\Z\ZO	�\n�8\�2�M��N	�`Z;��<�\�pN\�U�\�@\0\Z1�r\�\�\r6l��P���5��8Ţ\����Na�,�GB\�K��o�\�\�	\�z/�\r��\014V\�i�a`����Dkȟ��\r�YN�+>�KԤ��\Z�����z�\09y�\�B\��B�c\�\�\0\0\�?�\�&,Gw�\���^\�\�>껢1F\r\�û\n\�\\kn\'��;���\n?i�h�������t\�+�?O�М�ON+�0�I[���\�SkyV2�}�F���V֖�v�9\0z��GD0Ǿ\�b�;�+^ha�t�r\n4[���\�F��ۡWC\�(�\\e�k(ڎ�\�\�$\Z�Q\�\�{�ў�\�60\�\n\�5\�+����\ZЦ�T��\n�԰;��D�Єc�.\�Gl$�6�G[�R\�ͱ{���\�!��w��3\�.[	aqiZg���%�~��i\�X�3h\��`�b\��7\�_Q�\�G����;\�\�!}w/\�b\�r\�hi����y䫶{�9%\�!F\�/\�؂R\�\�@ɛ��\��ȋuR=8�̇\�\rZ���\�oCk^��\0��\0\��f�?��\0\�cݑ1>|�z8\����5J\���\�׍\�$k\"t#6�\n9�\Zw0\�����.��\�>Y=�\�{d�\��O��\�y�{ \�;߬{��~H\�/�(�\0M�\�?\�O�\�\��ƿ�\�{�\��g�\\�����T`wdn7�\����<Yy����\�\�Z8H�/--�X\�Y\�řl\�\�Z_Ų�x�{epw\�\�\�\�\\\�;�*�\��/-/.\�\�\�2�e閸�x�(\�\�>0�\�*K�\�	p\�m�cA`\�\�j\�\�o/���\�R\�˗��qͲ�\�2�]ŋ./Mŗ\�Esy&�/s�1ܺ��ńx�9B\�7��婗}�yY�\�ˁ�q�yI\�I^8<CSX_��p_/E\���E\��6\�LiE틃G��6�W\�=�B���@S�\�\nF�\�e��\�n?4J�z\�\�8Ca��=�d�Z�l�\�,Ԟ\�FJ��¶-IN\��>�^\�I狎D_p�B�u�\�Ŏ-sr�\�\�\�eE\�\�p~�k7\�\�X���\�\�bĔ4\�4�� \\�\�@����\���`b\�Ma���ԢlV\Z�\�%1�Pa��sA\0�\0�w%u]���\n�9\�+<`\�<���\\Bp�\�	p��u\0\0\��`�\n\r��EA�Hs\�\��\�S�\���c\�;�\�\\@�Q��|@H�\�3�BG�eC�q�!�]\�X[��!џ)�\�Y�׿��s��Zj���\��@�\�\�\�\�s0\�Ģ~b�\�A�ٕ��i�V�E\�D�\�\�w�N\�\�Mz,�P�����\�\�\�\r\�.|�\�\�i�e9C��60H��>�z�M0Y\0�\r���\��\0E\�\����H\�iF�ߡ�\�a\�\"����\��E��\�ʉ\\�k�M�\\.\�[u�84�\�\\(␰k��G_i�#�1DW���z�俨$�\�v��N���\Z�sqH�Y\�\�\����V�\�\�f��\�\�\�X\0\�~C�4�a�Ƴ}aS�1H�\�j3�~�\���H2\�%\�.\�\�\�e�\�h\�\�n۹��M\�j\�\�/A��\�qx\�{64~Ь,�b��`�Dvpap\�P>��\�\0�\�շ �vm?S\�\r�i��_\�@\�\�\�>\��򂸴�W\�J[&�\0\�o~,	�`G�욫\�\�ĵӒ\�z�����x\�v�(�䲴N�\���N3�\�h�\�e�\�\��B��3\�(F\� ��\�Ѩ\�(u\�E]y?R�{!�\�+l\�\�t\"��\�\�W�;#�\n\�\��]�_z\�A^<�\�M|#ZVЖ�9 H\�͋Z\�\�ョxo�&�ǌTHc�\�\���Ĕ\�T�\�*�eJ�\�J�*�@��+�Tr�pܮ����+5TH��J�*T�Q%J�ĩX�W�R�\�IiX���*BM\�8��*��϶}؛:D��5)#՞�\���<�<�\0��	�r��Ǘ\��Q2^W�\��\����\'����	\�~	\�\�V\�\'�����>\0,=\����\���OZ,�uD�d��j��\�=_\�3���\�)}\���ٞg=\�\�\����=\�|��+ɚ:�jVjTb�z\�\�)�����D�`#�]�HT�\�\n²T�^���J�*T�Q��T�T����*8N�٬Xz0�\�\�\�˗/�r\�[.^��r\�k��.\\Yr�Yr\�r\�\�K\�\�\�\��^Ka酰�----��T��6��\�E\�ih\�^.^[*���\�\�/}Z�ƾ�\�q�_C/\�ܾ�1glܳ\Z�/�\�/7��.5��^�\�.\\��\�%%��e%����\��l<�\�6s\'DKt�w.6t$Vs�L��\�\'S\�	\�An\�\�=\�g1�\�v2Q\�\�g8�\�/\"/�|B��}\�@\�-\�j�~X[\�Q��\�\�pr1h�x�͛�¢\�Cot\�Ih\�\�\�t*[\�=	\�K�Ǉs叶W�}�\�\��ϓ\�>Y�ϒW��\"y�\��k\�S��M{\�^򦥍EM^0�̩P���\�|�\�~!\�\�U�\���\�<�׼p�\�ϾW��I�\�QR�f��\n|��\�\�\�[=s\�\�[=\�\�\�=mG\�\�K9�\�\�5r��zHxI\�bz�\���!\�OBz\'�=I\�GĞ����=loZz�֞���Q\�О����OJzS\�����=/B4ǥ=)\�OJ=�=,�\�^����=f7�z\�֞����=I\�OBzSҞ������\'�=iY�\nzH�QN\�|I\�OQ\�=D|I\�%x��R�	^$����\�Y\�R7�\�	W�I�q����О�\�\�a\��Pb�?�Y\�F\'C\�tůw?\�g��\��\�\��\�\'���\\��\r���8B�.�=\�{P.���Զ\��S�l�(;C��\���~|���=\�\�3�?���\��\0���$\�#�\�?�O\�+PW�\n\�P�q�!\�~D���,?�\��\�\�\�O\�\�\��du��\���<{?�?��\0��\0\�3\��\0Wk�a\��\�\���\'\��c��^߄�\��\���\0��|_���|G\��\�z%,R�\�1���z�qJn&0m���\�nnn���\�{�\�\�w�ĩj�x��iiz\�^\n�\�\�\��eM\�\0M\�<\�|!\�#\�?0�e^\�`j{\��b\�\�\n�\�\�-\"\��.�¡=���	x9r\�7s�\�v\�ܯ{�d�N�\\��2\�nL�/3F@� �6M�E��F;;~\�ujb%9c)6<\�XK\�Q\�ZQ(���kE�m\�\�ʝ�\�\�\�\'S�P<�B\�$jV�\� �\�Q\��\"���Ӗ\�.�\�#\�34.(�n\�t��x\�	L1�z6q(�\�Z�13X%\�D\�<*e|\���Dy��\�\�8�;��\�wm\�oF(B���\ry�q\���\�\�\�\�ܮQ@n��VHqU5c��\�$\�\�\�.\��1\�p�m�\� R\�\�\�\Z�w��2��\�R��D�F\�\'�-\'�/z��?�\�f�@\�\�	\�+P$\�(\�6���W*@\�V��bԔ\�\\IK*�\�\�T6%�a\\Ē�we>b���-\�v\���[\�\"oMu*Bm\��V�\�)�,��]\�Q,H56��\�8a;\�^:�(��q�1Ѳ\0y%�\�@7p\0!\�{\�\�J{�\"\�\�\Z�(v��c\ritN��av�,�U��\�B\�;wzJ�\�!j��CҘ�5\�z~\�}e)+\�.��1%�\��\'\Z�x�\�\��5F�^\�\�\�\�wl\�㈔��\"�+\0�\�*Q\��F9\�9;\�K^*w��V;\�&��	\�9P\�j}ᚲ4ET-�n\"���\�\\h�\�.u*��$B\"]ͭ\�c��Pw�\0\�\�7�Clin#��؅ #���83�ƒ��0�\�F5\�F5�TPA@ F\��\"��O\�ܫ���\��74<<l�>`BZ�\�P\�r*\�\��[4\�)m�A}\�m\�\�\�n�����ڣ\�*U�\�2�1��J���x�K[#SPz�e�&�!j\"\"j00n\�./��4\�7*�\�̮!�	�$)z��`�\���#\�&��8��\�S\�B=�!�\�;Cx\�\�\�X�<\�	\"�b�S\��a\�W%GH\�\�\nvǲ\�U�A;TE[�l\�,\0\�P\��\��\�\�E�\�[�\�ĦD,��Q�\r\�.\�\�$e\�r\�\��1\�a]����\�\�)��۹sZ��)\�S)b2Y�����aX�qޱPE��+\0/po��I\�\�EU\�jq\�\�\�	J�\�.X*+�%�\�k�\�,t�\Zg1�l �!\�J0\r�\'\�\�f7�z!\Z��ΥK��!M���g\�eo\\6B�H\�P]K0U\"n�\�.��\�\�y�f\���\�e�K�7�\�A����\Z\�HK�#Git� \�0&\�p�e�\�r�F{�Ի1D� �\rE5��0CQK�1���\�\�\�\�$�%\�DV\n/MO�>�\�\��\�{�n\��\�kG\�K\�0K�H��\�\�$\�\���x�|�\\\�6�7Q\\E��1�Ixs\�2w��q�C>p%y\�Nf\�I�\�\�������ۘ��e@�J\�r�ŗ\raƱ\�4��󨓉��g\�\�/�=�\"l��� \�n<\\\�ਲ\�eaYp�q��\\s�\�h\�\�j\�Z�\�{�o���Qj/~�\�\�4�\�-\�c�\'vv�Q*#݇B��A\�n0��\�00s\��2��{�b��q!c,��\�\�e-\�h�؅e\�\�	D�\�w��\�pYl�)�l��YGxEFWh��j~IK�\Z4�tl(��y+r��גpN~\�0ÖSl\�,Hkpܻ4¬�\�(u6YU�,P\�-\��}�xЮ҅��,Y-\�\\{˼^�n.9k]a\�x츞�|\�EU\�\0��\�z\"\�VԤ�Q.ℰ�\�(F��MD\�0q�\�9�8\\�\�%%��^\�5\�\�\�\�$�\�Ԗ,�4jr\����\'&m8)���\�\�n5q\�R���1�(�t\�a4��;\�j;Q�m��\�\0IxWW\\4\�Q\�x�-\�{\�@ K<:���\�*�\Z�\�\�!\�\�88�ͷ:D\�\��P6[y!~&\�R(q�\\\�=\�\���B+l��Ƥ8\����r�\�\�!\�QD�@\�6�(\�Z�%ۉ�&�Ѳ(\�lNX�\�z�g�K\�Wx�dю� \�v`#\�V������O� \�6Q.�=G\�PO�^Y\�\�Q�%�|��/��4g=�\�v�ɨ�R��d\�\",�\�*^�\r�\�n-�O)W�,�\�/�Q��?�Z\�\r$�yL00`ԸA����\�	;\�؏�ߘlѸ*�C�y�\�epJޘ�VԵԥD\�w\nsa\�\�!\�\n);7{\�*�\�V����ȏ�-�%�;ĩm\��s6Bښ8��*�|\�ʵǄbˏ7��`�\�i�{¦�rF�\�_\rCL��dq\�� \�u\�])؊x�\�c{`\��@\�\�\�^\�\��\�(��E��wR���`\�\Z%8�	c���\'`\�5+��Dxb\�W�S44J\�\�\\Ʊo\0\�i�/^Y�\���\�&�5q~X+b��g(\r\�]B�\\t2\�4\�\�\�ܺ&ָ\�NI͸\�.,X1�\�\��n\�^h�*X\�|JX0|�S\�`\'e�Ab\�\�El�@��q�9r�`\�\�G��\"\�;\����K�\���\��2�J�9���/؂e\�:e>cR\�\�\��3�\�',14,'2025-05-17 20:41:48',NULL);
/*!40000 ALTER TABLE `pago` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reembolso`
--

DROP TABLE IF EXISTS `reembolso`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reembolso` (
  `idreembolso` int NOT NULL AUTO_INCREMENT,
  `idreserva` int NOT NULL,
  `monto` decimal(10,2) DEFAULT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `idestado` int NOT NULL,
  PRIMARY KEY (`idreembolso`),
  KEY `idreserva` (`idreserva`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `reembolso_ibfk_1` FOREIGN KEY (`idreserva`) REFERENCES `reserva` (`idreserva`),
  CONSTRAINT `reembolso_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reembolso`
--

LOCK TABLES `reembolso` WRITE;
/*!40000 ALTER TABLE `reembolso` DISABLE KEYS */;
/*!40000 ALTER TABLE `reembolso` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reporte`
--

DROP TABLE IF EXISTS `reporte`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reporte` (
  `idreporte` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `tipo` enum('PDF','Excel') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `filtro_aplicado` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `ruta_archivo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_generacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idreporte`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `reporte_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reporte`
--

LOCK TABLES `reporte` WRITE;
/*!40000 ALTER TABLE `reporte` DISABLE KEYS */;
/*!40000 ALTER TABLE `reporte` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reserva`
--

DROP TABLE IF EXISTS `reserva`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reserva` (
  `idreserva` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `idsede_servicio` int NOT NULL,
  `fecha_reserva` date NOT NULL,
  `idhorario` int NOT NULL,
  `idestado` int NOT NULL,
  `idpago` int DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `fecha_limite_pago` datetime DEFAULT NULL,
  PRIMARY KEY (`idreserva`),
  KEY `idhorario` (`idhorario`),
  KEY `idestado` (`idestado`),
  KEY `idpago` (`idpago`),
  KEY `idx_usuario_reserva` (`idusuario`),
  KEY `idx_reserva_sede_servicio` (`idsede_servicio`),
  KEY `idx_reserva_fecha_limite` (`fecha_limite_pago`),
  CONSTRAINT `reserva_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`),
  CONSTRAINT `reserva_ibfk_2` FOREIGN KEY (`idsede_servicio`) REFERENCES `sede_servicio` (`idsede_servicio`),
  CONSTRAINT `reserva_ibfk_3` FOREIGN KEY (`idhorario`) REFERENCES `horario_disponible` (`idhorario`),
  CONSTRAINT `reserva_ibfk_4` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`),
  CONSTRAINT `reserva_ibfk_5` FOREIGN KEY (`idpago`) REFERENCES `pago` (`idpago`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reserva`
--

LOCK TABLES `reserva` WRITE;
/*!40000 ALTER TABLE `reserva` DISABLE KEYS */;
INSERT INTO `reserva` VALUES (1,3,1,'2025-06-10',1,2,1,'2025-05-13 04:40:00','2025-05-13 03:40:00'),(2,4,2,'2025-06-15',4,3,2,'2025-05-13 04:40:00','2025-05-13 03:40:00'),(3,4,1,'2025-06-03',4,1,3,'2025-05-17 20:41:40','2025-05-17 19:41:40');
/*!40000 ALTER TABLE `reserva` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rol`
--

DROP TABLE IF EXISTS `rol`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rol` (
  `idrol` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `nivel_acceso` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rol`
--

LOCK TABLES `rol` WRITE;
/*!40000 ALTER TABLE `rol` DISABLE KEYS */;
INSERT INTO `rol` VALUES (1,'Superadmin','Acceso completo a toda la plataforma',3),(2,'Administrador','Gestiona usuarios, reservas y servicios',2),(3,'Coordinador','Asiste en campo, marca asistencia y reporta incidencias',2),(4,'Vecino','Usuario final que reserva servicios',1);
/*!40000 ALTER TABLE `rol` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede`
--

DROP TABLE IF EXISTS `sede`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede` (
  `idsede` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `distrito` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `referencia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `latitud` double DEFAULT NULL,
  `longitud` double DEFAULT NULL,
  `activo` bit(1) DEFAULT NULL,
  PRIMARY KEY (`idsede`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede`
--

LOCK TABLES `sede` WRITE;
/*!40000 ALTER TABLE `sede` DISABLE KEYS */;
INSERT INTO `sede` VALUES (1,'Complejo Deportivo Maranga','Av. La Marina 1350','San Miguel','Frente a la Universidad San Marcos',-12.0795,-77.0873,NULL),(2,'Polideportivo San Miguel','Av. Costanera 1535','San Miguel','Cerca al Parque de las Leyendas',-12.0758,-77.0902,NULL),(3,'Centro Cultural San Miguel','Av. Federico Gallese 750','San Miguel','Junto a la Municipalidad',-12.0774,-77.084,NULL),(4,'Complejo Deportivo San Miguel','Av. Universitaria 456','San Miguel','Frente al parque central',-12.0689,-77.0795,NULL);
/*!40000 ALTER TABLE `sede` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sede_servicio`
--

DROP TABLE IF EXISTS `sede_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sede_servicio` (
  `idsede_servicio` int NOT NULL AUTO_INCREMENT,
  `idsede` int NOT NULL,
  `idservicio` int NOT NULL,
  `idtarifa` int NOT NULL,
  PRIMARY KEY (`idsede_servicio`),
  KEY `idservicio` (`idservicio`),
  KEY `idtarifa` (`idtarifa`),
  KEY `idx_sede_servicio` (`idsede`,`idservicio`),
  CONSTRAINT `sede_servicio_ibfk_1` FOREIGN KEY (`idsede`) REFERENCES `sede` (`idsede`),
  CONSTRAINT `sede_servicio_ibfk_2` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`),
  CONSTRAINT `sede_servicio_ibfk_3` FOREIGN KEY (`idtarifa`) REFERENCES `tarifa` (`idtarifa`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sede_servicio`
--

LOCK TABLES `sede_servicio` WRITE;
/*!40000 ALTER TABLE `sede_servicio` DISABLE KEYS */;
INSERT INTO `sede_servicio` VALUES (1,1,1,1),(2,2,2,2),(3,1,3,3),(4,1,4,4),(5,3,5,5),(6,3,6,6);
/*!40000 ALTER TABLE `sede_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `servicio`
--

DROP TABLE IF EXISTS `servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `servicio` (
  `idservicio` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idtipo` int NOT NULL,
  `idestado` int NOT NULL,
  `contacto_soporte` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `horario_inicio` time DEFAULT NULL,
  `horario_fin` time DEFAULT NULL,
  `imagen_complejo` tinyblob,
  PRIMARY KEY (`idservicio`),
  KEY `idtipo` (`idtipo`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `servicio_ibfk_1` FOREIGN KEY (`idtipo`) REFERENCES `tipo_servicio` (`idtipo`),
  CONSTRAINT `servicio_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `servicio`
--

LOCK TABLES `servicio` WRITE;
/*!40000 ALTER TABLE `servicio` DISABLE KEYS */;
INSERT INTO `servicio` VALUES (1,'Piscina Principal','Piscina olímpica con 6 carriles',1,4,'987654321','08:00:00','18:00:00',NULL),(2,'Gimnasio Municipal','Gimnasio equipado con máquinas de última generación',2,4,'987654321','06:00:00','22:00:00',NULL),(3,'Cancha Fútbol 1','Cancha de fútbol 7 con césped sintético',3,4,'987654321','07:00:00','21:00:00',NULL),(4,'Cancha Vóley','Cancha reglamentaria para vóley',4,4,'987654321','08:00:00','18:00:00',NULL),(5,'Salón de Eventos','Salón para reuniones o eventos sociales',5,4,'987654321','10:00:00','22:00:00',NULL),(6,'Taller Artesanal','Espacio para talleres municipales',6,4,'987654321','09:00:00','13:00:00',NULL);
/*!40000 ALTER TABLE `servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `solicitud_eliminacion`
--

DROP TABLE IF EXISTS `solicitud_eliminacion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `solicitud_eliminacion` (
  `idsolicitud` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `fecha_solicitud` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `confirmado` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`idsolicitud`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `solicitud_eliminacion_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `solicitud_eliminacion`
--

LOCK TABLES `solicitud_eliminacion` WRITE;
/*!40000 ALTER TABLE `solicitud_eliminacion` DISABLE KEYS */;
/*!40000 ALTER TABLE `solicitud_eliminacion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spring_session`
--

DROP TABLE IF EXISTS `spring_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spring_session` (
  `PRIMARY_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `SESSION_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `CREATION_TIME` bigint NOT NULL,
  `LAST_ACCESS_TIME` bigint NOT NULL,
  `MAX_INACTIVE_INTERVAL` int NOT NULL,
  `EXPIRY_TIME` bigint NOT NULL,
  `PRINCIPAL_NAME` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`PRIMARY_ID`),
  UNIQUE KEY `SPRING_SESSION_IX1` (`SESSION_ID`),
  KEY `SPRING_SESSION_IX2` (`EXPIRY_TIME`),
  KEY `SPRING_SESSION_IX3` (`PRINCIPAL_NAME`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spring_session`
--

LOCK TABLES `spring_session` WRITE;
/*!40000 ALTER TABLE `spring_session` DISABLE KEYS */;
INSERT INTO `spring_session` VALUES ('dfeeaf76-879d-4262-857b-8a946d0c05fc','112cc21b-3c66-4c2f-9d8b-e3bd379293bf',1747516230277,1747516230383,1800,1747518030383,NULL);
/*!40000 ALTER TABLE `spring_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `spring_session_attributes`
--

DROP TABLE IF EXISTS `spring_session_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `spring_session_attributes` (
  `SESSION_PRIMARY_ID` char(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ATTRIBUTE_NAME` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ATTRIBUTE_BYTES` blob NOT NULL,
  PRIMARY KEY (`SESSION_PRIMARY_ID`,`ATTRIBUTE_NAME`),
  CONSTRAINT `SPRING_SESSION_ATTRIBUTES_FK` FOREIGN KEY (`SESSION_PRIMARY_ID`) REFERENCES `spring_session` (`PRIMARY_ID`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `spring_session_attributes`
--

LOCK TABLES `spring_session_attributes` WRITE;
/*!40000 ALTER TABLE `spring_session_attributes` DISABLE KEYS */;
INSERT INTO `spring_session_attributes` VALUES ('dfeeaf76-879d-4262-857b-8a946d0c05fc','org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository.CSRF_TOKEN',_binary '�\�\0sr\06org.springframework.security.web.csrf.DefaultCsrfTokenZ\�\�/��\�\0L\0\nheaderNamet\0Ljava/lang/String;L\0\rparameterNameq\0~\0L\0tokenq\0~\0xpt\0X-CSRF-TOKENt\0_csrft\0$3965a0e3-1619-4ac8-a583-2859e6fa5c41');
/*!40000 ALTER TABLE `spring_session_attributes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taller`
--

DROP TABLE IF EXISTS `taller`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taller` (
  `idtaller` int NOT NULL AUTO_INCREMENT,
  `idservicio` int NOT NULL,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `cupos_maximos` int NOT NULL,
  `instructor` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idestado` int NOT NULL,
  PRIMARY KEY (`idtaller`),
  KEY `idservicio` (`idservicio`),
  KEY `idestado` (`idestado`),
  CONSTRAINT `taller_ibfk_1` FOREIGN KEY (`idservicio`) REFERENCES `servicio` (`idservicio`),
  CONSTRAINT `taller_ibfk_2` FOREIGN KEY (`idestado`) REFERENCES `estado` (`idestado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taller`
--

LOCK TABLES `taller` WRITE;
/*!40000 ALTER TABLE `taller` DISABLE KEYS */;
INSERT INTO `taller` VALUES (1,6,'Taller de Cerámica','Aprende técnicas básicas de cerámica','2025-06-01','2025-06-30','10:00:00','12:00:00',15,'Prof. Ana Sánchez',18),(2,6,'Taller de Pintura','Introducción a la pintura al óleo','2025-06-15','2025-07-15','15:00:00','17:00:00',12,'Prof. Carlos López',18);
/*!40000 ALTER TABLE `taller` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taller_inscripcion`
--

DROP TABLE IF EXISTS `taller_inscripcion`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taller_inscripcion` (
  `idinscripcion` int NOT NULL AUTO_INCREMENT,
  `idtaller` int NOT NULL,
  `idusuario` int NOT NULL,
  `fecha_inscripcion` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idinscripcion`),
  KEY `idtaller` (`idtaller`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `taller_inscripcion_ibfk_1` FOREIGN KEY (`idtaller`) REFERENCES `taller` (`idtaller`),
  CONSTRAINT `taller_inscripcion_ibfk_2` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taller_inscripcion`
--

LOCK TABLES `taller_inscripcion` WRITE;
/*!40000 ALTER TABLE `taller_inscripcion` DISABLE KEYS */;
INSERT INTO `taller_inscripcion` VALUES (1,1,3,'2025-05-13 04:40:00'),(2,1,4,'2025-05-13 04:40:00'),(3,2,3,'2025-05-13 04:40:00');
/*!40000 ALTER TABLE `taller_inscripcion` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tarifa`
--

DROP TABLE IF EXISTS `tarifa`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tarifa` (
  `idtarifa` int NOT NULL AUTO_INCREMENT,
  `descripcion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `monto` double DEFAULT NULL,
  `fecha_actualizacion` date DEFAULT (curdate()),
  PRIMARY KEY (`idtarifa`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tarifa`
--

LOCK TABLES `tarifa` WRITE;
/*!40000 ALTER TABLE `tarifa` DISABLE KEYS */;
INSERT INTO `tarifa` VALUES (1,'Tarifa estándar piscina',15,'2025-05-08'),(2,'Tarifa gimnasio mañana',10,'2025-05-08'),(3,'Tarifa cancha fútbol',50,'2025-05-08'),(4,'Tarifa cancha vóley',25,'2025-05-08'),(5,'Tarifa evento social',100,'2025-05-08'),(6,'Tarifa taller',60,'2025-05-08');
/*!40000 ALTER TABLE `tarifa` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipo_servicio`
--

DROP TABLE IF EXISTS `tipo_servicio`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tipo_servicio` (
  `idtipo` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`idtipo`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipo_servicio`
--

LOCK TABLES `tipo_servicio` WRITE;
/*!40000 ALTER TABLE `tipo_servicio` DISABLE KEYS */;
INSERT INTO `tipo_servicio` VALUES (1,'Piscina'),(2,'Gimnasio'),(3,'Cancha de Fútbol'),(4,'Cancha de Vóley'),(5,'Salón de Eventos'),(6,'Taller');
/*!40000 ALTER TABLE `tipo_servicio` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `usuario` (
  `idusuario` int NOT NULL AUTO_INCREMENT,
  `dni` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `idrol` int NOT NULL,
  `estado` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `notificar_recordatorio` tinyint(1) DEFAULT '1',
  `notificar_disponibilidad` tinyint(1) DEFAULT '1',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `dni` (`dni`),
  UNIQUE KEY `email` (`email`),
  KEY `idrol` (`idrol`),
  KEY `idx_usuario_email` (`email`),
  KEY `idx_usuario_dni` (`dni`),
  CONSTRAINT `usuario_ibfk_1` FOREIGN KEY (`idrol`) REFERENCES `rol` (`idrol`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES (1,'87654321','Admin','San Miguel','admin@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. La Marina 123',1,'activo',1,1,'2025-05-13 04:40:00'),(2,'75234109','Sofía','Delgado','sdelgado@sanmiguel.gob.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654322','Av. Costanera 456',2,'activo',1,1,'2025-05-13 04:40:00'),(3,'12345678','Luis','Fernández','lfernandez@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654323','Calle Los Cedros 102',4,'activo',1,1,'2025-05-13 04:40:00'),(4,'23456789','Carla','Mendoza','carla.mendoza@gmail.com','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654322','Pasaje 3 Mz. B Lt. 4',4,'activo',1,1,'2025-05-13 04:40:00'),(5,'12345677','Carlos','Lopez','carlos.lopez@pucp.edu.pe','$2a$12$dph5tAef7Fp9jw14axukY.5YWxJ3khz8bCzGoXqHUlGUUDGxIR1em','987654321','Av. Ejemplo 123',3,'activo',1,1,'2025-05-13 04:43:48');
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `validacion_usuario`
--

DROP TABLE IF EXISTS `validacion_usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `validacion_usuario` (
  `idvalidacion` int NOT NULL AUTO_INCREMENT,
  `idusuario` int NOT NULL,
  `codigo_validacion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `password_temporal` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_expiracion` datetime DEFAULT NULL,
  `estado` enum('pendiente','aceptado','rechazado') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pendiente',
  PRIMARY KEY (`idvalidacion`),
  KEY `idusuario` (`idusuario`),
  CONSTRAINT `validacion_usuario_ibfk_1` FOREIGN KEY (`idusuario`) REFERENCES `usuario` (`idusuario`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `validacion_usuario`
--

LOCK TABLES `validacion_usuario` WRITE;
/*!40000 ALTER TABLE `validacion_usuario` DISABLE KEYS */;
/*!40000 ALTER TABLE `validacion_usuario` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-17 16:14:53
