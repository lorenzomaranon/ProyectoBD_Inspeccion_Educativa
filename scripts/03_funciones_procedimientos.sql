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

-- R-10: DiasRestantes = DiasTotales - DiasSolicitados >= 0
CREATE PROCEDURE comprobarDiasSolicitados(IN pCurso VARCHAR(7), IN pDias INT)
BEGIN
    IF pDias > (SELECT DiasTotales FROM Cursos WHERE Nombre = pCurso) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'R-10: DiasSolicitados supera los DiasTotales del curso';
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

DELIMITER ;
