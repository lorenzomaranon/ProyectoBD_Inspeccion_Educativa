USE inspeccion_educativa;

CREATE TABLE Zonas
(	Codigo INT AUTO_INCREMENT, 
	Nombre VARCHAR(50) NOT NULL, 
	PRIMARY KEY(Codigo),
	CONSTRAINT ak_zonas_nombre UNIQUE (Nombre));
					
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
    -- R-11 (el responsable trabaja en ese centro) se comprueba con triggers en 04_triggers.sql:
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


CREATE TABLE DocumentosCita
(	Num_solicitud INT,
   DocumentacionAdjunta VARCHAR(50),
   PRIMARY KEY(Num_solicitud, DocumentacionAdjunta),
-- Si se borra una cita tambien se borran sus documentos -> ON DELETE CASCADE
CONSTRAINT fk_DocumentosCita_NumSolicitud FOREIGN KEY (Num_solicitud) REFERENCES Citas (Num_solicitud) ON DELETE CASCADE);


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
    Origen VARCHAR(100) NULL,              -- NULL: primer desplazamiento, sale de Cádiz
    Destino VARCHAR(100) NULL,
    Km REAL NULL,                          -- km del tramo entre centros
    PRIMARY KEY (oid_Visita),
    CONSTRAINT fk_desplazamientos_visita FOREIGN KEY (oid_Visita)
        REFERENCES Visitas (oid_Visita) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT ch_desplazamientos_tramo CHECK (
        (Origen IS NULL AND Destino IS NULL AND Km IS NULL) OR
        (Origen IS NOT NULL AND Destino IS NOT NULL AND Km >= 0)),
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

