# TopNote

## Introduction  
TopNote is an internal plugin for Godot 4 that enables the creation and management of various notes within the editor. The aim of this tool is to enhance efficiency and simplify the processes of organizing, saving, and using texts such as notes, to-do lists, and codes with diverse capabilities.

## Features  
- **Quick and Simple Note-taking**: At any time, you have access to an unlimited page for writing and reading notes, providing all necessary functionalities.  
- **Task Management**: Create to-do lists and automatically categorize tasks with easy management.  
- **Save Frequently Used Codes**: The option to save any number of codes and add them to projects with a single click.  
- **Linked Notes**: Create notes for source files and save related details.  
- **Local Storage**: All information remains in the project directory and is fully compatible with version control systems.  
- **User-friendly Interface**: The interface seamlessly integrates with your overall editing experience, even when using customized themes.  
- **Flexibility**: Easily move panels to any location within the editor.

## Installation and Setup  
1. Download the plugin folder from the releases section.  
2. Go to the editor and use the import option in the asset library to import the zip file.  
3. Before starting the import process, ensure the paths of the files and folders are correct.  
4. Activate the plugin in Project Settings > Plugins.

## How to Use  
- On the first run, the plugin panel will be added to the bottom panel of the editor. In this panel, you have access to five options: Notes, To-Do List, Saved Codes, Linked Notes, and Menu (at the bottom of the page).  
- To configure the plugin and move the panel, use the menu option at the bottom of the panel. A pop-up will appear that allows you to move the panel to any part of the editor, so you can choose based on comfort and see the result.

> [!NOTE]  
> Please avoid frequently moving the panel; as this feature still has some bugs and may complicate your debugging system.

- If you move the panel to the toolbar or the 2D or 3D menu, a button will be added instead of the panel, which will load the panel in a pop-up.  
- In the notes section, you have an unlimited text editor at your disposal; your text will never be lost, and you can keep customized notes in it.  
- In the to-do section, there is an unlimited list of tasks. You can create a new task in one of three new categories (tasks for improving the project in the future), bug fixes (issues to be resolved), and uncategorized, using the second row of its menu, and select text for it. The first two categories are marked with + and !. You can change the status of each task from "incomplete" to "complete" or vice versa by clicking on any task. In the first row of the menu, there is a search and filter functionality, as well as a button that activates the delete mode. In delete mode, clicking on any task changes its status to "complete," and a pop-up appears; confirming it will delete the task.

- In the third section (Saved Codes), you can save any number of codes and select a specific name for them. Each code has three options:  
  1. **Copy Code Text**: This option copies the code text with the same specified formatting to memory.  
  2. **Edit**: Opens a pop-up that allows editing the name and text of the code.  
  3. **Delete**: This option deletes the code (no confirmation needed).

- Above these two bars, there are options for search and adding, which allow you to search by name or name and code.  
- In the last section, there is an editor that opens automatically by double-clicking on any source (like images) (if there is no button instead of the plugin panel). The text of this editor is saved based on the RID of the opened source and will display again with a double-click on that source.

## Contribution  
If you are interested in contributing to this project, please contact us or refer to the source code repository.

## About the Project  
TopNote is a tool for the Godot 4 editor that allows developers to better manage their projects. TopNote is released under the MIT license. If you would like to support this project, please contact me via email or other links available in my profile.  
The idea for this project and its structure is a personal project by Mahan Khalili (mkh-user), released as the first plugin under the Pulse Plugins subgroup, and this plugin is one of the few plugins that will directly connect to GDPulse.
