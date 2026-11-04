# Correcciones detectadas con el escenario 2

Anomalías que el [escenario 2](../Situacion.md) revela en el modelo del escenario 1 ([escenario_1.puml](../../escenario_1/escenario_1.puml)). Ya están aplicadas en [escenario_2.puml](../escenario_2.puml).

| # | Situación del escenario 2 | Anomalía en el modelo del escenario 1 | Corrección | Requisito |
| --- | --- | --- | --- | --- |
| 1 | Paso 1: Pablo registra `c2`, que aún no tiene inspector | `Inspector "1" -- "*" Cita : atiende` obliga a que toda cita tenga inspector | `atiende` pasa a `"0..1"` y R-05 lo exige si la cita está `Concertada` | RC-07 |
| 2 | Pasos 1 a 3: `c2` no tiene `Fecha` ni `Hora` hasta que se concierta, ni `Prioridad` hasta que Luis la atiende | Los tres atributos son obligatorios | Pasan a `[0..1]`, con R-05 | RC-03, RC-06 y RC-07 |
| 3 | Paso 5: `v2` la realiza `nuria` y la recibe `ceipBahia` | `Inspector *-- Actividad` y `CentroEducativo *-- Visita` son composiciones y dan a `v2` dos compuestos, pero ni un inspector ni un centro están compuestos de visitas: son clases ajenas, y sus visitas se conservan aunque desaparezcan | `realiza` y `recibe` pasan a asociaciones simples. Que toda visita tenga centro e inspector lo garantiza la multiplicidad `1` | RI-09 |
| 4 | `ceipBahia` tiene dos profesores, y solo `mateo` es el responsable | Nada impide que `rosa` también tenga `esResponsableCentro = true` | R-04 | RN-07 |
| 5 | Luis asigna la visita a Nuria por ser «de la zona del centro» | Nada impide asignarla a un inspector de otra zona | R-06 | RI-02 y RC-05 |
| 6 | Pablo solicita la cita como tutor legal de Lucía | Nada impide que la cita trate sobre un alumno del que no es tutor | R-07 | RI-06 y glosario, «Cita» |

`escenario_2.puml` también difiere de `escenario_1.puml` en elementos que este ejemplo no revela:

- **Del [escenario 3](../../escenario_3/Situacion.md):** R-08, R-09, R-10, `HoraLlegadaDomicilio [0..1]` y los atributos `Curso`, `DiasTotales` y `/DiasRestantes`.
- **De `modelado_conceptual.puml`:** las clases `Anotación` y `DiasAsuntosPersonales`, `{unique}`, `{solapada}` y `1..*` en ambos lados de `responsableDe`.
