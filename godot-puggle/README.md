# Puggle Character - Godot Project

A simple Godot 4.x project featuring your cute puggle character with 8-directional movement!

## 🎮 Controls

- **WASD** or **Arrow Keys** - Move the puggle in 8 directions
- The puggle sprite automatically rotates to face the direction of movement

## 📁 Project Structure

```
puggle_godot/
├── project.godot          # Main project configuration
├── scenes/
│   ├── main.tscn         # Main game scene
│   └── player.tscn       # Player character scene
├── scripts/
│   └── player.gd         # Player movement controller
├── rotations/            # All 8 directional sprites
│   ├── south.png
│   ├── south-east.png
│   ├── east.png
│   ├── north-east.png
│   ├── north.png
│   ├── north-west.png
│   ├── west.png
│   └── south-west.png
└── metadata.json         # Character metadata from PixelLab

## 🚀 Getting Started

1. **Open in Godot 4.x**
   - Launch Godot 4.x
   - Click "Import"
   - Navigate to this folder and select `project.godot`

2. **Run the Game**
   - Press F5 or click the Play button
   - Move your puggle around with WASD or arrow keys!

## 🎨 Character Details

- **8 directional sprites** for smooth movement
- **48×48px canvas** with pixel-perfect rendering
- **Chibi proportions** for extra cuteness
- **Character ID**: 156a597c-7295-4800-8191-1558d7ecbb02

## 🔧 Customization

### Adjusting Movement Speed
Edit `scripts/player.gd` and change the `speed` variable:
```gdscript
@export var speed: float = 150.0  # Change this value
```

### Adding Animations
You can request walking animations from PixelLab for this character:
```python
animate_character(
    character_id='156a597c-7295-4800-8191-1558d7ecbb02',
    template_animation_id='walking'
)
```

Available animations: walking, running, jumping, and many more!

## 📚 Next Steps

- Add walking animations from PixelLab
- Create a tilemap for your puggle to explore
- Add collision detection for obstacles
- Implement a simple camera follow system
- Add sound effects for movement

Enjoy your puggle! 🐶
