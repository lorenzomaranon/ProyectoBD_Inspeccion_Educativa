### ESCENARIO DE PRUEBA 3: Persona con dos perfiles, dos visitas el mismo día y días de asuntos personales

# Título: Un profesor pide una cita como padre; el inspector encadena dos visitas en un día y consulta sus días de asuntos personales

> Todas las personas, centros y datos de este escenario son inventados.

## 1. Situación

Antonio Ríos es profesor de Lengua en el IES Marismas del Guadalete (El Puerto de Santa María) y, a la vez, padre y único tutor legal de Daniel Ríos, alumno de 4.º de Primaria en el CEIP Los Albarizones (Jerez de la Frontera). Antonio es una sola persona con dos perfiles: profesor en un centro y tutor legal de un alumno de otro.

El lunes 9 de noviembre de 2026, Daniel le cuenta que lo han cambiado de grupo a mitad de curso sin que nadie se lo comunicara a la familia. Antonio, como tutor legal, solicita por escrito una cita con la inspección a través del portal y adjunta el escrito que ya envió a la dirección. La solicitud menciona al director del centro, Julián Ferrer, que firmó el cambio. La solicitud queda pendiente de revisión.

Al día siguiente, conserjería revisa la solicitud y la concierta para el jueves 12 de noviembre, trasladándola a la inspectora jefe Gloria Aranda, que es quien la atiende.

Tras reunirse con Antonio, Gloria le asigna a la cita una prioridad media y, como es inspectora jefe (`esJefe = true`), asigna dos visitas al inspector Sergio Molina, que trabaja en la zona de ambos centros, para el miércoles 18 de noviembre:

- Una **visita** al CEIP Los Albarizones, para comprobar el cambio de grupo.
- Una **visita ordinaria** al CEIP Fuente Clara (Espera), que no tiene relación con la cita. Se programa el mismo día para aprovechar el viaje.

El 18 de noviembre, Sergio sale de Cádiz hacia Jerez y realiza la primera visita. Después va directamente de Jerez a Espera, realiza la segunda y regresa a su domicilio. Cada visita tiene su propio desplazamiento. Según RN-01, la ida de un desplazamiento se mide siempre desde el centro de Cádiz (`KmDesdeCadiz` del centro visitado), aunque Sergio salga de Jerez hacia Espera, y en cada desplazamiento solo se registran los kilómetros de vuelta (`KmVuelta`). En el primero Sergio no vuelve, sino que sigue hacia Espera, así que su `KmVuelta` es 0. Solo en el segundo Sergio vuelve a casa, y lo hace pasadas las 15:00, así que solo ahí se añade el plus de almuerzo.

Al día siguiente, Sergio solicita dos días de asuntos personales y el sistema recalcula los que le quedan. Sergio consulta los suyos sin problema, pero no puede consultar los de su compañera Paula Reyes. Gloria, como inspectora jefe, sí puede ver los de ambos.

## 2. Datos del escenario

### Personas

| Objeto | Clase | Nombre y apellidos | DNI | Atributos propios |
| --- | --- | --- | --- | --- |
| `antonio` | **Profesor y TutorLegal** | Antonio Ríos Cabello | 00000021K | asignaturasImparte = [Lengua] |
| `daniel` | Alumno | Daniel Ríos Pineda | 00000022E | — |
| `isabel` | Profesor | Isabel Montero Gil | 00000023T | asignaturasImparte = [Geografía e Historia] |
| `julian` | Profesor | Julián Ferrer Lozano | 00000024R | asignaturasImparte = [Matemáticas] |
| `elisa` | Profesor | Elisa Quintero Vera | 00000025W | asignaturasImparte = [Conocimiento del Medio] |
| `gloria` | Inspector | Gloria Aranda Pons | 00000026A | esJefe = true |
| `sergio` | Inspector | Sergio Molina Duarte | 00000027G | esJefe = false |
| `paula` | Inspector | Paula Reyes Gil | 00000028M | esJefe = false |

`antonio` es **un único objeto** con dos clases. Si fuesen dos objetos, tendrían el mismo DNI.

`isabel`, `julian` y `elisa` trabajanEn su centro y además esResponsable de él: cada centro tiene exactamente un profesor responsable (RN-07).

### Tutela (`antonio` – `daniel`)

| Atributo | Valor |
| --- | --- |
| parentesco | Padre |

`antonio` es el único tutor legal de `daniel`.

### Zonas

| Objeto | Codigo | Nombre |
| --- | --- | --- |
| `z02` | Z-02 | Bahía de Cádiz |
| `z03` | Z-03 | Campiña de Jerez |

