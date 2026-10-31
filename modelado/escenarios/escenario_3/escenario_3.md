### ESCENARIO DE PRUEBA 3: Persona con dos perfiles, dos visitas el mismo día y días de asuntos personales

# Título: Un profesor pide una cita como padre; el inspector encadena dos visitas en un día y consulta sus días de asuntos personales

> Todas las personas, centros y datos de este escenario son inventados.

> Este escenario se valida contra el modelo de [escenario_2.puml](../escenario_2/escenario_2.puml) (restricciones R-01 a R-07), no contra el `modelado_conceptual.puml` actual.

## 1. Situación

Antonio Ríos es profesor de Lengua en el IES Marismas del Guadalete (El Puerto de Santa María) y, a la vez, padre y único tutor legal de Daniel Ríos, alumno de 4.º de Primaria en el CEIP Los Albarizones (Jerez de la Frontera). Antonio es una sola persona con dos perfiles: profesor en un centro y tutor legal de un alumno de otro.

El lunes 9 de noviembre de 2026, Daniel le cuenta que lo han cambiado de grupo a mitad de curso sin que nadie se lo comunicara a la familia. Antonio, como tutor legal, solicita por escrito una cita con la inspección a través del portal y adjunta el escrito que ya envió a la dirección. La solicitud menciona al director del centro, Julián Ferrer, que firmó el cambio. La solicitud queda pendiente de revisión.

Al día siguiente, conserjería revisa la solicitud y la concierta para el jueves 12 de noviembre, trasladándola a la inspectora jefe Gloria Aranda, que es quien la atiende.

Tras reunirse con Antonio, Gloria le asigna a la cita una prioridad media y, como es inspectora jefe (`esJefe = true`), asigna dos visitas al inspector Sergio Molina, que trabaja en la zona de ambos centros, para el miércoles 18 de noviembre:

- Una **visita** al CEIP Los Albarizones, para comprobar el cambio de grupo.
- Una **visita ordinaria** al CEIP Fuente Clara (Espera), que no tiene relación con la cita. Se programa el mismo día para aprovechar el viaje.

El 18 de noviembre, Sergio sale de Cádiz hacia Jerez y realiza la primera visita. Después va directamente de Jerez a Espera, realiza la segunda y regresa a su domicilio. Cada visita tiene su propio desplazamiento. El primero va de Cádiz a Jerez. El segundo va de un centro educativo a otro, no desde Cádiz. Solo en el segundo Sergio vuelve a casa, y lo hace pasadas las 15:00, así que solo ahí se añade el plus de almuerzo.

Al día siguiente, Sergio solicita dos días de asuntos personales y el sistema recalcula los que le quedan. Sergio consulta los suyos sin problema, pero no puede consultar los de su compañera Paula Reyes. Gloria, como inspectora jefe, sí puede ver los de ambos.

## 2. Datos del escenario

### Personas

| Objeto | Clase | Nombre y apellidos | DNI | Atributos propios |
| --- | --- | --- | --- | --- |
| `antonio` | **Profesor y TutorLegal** | Antonio Ríos Cabello | 00000021K | asignaturasImparte = [Lengua]; esResponsableCentro = false |
| `daniel` | Alumno | Daniel Ríos Pineda | 00000022E | — |
| `isabel` | Profesor | Isabel Montero Gil | 00000023T | asignaturasImparte = [Geografía e Historia]; esResponsableCentro = true |
| `julian` | Profesor | Julián Ferrer Lozano | 00000024R | asignaturasImparte = [Matemáticas]; esResponsableCentro = true |
| `elisa` | Profesor | Elisa Quintero Vera | 00000025W | asignaturasImparte = [Conocimiento del Medio]; esResponsableCentro = true |
| `gloria` | Inspector | Gloria Aranda Pons | 00000026A | esJefe = true |
| `sergio` | Inspector | Sergio Molina Duarte | 00000027G | esJefe = false |
| `paula` | Inspector | Paula Reyes Gil | 00000028M | esJefe = false |

`antonio` es **un único objeto** con dos clases. Si fuesen dos objetos, tendrían el mismo DNI.

`isabel`, `julian` y `elisa` aparecen para cumplir la RN-07: cada centro tiene exactamente un profesor responsable.

### Tutela (`antonio` – `daniel`)

| Atributo | Valor |
| --- | --- |
| parentesco | Padre |

`antonio` es el único tutor legal de `daniel`.

### Zonas

| Objeto | Código | Nombre |
| --- | --- | --- |
| `z02` | Z-02 | Bahía de Cádiz |
| `z03` | Z-03 | Campiña de Jerez |

### Centros educativos

