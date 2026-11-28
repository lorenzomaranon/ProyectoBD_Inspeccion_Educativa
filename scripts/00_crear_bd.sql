CREATE DATABASE IF NOT EXISTS inspeccion_educativa
 CHARACTER SET utf8mb4
 COLLATE utf8mb4_unicode_ci;

USE inspeccion_educativa;

-- Borrado en orden inverso al de creación (primero las hijas)
DROP TRIGGER IF EXISTS trVisitasJefeIns;
DROP TRIGGER IF EXISTS trVisitasJefeUpd;
DROP TRIGGER IF EXISTS trTareasJefeIns;
DROP TRIGGER IF EXISTS trTareasJefeUpd;
DROP PROCEDURE IF EXISTS comprobarJefe;
DROP TRIGGER IF EXISTS trInspectoresUnJefeIns;
DROP TRIGGER IF EXISTS trInspectoresUnJefeUpd;
DROP PROCEDURE IF EXISTS comprobarUnJefe;

DROP TRIGGER IF EXISTS trTareasSolapamientoUpd;
DROP TRIGGER IF EXISTS trTareasSolapamientoIns;
DROP TRIGGER IF EXISTS trVisitasSolapamientoUpd;
DROP TRIGGER IF EXISTS trVisitasSolapamientoIns;
DROP PROCEDURE IF EXISTS comprobarSolapamiento;

DROP TRIGGER IF EXISTS trVisitasEstadoDesplazamiento;
DROP TRIGGER IF EXISTS trDesplazamientosIns;
DROP TRIGGER IF EXISTS trDesplazamientosUpd;
DROP TRIGGER IF EXISTS trDesplazamientosAlmuerzo;
DROP TRIGGER IF EXISTS trDietasAlmuerzoIns;
DROP TRIGGER IF EXISTS trDietasAlmuerzoUpd;
DROP TRIGGER IF EXISTS trDAPDiasIns;
DROP TRIGGER IF EXISTS trDAPDiasUpd;
DROP TRIGGER IF EXISTS trCursosDiasTotales;
DROP PROCEDURE IF EXISTS comprobarDesplazamiento;
DROP PROCEDURE IF EXISTS comprobarDiasSolicitados;

DROP TABLE IF EXISTS Dietas;
DROP TABLE IF EXISTS Desplazamientos;
DROP TABLE IF EXISTS DiasAsuntosPersonales;
DROP TABLE IF EXISTS Cursos;
DROP TABLE IF EXISTS Tareas;
DROP TABLE IF EXISTS Informes;
DROP TABLE IF EXISTS Visitas;
DROP TABLE IF EXISTS Anotaciones;
DROP TABLE IF EXISTS DocumentosCita;
DROP TABLE IF EXISTS Citas;
DROP TABLE IF EXISTS Tutelas;
DROP TABLE IF EXISTS TutoresLegales;
DROP TABLE IF EXISTS AsignaturasProfesor;
DROP TABLE IF EXISTS Profesores;
DROP TABLE IF EXISTS Alumnos;
DROP TABLE IF EXISTS Inspectores;
DROP TABLE IF EXISTS Personas;
DROP TABLE IF EXISTS CentrosEducativos;
DROP TABLE IF EXISTS Zonas;
