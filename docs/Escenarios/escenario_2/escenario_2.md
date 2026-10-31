### ESCENARIO DE PRUEBA 2: Seguimiento de una solicitud sin cambio de prioridad

# Título: Un padre pide una cita porque su hija no recibe apoyo educativo; la visita no encuentra incidencias graves

> Todas las personas, centros y datos de este escenario son inventados.

## 1. Situación

Lucía Nieto, alumna del CEIP Bahía Azul (Puerto Real), tiene dificultades de aprendizaje y su familia lleva meses esperando el refuerzo educativo que el centro le debía prestar. El lunes 2 de noviembre de 2026, su padre, Pablo Nieto, solicita por escrito una cita con la inspección a través del portal de citas. Pablo es uno de los dos tutores legales de Lucía; el otro es su madre, Irene Vidal, que no interviene en el trámite. La solicitud menciona a la profesora de apoyo, Rosa Pérez.

Al día siguiente, conserjería revisa la solicitud, le asigna una prioridad media y la concierta para el jueves 5 de noviembre, trasladándola al inspector jefe Luis Barea, que es quien la atiende.

Tras reunirse con Pablo, Luis, que es inspector jefe (`esJefe = true`), programa dos actividades en el calendario de una inspectora de la zona del centro, Nuria Campos:

- Una **tarea** (no hace falta salir de la oficina): preparar el guion de entrevistas y reunir el plan de atención a la diversidad del centro.
- Una **visita** al centro, en estado `Pendiente`.

Nuria no es inspectora jefe (`esJefe = false`), así que no podría haber creado esas actividades ella misma (RN-05).

El miércoles 11 de noviembre, Nuria se desplaza desde el centro de Cádiz hasta el colegio, realiza la visita y esta pasa a `Finalizada`. El desplazamiento es corto y Nuria llega a su domicilio antes de las 15:00, así que el sistema calcula la dieta solo con el kilometraje, **sin plus de almuerzo**.

Nuria, como inspectora responsable de la visita, redacta el informe. Concluye que el centro está atendiendo a la alumna y que solo hay un retraso administrativo, por lo que le da prioridad `baja`. Al revisar la prioridad del centro, que ya era `media`, no encuentra motivo para cambiarla, así que **no se modifica** y el sistema no envía ningún aviso.

Este escenario es el complementario del primero: allí todo cambia (prioridad, plus de almuerzo, aviso); aquí se comprueba que el modelo también representa bien el caso en que **no** cambia nada.

## 2. Datos del escenario

### Personas

| Objeto | Clase | Nombre y apellidos | DNI | Atributos propios |
| --- | --- | --- | --- | --- |
| `pablo` | TutorLegal | Pablo Nieto Barral | 00000011B | — |
| `irene` | TutorLegal | Irene Vidal Soler | 00000012N | — |
| `lucia` | Alumno | Lucía Nieto Vidal | 00000013J | — |
| `rosa` | Profesor | Rosa Pérez Gálvez | 00000014Z | asignaturasImparte = [Pedagogía Terapéutica]; esResponsableCentro = false |
| `mateo` | Profesor | Mateo Cruz Lozano | 00000015S | asignaturasImparte = [Matemáticas, Lengua]; esResponsableCentro = true |
| `luis` | Inspector | Luis Barea Mora | 00000016Q | esJefe = true |
| `nuria` | Inspector | Nuria Campos Ríos | 00000017V | esJefe = false |

`mateo` aparece para cumplir la RN-07: todo centro tiene exactamente un profesor responsable.

### Tutelas

| Tutor | Alumno | parentesco |
| --- | --- | --- |
| `pablo` | `lucia` | Padre |
| `irene` | `lucia` | Madre |

### Zona `z02`

| Atributo | Valor |
| --- | --- |
| Código | Z-02 |
| Nombre | Bahía de Cádiz |

### Centro Educativo `ceipBahia`

| Atributo | Valor |
| --- | --- |
| Identificación | 11999002 – CEIP Bahía Azul |
| Ubicación | Avenida Ficticia 7, Puerto Real (Cádiz) |
| Prioridad | media (sin cambios) |

### Cita `c2`

