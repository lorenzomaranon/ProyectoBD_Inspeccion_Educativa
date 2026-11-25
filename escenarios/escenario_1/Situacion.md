### ESCENARIO DE PRUEBA 1: Flujo de datos de una solicitud de cita

# Título: Un hijo le dice a su madre que un profesor le acosa, ella recurre a la inspección

> Todas las personas, centros y datos de este escenario son inventados.

## 1. Situación

Hugo Gil, alumno del IES Mirador de la Peña (Arcos de la Frontera), le cuenta a su madre, Marta Ruiz, que su profesor de Matemáticas, Andrés Vega, le humilla reiteradamente en clase. El lunes 5 de octubre de 2026, Marta, como tutora legal de Hugo, solicita por escrito una cita con la inspección a través del portal de citas y adjunta la documentación de la que dispone. La solicitud queda pendiente de revisión.

Al día siguiente, conserjería revisa la solicitud y la concierta para el jueves 8 de octubre, trasladándola a la inspectora Carmen Soto, que es quien la atiende.

Tras reunirse con Marta, Carmen le asigna a la cita una prioridad alta y, como es inspectora jefe (`esJefe = true`), programa una actividad en el calendario de otro inspector de la zona del centro, Javier Mena, que será quien la realice. Toda actividad es o bien una tarea o bien una visita. En este caso hace falta una comprobación presencial, por lo que se crea una visita al centro en estado `Pendiente`. Si Carmen no fuese inspectora jefe, no podría asignarla (RN-05).

El miércoles 14 de octubre, Javier se desplaza desde el centro de Cádiz hasta el instituto, realiza la visita y esta pasa a `Finalizada`. Toda visita finalizada tiene un desplazamiento, del que puede derivarse una dieta. Aquí el sistema calcula la dieta a partir del kilometraje (KmDesdeCadiz del centro más KmVuelta del desplazamiento) y la TarifaKm del curso 2026-27, y añade el plus de almuerzo porque Javier regresa a su domicilio después de las 15:00.

Durante la visita, Javier, el inspector responsable de la visita, cumplimenta el informe, que forma parte de la visita (R-03). No hace falta un enlace aparte entre Javier y el informe: el autor es el responsable de la visita. El informe tiene una prioridad (baja, media, alta o urgente) que sirve de referencia para revisar la prioridad del centro educativo. Como es `alta`, se actualiza la prioridad del centro de `media` a `alta`, y el sistema avisa a la inspectora jefe y a los inspectores de la zona (RC-04).

## 2. Datos del escenario

### Personas

| Objeto | Clase | Nombre y apellidos | DNI | Atributos propios |
| --- | --- | --- | --- | --- |
| `marta` | TutorLegal | Marta Ruiz Domínguez | 00000001R | — |
| `hugo` | Alumno | Hugo Gil Ruiz | 00000002W | — |
| `andres` | Profesor | Andrés Vega Romero | 00000003A | asignaturasImparte = [Matemáticas] |
| `elena` | Profesor | Elena Cano Ortega | 00000004G | asignaturasImparte = [Lengua] |
| `carmen` | Inspector | Carmen Soto Lara | 00000005M | esJefe = true |
| `javier` | Inspector | Javier Mena Prieto | 00000006Y | esJefe = false |

`andres` y `elena` trabajanEn `iesMirador`, y `elena` además esResponsable de él: todo centro tiene exactamente un profesor responsable (RN-07).

### Tutela (`marta` – `hugo`)

| Atributo | Valor |
| --- | --- |
| parentesco | Madre |

### Zona `z04`

| Atributo | Valor |
| --- | --- |
| Codigo | Z-04 |
| Nombre | Sierra de Cádiz |

### Centro Educativo `iesMirador`

| Atributo | Valor |
| --- | --- |
| Identificacion | 11999001 |
| Nombre | IES Mirador de la Peña |
| Ubicación | Calle Ficticia 12, Arcos de la Frontera (Cádiz) |
| Prioridad | media → **alta** |
| KmDesdeCadiz | 34 |

### Curso `curso2627`

| Atributo | Valor |
| --- | --- |
| Nombre | 2026-27 |
| DiasTotales | 4 |
| TarifaKm | 0,24 €/km |
| PlusAlmuerzo | 20 € |

### Cita `c1`

