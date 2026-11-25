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
DROP TRIGGER IF EXISTS trProfesoresResponsableIns;
DROP TRIGGER IF EXISTS trProfesoresResponsableUpd;

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
-- -------------------------------------------------
-- Creaciones de tablas ---------------------------
-- -------------------------------------------------

-- Zonas  ---------
CREATE TABLE Zonas
(	Codigo INT AUTO_INCREMENT, 
	Nombre VARCHAR(50) NOT NULL, 
	PRIMARY KEY(Codigo),
	CONSTRAINT ak_zonas_nombre UNIQUE (Nombre));
					
-- Centros ---------
CREATE TABLE CentrosEducativos 
(	Identificacion INT AUTO_INCREMENT, 
	Nombre VARCHAR(150) NOT NULL, 
	Zona INT NOT NULL, 
	Ubicacion VARCHAR(100) NOT NULL, 
	Prioridad ENUM('baja', 'media', 'alta', 'urgente') NOT NULL, 
	KmDesdeCadiz REAL NOT NULL,
	PRIMARY KEY (Identificacion), 
CONSTRAINT ak_centros_nombre UNIQUE (Nombre),
CONSTRAINT fk_centros_zona FOREIGN KEY (Zona) REFERENCES Zonas (Codigo),
CONSTRAINT ch_KmDesdeCadiz CHECK (KmDesdecadiz >= 0)
);
	
										
-- Citas  ---------

-- ============= FIN TABLAS JAVI ========================================================

CREATE TABLE Personas (
    oid_Persona INT NOT NULL AUTO_INCREMENT,
    DNI CHAR(9) NOT NULL,
    Nombre VARCHAR(50) NOT NULL,
    Apellidos VARCHAR(100) NOT NULL,
    PRIMARY KEY (oid_Persona),
    CONSTRAINT ak_personas_dni UNIQUE (DNI)
);

