-- =====================================================================
-- tablas.sql - Inspeccion Educativa (MariaDB)
-- =====================================================================


-- =====================================================================
-- !! TABLAS GENERADAS CON IA (Claude) - NO SON LAS DEFINITIVAS !!
--
-- Las siguientes tablas las ha generado una IA unicamente para que yo (Jaime)
-- pueda crear y probar MIS tablas (Visitas, Informes y Tareas), que
-- dependen de ellas mediante claves ajenas.
-- Las versiones reales las haceis vosotros: 
-- Tipos de datos y valores de ENUM son suposiciones.
-- =====================================================================

CREATE TABLE Zonas (
    Codigo INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Personas (
    oid_Persona INT AUTO_INCREMENT PRIMARY KEY,
    DNI VARCHAR(9) NOT NULL UNIQUE,
    Nombre VARCHAR(100) NOT NULL,
    Apellidos VARCHAR(150) NOT NULL
);

CREATE TABLE Inspectores (
    oid_Persona INT PRIMARY KEY,
    esJefe BOOLEAN NOT NULL,
    Zona INT NOT NULL,
    FOREIGN KEY (oid_Persona) REFERENCES Personas(oid_Persona),
    FOREIGN KEY (Zona) REFERENCES Zonas(Codigo)
);

CREATE TABLE CentrosEducativos (
    Identificacion INT AUTO_INCREMENT PRIMARY KEY,
    Ubicacion VARCHAR(200) NOT NULL,
    Prioridad ENUM('Baja', 'Media', 'Alta') NOT NULL, -- valores supuestos
    Zona INT NOT NULL,
    KmDesdeCadiz REAL NOT NULL,
    FOREIGN KEY (Zona) REFERENCES Zonas(Codigo)
);

-- ================== FIN DE LAS TABLAS GENERADAS CON IA ===============

-- =====================================================================
-- MIS TABLAS (hechas por mi): Visitas, Informes, Tareas
-- =====================================================================

CREATE TABLE Visitas (
    oid_Visita SMALLINT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE,
    HoraInicio TIME NOT NULL,
    HoraFin TIME,
    Estado ENUM('Pendiente', 'Finalizada', 'Rechazada') NOT NULL,
    Responsable INT,
    Jefe INT,
    Centro INT NOT NULL,
    -- En la mayoria de atributos pienso que puede ser NULL (no pongo NOT NULL), por ejemplo, la Hora cuando la Visita sigue en estado 'Pendiente'

    FOREIGN KEY (Responsable) REFERENCES Inspectores(oid_Persona),
    FOREIGN KEY (Jefe) REFERENCES Inspectores(oid_Persona),            -- No voy a anadir ON DELETE ni ON UPDATE en las FK porque voy a considerar que un Inspector
    FOREIGN KEY (Centro) REFERENCES CentrosEducativos(Identificacion), -- o un Centro con Visitas asociadas NO se puede borrar ,es decir, aplica, por defecto, RESTRICT
    
    CONSTRAINT chVisitasHorasInicioFin CHECK (HoraInicio < HoraFin)
);

CREATE TABLE Informes (
    oid_Visita SMALLINT PRIMARY KEY,
    Prioridad ENUM('Baja', 'Media', 'Alta', 'Urgente'),
    Observacion TEXT,

    FOREIGN KEY (oid_Visita) REFERENCES Visitas(oid_Visita)
);

CREATE TABLE Tareas (
    oid_Tarea SMALLINT PRIMARY KEY AUTO_INCREMENT,
    Fecha DATE,
    HoraInicio TIME NOT NULL,
    HoraFin TIME,
    Descripcion TEXT,
    Responsable INT,
    Jefe INT,

    FOREIGN KEY (Responsable) REFERENCES Inspectores(oid_Persona),
    FOREIGN KEY (Jefe) REFERENCES Inspectores(oid_Persona),

    CONSTRAINT chTareasHorasInicioFin CHECK (HoraInicio < HoraFin)
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

DELIMITER ;

-- ================== FIN DEL CODIGO GENERADO CON IA ===================