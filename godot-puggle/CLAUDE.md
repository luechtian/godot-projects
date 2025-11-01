# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.5 project featuring a puggle character with 8-directional movement. The project demonstrates both static sprite swapping (Sprite2D) and animated sprites (AnimatedSprite2D) for character movement.

## Running the Project

This project must be opened and run through the Godot 4.5 Editor:

1. Open Godot 4.5
2. Import the project by selecting `project.godot`
3. Press F5 or click the Play button to run

**Note:** There are no command-line build tools configured. All development happens within the Godot Editor.

## Project Architecture

### Scene Structure

- **Main Scene**: `scenes/main.tscn` - Entry point, contains player instance and background
- **Player Scenes**:
  - `scenes/player.tscn` - Original static sprite version using Sprite2D
  - `scenes/player_animated.tscn` - Current animated version using AnimatedSprite2D

The main scene currently references `player_animated.tscn` (line 3 in main.tscn).

### Script Architecture

Two player controller implementations exist:

**Static Sprite Version** (`scripts/player.gd`):
- Uses dictionary of preloaded textures mapped by direction names
- Swaps sprite texture based on movement angle
- Direction names use hyphens: "south-east", "north-west", etc.

**Animated Version** (`scripts/player_animated.gd`):
- Uses AnimatedSprite2D with SpriteFrames resource
- Plays directional animations dynamically: "walk_" + direction
- Direction names use underscores: "south_east", "north_west", etc.
- Handles idle state by pausing animation and showing first frame

### 8-Directional Movement System

Both scripts share the same movement logic:

1. **Input**: Uses Godot's input actions (move_left, move_right, move_up, move_down) configured in project.godot
2. **Direction Calculation**: Converts 2D input vector to angle in degrees
3. **Direction Mapping**: Maps 360° into 8 segments of 45° each
4. **Movement**: CharacterBody2D with `move_and_slide()` for physics-based movement

**Critical Detail**: Direction naming convention differs between the two implementations:
- Static version: uses hyphens in direction names
- Animated version: uses underscores in direction names (matches SpriteFrames animation naming)

### Asset Organization

- `rotations/` - Contains 8 directional sprite images (south, south-east, east, etc.)
- Each sprite is 48×48px pixel art
- Texture filter set to "Nearest" (value 0) in project.godot for pixel-perfect rendering

### Input Configuration

Defined in `project.godot` under `[input]` section:
- `move_right`: D key or Right arrow
- `move_left`: A key or Left arrow
- `move_down`: S key or Down arrow
- `move_up`: W key or Up arrow

## Key Implementation Details

### Angle to Direction Mapping

The `get_direction_from_angle()` function maps as follows:
- East: 337.5° - 22.5°
- South-East: 22.5° - 67.5°
- South: 67.5° - 112.5°
- South-West: 112.5° - 157.5°
- West: 157.5° - 202.5°
- North-West: 202.5° - 247.5°
- North: 247.5° - 292.5°
- North-East: 292.5° - 337.5°

### AnimatedSprite2D Setup

When working with AnimatedSprite2D:
- Animation names MUST match the pattern: `walk_` + direction (with underscores)
- Direction changes trigger animation changes via `animated_sprite.play()`
- Idle state: pause animation and set `frame = 0`
- Speed typically set to 8 FPS for pixel art walk cycles

## Switching Between Implementations

To switch from animated to static player:

1. Edit `scenes/main.tscn` line 3
2. Change `path="res://scenes/player_animated.tscn"` to `path="res://scenes/player.tscn"`

## Common Gotchas

1. **Direction Name Mismatches**: Static version uses hyphens, animated uses underscores
2. **Scene File Format**: .tscn files are Godot's text scene format - edit carefully
3. **No CLI Build**: This project has no headless export configured; all work happens in Godot Editor
4. **@onready Variables**: Must reference correct child node names (e.g., `$Sprite2D` vs `$AnimatedSprite2D`)
5. **Character ID**: 156a597c-7295-4800-8191-1558d7ecbb02 (from PixelLab, for requesting additional animations)

## Reference Documentation

The `TUTORIAL_ANIMATED_SPRITES.md` file contains a comprehensive step-by-step guide for:
- Converting static sprites to AnimatedSprite2D
- Setting up SpriteFrames resources
- Understanding animation control in GDScript
- Common issues and troubleshooting
