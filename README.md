# Tech Ticket Hero

Tech Ticket Hero is a small 2D game built with Godot. The player navigates campus and office scenes, completing tech-related tasks and interacting with NPCs to progress through levels.

## Features
- Single-player 2D adventure with multiple levels and NPC interactions
- Mobile-friendly input and UI
- Scene-based project structure with reusable `Global` autoloads

## Requirements
- Godot Engine 4.6 (project configured for Godot 4.x)
- Desktop or mobile platform supported by Godot 4.6

## Run the project
1. Install Godot 4.6 from https://godotengine.org if you don't have it.
2. Open the project folder in the Godot editor (open the folder containing `project.godot`).
3. Set the main scene to the game scene or `game_intro.tscn` and run the project.

## Controls
- Keyboard: WASD or arrow keys to move
- Interact: `E` (or on-screen touch controls for mobile)
- Pause: platform-specific pause key / UI

## Project Structure (high level)
- `Scenes/` — all game scenes and level folders
- `Assets/` — images, audio, fonts, and other assets
- `Scripts/` — GDScript files including `Global.gd` and gameplay scripts
- `addons/` — any editor/runtime plugins used by the project

## Contributing
Feel free to open issues or submit pull requests. Small, focused changes and clear commit messages are appreciated.

---

Project opened from the Godot project file; configured features include Godot 4.6 and Mobile support.