CREATE TABLE Inspectores (
    oid_Persona INT NOT NULL,
    esJefe BOOLEAN NOT NULL DEFAULT FALSE,
    Zona INT NOT NULL,
    PRIMARY KEY (oid_Persona),
    CONSTRAINT fk_inspectores_persona FOREIGN KEY (oid_Persona) REFERENCES Personas (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_inspectores_zona FOREIGN KEY (Zona) REFERENCES Zonas (Codigo) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Alumnos (
    oid_Persona INT NOT NULL,
    Centro INT NOT NULL,
    PRIMARY KEY (oid_Persona),
    CONSTRAINT fk_alumnos_persona FOREIGN KEY (oid_Persona) REFERENCES Personas (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_alumnos_centro FOREIGN KEY (Centro) REFERENCES CentrosEducativos (Identificacion) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Profesores (
    oid_Persona INT NOT NULL,
    Centro INT NOT NULL,
    CentroResponsable INT NULL,
    PRIMARY KEY (oid_Persona),
    CONSTRAINT fk_profesores_persona FOREIGN KEY (oid_Persona) REFERENCES Personas (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_profesores_centro FOREIGN KEY (Centro) REFERENCES CentrosEducativos (Identificacion) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_profesores_centro_responsable FOREIGN KEY (CentroResponsable) REFERENCES CentrosEducativos (Identificacion) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT ak_profesores_centroresponsable UNIQUE (CentroResponsable)
    -- R-11 (el responsable trabaja en ese centro) se comprueba con triggers al final:
    -- MySQL no admite CHECK sobre columnas con acciones referenciales (CASCADE / SET NULL)
);

CREATE TABLE AsignaturasProfesor (
    oid_Persona INT NOT NULL,
    Asignatura VARCHAR(100) NOT NULL,
    PRIMARY KEY (oid_Persona, Asignatura),
    CONSTRAINT fk_asignaturas_profesor FOREIGN KEY (oid_Persona) REFERENCES Profesores (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TutoresLegales (
    oid_Persona INT NOT NULL,
    PRIMARY KEY (oid_Persona),
    CONSTRAINT fk_tutores_persona FOREIGN KEY (oid_Persona) REFERENCES Personas (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Tutelas (
    Tutor INT NOT NULL,
    Alumno INT NOT NULL,
    Parentesco ENUM('Padre', 'Madre', 'otroTutor') NOT NULL,
    PRIMARY KEY (Tutor, Alumno),
    CONSTRAINT fk_tutelas_tutores FOREIGN KEY (Tutor) REFERENCES TutoresLegales (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_tutelas_alumnos FOREIGN KEY (Alumno) REFERENCES Alumnos (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE
);


-- =====================================================================
-- tablas.sql - Inspeccion Educativa (MariaDB)
-- =====================================================================


CREATE TABLE Citas
(	Num_solicitud INT AUTO_INCREMENT,
   Fecha DATE,
   Hora TIME,
   Titulo VARCHAR(50) NOT NULL,
   TextoSolicitud TEXT NOT NULL,
   Estado ENUM('PendienteDeRevision', 'Rechazada', 'Concertada') NOT NULL DEFAULT 'PendienteDeRevision',
   Prioridad ENUM('baja', 'media', 'alta', 'urgente'),
   Procedencia ENUM('Agenda', 'Llamada', 'Portal_Citas') NOT NULL,
	Tutor INT NOT NULL,
   Alumno INT NOT NULL,
   Inspector INT,
	PRIMARY KEY (Num_solicitud),
CONSTRAINT fk_Citas_Tutor FOREIGN KEY (Tutor) REFERENCES TutoresLegales (oid_Persona),
CONSTRAINT fk_Citas_Alumno FOREIGN KEY (Alumno) REFERENCES Alumnos (oid_Persona),
CONSTRAINT fk_Citas_Inspector FOREIGN KEY (Inspector) REFERENCES Inspectores (oid_Persona),
-- si es concertada tiene que tener los 3 datos:
CONSTRAINT ch_estado_cita_concertada CHECK (Estado <> 'Concertada' OR (Fecha IS NOT NULL AND Hora IS NOT NULL and Inspector IS NOT NULL)),
-- si es rechazada no tiene inspector:
CONSTRAINT ch_estado_cita_rechazada CHECK (Estado <> 'Rechazada' OR Inspector IS NULL),
-- si esta PendienteDeRevision no puede tener niguno de los 3 datos:
CONSTRAINT ch_estado_cita_pendiente CHECK (Estado <> 'PendienteDeRevision' OR (Fecha IS NULL AND Hora IS NULL and Inspector IS NULL)));
-- falta por decidir si hace falta un trigger para la tutela -> !!!


-- DocumentosCita  ---------
CREATE TABLE DocumentosCita
(	Num_solicitud INT,
   DocumentacionAdjunta VARCHAR(50),
   PRIMARY KEY(Num_solicitud, DocumentacionAdjunta),
-- Si se borra una cita tambien se borran sus documentos -> ON DELETE CASCADE
CONSTRAINT fk_DocumentosCita_NumSolicitud FOREIGN KEY (Num_solicitud) REFERENCES Citas (Num_solicitud) ON DELETE CASCADE);

-- Anotaciones  ---------
CREATE TABLE Anotaciones
(	oid_Anotacion INT AUTO_INCREMENT,
   Fecha DATE NOT NULL,
   Titulo VARCHAR(50) NOT NULL,
   Descripcion VARCHAR(200) NOT NULL,
   Prioridad ENUM('baja', 'media', 'alta', 'urgente') NOT NULL,
   Inspector INT NOT NULL,
   Centro INT NOT NULL,
   PRIMARY KEY(oid_Anotacion),
CONSTRAINT fk_Anotaciones_Inspector FOREIGN KEY (Inspector) REFERENCES Inspectores (oid_Persona),
CONSTRAINT fk_Anotaciones_Centro FOREIGN KEY (Centro) REFERENCES CentrosEducativos (Identificacion));

-- =====================================================================
-- MIS TABLAS (hechas por mi): Visitas, Informes, Tareas
-- =====================================================================

CREATE TABLE Visitas (
    oid_Visita SMALLINT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE,
    HoraInicio TIME NOT NULL,
    HoraFin TIME,
    Estado ENUM('Pendiente', 'Finalizada', 'Rechazada') NOT NULL,
    Responsable INT NOT NULL,
    Jefe INT NOT NULL,
    Centro INT NOT NULL,
    -- En la mayoria de atributos pienso que puede ser NULL (no pongo NOT NULL), por ejemplo, la Hora cuando la Visita sigue en estado 'Pendiente'

    FOREIGN KEY (Responsable) REFERENCES Inspectores(oid_Persona),
    FOREIGN KEY (Jefe) REFERENCES Inspectores(oid_Persona),            -- No voy a anadir ON DELETE ni ON UPDATE en las FK porque voy a considerar que un Inspector
    FOREIGN KEY (Centro) REFERENCES CentrosEducativos(Identificacion), -- o un Centro con Visitas asociadas NO se puede borrar ,es decir, aplica, por defecto, RESTRICT
    
    CONSTRAINT chVisitasHorasInicioFin CHECK (HoraInicio < HoraFin)
);

CREATE TABLE Informes (
    oid_Visita SMALLINT PRIMARY KEY,
    Prioridad ENUM('baja', 'media', 'alta', 'urgente'),
    Observacion TEXT,

    FOREIGN KEY (oid_Visita) REFERENCES Visitas(oid_Visita)
);

CREATE TABLE Tareas (
    oid_Tarea SMALLINT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE,
    HoraInicio TIME NOT NULL,
    HoraFin TIME,
    Descripcion TEXT,
    Responsable INT NOT NULL,
    Jefe INT NOT NULL,

    FOREIGN KEY (Responsable) REFERENCES Inspectores(oid_Persona),
    FOREIGN KEY (Jefe) REFERENCES Inspectores(oid_Persona),

    CONSTRAINT chTareasHorasInicioFin CHECK (HoraInicio < HoraFin)
);
CREATE TABLE Desplazamientos (
    oid_Visita SMALLINT NOT NULL,          -- mismo tipo que Visitas.oid_Visita
    HoraSalida TIME NOT NULL,
    HoraLlegadaDomicilio TIME NULL,
    KmVuelta REAL NOT NULL,
    PRIMARY KEY (oid_Visita),
    CONSTRAINT fk_desplazamientos_visita FOREIGN KEY (oid_Visita)
        REFERENCES Visitas (oid_Visita) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ch_desplazamientos_km CHECK (KmVuelta >= 0),
    CONSTRAINT ch_desplazamientos_horas CHECK (HoraSalida < HoraLlegadaDomicilio)
);

CREATE TABLE Dietas (
    oid_Visita SMALLINT NOT NULL,
    Almuerzo BOOLEAN NOT NULL DEFAULT FALSE, -- lo calcula un trigger (RN-02)
    PRIMARY KEY (oid_Visita),
    CONSTRAINT fk_dietas_desplazamiento FOREIGN KEY (oid_Visita)
        REFERENCES Desplazamientos (oid_Visita) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Cursos (
    Nombre VARCHAR(7) NOT NULL,              -- formato '2026-27'
    DiasTotales INT NOT NULL,
    TarifaKm REAL NOT NULL,
    PlusAlmuerzo REAL NOT NULL,
    PRIMARY KEY (Nombre),
    CONSTRAINT ch_cursos_formato CHECK (Nombre REGEXP '^[0-9]{4}-[0-9]{2}$'),
    CONSTRAINT ch_cursos_dias CHECK (DiasTotales >= 0),
    CONSTRAINT ch_cursos_tarifa CHECK (TarifaKm >= 0),
    CONSTRAINT ch_cursos_plus CHECK (PlusAlmuerzo >= 0)
);

CREATE TABLE DiasAsuntosPersonales (
    oid_DAP INT NOT NULL AUTO_INCREMENT,
    Inspector INT NOT NULL,
    Curso VARCHAR(7) NOT NULL,
    DiasSolicitados INT NOT NULL DEFAULT 0,
    PRIMARY KEY (oid_DAP),
    CONSTRAINT ak_dap_inspector_curso UNIQUE (Inspector, Curso),
    CONSTRAINT fk_dap_inspector FOREIGN KEY (Inspector)
        REFERENCES Inspectores (oid_Persona) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_dap_curso FOREIGN KEY (Curso)
        REFERENCES Cursos (Nombre) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT ch_dap_dias CHECK (DiasSolicitados >= 0)
);

-- =====================================================================
-- Regla R-09: no se solapan las actividades (Visitas y Tareas) de un
-- mismo inspector responsable en la misma fecha.
-- Si una actividad no tiene HoraFin, se entiende que termina cuando
-- empieza la siguiente: se trata como un punto (su HoraInicio).
--
-- Dos actividades A y B entran en conflicto si:
--   * empiezan a la misma hora, o
--   * A.HoraInicio < fin(B) y B.HoraInicio < fin(A),
--     donde fin(X) = COALESCE(X.HoraFin, X.HoraInicio).
--
-- Si Responsable o Fecha son NULL no se comprueba nada.
-- Nota: DELIMITER es un comando del cliente (mysql, HeidiSQL, DBeaver);
-- si tu cliente no lo admite, el script fallara aqui.
-- =====================================================================

DELIMITER //

-- pExcluirVisita / pExcluirTarea: id de la fila que se esta modificando
-- (para no compararla consigo misma en un UPDATE). NULL en un INSERT.
CREATE PROCEDURE comprobarSolapamiento(
    IN pResponsable INT,
    IN pFecha DATE,
    IN pInicio TIME,
    IN pFin TIME,
    IN pExcluirVisita SMALLINT,
    IN pExcluirTarea SMALLINT
)
BEGIN
    IF pResponsable IS NOT NULL AND pFecha IS NOT NULL THEN
        IF EXISTS (
            SELECT 1
            FROM (
                SELECT 'V' AS tipo, oid_Visita AS id, HoraInicio, HoraFin
                FROM Visitas
                WHERE Responsable = pResponsable AND Fecha = pFecha
                UNION ALL
                SELECT 'T', oid_Tarea, HoraInicio, HoraFin
                FROM Tareas
                WHERE Responsable = pResponsable AND Fecha = pFecha
            ) AS a
            WHERE NOT (a.tipo = 'V' AND a.id <=> pExcluirVisita)
              AND NOT (a.tipo = 'T' AND a.id <=> pExcluirTarea)
              AND (
                    a.HoraInicio = pInicio
                 OR (pInicio < COALESCE(a.HoraFin, a.HoraInicio)
                     AND a.HoraInicio < COALESCE(pFin, pInicio))
              )
        ) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'R-09: la actividad se solapa con otra del mismo inspector responsable';
        END IF;
    END IF;
END//

CREATE TRIGGER trVisitasSolapamientoIns BEFORE INSERT ON Visitas
FOR EACH ROW
BEGIN
    CALL comprobarSolapamiento(NEW.Responsable, NEW.Fecha, NEW.HoraInicio, NEW.HoraFin, NULL, NULL);
END//

CREATE TRIGGER trVisitasSolapamientoUpd BEFORE UPDATE ON Visitas
FOR EACH ROW
BEGIN
    CALL comprobarSolapamiento(NEW.Responsable, NEW.Fecha, NEW.HoraInicio, NEW.HoraFin, NEW.oid_Visita, NULL);
END//

CREATE TRIGGER trTareasSolapamientoIns BEFORE INSERT ON Tareas
FOR EACH ROW
BEGIN
    CALL comprobarSolapamiento(NEW.Responsable, NEW.Fecha, NEW.HoraInicio, NEW.HoraFin, NULL, NULL);
END//

CREATE TRIGGER trTareasSolapamientoUpd BEFORE UPDATE ON Tareas
FOR EACH ROW
BEGIN
    CALL comprobarSolapamiento(NEW.Responsable, NEW.Fecha, NEW.HoraInicio, NEW.HoraFin, NULL, NEW.oid_Tarea);
END//

-- R-01 (parte Desplazamiento): solo hay desplazamiento si la visita está Finalizada.
-- R-08: HoraLlegadaDomicilio solo en el ÚLTIMO desplazamiento del día del inspector.
CREATE PROCEDURE comprobarDesplazamiento(IN pVisita SMALLINT, IN pLlegada TIME)
BEGIN
    DECLARE vEstado VARCHAR(20);
    DECLARE vResp INT;
    DECLARE vFecha DATE;
    DECLARE vInicio TIME;

    SELECT Estado, Responsable, Fecha, HoraInicio
      INTO vEstado, vResp, vFecha, vInicio
      FROM Visitas WHERE oid_Visita = pVisita;

    IF vEstado <> 'Finalizada' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-01: solo una visita Finalizada puede tener desplazamiento';
    END IF;

    -- Otro desplazamiento del mismo inspector y día que choque con este:
    --  * si este tiene llegada: no puede haber uno posterior ni otro con llegada
    --  * aunque este no tenga llegada: no puede haber uno ANTERIOR con llegada
    IF vResp IS NOT NULL AND vFecha IS NOT NULL AND EXISTS (
        SELECT 1
          FROM Desplazamientos d JOIN Visitas v ON v.oid_Visita = d.oid_Visita
         WHERE v.Responsable = vResp AND v.Fecha = vFecha
           AND d.oid_Visita <> pVisita
           AND (   (pLlegada IS NOT NULL AND (v.HoraInicio > vInicio OR d.HoraLlegadaDomicilio IS NOT NULL))
                OR (d.HoraLlegadaDomicilio IS NOT NULL AND v.HoraInicio < vInicio))
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-08: HoraLlegadaDomicilio solo en el ultimo desplazamiento del dia';
    END IF;
END//

CREATE TRIGGER trDesplazamientosIns BEFORE INSERT ON Desplazamientos
FOR EACH ROW
BEGIN
    CALL comprobarDesplazamiento(NEW.oid_Visita, NEW.HoraLlegadaDomicilio);
END//

CREATE TRIGGER trDesplazamientosUpd BEFORE UPDATE ON Desplazamientos
FOR EACH ROW
BEGIN
    CALL comprobarDesplazamiento(NEW.oid_Visita, NEW.HoraLlegadaDomicilio);
END//

-- R-01 (parte Visita): una visita con desplazamiento no puede dejar de estar Finalizada.
CREATE TRIGGER trVisitasEstadoDesplazamiento BEFORE UPDATE ON Visitas
FOR EACH ROW
BEGIN
    IF NEW.Estado <> 'Finalizada'
       AND EXISTS (SELECT 1 FROM Desplazamientos WHERE oid_Visita = OLD.oid_Visita) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-01: la visita tiene desplazamiento, debe seguir Finalizada';
    END IF;
END//

-- RN-02: Almuerzo = la llegada al domicilio es posterior a las 15:00.
-- Lo calcula el sistema; lo que se escriba a mano en Almuerzo se ignora.
CREATE TRIGGER trDietasAlmuerzoIns BEFORE INSERT ON Dietas
FOR EACH ROW
BEGIN
    SET NEW.Almuerzo = COALESCE(
        (SELECT HoraLlegadaDomicilio > '15:00:00'
           FROM Desplazamientos WHERE oid_Visita = NEW.oid_Visita), FALSE);
END//

CREATE TRIGGER trDietasAlmuerzoUpd BEFORE UPDATE ON Dietas
FOR EACH ROW
BEGIN
    SET NEW.Almuerzo = COALESCE(
        (SELECT HoraLlegadaDomicilio > '15:00:00'
           FROM Desplazamientos WHERE oid_Visita = NEW.oid_Visita), FALSE);
END//

-- Si cambia la hora de llegada, se recalcula el almuerzo de su dieta.
CREATE TRIGGER trDesplazamientosAlmuerzo AFTER UPDATE ON Desplazamientos
FOR EACH ROW
BEGIN
    UPDATE Dietas
       SET Almuerzo = COALESCE(NEW.HoraLlegadaDomicilio > '15:00:00', FALSE)
     WHERE oid_Visita = NEW.oid_Visita;
END//

-- R-10: DiasRestantes = DiasTotales - DiasSolicitados >= 0
CREATE PROCEDURE comprobarDiasSolicitados(IN pCurso VARCHAR(7), IN pDias INT)
BEGIN
    IF pDias > (SELECT DiasTotales FROM Cursos WHERE Nombre = pCurso) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-10: DiasSolicitados supera los DiasTotales del curso';
    END IF;
END//

CREATE TRIGGER trDAPDiasIns BEFORE INSERT ON DiasAsuntosPersonales
FOR EACH ROW
BEGIN
    CALL comprobarDiasSolicitados(NEW.Curso, NEW.DiasSolicitados);
END//

CREATE TRIGGER trDAPDiasUpd BEFORE UPDATE ON DiasAsuntosPersonales
FOR EACH ROW
BEGIN
    CALL comprobarDiasSolicitados(NEW.Curso, NEW.DiasSolicitados);
END//

-- R-10 (desde Cursos): no se pueden bajar los DiasTotales por debajo de lo ya solicitado.
CREATE TRIGGER trCursosDiasTotales BEFORE UPDATE ON Cursos
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM DiasAsuntosPersonales
                WHERE Curso = OLD.Nombre AND DiasSolicitados > NEW.DiasTotales) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-10: hay inspectores con mas dias solicitados que los nuevos DiasTotales';
    END IF;
END//

-- RN: solo puede haber un jefe de inspección.
CREATE PROCEDURE comprobarUnJefe(IN pEsJefe BOOLEAN, IN pExcluir INT)
BEGIN
    IF pEsJefe AND EXISTS (
        SELECT 1 FROM Inspectores
         WHERE esJefe = TRUE
           AND NOT (oid_Persona <=> pExcluir)
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Ya existe un jefe de inspeccion';
    END IF;
END//

CREATE TRIGGER trInspectoresUnJefeIns BEFORE INSERT ON Inspectores
FOR EACH ROW
BEGIN
    CALL comprobarUnJefe(NEW.esJefe, NULL);
END//

CREATE TRIGGER trInspectoresUnJefeUpd BEFORE UPDATE ON Inspectores
FOR EACH ROW
BEGIN
    CALL comprobarUnJefe(NEW.esJefe, OLD.oid_Persona);
END//

-- RN: el inspector indicado como Jefe (quien asigna la actividad) en Visitas o Tareas debe tener esJefe = TRUE.
CREATE PROCEDURE comprobarJefe(IN pJefe INT)
BEGIN
    IF pJefe IS NOT NULL AND NOT EXISTS (
        SELECT 1 FROM Inspectores
         WHERE oid_Persona = pJefe AND esJefe = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El Jefe asignado no es jefe de inspeccion';
    END IF;
END//

CREATE TRIGGER trVisitasJefeIns BEFORE INSERT ON Visitas
FOR EACH ROW
BEGIN
    CALL comprobarJefe(NEW.Jefe);
END//

CREATE TRIGGER trVisitasJefeUpd BEFORE UPDATE ON Visitas
FOR EACH ROW
BEGIN
    IF NOT (NEW.Jefe <=> OLD.Jefe) THEN
        CALL comprobarJefe(NEW.Jefe);
    END IF;
END//

CREATE TRIGGER trTareasJefeIns BEFORE INSERT ON Tareas
FOR EACH ROW
BEGIN
    CALL comprobarJefe(NEW.Jefe);
END//

CREATE TRIGGER trTareasJefeUpd BEFORE UPDATE ON Tareas
FOR EACH ROW
BEGIN
    IF NOT (NEW.Jefe <=> OLD.Jefe) THEN
        CALL comprobarJefe(NEW.Jefe);
    END IF;
END//

DELIMITER ;

-- RN-10: El sistema debe evitar que un tutor pida cita sobre un alumno del que no es tutor legal.
DELIMITER //

CREATE OR REPLACE TRIGGER trCitasTutelasIns
BEFORE INSERT ON Citas
FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Tutelas WHERE Tutor = NEW.Tutor and Alumno = NEW.Alumno) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo tutores legales pueden solicitar una cita para ese alumno';
    END IF;
END //

DELIMITER ;

-- Otro para los UPDATEs
DELIMITER //

CREATE OR REPLACE TRIGGER trCitasTutelasUpd
BEFORE UPDATE ON Citas
FOR EACH ROW
BEGIN
    IF NOT EXISTS(SELECT 1 FROM Tutelas WHERE Tutor = NEW.Tutor and Alumno = NEW.Alumno) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo tutores legales pueden solicitar una cita para ese alumno';
    END IF;
END //

DELIMITER ;
-- -----------------------------------------------------------------------------------------------------------------------

-- R-11: el profesor responsable de un centro trabaja en ese mismo centro.
DELIMITER //

CREATE TRIGGER trProfesoresResponsableIns BEFORE INSERT ON Profesores
FOR EACH ROW
BEGIN
    IF NEW.CentroResponsable IS NOT NULL AND NEW.CentroResponsable <> NEW.Centro THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-11: el profesor responsable debe trabajar en ese centro';
    END IF;
END//

CREATE TRIGGER trProfesoresResponsableUpd BEFORE UPDATE ON Profesores
FOR EACH ROW
BEGIN
    IF NEW.CentroResponsable IS NOT NULL AND NEW.CentroResponsable <> NEW.Centro THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-11: el profesor responsable debe trabajar en ese centro';
    END IF;
END//

DELIMITER ;
