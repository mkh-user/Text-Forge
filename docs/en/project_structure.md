# Project Structure

This page is an explanation about Text Forge structure and modular design.

## Development Method

The focus is on the modular design in Text Forge, so everything is based on object-oriented programming. Each module 
must be independent, While it can be well-connected to other modules to form a complete system; To achieve this goal, 
the communication between modules in the Forge Text has a simple logic:

- The commands are sent to all relevant modules, each module is responsible for executing the order that relates to 
    itself and ignores the rest.
- Event signals are transferred to SignalBus, if the module needs a signal, it must be connected to it by itself.

## Definitions

- **Forge Port:** Functions or signals that allow modules to interact with Text Forge.
- **Forge Bridge:** Signals (or functions) that allow external modules to interact with other modules.

## Core

It all starts here, after loading Godot the Text Forge core is run to start everything else. This core also includes the
main scene node which is fixed during the entire runtime of the program, the core does not actually contain any specific
ports, but it manages other classes with ports that allow external modules to interact with the core.

**Access way:** `Global.get_core()`

## Extension Core

This class is for extensions, this feature is an experimental and uncompleted feature in Text Forge.

## SignalBus

This class is the location of the most important signals, all components of the program are connected through these 
signals, and interaction with other Text Forge components is done in this way.

**Access way:** `Signals`

### Script Running

There is two types of action scripts: **Action Scripts** and **Multi Action Scripts**. Multi Action Scripts are options with 
submenu that can handle all items in submenu by itself, so they have more required details to run.

**Signal:** `run_script(script_id: int)` **Forge Port**

**Signal:** `run_subscript(id: int, submenu: PopupMenu, rootmenu: String)` **Forge Port**

### Check Options State

To handle enabling / disabling options, SignalBus have a signal that is connected to all action scripts and multi action
scripts for this feature:

**Signal:** `check_options` **Forge Port**

### Notification System

There is a connection port for external modules to add ability to work with other modules, `notification` signal have an
id based connection port with support for data transfer as `Array`.

**Signal:** `notification(id: String, data: Array)` **Forge Bridge**

### Other Signals

There is some special signals for some actions:

**Signal:** `close_file` **Forge Port**

**Signal:** `open_file(path: String)` **Forge Port**

**Signal:** `new_file` **Forge Port**

**Signal:** `update_recent_files` **Forge Port**, This signal will call related function in core to reload recent files
submenu from its file in data

Also, some signals for internal usages:

**Signal:** `caret_selected(index: int)`

**Signal:** `mode_selected`

### Save and Callback

Sometimes editor need to save changes and then do an action, in these cases SignalBus is an important part:

- Action script with an `id` calls `Signals.save_request(id)`, this action means script with this `id` is in pending for save
    state.
- SignalBus creates a confirmation dialog for save changes request, here:
    - If user select `Save`, SignalBus calls save action script (first match in children of `Scripts` node) with
        `callback = id` parameter (If save as is required save action script will do this for save_as action script).
        - After save, save or save as action script emits `Signals.save_finished(id)` and resets callback parameter.
        - SignalBus will mark changes as saved and emits `run_script(id)`
    - If user select `Discard`, SignalBus emits `run_script(id)`.
- Action script receives run command and do action.

## GlobalAccess

This class have some functions for faster and safer access to important parts of Text Forge.

**Function:** `get_core()` **Forge Port**, see `Core` section for more information.

**Function:** `get_editor()` **Forge Port**, returns main editor node.

**Function:** `get_editor_api()` **Forge Port**, returns EditorAPI that manage modes, see `EditorAPI` section for more
    information.

**Function:** `get_editor_text()` **Forge Port**, returns current text of editor.

**Function:** `get_file_name()` **Forge Port**, returns name of currently opened file.

**Function:** `get_file_path()` **Forge Port**, returns path to currently opened file.

**Function:** `get_scripts_node()` **Forge Port**, returns parent node of scripts.

**Function:** `is_editor_disabled()` **Forge Port**, returns `true` if editor is disabled.

**Function:** `set_editor_disabled(disabled: bool)` **Forge Port**, can disable / enable the editor.

**Function:** `set_editor_text(text: String)` **Forge Port**, sets `text` to editor, will move caret to start of text.

**Function:** `set_file_name(file_name: String)` **Forge Port**, sets `file_name` as name of opened file, isn't loading!

**Function:** `set_file_path(path: String)` **Forge Port**, sets `path` as opened file path, isn't loading!

## ActionScript

This is base class for action scripts, to create an actions script you need to know these:

- Scripts will load from `scripts/` based on `data/main_ui.ini`, so if there is an option in UI source and a script with same name (converted to 
    **snake_case**) in `scripts/` folder `.gd` file of action script will load, otherwise nothing happens.
- Scripts have this internal items: property: `id, menu, need_file, action_shortcut`, function: `_ready, _check_option, 
    _load_shotcut, _convert_event_to_key, run, _run_action`
- Core will call `run` function and this function will call `_run_action` if command id is correct.
- `_ready` function have `_load_shortcut` call, so if you want to overwrite it you should add `_load_shortcut()` in your
    `_ready`
- If `need_file` is `true` (default is `false`) when there is no opened file, script will disable related option in
    menus.
- Shortcuts will load from `shortcuts/` folder from a file with same name as action script file (`.tres` instead of 
    `.gd`), if this file doesn't exist, nothing happens.
- Shortcuts should be from `Shortcut` class of Godot. 
- Write main logic of your action in `_run_action()`.