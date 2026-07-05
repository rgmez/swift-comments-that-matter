# WWDC26 Staff iOS Review: `swift-comments-that-matter`

Fecha de revisión: 5 de julio de 2026

## Resumen ejecutivo

La tesis central de la skill sigue siendo correcta:

> El código debe explicar qué ocurre; los comentarios deben preservar por qué existe una decisión y qué no puede romperse.

WWDC26 no exige sustituir esta regla, sino extenderla. Swift 6.3/6.4, SwiftUI en
los sistemas 2027 y Xcode 27 hacen explícitos nuevos contratos que no siempre se
deducen de la implementación: regiones de cancelación protegida, aislamiento y
transferencia entre tareas, ownership de valores no copiables, vida del estado en
contenedores lazy, observación automática, ownership de conexiones y streams,
límites entre código generado y código mantenido, y excepciones locales a los
diagnósticos del compilador.

La skill actual cubre concurrencia, invariantes y SwiftUI, pero todavía lo hace
con una taxonomía de Swift 5.9. La recomendación es evolucionarla a una versión
orientada a Swift 6.3+ y Xcode 27, conservando compatibilidad con proyectos
anteriores.

## Alcance y método

Se revisó el [catálogo completo de sesiones de WWDC26](https://developer.apple.com/videos/wwdc2026/)
para clasificar las sesiones según su impacto sobre comentarios, contratos de API,
invariantes, concurrencia, estado y mantenimiento asistido por agentes.

No todas las sesiones merecen convertirse en reglas de la skill. Se hizo una
segunda revisión, mediante resumen, capítulos, transcripción y código oficial, de
las sesiones con señal directa:

- [What’s new in Swift](https://developer.apple.com/videos/play/wwdc2026/262/)
- [What’s new in SwiftUI](https://developer.apple.com/videos/play/wwdc2026/269/)
- [Dive into lazy stacks and scrolling with SwiftUI](https://developer.apple.com/videos/play/wwdc2026/321/)
- [Use SwiftUI with AppKit and UIKit](https://developer.apple.com/videos/play/wwdc2026/272/)
- [Modernize your UIKit app](https://developer.apple.com/videos/play/wwdc2026/278/)
- [Build real-time apps and services with gRPC and Swift](https://developer.apple.com/videos/play/wwdc2026/265/)
- [Code-along: Add persistence with SwiftData](https://developer.apple.com/videos/play/wwdc2026/275/)
- [Migrate to Swift Testing](https://developer.apple.com/videos/play/wwdc2026/267/)
- [Profile, fix, and verify: Improve app responsiveness with Instruments](https://developer.apple.com/videos/play/wwdc2026/268/)
- [What’s new in Xcode 27](https://developer.apple.com/videos/play/wwdc2026/258/)
- [Xcode, agents, and you](https://developer.apple.com/videos/play/wwdc2026/259/)
- [Discover new capabilities in the App Intents framework](https://developer.apple.com/videos/play/wwdc2026/345/)

Las demás sesiones se consideran sin impacto directo o con impacto de dominio:
pueden aportar escenarios concretos, pero no justifican nuevas reglas generales
sobre comentarios Swift.

## Diagnóstico de la skill actual

### Fortalezas que deben mantenerse

- La regla `refactor-first` evita usar comentarios para compensar nombres o diseño
  pobres.
- La separación entre comentario local y artículo DocC es clara y práctica.
- El patrón `no comment -> bad -> good -> best` enseña criterio, no solo sintaxis.
- La rúbrica `Signal / Safety / Actionability` mide valor para el cambio futuro.
- Los escenarios de token refresh, deduplicación, pagos, rounding y ciclos async
  representan fallos reales.

### Gaps relevantes después de WWDC26

1. La compatibilidad declarada (`Swift 5.9+`) ya no describe el modelo de lenguaje
   que la skill debe enseñar.
2. `Concurrency:` es una categoría demasiado amplia. No distingue cancelación,
   aislamiento, lifetime, ownership de tareas ni backpressure.
3. No existe una regla que favorezca expresar contratos con el compilador antes
   que escribirlos en prosa.
4. No se diferencia código generado de código mantenido manualmente.
5. SwiftUI se limita al stale write async; faltan identidad, lifetime de estado,
   prefetch y reconstrucción en contenedores lazy.
6. La frontera DocC está bien definida por tamaño, pero no por fuente de verdad,
   verificabilidad o comportamiento dependiente de versión.
7. No hay guía para comentarios e instrucciones generados o consumidos por coding
   agents, pese a que Xcode 27 integra agentes y skills en el editor.

## Hallazgos WWDC26 y cambio recomendado

### 1. El compilador debe ganar a la prosa

Swift 6.3/6.4 incorpora mejores diagnósticos para tareas que ignoran errores,
`weak let`, conformidad negativa `~Sendable`, `@diagnose`, selectores de módulo,
`@C`, mejoras de ownership y accessors `borrow`/`mutate`. La sesión
[What’s new in Swift](https://developer.apple.com/videos/play/wwdc2026/262/)
también introduce un cancellation shield cuya región debe mantenerse corta y
dedicada a completar o revertir trabajo ya iniciado.

Nueva regla propuesta:

> Si el lenguaje puede expresar o verificar el contrato, exprésalo en tipos,
> aislamiento, ownership, disponibilidad o diagnósticos. Comenta únicamente la
> razón por la que se eligió ese contrato y el fallo de dominio que evita.

Esto evita comentarios como “not thread-safe” cuando `~Sendable`, un actor o un
tipo no copiable puede representar mejor la restricción.

### 2. Cancelación no equivale a rollback

La skill debe separar:

- propagación de cancelación;
- cleanup en `defer`;
- regiones que deben terminar pese a la cancelación;
- operaciones irreversibles;
- idempotencia de retry;
- errores de tareas no observados.

Escenario requerido:

```swift
/// Cancellation:
/// Once the file replacement starts, cancellation is shielded until commit or
/// rollback completes. Exiting midway can leave neither version recoverable.
```

El comentario no narra `withTaskCancellationShield`; documenta el punto de no
retorno y la condición de consistencia.

### 3. Ownership y lifetime son señales de primer nivel

Con tipos no copiables, accessors `borrow`/`mutate`, streams bidireccionales y
tareas estructuradas, “quién posee qué y hasta cuándo” pasa a ser una pregunta de
review obligatoria.

Añadir señales:

- `Ownership:`
- `Lifetime:`
- `Cancellation:`
- `Backpressure:`

No deben convertirse en una plantilla obligatoria. Se usan solo cuando protegen
una frontera no evidente.

### 4. El estado de SwiftUI lazy tiene una vida distinta a la del modelo

[Dive into lazy stacks and scrolling with SwiftUI](https://developer.apple.com/videos/play/wwdc2026/321/)
explica que las vistas fuera de pantalla pueden conservarse temporalmente, pero
su estado desaparece cuando SwiftUI las elimina. También recomienda no depender
del estado local para datos que deban sobrevivir al scroll, filtrar en el nivel de
datos y preparar estado antes de `onAppear` cuando la vista debe estar lista al
ser mostrada.

La skill necesita escenarios para:

- identidad estable en `ForEach`;
- estado efímero frente a estado de dominio;
- `onAppear` como señal repetible, no como inicializador único;
- prefetch y operaciones duplicadas;
- cambios de layout después de aparecer;
- cancelación y reentrada de `.task(id:)`.

Nueva pregunta del decision flow:

> ¿La corrección depende de identidad, lifetime o reconstrucción gestionados por
> el framework y no visibles en el cuerpo de la vista?

### 5. Observation introduce dependencias implícitas

[Use SwiftUI with AppKit and UIKit](https://developer.apple.com/videos/play/wwdc2026/272/)
muestra Observation automática en métodos de AppKit/UIKit y su adopción
incremental. Esto reduce glue code, pero vuelve menos visible qué lecturas
registran dependencias y qué mutaciones provocan una actualización.

La skill debería aceptar comentarios breves cuando:

- una lectura existe para registrar una dependencia de Observation;
- un callback debe ejecutarse dentro de un contexto de tracking;
- una mutación aparentemente redundante fuerza una invalidación necesaria;
- la compatibilidad depende de una clave de `Info.plist` en sistemas anteriores.

El comentario debe explicar el acoplamiento implícito, no enseñar `@Observable`.

### 6. Código generado: documentar la fuente, no el resultado

[Build real-time apps and services with gRPC and Swift](https://developer.apple.com/videos/play/wwdc2026/265/)
usa Protobuf como fuente de verdad y genera clientes, mensajes y protocolos. La
misma distinción aparece en App Intents y App Schemas.

Nueva regla:

> No añadas documentación manual al artefacto generado. Documenta el schema,
> specification o wrapper estable que controla el contrato, e indica el comando
> o proceso de regeneración cuando no sea descubrible.

Escenarios:

- números de campo Protobuf que nunca se reutilizan;
- compatibilidad forward/backward;
- lifecycle compartido de conexiones;
- cierre del stream como señal de cancelación;
- backpressure y orden de mensajes;
- ownership del cliente al entrar en background.

### 7. Los agentes elevan el coste de comentarios ambiguos

[What’s new in Xcode 27](https://developer.apple.com/videos/play/wwdc2026/258/) y
[Xcode, agents, and you](https://developer.apple.com/videos/play/wwdc2026/259/)
integran agentes, skills y tareas multi-step en el flujo normal de desarrollo.
Los comentarios ya no solo orientan a humanos: también son contexto para cambios
automatizados.

La skill debe prohibir comentarios que parezcan autoridad normativa sin serlo:

- TODO sin owner, condición o criterio de salida;
- “temporary” sin deadline o evento que permita eliminarlo;
- workarounds sin versión, radar, issue o prueba de retirada;
- afirmaciones de performance sin medición reproducible;
- comentarios que contradigan el tipo o los tests.

Nueva regla:

> Un comentario operativo debe incluir una condición verificable de vigencia o
> retirada. Si no puede verificarse, conviértelo en issue o elimínalo.

### 8. Performance: documentar presupuesto y evidencia, no intuición

[Profile, fix, and verify](https://developer.apple.com/videos/play/wwdc2026/268/)
propone un ciclo de diagnosticar, medir, corregir y comparar. Los comentarios de
performance deben enlazar una restricción reproducible: presupuesto, métrica,
traza, benchmark o patrón de contención.

Ejemplo:

```swift
/// Performance:
/// Keep decoding off the main actor; the 10k-item fixture otherwise exceeds the
/// 100 ms interaction budget measured by `SearchResults.trace`.
```

Evitar: “Optimized for performance”.

### 9. Tests como ubicación preferida para contratos ejecutables

[Migrate to Swift Testing](https://developer.apple.com/videos/play/wwdc2026/267/)
refuerza tests parametrizados, ejecución paralela, interoperabilidad y exit tests.
La skill debe incorporar una tercera frontera:

- código/tipos para contratos compilables;
- tests para contratos ejecutables;
- comentarios/DocC para intención, trade-offs y restricciones no ejecutables.

Antes de escribir “must never”, el reviewer debe preguntar si puede ser un
`#expect`, un test parametrizado, un exit test o una precondición.

## Propuesta de taxonomía revisada

Mantener:

- `Why:`
- `Assumption:`
- `Constraint:`
- `Invariant:`
- `Risk:`
- `Side Effects:`
- `Concurrency:`

Añadir:

- `Cancellation:` punto de cancelación, cleanup, rollback y no-retorno.
- `Isolation:` actor/executor requerido y motivo.
- `Ownership:` propietario único, transferencia, borrow o consumo.
- `Lifetime:` evento que crea, conserva y destruye estado o recurso.
- `Backpressure:` política ante productor más rápido que consumidor.
- `Performance:` presupuesto y evidencia reproducible.
- `Compatibility:` versión, fallback y condición de retirada.
- `Generated:` fuente de verdad y proceso de regeneración.

`Concurrency:` queda como señal general; cuando exista una dimensión más precisa,
debe preferirse la etiqueta específica.

## Nuevo decision flow recomendado

1. ¿Puede el nombre o la estructura eliminar la explicación?
2. ¿Puede el sistema de tipos, aislamiento, ownership, disponibilidad o un
   diagnóstico expresar el contrato?
3. ¿Puede un test o una precondición verificarlo?
4. ¿Existe comportamiento implícito del framework?
5. ¿La corrección depende de identidad, orden, lifetime, cancelación o ownership?
6. ¿Hay una fuente de verdad externa o código generado?
7. ¿El comentario contiene una condición verificable para seguir siendo cierto?
8. ¿Una modificación razonable podría romper algo sin que compiler/tests avisen?

Si las respuestas 4–8 son “no”, no añadir comentario.

## Backlog recomendado

### P0 — Actualización conceptual

1. Cambiar la compatibilidad a Swift 6.3+/Xcode 27, aclarando que el principio es
   retrocompatible.
2. Añadir la regla `compiler -> tests -> comment -> DocC`.
3. Ampliar el decision flow con comportamiento implícito, lifetime, ownership y
   verificabilidad.
4. Añadir red flags para comentarios destinados a agentes: TODO ambiguo,
   workaround sin retirada y afirmación de performance sin evidencia.

### P1 — Ejemplos que enseñan el nuevo criterio

1. Cancellation shield durante commit/rollback.
2. Tipo `~Sendable` frente a comentario “not thread-safe”.
3. Ownership de valor no copiable y accessors `borrow`/`mutate`.
4. Estado de fila perdido al salir de un `LazyVStack`.
5. `.task(id:)` con cancelación y stale completion.
6. Observation implícita en UIKit/AppKit.
7. gRPC bidireccional: cierre, cancelación, orden y backpressure.
8. Protobuf/App Schema como fuente de verdad.
9. Excepción `@diagnose` con motivo y condición de retirada.
10. Restricción de performance respaldada por fixture y trace.

### P2 — Producto y distribución de la skill

1. Añadir una matriz de ubicación: tipo, test, inline comment, DocC, issue.
2. Crear un modo de auditoría que clasifique cada comentario como `keep`,
   `refactor`, `encode`, `test`, `move-to-DocC` o `delete`.
3. Añadir tests de calidad para asegurar paridad entre `standards/` y `skills/`.
4. Validar todos los ejemplos con el toolchain actual cuando Xcode 27 sea estable.
5. Exportar la skill con formato compatible con los workflows de agentes de
   Xcode 27 y documentar el proceso de actualización.

## Criterios de aceptación

La mejora estará completa cuando:

- ningún ejemplo dependa de semántica obsoleta de Swift 5.9;
- cada nueva etiqueta tenga al menos un ejemplo `no/bad/good/best`;
- la skill prefiera contratos compilables o ejecutables frente a comentarios;
- SwiftUI cubra identidad y lifetime, no solo stale writes;
- concurrencia cubra cancelación, aislamiento y ownership por separado;
- exista una política explícita para código generado y fuentes de verdad;
- los workarounds incluyan versión/issue y condición de retirada;
- `standards/` y `skills/` permanezcan sincronizados;
- los enlaces locales y snippets Swift pasen validación automatizada.

## Decisión Staff

Recomiendo una evolución incremental, no un rewrite. El núcleo conceptual es
bueno y reconocible; reemplazarlo diluiría la skill. La versión siguiente debería
posicionarse como una guía para preservar contratos que Swift, los tests y los
frameworks todavía no pueden hacer evidentes por sí solos.

El cambio de mayor impacto es esta jerarquía:

> Primero haz el contrato explícito en el código. Después hazlo ejecutable en un
> test. Comenta únicamente la decisión, el límite o el riesgo que todavía queda
> invisible. Usa DocC cuando ese contexto deje de pertenecer a un solo símbolo.

