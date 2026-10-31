# Correcciones de modelado detectadas al validar los escenarios

Compara estas fuentes:

- [modelado_conceptual.puml](../../modelado_conceptual.puml) (MC)
- [escenario_1.puml](../escenario_1/escenario_1.puml) y [correcciones.md](../escenario_1/correcciones.md) (escenario 1)
- [CATALOGO_REQUISITOS.docx](../../../docs/CATALOGO_REQUISITOS.docx) (catálogo)
- [escenario_2.md](escenario_2.md) (escenario 2)

El resultado está en [escenario_2.puml](escenario_2.puml), el modelo propuesto. El MC no se ha modificado.

## 1. Conclusión

**Sí hacía falta cambiar el modelo.** El MC incumple varios requisitos del catálogo, y `escenario_1.puml` corrige parte de ellos, pero no todos.

Esto no garantiza que el modelo propuesto sea perfecto. Los escenarios pueden demostrar que un modelo falla, pero no que sea correcto: solo muestran que admite los casos probados. Lo que sí se puede afirmar es que cada cambio tiene una justificación y que los dos escenarios encajan en el modelo propuesto, salvo el orden de pasos de la sección 5. Esta comprobación se ha hecho a mano.

## 2. Qué aporta cada versión

| Cambio | MC | `escenario_1.puml` | `escenario_2.puml` | Justificación | Fiabilidad |
| --- | --- | --- | --- | --- | --- |
| Quitar `Actividad <\|-- Cita` | No | Sí | Sí | RI-09 y glosario | Exigido |
| `TarifaKm` | No | Sí | Sí | RI-11 y RC-01 | Exigido |
| `Kilometros` | No | Sí | Sí | RC-01 y RC-10 | Necesario para el cálculo; podría ser derivado |
| `HoraLlegadaDomicilio` | No | Sí | Sí | RN-02 | Exigido |
| `Informe` y `Desplazamiento` `0..1`, con R-01 | No | Sí | Sí | Estado `Pendiente` (RI-09) | Exigido por la lógica; requiere matizar RI-10 y RI-11 |
| Roles `1 responsable` y `1 jefe`, R-02 y R-03 | No | Sí | Sí | RI-09, RN-03 y RN-05 | Exigido |
| `Cita -- Profesor : implicaA` | No | Sí | Sí | Solo los escenarios | **Opcional**: el catálogo no lo pide |
| `Anotaciones` | Sí | **No** | Sí | RI-08, RC-03 y RC-12 | Exigido |
| `DiasAsuntosPersonales` | Sí | **No** | Sí | RI-13, RC-02, RC-13 y RN-06 | Exigido |
| `realiza` como asociación simple | No | No | **Nuevo** | Una parte solo puede tener un compuesto | El problema es seguro; la solución elegida es una opción |
| R-04: un profesor responsable por centro | No | No | **Nuevo** | RN-07 | Exigido |
| `atiende` con `0..1` | No | No (pendiente, problema 10) | **Nuevo** | RC-07: una cita rechazada no llega al inspector | Exigido por la lógica |
| `Fecha`, `Hora` y `Prioridad` de `Cita` con `[0..1]`, y R-05 | No | No | **Nuevo** | RC-06, RC-07 y pasos 1 y 2 de los casos | Interpretación: «fecha» es la de la cita, no la de la solicitud |
| R-06: inspector de la zona del centro | No | No | **Nuevo** | RI-02 y RC-05 | Interpretación: el catálogo solo lo dice para centros prioritarios |
| R-07: el solicitante es tutor del alumno | No | No | **Nuevo** | Glosario, «Cita», y RI-06 | Exigido por la lógica |

Las mejoras que `escenario_1.puml` no incluye son las seis marcadas como **Nuevo**, además de recuperar las dos clases que eliminó. El MC ya tenía esas dos clases, así que para el MC no son una mejora.

## 3. Rectificaciones de la versión anterior de este documento

- **R-01 no necesita cambiar.** Antes se presentaba como un problema del modelo, pero la restricción se aplica al estado final de la operación. Lo incorrecto es el orden de los pasos de los casos (sección 5).
- **`Prioridad` de `Cita` también es opcional.** Se asigna en el paso 2, igual que `Fecha` y `Hora`, y antes no se había detectado.
- **Profesor implicado del centro del alumno.** Se retira como restricción: el catálogo no la pide y `implicaA` ya es opcional.
- **Notas comentadas del MC.** Actualizarlas es limpieza y no mejora el modelo. `escenario_2.puml` no las incluye; siguen en el MC.

## 4. Cuestiones abiertas, sin cambios en el modelo

| # | Cuestión | Por qué no se ha cambiado |
| --- | --- | --- |
| 1 | ¿Se mantiene `implicaA`? | El catálogo no lo pide. Si se mantiene, hay que añadirlo a RI-07. |
| 2 | ¿Cómo encajan las citas por llamada o agenda (RI-07) con RN-04, que exige presentar toda solicitud por el portal? | Es una tensión del catálogo; el modelo admite ambas. |
| 3 | ¿Cuándo no hay dieta? `Desplazamiento *-- "0..1" Dieta` la hace opcional, pero todo desplazamiento tiene kilómetros y, por tanto, importe. | RI-12 dice «cuando corresponda» sin definirlo. |
| 4 | ¿Debe enlazarse la visita con la cita que la origina? Hoy no se puede saber qué visita surgió de qué cita. | El catálogo no lo pide. |
| 5 | `Inspector -- Informe : redacta` es derivable con R-03, a través de la visita. `Importe`, `Almuerzo` y `DiasRestantes` también se pueden calcular. | La redundancia no es un error; podría marcarse como derivado (`/`). |
| 6 | ¿Queda registrada conserjería en el modelo? (Problema 8 del escenario 1). | Es válido tratarla solo como perfil de usuario. |
| 7 | ¿El kilometraje es de ida o de ida y vuelta? (Problema 9 del escenario 1). | No afecta a la estructura, solo al importe. |

## 5. Pendiente fuera del modelo

**Orden de pasos en `escenario_1.md` y `escenario_2.md`.** La visita debe pasar a `Finalizada` en la misma operación que registra el desplazamiento y el informe, no antes.

**Errores en `escenario_2.md`:**

- **Aviso:** «Aviso solo si hay cambio» es impreciso. Según RC-04, se avisa cuando el centro pasa a prioridad alta o urgente.
- **Coordinadores:** la última limitación es falsa, porque RN-05 solo autoriza a los inspectores jefe. Hay que eliminarla.
- **Limitación de `atiende`:** deja de aplicar con el modelo propuesto.
- **Operaciones rechazadas:**
  - La fila de `v2` debe indicar que el error es dejar la visita `Finalizada` una vez terminada la operación sin `d2` ni `i2`.
  - `Procedencia = Llamada` es un valor válido según RI-07; hay que quitar la fila o reformularla.
  - La fila del segundo profesor responsable debe citar R-04.

**Catálogo.** RI-10 y RI-11 deben precisar que «uno por visita» se refiere a las visitas finalizadas. RI-11 debe incluir el kilometraje y aclarar que la hora de llegada es al domicilio.

**`correcciones.md` del escenario 1.** El título «Corregidos en `modelado_conceptual.puml` y `escenario_1.puml`» no es cierto para el MC.

## 6. Siguiente paso

Revisar en grupo la columna «Fiabilidad» y la sección 4. Si se acepta, `escenario_2.puml` puede sustituir al MC como única versión del modelo.