### Centros educativos

| Objeto | Identificacion | Nombre | Ubicación | Prioridad | KmDesdeCadiz |
| --- | --- | --- | --- | --- | --- |
| `iesMarismas` | 11999003 | IES Marismas del Guadalete | Calle Ficticia 3, El Puerto de Santa María (Cádiz) | baja (sin cambios) | 20 |
| `ceipAlbarizones` | 11999004 | CEIP Los Albarizones | Calle Ficticia 21, Jerez de la Frontera (Cádiz) | baja → **media** | 38 |
| `ceipFuenteClara` | 11999005 | CEIP Fuente Clara | Plaza Ficticia 1, Espera (Cádiz) | baja (sin cambios) | 100 |

### Curso `curso2627`

| Atributo | Valor |
| --- | --- |
| Nombre | 2026-27 |
| DiasTotales | 4 |
| TarifaKm | 0,24 €/km |
| PlusAlmuerzo | 20 € |

### Cita `c3`

| Atributo | Valor |
| --- | --- |
| Num_solicitud | 3 |
| Fecha | 12/11/2026 |
| Hora | 10:00 |
| Titulo | Cambio de grupo de mi hijo sin avisar a la familia |
| TextoSolicitud | «Mi hijo Daniel, de 4.º de Primaria, ha sido cambiado de grupo a mitad de curso sin que el centro nos lo comunicara ni nos diera explicaciones. El director, Julián Ferrer, firmó el cambio. Solicito una cita con la inspección.» |
| DocumentaciónAdjunta | [escrito_a_direccion.pdf] |
| Estado | PendienteDeRevisión → **Concertada** |
| Prioridad | media (la asigna `gloria`) |
| Procedencia | Portal_Citas |

### Visitas

| Objeto | Fecha | HoraInicio | HoraFin | Estado |
| --- | --- | --- | --- | --- |
| `v3` (CEIP Los Albarizones) | 18/11/2026 | 10:00 | 12:00 | Pendiente → **Finalizada** |
| `v4` (CEIP Fuente Clara) | 18/11/2026 | 13:15 | 14:45 | Pendiente → **Finalizada** |

Las dos visitas son del mismo inspector y el mismo día, y sus horarios no se solapan.

### Desplazamientos

| Atributo | `d3` | `d4` |
| --- | --- | --- |
| HoraSalida | 08:45 | 12:15 |
| HoraLlegadaDomicilio | — (Sergio no vuelve a casa) | 16:05 |
| KmVuelta | 0 (no vuelve: sigue a Espera) | 100 |

Los kilómetros de ida no son un atributo del desplazamiento: salen de `KmDesdeCadiz` del centro que recibe la visita (RN-01).

### Dietas

| Atributo | `dt3` | `dt4` |
| --- | --- | --- |
| Almuerzo | false | true |
| /Importe (derivado) | 9,12 € | 68,00 € |

Cálculo (RC-01, RN-01 y RN-02):

| Concepto | `dt3` | `dt4` |
| --- | --- | --- |
| Kilometraje | (38 KmDesdeCadiz + 0 KmVuelta) = 38 km × 0,24 €/km = 9,12 € | (100 KmDesdeCadiz + 100 KmVuelta) = 200 km × 0,24 €/km = 48,00 € |
| Plus de almuerzo | No aplica: no llega a su domicilio | 16:05 > 15:00: PlusAlmuerzo = 20,00 € |
| **Total** | **9,12 €** | **68,00 €** |

La `TarifaKm` y el `PlusAlmuerzo` son los de `curso2627`, no del desplazamiento.

### Informes

| Atributo | `i3` | `i4` |
| --- | --- | --- |
| Prioridad | media | baja |
| Observacion | El director reconoce que el cambio de grupo se hizo por ajuste de ratio y que no se comunicó a la familia. Se le requiere informar por escrito a Antonio y revisar el protocolo de comunicación. | Visita ordinaria de seguimiento sin incidencias. |

### Días de asuntos personales

`DiasAsuntosPersonales` es la clase asociación entre `Inspector` y `Curso`: cada objeto enlaza un inspector con `curso2627`. `DiasTotales` no es atributo suyo, sino del curso (4 días, supuesto para el escenario; el valor real depende de la legislación vigente, RC-02). `DiasRestantes` es derivado: `curso2627.DiasTotales - DiasSolicitados` (R-10).

| Objeto | Enlace (Inspector, Curso) | DiasSolicitados | /DiasRestantes |
| --- | --- | --- | --- |
| `diasSergio` | (`sergio`, `curso2627`) | 1 → **3** | 3 → **1** |
| `diasPaula` | (`paula`, `curso2627`) | 0 | 4 |
| `diasGloria` | (`gloria`, `curso2627`) | 2 | 2 |

