Cambios que ha exigido el [escenario 3](Situacion.md) en el modelo, el catálogo y el propio escenario. El diagrama de objetos es [escenario_3_objetos.puml](escenario_3_objetos.puml).

## 4. Correcciones sobre el seguimiento original

| Texto original | Corrección | Motivo |
| --- | --- | --- |
| «conserjería revisa la solicitud, le asigna una prioridad media y la concierta» | Conserjería solo revisa y concierta. La prioridad la asigna Gloria al atender la cita (paso 3) | Conserjería valida o rechaza la cita y no asigna prioridad (catálogo corregido, problema 5) |
| Paso 2: «`c3`: Estado = Concertada, Prioridad = media, Fecha y Hora», con requisitos RC-03 y RC-07 | Paso 2: Estado, Fecha y Hora (RC-07). Paso 3: `Prioridad = media` (RC-03 y RN-05) | Igual que la anterior |
| `d3`: `HoraLlegadaDomicilio` obligatoria, aunque Sergio no vuelve a casa | `HoraLlegadaDomicilio` es opcional: `d3` no tiene valor y solo `d4` lo tiene | R-08 y RN-02 (problema 1) |
| `DiasRestantes` como dato guardado (de 3 a 1) | `DiasRestantes` se calcula como `DiasTotales - DiasSolicitados`. La tabla incluye `Curso` y `DiasTotales` | R-10 y RC-02 (problema 3) |
| Los hallazgos 1, 2, 4 y 5 figuraban como limitaciones | Se marcan como resueltos (el 5, en parte) una vez aplicados los cambios de abajo | Problemas 1 a 4 |

## 5. Problemas detectados en el modelo

### Corregidos en `escenario_2.puml`

1. **`HoraLlegadaDomicilio` era obligatoria en todo desplazamiento.** En `d3` Sergio no vuelve a casa, así que el valor no tenía sentido. Pasa a `[0..1]` y se añade R-08: solo tiene valor en el último desplazamiento del día de un inspector.
2. **Nada impedía que dos actividades del mismo inspector se solaparan.** Sergio realiza `v3` y `v4` el mismo día. Se añade R-09: no se solapan las actividades de un mismo inspector responsable con la misma `Fecha`, y `HoraInicio` es anterior a `HoraFin`.
3. **`DiasAsuntosPersonales` no tenía datos para calcular `DiasRestantes`**, y RC-02 pide hacerlo según la legislación vigente. Se añaden `Curso` y `DiasTotales`, y `DiasRestantes` pasa a derivado (`/DiasRestantes`). Se añade R-10.

### Corregidos en el catálogo de requisitos

4. **El kilometraje salía «siempre» del centro de Cádiz**, pero `d4` parte de otro centro educativo. Se reescriben RN-01, RI-11, RC-01 y las entradas «Desplazamiento» y «Kilometraje» del glosario: el kilometraje se calcula entre el origen y el destino de cada desplazamiento, y el primero del día parte de Cádiz. RI-11 también incluye ahora el kilometraje y aclara que la hora de llegada es al domicilio, si el desplazamiento termina allí.
5. **El catálogo decía que conserjería asigna la prioridad.** Se corrige en la descripción del problema, el glosario («Nivel de prioridad»), el perfil Conserjería (3.1), RG-04 y RC-03: la asignan los inspectores. Esta corrección ya se había hecho en el escenario 1, pero se perdió al renombrar los archivos de `casos` a `escenarios`, y el catálogo la contradecía.

### Corregidos en otros archivos

6. **Escenarios 1 y 2, y R-05.** Se corrige que la prioridad de la cita la asigna el inspector que la atiende, no conserjería. En `escenario_2.puml`, R-05 deja de exigir `Prioridad` a una cita concertada. El escenario 3 ya está redactado con la prioridad asignada por el inspector.

### Corregidos en `modelado_conceptual.puml` y `escenario_2.puml`

- **`DNI {unique}`.** Se añade para que `antonio` sea un único objeto con dos clases: dos objetos con el mismo DNI no serían válidos.
- **`Persona {solapada}`.** Se añade porque `antonio` es a la vez `Profesor` y `TutorLegal`, algo que una herencia disjunta no permite.

