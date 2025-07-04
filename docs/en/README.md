[en](https://github.com/mkh-user/Text-Forge/tree/Main/README.md) | [fa](https://github.com/mkh-user/Text-Forge/tree/Main/docs/fa/README.md) | [zh](https://github.com/mkh-user/Text-Forge/tree/Main/docs/zh/README.md) | [es](https://github.com/mkh-user/Text-Forge/tree/Main/docs/es/README.md)
# Text Forge

Text Forge is a lightweight, extensible, and mode-driven text editor. It's customizable, scriptable, and ready to handle
any format and language in a data-driven and object-oriented environment without any change in source.

> [!Note]
> Text Forge still has many uncompleted/unenabled capabilities, but it is usable even now (because most of these uncompleted capabilities are not core-related).

---

## ✨ Core Principles

- **Language-Agnostic Foundation:**
  
  **No built-in assumptions** about HTML, Python, JSON, or any language. All formatting and highlight rules are defined 
  in editable and portable assets.

- **Hot-Pluggable Modes:**

  Each mode is self-contained with syntax-highlight, formatting behavior, and buffers based on file types.

- **Scriptable Shortcuts & Actions:**

  All actions (even `open` and `new`) and their shortcuts are modular scripts separated from source.

---

## Why Text Forge?

Text Forge is a response to the growing demand for tools that **empower** rather than constrain. Designed as a standalone text editor with a focus on **modularity, deep customization, and minimal design**, it offers a flexible and efficient foundation for users who want full control over their editing environment.

With Text Forge:
- The internal architecture is structured to make components easy to add, remove, or redefine
- A versatile formatting engine enables precise handling of complex, structured text
- It delivers a lightweight, independent experience—usable without dependency on heavy ecosystems
- **It provides a core foundation that can be rapidly adapted to various file types, formatting styles, and workflows**—in essence, Text Forge is more than an app; it functions as a *framework for building custom editors*

Our goal is to create a tool that puts creative and technical decisions back in the hands of the user—where they belong.

---

## 🧠 Project Structure

### Core
Text Forge have an object-oriented core with systems to handle any extension type, so anything can change without change
one line in the core.

### Data-driven UI
Text Forge uses configuration files to load UI and have flexible UI system for have highly extendable UI sections.

### Editor API & Modes
In Text Forge we have a **mode** to work with a file, modes will load by Editor API in app to handle loading/saving, 
syntax-highlighting and auto formatting, so Text Forge can handle any file using modes in `/modes` folder!

### Script & Shortcuts
Need to customize any option functionality? So you can replace your code in its script in `/scripts` folder to create 
your own actions. Need complete UX customization? Create your shortcut mapping in `/shortcuts` folder without touch 
editor core! 

---

## 🧩 Creating a Custom Mode

Text Forge can handle any file with modes, so if you want to create a mode or edit existing one, you can see 
[here](https://github.com/mkh-user/text-forge-modes/wiki/Modes-structure-guide) for guides and examples.

---

## 🛠 Adding a Command

You can add any functionality in text forge without change source, see [here](https://github.com/mkh-user/text-forge) for guides and examples.

---

## ✅ Available Modes

See [here](https://github.com/mkh-user/text-forge-modes) for available modes.

---

## 🔐 License

MIT 2025 Mahan Khalili. See more informations in LICENSE file.

---

## 🚀 Installing

- Requires desktop platforms (full checked in Windows)

### Get Core
#### From Releases
Just download Text Forge from Github releases page and run it! To keep our editor lightweight and clean, we don't include modes in the releases!
#### From Source
You need **Godot Engine** (4.4 or later) to run Text Forge. After get it, download or clone repo and open it with Godot. Then, just press `F5` to run project.  To keep source repo clean and separated from modes, we don't include modes in this repo! (`modes/` folder is ignored)

### Get Modes & Packages
 To get the **modes** you need, go to [this link](https://github.com/mkh-user/text-forge-modes/releases), download your modes, and extract them into the `modes` folder.
 
 Also, You can find equipped **packages** for specific cases on [this page](https://github.com/mkh-user/text-forge-modes/wiki/Packages). Packages are a collection of mods that are useful for a specific type of user.

---

## 🙌 Credit

Crafted by Mahan Khalili, with an eye toward modularity, control, and clarity.