| Objeto | Identificación | Ubicación | Prioridad |
| --- | --- | --- | --- |
| `iesMarismas` | 11999003 – IES Marismas del Guadalete | Calle Ficticia 3, El Puerto de Santa María (Cádiz) | baja (sin cambios) |
| `ceipAlbarizones` | 11999004 – CEIP Los Albarizones | Calle Ficticia 21, Jerez de la Frontera (Cádiz) | baja → **media** |
| `ceipFuenteClara` | 11999005 – CEIP Fuente Clara | Plaza Ficticia 1, Espera (Cádiz) | baja (sin cambios) |

### Cita `c3`

| Atributo | Valor |
| --- | --- |
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
| Origen | Centro de Cádiz | CEIP Los Albarizones, Jerez de la Frontera |
| Destino | CEIP Los Albarizones, Jerez de la Frontera | CEIP Fuente Clara, Espera |
| HoraSalida | 08:45 | 12:15 |
| HoraLlegadaDomicilio | — (Sergio no vuelve a casa) | 16:05 |
| Kilometros | 38 | 41 |
| TarifaKm | 0,24 €/km | 0,24 €/km |

`d4` no sale de Cádiz, sino de un centro educativo.

### Dietas

| Atributo | `dt3` | `dt4` |
| --- | --- | --- |
| Importe | 9,12 € | 29,84 € |
| Almuerzo | false | true |

Cálculo (RC-01, RN-01 y RN-02):

| Concepto | `dt3` | `dt4` |
| --- | --- | --- |
| Kilometraje | 38 km × 0,24 €/km = 9,12 € | 41 km × 0,24 €/km = 9,84 € |
| Plus de almuerzo | No aplica: no llega a su domicilio | 16:05 > 15:00 = 20,00 € |
| **Total** | **9,12 €** | **29,84 €** |

Como en los escenarios 1 y 2, el kilometraje cuenta solo el trayecto de ida (problema 9 de [correcciones.md](../escenario_1/correcciones.md)).

### Informes

| Atributo | `i3` | `i4` |
| --- | --- | --- |
| Prioridad | media | baja |
| Observacion | El director reconoce que el cambio de grupo se hizo por ajuste de ratio y que no se comunicó a la familia. Se le requiere informar por escrito a Antonio y revisar el protocolo de comunicación. | Visita ordinaria de seguimiento sin incidencias. |

### Días de asuntos personales

Se supone, para el escenario, un total de 4 días en el curso. El valor real depende de la legislación vigente (RC-02).

| Objeto | Inspector | DiasSolicitados | DiasRestantes |
| --- | --- | --- | --- |
| `diasSergio` | `sergio` | 1 → **3** | 3 → **1** |
| `diasPaula` | `paula` | 0 | 4 |
| `diasGloria` | `gloria` | 2 | 2 |

## 3. Seguimiento de los datos

| # | Fecha | Quién | Qué ocurre | Objetos creados o modificados | Asociaciones | Requisitos |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | 09/11 | Antonio | Registra la solicitud en el portal, como tutor legal de Daniel | Crea `c3`: Estado = PendienteDeRevisión, Procedencia = Portal_Citas | `antonio` solicita `c3`; `c3` trataSobre `daniel`; `c3` implicaA `julian` | RI-07, RC-06, RN-04, R-07 |
| 2 | 10/11 | Conserjería | Revisa y concierta la solicitud | `c3`: Estado = Concertada, Fecha y Hora | `gloria` atiende `c3` | RC-07 |
| 3 | 12/11 | Gloria | Atiende a Antonio, asigna la prioridad de la cita y comprueba que es jefa | `c3`: Prioridad = media; lee `gloria.esJefe = true` | — | RC-03, RN-05 |
| 4 | 12/11 | Gloria | Asigna a Sergio la visita derivada de la cita | Crea `v3`: Estado = Pendiente, con fecha y horas | `gloria` asigna `v3`; `sergio` realiza `v3`; `ceipAlbarizones` recibe `v3` | RI-09, RC-09, R-06 |
| 5 | 12/11 | Gloria | Asigna a Sergio una segunda visita ordinaria el mismo día | Crea `v4`: Estado = Pendiente, con fecha y horas | `gloria` asigna `v4`; `sergio` realiza `v4`; `ceipFuenteClara` recibe `v4` | RI-09, RC-09, R-06 |
| 6 | 18/11 | Sergio | Realiza la primera visita y la cierra | `v3`: Estado = Finalizada; crea `d3` e `i3` | `v3` existe `d3`; `sergio` redacta `i3`; `v3` contiene `i3` | RI-10, RI-11, RC-11, RN-03, R-01 |
| 7 | 18/11 | Sistema | Calcula la dieta del primer desplazamiento, sin plus | Crea `dt3`: Importe = 9,12 €, Almuerzo = false | `d3` requiere `dt3` | RI-12, RC-01, RN-01 |
| 8 | 18/11 | Sergio | Revisa la prioridad del centro a partir del informe | `ceipAlbarizones`: Prioridad = media | Camino `i3` → `v3` → `ceipAlbarizones` | RC-03 |
| 9 | 18/11 | Sergio | Se desplaza de un centro al otro, realiza la segunda visita, vuelve a casa y la cierra | `v4`: Estado = Finalizada; crea `d4` (Origen = `ceipAlbarizones`) e `i4` | `v4` existe `d4`; `sergio` redacta `i4`; `v4` contiene `i4` | RI-10, RI-11, RC-11, RN-03, R-01 |
| 10 | 18/11 | Sistema | Calcula la dieta del segundo desplazamiento, con plus | Crea `dt4`: Importe = 29,84 €, Almuerzo = true | `d4` requiere `dt4` | RI-12, RC-01, RN-01, RN-02 |
| 11 | 19/11 | Sergio | Solicita dos días de asuntos personales | `diasSergio`: DiasSolicitados = 3, DiasRestantes = 1 | `sergio` cuentaCon `diasSergio` | RI-13, RC-02 |
| 12 | 19/11 | Sergio | Consulta sus días de asuntos personales | Sin cambios en los datos | `sergio` cuentaCon `diasSergio` | RC-13, RN-06 |
| 13 | 19/11 | Gloria | Consulta los días de asuntos personales de todos los inspectores | Sin cambios en los datos | `sergio` y `paula` cuentaCon `diasSergio` y `diasPaula` | RC-13, RN-06 |