| Atributo | Valor |
| --- | --- |
| Num_solicitud | 1 |
| Fecha | 08/10/2026 |
| Hora | 10:30 |
| Titulo | Posible acoso de un profesor a mi hijo |
| TextoSolicitud | «Mi hijo Hugo, de 3.º de ESO, me ha contado que su profesor de Matemáticas, Andrés Vega, le humilla en clase delante de sus compañeros desde hace semanas. Solicito una cita con la inspección.» |
| DocumentaciónAdjunta | [relato_de_los_hechos.pdf, correos_con_tutoria.pdf] |
| Estado | PendienteDeRevisión → **Concertada** |
| Prioridad | alta (la asigna `carmen`) |
| Procedencia | Portal_Citas |

### Visita `v1`

| Atributo | Valor |
| --- | --- |
| Fecha (heredado) | 14/10/2026 |
| HoraInicio (heredado) | 10:00 |
| HoraFin (heredado) | 14:30 |
| Estado | Pendiente → **Finalizada** |

### Desplazamiento `d1`

| Atributo | Valor |
| --- | --- |
| HoraSalida | 08:45 |
| HoraLlegadaDomicilio | 15:40 |
| KmVuelta | 34 |

### Dieta `dt1`

| Atributo | Valor |
| --- | --- |
| Almuerzo | true |
| /Importe (derivado) | 36,32 € |

Cálculo (RC-01, RN-01 y RN-02):

| Concepto | Operación | Importe |
| --- | --- | --- |
| Kilometraje | (34 KmDesdeCadiz + 34 KmVuelta) = 68 km × 0,24 €/km (TarifaKm del curso) | 16,32 € |
| Plus de almuerzo | 15:40 > 15:00: PlusAlmuerzo del curso | 20,00 € |
| **Total** | | **36,32 €** |

### Informe `i1`

| Atributo | Valor |
| --- | --- |
| Prioridad | alta |
| Observacion | Las entrevistas con el alumno, el profesor y la dirección aportan indicios de trato inadecuado reiterado en el aula. Se propone activar el protocolo del centro y hacer seguimiento en un mes. |

## 3. Seguimiento de los datos

| # | Fecha | Quién | Qué ocurre | Objetos creados o modificados | Asociaciones | Requisitos |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 05/10 | Marta | Registra la solicitud en el portal | Crea `c1`: Num_solicitud = 1, Estado = PendienteDeRevisión, Procedencia = Portal_Citas | `marta` solicita `c1`; `c1` trataSobre `hugo` | RI-07, RC-06, RN-04 |
| 2 | 06/10 | Conserjería | Revisa y concierta la solicitud | `c1`: Estado = Concertada, Fecha y Hora | `carmen` atiende `c1`; `c1`  | RC-07 |
| 3 | 08/10 | Carmen | Atiende a Marta, asigna la prioridad de la cita y comprueba que es jefa | `c1`: Prioridad = alta; lee `carmen.esJefe = true` | — | RC-03, RN-05 |
| 4 | 08/10 | Carmen | Asigna la visita a un inspector de la zona del centro | Crea `v1`: Estado = Pendiente, con fecha y horas | `carmen` asigna `v1`; `javier` realiza `v1`; `iesMirador` recibe `v1` | RI-09, RC-09 |
| 5 | 14/10 | Javier | Se desplaza y realiza la visita | `v1`: Estado = Finalizada; crea `d1` | `v1` existe `d1` | RI-11 |
| 6 | 14/10 | Sistema | Calcula la dieta | Crea `dt1`: Almuerzo = true (/Importe = 36,32 €, derivado) | `d1` requiere `dt1` | RI-12, RC-01, RN-01, RN-02 |
| 7 | 14/10 | Javier | Cumplimenta el informe | Crea `i1`: Prioridad = alta | `v1` contiene `i1` (autor: `javier`, responsable de `v1`, R-03) | RI-10, RC-11, RN-03 |
| 8 | 14/10 | Javier | Revisa la prioridad del centro a partir del informe | `iesMirador`: Prioridad = alta | Camino `i1` → `v1` → `iesMirador` | RC-03 |
| 9 | 14/10 | Sistema | Avisa del cambio de prioridad | Sin cambios en los datos | `carmen`, `javier` trabajanEn `z04`; `z04` contiene `iesMirador` | RC-04 |

Asociaciones que existen desde antes del escenario:

- `marta` responsableDe `hugo`, con la tutela `Madre`.
- `hugo` pertenece a `iesMirador`; `andres` y `elena` trabajanEn `iesMirador`.
- `elena` esResponsable de `iesMirador`.
- `iesMirador` pertenece a `z04`.
- `carmen` y `javier` trabajan en `z04`.