| Atributo | Valor |
| --- | --- |
| Fecha | 05/11/2026 |
| Hora | 12:00 |
| Titulo | Falta de refuerzo educativo para mi hija |
| TextoSolicitud | «Mi hija Lucía tiene un informe de necesidades de apoyo desde el curso pasado y todavía no recibe las sesiones de refuerzo que le corresponden. La profesora de apoyo, Rosa Pérez, dice que no depende de ella. Solicito una cita con la inspección.» |
| DocumentaciónAdjunta | [informe_psicopedagogico.pdf] |
| Estado | PendienteDeRevisión → **Concertada** |
| Prioridad | media |
| Procedencia | Portal_Citas |

### Tarea `t1`

| Atributo | Valor |
| --- | --- |
| Fecha (heredado) | 09/11/2026 |
| HoraInicio (heredado) | 09:00 |
| HoraFin (heredado) | 11:00 |
| Descripcion | Preparar el guion de entrevistas y reunir el plan de atención a la diversidad del CEIP Bahía Azul |

### Visita `v2`

| Atributo | Valor |
| --- | --- |
| Fecha (heredado) | 11/11/2026 |
| HoraInicio (heredado) | 09:30 |
| HoraFin (heredado) | 13:00 |
| Estado | Pendiente → **Finalizada** |

### Desplazamiento `d2`

| Atributo | Valor |
| --- | --- |
| Origen | Centro de Cádiz |
| Destino | CEIP Bahía Azul, Puerto Real |
| HoraSalida | 08:30 |
| HoraLlegadaDomicilio | 14:20 |
| Kilometros | 22 |
| TarifaKm | 0,24 €/km |

### Dieta `dt2`

| Atributo | Valor |
| --- | --- |
| Importe | 5,28 € |
| Almuerzo | false |

Cálculo (RC-01, RN-01 y RN-02):

| Concepto | Operación | Importe |
| --- | --- | --- |
| Kilometraje | 22 km × 0,24 €/km | 5,28 € |
| Plus de almuerzo | 14:20 ≤ 15:00, no se aplica | 0,00 € |
| **Total** | | **5,28 €** |

### Informe `i2`

| Atributo | Valor |
| --- | --- |
| Prioridad | baja |
| Observacion | El centro reconoce el retraso en el refuerzo por falta de horas de apoyo y presenta un calendario de sesiones desde la semana siguiente. No se aprecian indicios de desatención voluntaria. Se recomienda comprobar el cumplimiento del calendario en dos meses. |

## 3. Seguimiento de los datos

| # | Fecha | Quién | Qué ocurre | Objetos creados o modificados | Asociaciones | Requisitos |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 02/11 | Pablo | Registra la solicitud en el portal | Crea `c2`: Estado = PendienteDeRevisión, Procedencia = Portal_Citas | `pablo` solicita `c2`; `c2` trataSobre `lucia` | RI-07, RC-06, RN-04 |
| 2 | 03/11 | Conserjería | Revisa y concierta la solicitud | `c2`: Estado = Concertada, Prioridad = media, Fecha y Hora | `luis` atiende `c2`; `c2` implicaA `rosa` | RC-03, RC-07 |
| 3 | 05/11 | Luis | Atiende a Pablo y comprueba que es jefe | Lee `luis.esJefe = true` | — | RN-05 |
| 4 | 05/11 | Luis | Programa una tarea en el calendario de un inspector de la zona | Crea `t1` con fecha y horas | `luis` asigna `t1`; `nuria` realiza `t1` | RI-09, RN-05 |
| 5 | 05/11 | Luis | Asigna la visita al mismo inspector | Crea `v2`: Estado = Pendiente, con fecha y horas | `luis` asigna `v2`; `nuria` realiza `v2`; `ceipBahia` recibe `v2` | RI-09, RC-09 |
| 6 | 11/11 | Nuria | Se desplaza y realiza la visita | `v2`: Estado = Finalizada; crea `d2` | `v2` existe `d2` | RI-11 |
| 7 | 11/11 | Sistema | Calcula la dieta sin plus de almuerzo | Crea `dt2`: Importe = 5,28 €, Almuerzo = false | `d2` requiere `dt2` | RI-12, RC-01, RN-01, RN-02 |
| 8 | 11/11 | Nuria | Redacta el informe | Crea `i2`: Prioridad = baja | `nuria` redacta `i2`; `v2` contiene `i2` | RI-10, RC-11, RN-03 |
| 9 | 11/11 | Nuria | Revisa la prioridad del centro a partir del informe | `ceipBahia`: Prioridad = media, sin cambios | Camino `i2` → `v2` → `ceipBahia` | RC-03 |
| 10 | 11/11 | Sistema | No avisa, porque la prioridad no ha cambiado | Sin cambios en los datos | — | RC-04 |