Asociaciones que existen desde antes del escenario:

- `antonio` responsableDe `daniel`, con la tutela `Padre`.
- `antonio` e `isabel` pertenecen a `iesMarismas`.
- `daniel` y `julian` pertenecen a `ceipAlbarizones`.
- `elisa` pertenece a `ceipFuenteClara`.
- `iesMarismas` pertenece a `z02`.
- `ceipAlbarizones` y `ceipFuenteClara` pertenecen a `z03`.
- `gloria`, `sergio` y `paula` trabajan en `z03`.
- `gloria`, `sergio` y `paula` cuentaCon `diasGloria`, `diasSergio` y `diasPaula`, respectivamente.

## 4. Qué comprueba este escenario sobre el modelo

| Aspecto del modelo | Cómo lo refleja el escenario |
| --- | --- |
| Herencia solapada de `Persona` | `antonio` es a la vez `Profesor` y `TutorLegal`, con un único DNI |
| `DNI {unique}` | Representarlo con dos objetos de igual DNI no es válido |
| Tutela con un único tutor | `daniel` tiene un solo tutor legal, y la multiplicidad `1..*` lo admite |
| R-07 | `antonio` es tutor legal de `daniel`, el alumno sobre el que trata `c3` |
| Dos actividades del mismo inspector y día | `sergio` realiza `v3` y `v4` el mismo día, con horarios sin solapar |
| Cada visita tiene su desplazamiento | `d3` y `d4` son distintos, cada uno con su dieta |
| Desplazamiento entre dos centros | `d4` tiene como `Origen` un centro educativo y no el centro de Cádiz |
| Plus de almuerzo solo donde procede (RN-02) | `dt3` no lo lleva y `dt4` sí, porque solo en `d4` Sergio llega a su domicilio después de las 15:00 |
| R-06 | `sergio` trabaja en `z03`, igual que los dos centros que visita |
| R-01 | `v3` y `v4` pasan a `Finalizada` con su informe y su desplazamiento |
| `Inspector 1 -- 1 DiasAsuntosPersonales` | Cada inspector tiene exactamente un objeto de días, y el de `sergio` cambia |
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

1. **`HoraLlegadaDomicilio` es obligatoria en todo desplazamiento.** `d3` no termina en el domicilio, así que su valor no tiene sentido. Habría que poner `[0..1]` o decidir qué se guarda en los desplazamientos intermedios.
2. **RN-01, RI-11 y el glosario dicen que el kilometraje es «siempre» desde Cádiz.** `d4` sale de un centro. Hay que reescribirlos para admitir trayectos entre centros.
3. **RN-02 no dice qué pasa con dos desplazamientos el mismo día.** Aquí se ha aplicado el plus de 20 € solo al último. Podría entenderse que se aplica a cada dieta o una sola vez al día.
4. **El modelo no impide que dos actividades del mismo inspector se solapen.** Aquí no ocurre, pero ninguna restricción lo prohíbe.
5. **`DiasAsuntosPersonales` solo guarda contadores.** No registra las fechas ni quién aprueba los días solicitados, y RC-02 pide calcularlos según la legislación.
6. **RN-06 es una regla de acceso.** No se puede comprobar con un diagrama de objetos y hay que describirla en texto.
7. **No hay regla de conflicto de intereses.** Nada impide asignar a un inspector una visita a un centro donde trabaje un familiar.
8. **Persona solapada.** El modelo permite ahora que una persona sea `Profesor` y `TutorLegal`, pero la herencia de `Persona` también permite otras combinaciones (por ejemplo `Inspector` y `Profesor`). Convendría decidir si todas son válidas.
