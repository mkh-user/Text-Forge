# Text Forge

**Text Forge** es un editor de texto ligero, extensible y basado en modos. Es personalizable, programable mediante scripts y está preparado para manejar cualquier formato e idioma en un entorno orientado a objetos y basado en datos, sin necesidad de modificar el código fuente.

> [!Note]  
> Text Forge aún tiene muchas funciones incompletas o deshabilitadas, pero ya es utilizable (porque la mayoría de estas funciones no están relacionadas con el núcleo).

---

## ✨ Principios Fundamentales

- **Base independiente del lenguaje**  
  No hay suposiciones integradas sobre HTML, Python, JSON u otros lenguajes. Todas las reglas de formato y resaltado están definidas en recursos editables y portables.

- **Modos intercambiables en caliente (Hot-Pluggable)**  
  Cada modo es autónomo e incluye resaltado de sintaxis, comportamiento de formato y búferes según el tipo de archivo.

- **Acciones y atajos programables**  
  Todas las acciones (incluso `abrir` y `nuevo`) y sus atajos son scripts modulares separados del código fuente.

---

## ¿Por qué Text Forge?

Text Forge responde a la creciente necesidad de herramientas que **empoderen** en lugar de limitar. Diseñado como un editor de texto independiente con enfoque en la **modularidad, personalización profunda y diseño minimalista**, ofrece una base flexible y eficiente para quienes desean tener control total sobre su entorno de edición.

Con Text Forge:
- Su arquitectura interna está diseñada para facilitar la adición, eliminación o redefinición de componentes
- Un motor de formato versátil permite manejar texto estructurado complejo con precisión
- Ofrece una experiencia ligera e independiente—sin depender de ecosistemas pesados
- **Proporciona una base adaptable a distintos tipos de archivos, estilos de formato y flujos de trabajo**—en esencia, Text Forge es más que una aplicación: es un *marco para construir editores personalizados*

Nuestro objetivo es devolver las decisiones creativas y técnicas a manos del usuario—donde siempre debieron estar.

---

## 🧠 Estructura del Proyecto

### Núcleo  
Text Forge tiene un núcleo orientado a objetos con sistemas que permiten manejar cualquier tipo de extensión, por lo que todo puede cambiar sin modificar una sola línea del núcleo.

### Interfaz de Usuario basada en datos  
Text Forge utiliza archivos de configuración para cargar la interfaz y cuenta con un sistema flexible que permite extender fácilmente las secciones de la UI.

### API del Editor y Modos  
En Text Forge, cada archivo se maneja mediante un **modo**, que se carga a través de la API del editor para gestionar la carga/guardado, el resaltado de sintaxis y el formato automático. Así, puede manejar cualquier archivo usando los modos ubicados en la carpeta `/modes`.

### Scripts y Atajos  
¿Necesitas personalizar alguna funcionalidad? Puedes reemplazar el script correspondiente en la carpeta `/scripts` para crear tus propias acciones. ¿Quieres personalizar completamente la experiencia de usuario? Define tus atajos en la carpeta `/shortcuts` sin tocar el núcleo del editor.

---

## 🧩 Crear un Modo Personalizado

Text Forge puede manejar cualquier archivo mediante modos. Si deseas crear o editar uno, consulta [esta guía](https://github.com/mkh-user/text-forge) para obtener ejemplos y documentación.

---

## 🛠 Agregar un Comando

Puedes añadir cualquier funcionalidad a Text Forge sin modificar el código fuente. Consulta [esta página](https://github.com/mkh-user/text-forge) para ver ejemplos y guías.

---

## ✅ Modos Disponibles

Consulta los modos disponibles en [este enlace](https://github.com/mkh-user/text-forge).

---

## 🔐 Licencia

© 2025 Mahan Khalili  
Todos los derechos reservados. Este software es propiedad del autor y solo puede utilizarse con fines personales o académicos.  
La redistribución o el uso comercial requiere permiso por escrito. Contacto:  
[mahan.khalili.001@gmail.com](mailto:mahan.khalili.001@gmail.com)

---

## 🚀 Instalación

- Requiere plataformas de escritorio (comprobado completamente en Windows)

### Obtener el Núcleo  
#### Desde las versiones publicadas  
Descarga Text Forge desde la página de lanzamientos de GitHub y ejecútalo. Para mantener el editor ligero, los modos no están incluidos en los paquetes de lanzamiento.

#### Desde el código fuente  
Necesitas **Godot Engine (versión 4.4 o superior)** para ejecutar Text Forge. Una vez instalado, descarga o clona el repositorio y ábrelo con Godot. Luego, presiona `F5` para ejecutar el proyecto. Para mantener el repositorio limpio y separado de los modos, la carpeta `modes/` está excluida.

### Obtener Modos y Paquetes  
Para obtener los **modos** que necesitas, visita [esta página](https://github.com/mkh-user/text-forge-modes/releases), descárgalos y extráelos en la carpeta `modes`.

También puedes encontrar **paquetes** preconfigurados para casos específicos en [esta página](https://github.com/mkh-user/text-forge-modes/wiki/Packages). Los paquetes son colecciones de modos útiles para tipos específicos de usuarios.

---

## 🙌 Créditos

Creado por Mahan Khalili, con enfoque en modularidad, control y claridad.
