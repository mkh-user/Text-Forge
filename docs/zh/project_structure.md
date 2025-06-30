# 项目结构

本页面介绍了 Text Forge 的结构和模块化设计。

## 开发方法

Text Forge 专注于模块化设计，因此一切都基于面向对象编程。每个模块必须是独立的，同时又能与其他模块良好协作，构建一个完整的系统。为实现这一目标，模块之间的通信遵循以下简单逻辑：

- 命令会发送给所有相关模块，每个模块只执行与自身相关的命令，忽略其余部分。
- 事件信号会传递给 SignalBus，如果模块需要某个信号，必须自行连接。

## 定义

- **Forge Port（锻造端口）：** 允许模块与 Text Forge 核心交互的函数或信号。
- **Forge Bridge（锻造桥梁）：** 允许外部模块彼此交互的信号或函数。

## 核心（Core）

一切从这里开始。Godot 启动后，Text Forge 的核心会运行并启动其他部分。核心包含主场景节点，在整个程序运行期间保持不变。核心本身不直接包含端口，但它管理其他包含端口的类，这些类允许外部模块与核心交互。

**访问方式：** `Global.get_core()`

## Extension Core

用于扩展的类，目前为实验性功能，尚未完成。

## SignalBus

此类包含程序中最重要的信号。所有组件通过这些信号进行连接，与 Text Forge 的其他部分交互也通过此方式完成。

**访问方式：** `Signals`

### 脚本执行

有两种类型的动作脚本：**Action Scripts** 和 **Multi Action Scripts**。Multi Action Scripts 支持子菜单，并能独立处理所有子项，因此需要更多信息来运行。

- **信号：** `run_script(script_id: int)` — **Forge Port**
- **信号：** `run_subscript(id: int, submenu: PopupMenu, rootmenu: String)` — **Forge Port**

### 检查选项状态

为支持启用/禁用菜单项，SignalBus 提供了一个信号，所有动作脚本都会连接它：

- **信号：** `check_options` — **Forge Port**

### 通知系统

外部模块可通过 `notification` 信号与其他模块交互，支持通过 `Array` 传递数据。

- **信号：** `notification(id: String, data: Array)` — **Forge Bridge**

### 其他信号

常用操作：

- `close_file` — **Forge Port**
- `open_file(path: String)` — **Forge Port**
- `new_file` — **Forge Port**
- `update_recent_files` — **Forge Port**（用于重新加载最近文件菜单）

内部用途：

- `caret_selected(index: int)`
- `mode_selected`

### 保存与回调

当编辑器需要保存更改后再执行操作时，SignalBus 会协调整个流程：

1. 动作脚本调用 `Signals.save_request(id)`
2. SignalBus 弹出保存确认对话框
3. 如果用户选择“保存”：
    - 执行保存脚本，传入 `callback = id`
    - 保存完成后，脚本发送 `Signals.save_finished(id)`
    - SignalBus 标记为已保存，并执行 `run_script(id)`
4. 如果用户选择“放弃更改”，直接执行 `run_script(id)`

## GlobalAccess

提供快速、安全访问核心组件的函数：

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

动作脚本的基类。编写脚本时需注意：

- 脚本从 `scripts/` 加载，依据 `data/main_ui.ini` 中的 UI 配置
- 文件名需为 snake_case 格式
- 内部属性：`id`, `menu`, `need_file`, `action_shortcut`
- 主要函数：`_ready()`, `run()`, `_run_action()` 等
- 如果 `need_file = true` 且未打开文件，相关菜单项将被禁用
- 快捷键从 `shortcuts/` 加载，文件名与脚本同名但扩展名为 `.tres`
- 快捷键必须为 Godot 的 `Shortcut` 类型
- 主逻辑应写在 `_run_action()` 中