## 3. Seguimiento de los datos

| # | Fecha | Quién | Qué ocurre | Objetos creados o modificados | Asociaciones | Requisitos |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 09/11 | Antonio | Registra la solicitud en el portal, como tutor legal de Daniel | Crea `c3`: Num_solicitud = 3, Estado = PendienteDeRevisión, Procedencia = Portal_Citas | `antonio` solicita `c3`; `c3` trataSobre `daniel` | RI-07, RC-06, RN-04, R-07 |
| 2 | 10/11 | Conserjería | Revisa y concierta la solicitud | `c3`: Estado = Concertada, Fecha y Hora | `gloria` atiende `c3` | RC-07 |
| 3 | 12/11 | Gloria | Atiende a Antonio, asigna la prioridad de la cita y comprueba que es jefa | `c3`: Prioridad = media; lee `gloria.esJefe = true` | — | RC-03, RN-05 |
| 4 | 12/11 | Gloria | Asigna a Sergio la visita derivada de la cita | Crea `v3`: Estado = Pendiente, con fecha y horas | `gloria` asigna `v3`; `sergio` realiza `v3`; `ceipAlbarizones` recibe `v3` | RI-09, RC-09, R-06 |
| 5 | 12/11 | Gloria | Asigna a Sergio una segunda visita ordinaria el mismo día | Crea `v4`: Estado = Pendiente, con fecha y horas | `gloria` asigna `v4`; `sergio` realiza `v4`; `ceipFuenteClara` recibe `v4` | RI-09, RC-09, R-06 |
| 6 | 18/11 | Sergio | Realiza la primera visita y la cierra | `v3`: Estado = Finalizada; crea `d3` e `i3` | `v3` existe `d3`; `v3` contiene `i3` (autor: `sergio`, responsable de `v3`, R-03) | RI-10, RI-11, RC-11, RN-03, R-01 |
| 7 | 18/11 | Sistema | Calcula la dieta del primer desplazamiento, sin plus | Crea `dt3`: Almuerzo = false (/Importe = 9,12 €) | `d3` requiere `dt3` | RI-12, RC-01, RN-01 |
| 8 | 18/11 | Sergio | Revisa la prioridad del centro a partir del informe | `ceipAlbarizones`: Prioridad = media | Camino `i3` → `v3` → `ceipAlbarizones` | RC-03 |
| 9 | 18/11 | Sergio | Se desplaza de un centro al otro, realiza la segunda visita, vuelve a casa y la cierra | `v4`: Estado = Finalizada; crea `d4` (KmVuelta = 100) e `i4` | `v4` existe `d4`; `v4` contiene `i4` (autor: `sergio`, R-03) | RI-10, RI-11, RC-11, RN-03, R-01 |
| 10 | 18/11 | Sistema | Calcula la dieta del segundo desplazamiento, con plus | Crea `dt4`: Almuerzo = true (/Importe = 68,00 €) | `d4` requiere `dt4` | RI-12, RC-01, RN-01, RN-02 |
| 11 | 19/11 | Sergio | Solicita dos días de asuntos personales | `diasSergio`: DiasSolicitados = 3, DiasRestantes = 1 | (`sergio`, `curso2627`) cuentaCon `diasSergio` | RI-13, RC-02 |
| 12 | 19/11 | Sergio | Consulta sus días de asuntos personales | Sin cambios en los datos | (`sergio`, `curso2627`) cuentaCon `diasSergio` | RC-13, RN-06 |
| 13 | 19/11 | Gloria | Consulta los días de asuntos personales de todos los inspectores | Sin cambios en los datos | (`sergio`, `curso2627`) y (`paula`, `curso2627`) cuentaCon `diasSergio` y `diasPaula` | RC-13, RN-06 |

Asociaciones que existen desde antes del escenario:

- `antonio` responsableDe `daniel`, con la tutela `Padre`.
- `antonio` e `isabel` trabajanEn `iesMarismas`; `isabel` esResponsable de él.
- `daniel` pertenece a `ceipAlbarizones`; `julian` trabajaEn él y esResponsable de él.
- `elisa` trabajaEn `ceipFuenteClara` y esResponsable de él.
- `iesMarismas` pertenece a `z02`.
- `ceipAlbarizones` y `ceipFuenteClara` pertenecen a `z03`.
- `gloria`, `sergio` y `paula` trabajan en `z03`.
- `gloria`, `sergio` y `paula` están enlazados con `curso2627`, con los objetos `diasGloria`, `diasSergio` y `diasPaula` como clase asociación.

