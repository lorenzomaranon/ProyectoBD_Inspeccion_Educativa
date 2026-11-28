USE inspeccion_educativa;

DELIMITER //

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
