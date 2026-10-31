### ESCENARIO DE PRUEBA 1: Flujo de datos de una solicitud de cita

# Título: Un hijo le dice a su madre que un profesor le acosa, ella recurre a la inspección

> Todas las personas, centros y datos de este escenario son inventados.

## 1. Situación

Hugo Gil, alumno del IES Mirador de la Peña (Arcos de la Frontera), le cuenta a su madre, Marta Ruiz, que su profesor de Matemáticas, Andrés Vega, le humilla reiteradamente en clase. El lunes 5 de octubre de 2026, Marta, como tutora legal de Hugo, solicita por escrito una cita con la inspección a través del portal de citas y adjunta la documentación de la que dispone. La solicitud queda pendiente de revisión.

Al día siguiente, conserjería revisa la solicitud, le asigna una prioridad alta y la concierta para el jueves 8 de octubre, trasladándola a la inspectora Carmen Soto, que es quien la atiende.

Tras reunirse con Marta, y como Carmen es inspectora jefe (`esJefe = true`), programa una actividad en el calendario de otro inspector de la zona del centro, Javier Mena, que será quien la realice. Toda actividad es o bien una tarea o bien una visita. En este caso hace falta una comprobación presencial, por lo que se crea una visita al centro en estado `Pendiente`. Si Carmen no fuese inspectora jefe, no podría asignarla (RN-05).

El miércoles 14 de octubre, Javier se desplaza desde el centro de Cádiz hasta el instituto, realiza la visita y esta pasa a `Finalizada`. Toda visita finalizada tiene un desplazamiento, del que puede derivarse una dieta. Aquí el sistema calcula la dieta a partir del kilometraje y la tarifa vigente, y añade el plus de almuerzo porque Javier regresa a su domicilio después de las 15:00.

Tras la visita, Javier, el inspector que la ha realizado, redacta el informe, asociado a la visita y a él mismo como autor. El informe tiene una prioridad (baja, media, alta o urgente) que sirve de referencia para revisar la prioridad del centro educativo. Como es `alta`, Javier actualiza la prioridad del centro de `media` a `alta`, y el sistema avisa a la inspectora jefe y a los inspectores de la zona (RC-04).

## 2. Datos del escenario

### Personas

| Objeto | Clase | Nombre y apellidos | DNI | Atributos propios |
| --- | --- | --- | --- | --- |
| `marta` | TutorLegal | Marta Ruiz Domínguez | 00000001R | — |
| `hugo` | Alumno | Hugo Gil Ruiz | 00000002W | — |
| `andres` | Profesor | Andrés Vega Romero | 00000003A | asignaturasImparte = [Matemáticas]; esResponsableCentro = false |
| `elena` | Profesor | Elena Cano Ortega | 00000004G | asignaturasImparte = [Lengua]; esResponsableCentro = true |
| `carmen` | Inspector | Carmen Soto Lara | 00000005M | esJefe = true |
| `javier` | Inspector | Javier Mena Prieto | 00000006Y | esJefe = false |

`elena` aparece para cumplir la RN-07: todo centro tiene exactamente un profesor responsable.

### Tutela (`marta` – `hugo`)

| Atributo | Valor |
| --- | --- |
| parentesco | Madre |

### Zona `z04`

| Atributo | Valor |
| --- | --- |
| Código | Z-04 |
| Nombre | Sierra de Cádiz |

### Centro Educativo `iesMirador`

| Atributo | Valor |
| --- | --- |
| Identificación | 11999001 – IES Mirador de la Peña |
| Ubicación | Calle Ficticia 12, Arcos de la Frontera (Cádiz) |
| Prioridad | media → **alta** |

### Cita `c1`