## 4. Qué comprueba este escenario sobre el modelo

| Aspecto del modelo | Cómo lo refleja el escenario |
| --- | --- |
| Herencia solapada de `Persona` | `antonio` es a la vez `Profesor` y `TutorLegal`, con un único DNI |
| `DNI {unique}` | Representarlo con dos objetos de igual DNI no es válido |
| Tutela con un único tutor | `daniel` tiene un solo tutor legal, y la multiplicidad `1..*` lo admite |
| R-07 | `antonio` es tutor legal de `daniel`, el alumno sobre el que trata `c3` |
| Dos actividades del mismo inspector y día | `sergio` realiza `v3` y `v4` el mismo día, con horarios sin solapar |
| Cada visita tiene su desplazamiento | `d3` y `d4` son distintos, cada uno con su dieta |
| Dos desplazamientos encadenados | La ida se mide siempre desde Cádiz (`KmDesdeCadiz`); `d3` tiene `KmVuelta = 0` porque Sergio no vuelve, y `d4` registra la vuelta a casa |
| Plus de almuerzo solo donde procede (RN-02) | `dt3` no lo lleva y `dt4` sí, porque solo en `d4` Sergio llega a su domicilio después de las 15:00 |
| R-06 | `sergio` trabaja en `z03`, igual que los dos centros que visita |
| R-01 | `v3` y `v4` pasan a `Finalizada` con su informe y su desplazamiento |
| `(Inspector, Curso) .. DiasAsuntosPersonales` | Cada inspector tiene un objeto de días por curso, y el de `sergio` cambia |
| RN-06 | Cada uno consulta lo suyo y solo la jefa ve lo de todos |
| RN-07 | Los tres centros tienen exactamente un profesor responsable |
| Aviso solo si pasa a alta o urgente (RC-04) | `ceipAlbarizones` pasa de `baja` a `media` y no se avisa a nadie |

### Operaciones que el modelo debe rechazar

| Variación | Restricción que la impide |
| --- | --- |
| `sergio` consulta los días de asuntos personales de `paula` | RN-06 (regla de acceso, no se puede dibujar en el diagrama de objetos) |
| `antonio` solicita una cita sobre otro alumno de `ceipAlbarizones` del que no es tutor legal | R-07: el solicitante debe ser tutor legal del alumno |
| Se crea una segunda persona con el DNI de `antonio` para representar al padre | `DNI {unique}` |
| `dt3` con `Almuerzo = true` | RN-02: Sergio no llega a su domicilio en `d3` |
| `gloria` asigna a `sergio` una visita a un centro de `z02` | R-06: el inspector responsable debe trabajar en la zona del centro |
| `paula` se asigna `v4` a sí misma | R-02 / RN-05: quien asigna debe tener `esJefe = true` |
| `v4` queda `Finalizada` sin `d4` ni `i4` | R-01 |

### Limitaciones y hallazgos

Este escenario deja a la vista varios huecos del modelo:

1. **Resuelto.** `HoraLlegadaDomicilio` pasa a `[0..1]` y R-08 limita su valor al último desplazamiento del día. `d3` la deja vacía.
2. **Simplificación aceptada.** El modelo no guarda el trayecto real Jerez→Espera: la ida se mide siempre desde Cádiz (`KmDesdeCadiz`) y solo se registra `KmVuelta`, como dicen RN-01 y el glosario. Por eso `d4` cuenta 100 km de ida aunque Sergio salga de Jerez.
3. **RN-02 no dice qué pasa con dos desplazamientos el mismo día.** Aquí se ha aplicado el `PlusAlmuerzo` solo al último. Podría entenderse que se aplica a cada dieta o una sola vez al día.
4. **Resuelto.** R-09 impide que dos actividades del mismo inspector se solapen.
5. **Resuelto en parte.** `DiasTotales` y `Curso` permiten calcular `DiasRestantes` (R-10). Siguen sin registrarse las fechas ni quién aprueba los días solicitados, porque el catálogo no lo pide.
6. **RN-06 es una regla de acceso.** No se puede comprobar con un diagrama de objetos y hay que describirla en texto.
7. **No hay regla de conflicto de intereses.** Nada impide asignar a un inspector una visita a un centro donde trabaje un familiar.
8. **Persona solapada.** El modelo permite ahora que una persona sea `Profesor` y `TutorLegal`, pero la herencia de `Persona` también permite otras combinaciones (por ejemplo `Inspector` y `Profesor`). Convendría decidir si todas son válidas.