Asociaciones que existen desde antes del escenario:

- `pablo` e `irene` responsableDe `lucia`, con las tutelas `Padre` y `Madre`.
- `lucia`, `rosa` y `mateo` pertenecen a `ceipBahia`.
- `ceipBahia` pertenece a `z02`.
- `luis` y `nuria` trabajan en `z02`.

## 4. Qué comprueba este escenario sobre el modelo

| Aspecto del modelo | Cómo lo refleja el escenario |
| --- | --- |
| `TutorLegal "1..*" -- "*" Alumno` | `lucia` tiene dos tutores y cada uno con su propia `Tutela`; solo uno solicita la cita |
| `Actividad <|-- Tarea` (disjunta, completa) | `t1` es una tarea y `v2` una visita; ninguna es las dos cosas, y las dos comparten Fecha, HoraInicio y HoraFin |
| `Inspector "1 jefe" -- "*" Actividad : asigna` | `luis` asigna dos actividades distintas; `nuria` las realiza y no puede asignarlas (R-02) |
| `Dieta` opcional pero sin plus | `dt2` existe con `Almuerzo = false`; el importe es solo el kilometraje (RN-02: 14:20 no excede las 15:00) |
| `Visita *-- "0..1" Informe` / `Desplazamiento` | Hasta el paso 6, `v2` no tiene ni desplazamiento ni informe; los tiene al estar `Finalizada` (R-01) |
| `Cita "*" -- "*" Profesor : implicaA` | `c2` implica a `rosa`, un profesor que no es el responsable del centro |
| `esResponsableCentro` (RN-07) | Hay dos profesores en el centro y solo `mateo` es responsable |
| Prioridad del informe como referencia (RC-03) | El informe es `baja` y el centro sigue en `media`: la prioridad del centro no se calcula, se decide |
| Aviso solo si hay cambio (RC-04) | Sin cambio en `ceipBahia`, no se avisa a nadie |

### Operaciones que el modelo debe rechazar

Estas variaciones del escenario no deben ser posibles. Sirven para comprobar que las restricciones están bien definidas.

| Variación | Restricción que la impide |
| --- | --- |
| `nuria` intenta asignarse a sí misma una tarea o una visita | R-02 / RN-05: quien asigna debe tener `esJefe = true` |
| `luis` redacta `i2` en lugar de `nuria` | R-03 / RN-03: el informe lo redacta el inspector responsable de la visita |
| `v2` pasa a `Finalizada` sin crear `d2` ni `i2` | R-01: una visita finalizada tiene informe y desplazamiento |
| Existe `d2` o `i2` mientras `v2` sigue `Pendiente` | R-01: solo las visitas finalizadas los tienen |
| `pablo` contacta directamente con `nuria` y se crea `c2` con `Procedencia = Llamada` | RN-04: la familia solo solicita por el portal |
| Se añade un segundo profesor con `esResponsableCentro = true` en `ceipBahia` | RN-07: exactamente un responsable por centro |

### Limitaciones conocidas

- El paso 2 sigue sin registrar qué persona de conserjería revisó la cita (problema 8 de [correcciones_modelo.md](../caso_1/correcciones_modelo.md)).
- La asociación `Inspector "1" -- "*" Cita : atiende` obliga a que `c2` tenga inspector, y en el paso 1 todavía no lo tiene (problema 10 del mismo archivo).
- La RN-05 también permite asignar tareas a los coordinadores de equipo de zona, un perfil que el modelo actual no recoge; este escenario no lo necesita.
