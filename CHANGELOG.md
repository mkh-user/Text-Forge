# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Help menu
- Docs: Project Structure Guide
- Notifications panel
- Panel support
- Translation system
- Settings sytstem
- Log editor notifications
- Find & Replace panel
- Action Scripts for:
	- Edit:
		- Evulate Selection
	- Search:
		- Find and Replace
		- Find Next
		- Find Previous
		- Replace All
	- Command:
		- Remove All Indents
	- View:
		- Change Editor Font Size
		- Focus On Editor
		- Breakpoints
		- Bookmarks
		- Line Numbers
	- Help:
		- Github Repository
		- Mode Library
		- Forum
		- Share Feedback
		- Submit Issue
		- Online Docs
		- About

### Changed

- Edit/Auto Format shortcut: ~Ctrl+Alt+F~ to Ctrl+Shift+F

### Removed

- Help option from Settings menu (added Help menu instead)

### Fixed

- [Fix call _update_recent_files from scripts](https://github.com/mkh-user/Text-Forge/commit/8c8ce45f759af6887699f7702c8abfde04915a98)

## [0.1.0] - 2025-06-30

### Added

- Core for handle modules.
- EditorAPI to handle modes.
- Action Script support.
- File based shortcut system.
- Data-driven UI.
- Docs in 4 languages (en, fa, es, zh)

[unreleased]: https://github.com/mkh-user/text-forge/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/mkh-user/text-forge/releases/tag/v0.1.0
