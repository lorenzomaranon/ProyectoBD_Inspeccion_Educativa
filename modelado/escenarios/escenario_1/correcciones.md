## 4. Correcciones sobre el seguimiento original

| Texto original | Corrección | Motivo |
| --- | --- | --- |
| La cita pasa directamente de la solicitud al inspector | Se añade la revisión de conserjería y los estados de la cita | RN-04 y RC-07 |
| «un inspector que if esJefe le asigna una actividad» | Se redacta en prosa y se indica qué pasa si no es jefe | RN-05 |
| «La visita puede tener un desplazamiento o no» | Toda visita finalizada tiene un desplazamiento; lo opcional es la dieta | Glosario, RI-11, RI-12 y restricción R-01 |
| «se calculará la dieta a partir de los atributos de Desplazamiento» | Se calcula con `Kilometros` y `TarifaKm`, que se han añadido al modelo (problema 2) | RC-01, RI-11 y RN-01 |
| «un Informe que está asociado a ambas» | Asociado a la visita y al inspector que lo redacta | «Ambas» no tenía referente claro; `Inspector -- Informe` y `Visita *-- Informe` |
| La prioridad del informe «participa en el cómputo total» de la del centro | La prioridad del centro se asigna manualmente, tomando el informe como referencia | RC-03 y glosario: no existe ninguna fórmula de cálculo (problema 7) |

## 5. Problemas detectados en el modelo

### Corregidos en `modelado_conceptual.puml` y `escenario_1.puml`

1. **`Actividad <|-- Cita` contradecía la RI-09**, que dice que toda actividad es o visita o tarea. Se elimina la herencia.
2. **A `Desplazamiento` le faltaban datos para calcular la dieta.** Se añaden `Kilometros` y `TarifaKm`.
3. **`HoraLlegada` era ambigua**, y la RN-02 necesita la llegada al domicilio. Pasa a llamarse `HoraLlegadaDomicilio`.
4. **`Visita *-- "1" Informe` y `Visita *-- "1" Desplazamiento` no admitían el estado intermedio.** Pasan a `0..1`, y la restricción R-01 los exige si `Estado = Finalizada`.
5. **Nada vinculaba la cita con el profesor.** Se añade `Cita "*" -- "*" Profesor : implicaA`.
6. **Faltaban multiplicidades y restricciones.** Los roles `responsable` y `jefe` pasan a multiplicidad `1`, y se añaden las restricciones R-02 (RN-05) y R-03 (RN-03).

### Pendientes de decisión

7. **El cómputo de la prioridad del centro no está definido.** Si se quiere un cálculo real en lugar de la asignación manual de RC-03, hace falta una nueva regla de negocio y declarar `/Prioridad` como atributo derivado.
8. **Conserjería no está en el modelo.** No queda registrado quién revisó la cita (paso 2). Es válido si se trata solo como perfil de usuario, pero conviene dejarlo decidido.
9. **El kilometraje puede interpretarse de dos formas.** RN-01 y RC-01 hablan del trayecto de Cádiz al centro; aquí se cuenta solo la ida. Con ida y vuelta, el kilometraje sería 32,64 € y el total 52,64 €.
10. **`Inspector "1" -- "*" Cita : atiende` no admite citas sin inspector.** En el paso 1, `c1` aún no tiene inspector, y una cita `Rechazada` nunca lo tendría. Propuesta: usar `0..1`.

### Cambios que afectan al catálogo de requisitos

- RI-07 debe recoger el profesor implicado en la cita, porque `implicaA` es una asociación nueva.
- RI-10 y RI-11 dicen «uno por visita» y deben precisar que se refiere a las visitas finalizadas.
- RI-11 debe incluir el kilometraje y aclarar que la hora de llegada es la llegada al domicilio.