| Atributo | Valor |
| --- | --- |
| Fecha | 08/10/2026 |
| Hora | 10:30 |
| Titulo | Posible acoso de un profesor a mi hijo |
| TextoSolicitud | «Mi hijo Hugo, de 3.º de ESO, me ha contado que su profesor de Matemáticas, Andrés Vega, le humilla en clase delante de sus compañeros desde hace semanas. Solicito una cita con la inspección.» |
| DocumentaciónAdjunta | [relato_de_los_hechos.pdf, correos_con_tutoria.pdf] |
| Estado | PendienteDeRevisión → **Concertada** |
| Prioridad | alta |
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
| Origen | Centro de Cádiz |
| Destino | IES Mirador de la Peña, Arcos de la Frontera |
| HoraSalida | 08:45 |
| HoraLlegadaDomicilio | 15:40 |
| Kilometros | 68 |
| TarifaKm | 0,24 €/km |

### Dieta `dt1`

| Atributo | Valor |
| --- | --- |
| Importe | 36,32 € |
| Almuerzo | true |

Cálculo (RC-01, RN-01 y RN-02):

| Concepto | Operación | Importe |
| --- | --- | --- |
| Kilometraje | 68 km × 0,24 €/km | 16,32 € |
| Plus de almuerzo | 15:40 > 15:00 | 20,00 € |
| **Total** | | **36,32 €** |

### Informe `i1`

| Atributo | Valor |
| --- | --- |
| Prioridad | alta |
| Observacion | Las entrevistas con el alumno, el profesor y la dirección aportan indicios de trato inadecuado reiterado en el aula. Se propone activar el protocolo del centro y hacer seguimiento en un mes. |

## 3. Seguimiento de los datos

| # | Fecha | Quién | Qué ocurre | Objetos creados o modificados | Asociaciones | Requisitos |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 05/10 | Marta | Registra la solicitud en el portal | Crea `c1`: Estado = PendienteDeRevisión, Procedencia = Portal_Citas | `marta` solicita `c1`; `c1` trataSobre `hugo` | RI-07, RC-06, RN-04 |
| 2 | 06/10 | Conserjería | Revisa y concierta la solicitud | `c1`: Estado = Concertada, Prioridad = alta, Fecha y Hora | `carmen` atiende `c1`; `c1` implicaA `andres` | RC-03, RC-07 |
| 3 | 08/10 | Carmen | Atiende a Marta y comprueba que es jefa | Lee `carmen.esJefe = true` | — | RN-05 |
| 4 | 08/10 | Carmen | Asigna la visita a un inspector de la zona del centro | Crea `v1`: Estado = Pendiente, con fecha y horas | `carmen` asigna `v1`; `javier` realiza `v1`; `iesMirador` recibe `v1` | RI-09, RC-09 |
| 5 | 14/10 | Javier | Se desplaza y realiza la visita | `v1`: Estado = Finalizada; crea `d1` | `v1` existe `d1` | RI-11 |
| 6 | 14/10 | Sistema | Calcula la dieta | Crea `dt1`: Importe = 36,32 €, Almuerzo = true | `d1` requiere `dt1` | RI-12, RC-01, RN-01, RN-02 |
| 7 | 14/10 | Javier | Redacta el informe | Crea `i1`: Prioridad = alta | `javier` redacta `i1`; `v1` contiene `i1` | RI-10, RC-11, RN-03 |
| 8 | 14/10 | Javier | Revisa la prioridad del centro a partir del informe | `iesMirador`: Prioridad = alta | Camino `i1` → `v1` → `iesMirador` | RC-03 |
| 9 | 14/10 | Sistema | Avisa del cambio de prioridad | Sin cambios en los datos | `carmen`, `javier` trabajanEn `z04`; `z04` contiene `iesMirador` | RC-04 |

Asociaciones que existen desde antes del escenario:

- `marta` responsableDe `hugo`, con la tutela `Madre`.
- `hugo`, `andres` y `elena` pertenecen a `iesMirador`.
- `iesMirador` pertenece a `z04`.
- `carmen` y `javier` trabajan en `z04`.

