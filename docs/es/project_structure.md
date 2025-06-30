# Estructura del Proyecto

Esta página explica la estructura de Text Forge y su diseño modular.

## Método de Desarrollo

Text Forge se construye con un enfoque en diseño modular, por lo tanto, todo se basa en programación orientada a objetos. Cada módulo debe ser independiente, aunque capaz de conectarse con otros módulos para formar un sistema completo. Para lograrlo, la comunicación entre los módulos sigue una lógica simple:

- Los comandos se envían a todos los módulos relevantes; cada módulo ejecuta solo aquellos que le conciernen y omite el resto.
- Las señales se emiten al SignalBus; si un módulo necesita una señal, debe conectarse a ella por sí mismo.

## Definiciones

- **Forge Port:** Funciones o señales que permiten a los módulos interactuar con Text Forge.
- **Forge Bridge:** Señales o funciones que permiten a los módulos externos comunicarse entre sí.

## Núcleo (Core)

Todo comienza aquí: después de que Godot se inicia, el núcleo de Text Forge se ejecuta y arranca el resto del sistema. Este núcleo también contiene el nodo principal de la escena, que permanece fijo durante toda la ejecución. No contiene puertos directamente, pero gestiona otras clases que sí tienen puertos y que permiten interactuar con el núcleo.

**Acceso:** `Global.get_core()`

## Extension Core

Clase reservada para extensiones. Esta función está en fase experimental y aún no está completa.

## SignalBus

Clase que contiene las señales más importantes del sistema. Todos los componentes se comunican a través de estas señales, incluida su interacción con los demás elementos de Text Forge.

**Acceso:** `Signals`

### Ejecución de Scripts

Hay dos tipos de scripts de acción: **Action Scripts** y **Multi Action Scripts**. Los Multi Action Scripts manejan submenús enteros y requieren más información para su ejecución.

- **Señal:** `run_script(script_id: int)` — **Forge Port**
- **Señal:** `run_subscript(id: int, submenu: PopupMenu, rootmenu: String)` — **Forge Port**

### Estado de Opciones

Para habilitar o deshabilitar opciones en la interfaz:

- **Señal:** `check_options` — **Forge Port**

### Sistema de Notificaciones

Señal pensada para permitir a módulos externos comunicarse entre sí, con soporte de datos como arreglo (`Array`):

- **Señal:** `notification(id: String, data: Array)` — **Forge Bridge**

### Otras Señales

Acciones comunes:

- `close_file` — **Forge Port**
- `open_file(path: String)` — **Forge Port**
- `new_file` — **Forge Port**
- `update_recent_files` — **Forge Port** ← recarga el submenú de archivos recientes

Uso interno:

- `caret_selected(index: int)`
- `mode_selected`

### Guardado y Callback

Cuando se necesita guardar cambios antes de ejecutar una acción:

1. El script llama `Signals.save_request(id)`
2. SignalBus muestra un diálogo de confirmación.
3. Si el usuario acepta guardar:
    - Se ejecuta el script de guardado con `callback = id`
    - Al terminar, emite `Signals.save_finished(id)`
    - Luego se ejecuta `run_script(id)`
4. Si el usuario descarta, se llama directamente `run_script(id)`

## GlobalAccess

Clase con accesos rápidos y seguros al núcleo:

- `get_core()` — **Forge Port**
- `get_editor()` — **Forge Port**
- `get_editor_api()` — **Forge Port**
- `get_editor_text()` — **Forge Port**
- `get_file_name()` — **Forge Port**
- `get_file_path()` — **Forge Port**
- `get_scripts_node()` — **Forge Port**
- `is_editor_disabled()` — **Forge Port**
- `set_editor_disabled(disabled: bool)` — **Forge Port**
- `set_editor_text(text: String)` — **Forge Port**
- `set_file_name(file_name: String)` — **Forge Port**
- `set_file_path(path: String)` — **Forge Port**

## ActionScript

Clase base para scripts de acción. Consideraciones clave:

- Se cargan desde `scripts/` según la configuración en `data/main_ui.ini`
- Nombres deben estar en `snake_case`
- Propiedades internas: `id`, `menu`, `need_file`, `action_shortcut`
- Funciones: `_ready()`, `run()`, `_run_action()`, etc.
- Si `need_file = true`, el comando se desactiva si no hay archivo abierto
- Accesos rápidos se cargan desde `shortcuts/`, deben ser objetos `Shortcut`
- Lógica principal va dentro de `_run_action()`