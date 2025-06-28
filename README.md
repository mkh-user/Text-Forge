[en](https://github.com/mkh-user/Text-Forge/tree/Main/README.md) | [fa](https://github.com/mkh-user/Text-Forge/tree/Main/docs/fa/README.md)
# Text Forge

Text Forge is a lightweight, extensible, and mode-driven text editor. It's customizable, scriptable, and ready to handle
any format and language in a data-driven and object-oriented environment without any change in source.

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
[here](https://github.com/mkh-user/text-forge) for guides and examples.

---

## 🛠 Adding a Command

You can add any functionality in text forge without change source, see [here](https://github.com/mkh-user/text-forge) for guides and examples.

---

## ✅ Available Modes

See [here](https://github.com/mkh-user/text-forge) for available modes.

---

## 🔐 License

© 2025 Mahan Khalili.  
All rights reserved. This software is owned by the creator and may only be used for personal or academic purposes.  
Redistribution or commercial use requires written permission. For inquiries, contact: 
[mahan.khalili.001@gmail.com](mailto:mahan.khalili.001@gmail.com)

---

## 🚀 Running Locally

- Requires desktop platforms (full checked in Windows)

Download latest release from releases page, extract where you want and run executable `TextForge` file!

---

## 🙌 Credit

Crafted by Mahan Khalili, with an eye toward modularity, control, and clarity.