[en](https://github.com/mkh-user/Text-Forge/tree/Main/README.md)|[fa](https://github.com/mkh-user/Text-Forge/tree/Main/docs/fa/README.md)
# Text Forge

Text Forge is a lightweight, extensible, and mode-driven text editor. It offers unlimited language support with all features in a data-driven and object oriented environment.

---

## ✨ Core Principles

- Standalone Architecture  
  Not embedded in another environment — fully self-contained with its own input handling, UI layers, and mode logic. Just run and use!

- Language-Agnostic Foundation  
  No built-in assumptions about HTML, Python, JSON, or any language. All formatting and highlight rules are defined in editable and portable assets.

- Hot-Pluggable Modes  
  Each mode is self-contained (e.g., modes/html/) with highlight, formatting behavior, and buffers based on file types.

- Scriptable Shortcuts & Actions  
  Bind any user-defined action to keyboard shortcuts. All actions are written in GDScript and loaded dynamically so anyone can customize them without change anything in core.

---

## 🧠 Project Structure

### Core
Text Forge have a object oriented core with data-driven UI, so anything can change without change one line in core.

### Data-driven UI
Text Forge uses configuration files to load UI and have flexible UI system.

### Editor API & Modes
In text forge we have a "mode" to work with a file, modes will load by Editor API in app to handle loading/saving, syntax-highlighting and auto formatting, so Text Forge can handle any file using modes in `modes` folder!

### Script & Shortcuts
Need to costumize any option functionality? So you can raplace your code in its script in `scripts` folder to create your own actions. Need complete UX costumization? Create your shortcut mapping in `shortcuts` folder without touch editor core! 

---

## 🧩 Creating a Custom Mode

Text Forge can handle any file with modes, so if you want create a mode or edit existing one, you can see [here](https://github.com/mkh-user/text-forge) for guides and examples.

---

## 🛠 Adding a Command

You can add any functionality in text forge without change source, see [here](https://github.com/mkh-user/text-forge) for guides and examples.

---

## ✅ Available Modes

See [here](https://github.com/mkh-user/text-forge) for availablr modes.

---

## 🔐 License

© 2025 Mahan Khalili.  
All rights reserved. This software is owned by the creator and may only be used for personal or academic purposes.  
Redistribution or commercial use requires written permission. For inquiries, contact: mahan.khalili.001@gmail.com

---

## 🚀 Running Locally

- Requires desktop platforms (full checked in Windows)

Download latest release from releases page, extract where you want and run executable `TextForge` file!

---

## 🙌 Credit

Crafted by Mahan Khalili, with an eye toward modularity, control, and clarity.