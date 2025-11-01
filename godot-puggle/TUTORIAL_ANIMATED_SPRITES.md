# Godot 4.5 Tutorial: Adding Animated Sprites to Character

## 📚 What You'll Learn

This tutorial teaches you how to convert a static sprite character into an animated character using Godot 4.5's **AnimatedSprite2D** node. You'll learn:

- How SpriteFrames work
- Creating animation libraries
- Controlling animations from GDScript
- Handling 8-directional animations

---

## 🎯 Prerequisites

- Godot 4.5 installed
- Basic understanding of Godot scenes and nodes
- 8 directional sprite images (we're using the puggle sprites)
- Character movement script already working

---

## 📁 Starting Files

You should have these files:
```
puggle_godot/
├── rotations/
│   ├── south.png
│   ├── south-east.png
│   ├── east.png
│   ├── north-east.png
│   ├── north.png
│   ├── north-west.png
│   ├── west.png
│   └── south-west.png
├── scenes/
│   └── player.tscn (original with Sprite2D)
└── scripts/
    └── player.gd (original movement script)
```

---

## 🛠️ Step-by-Step Implementation

### **Step 1: Create New Player Scene**

We'll create a new scene to keep the old one as reference.

1. In Godot, click **Scene → New Scene**
2. Click **Other Node** and search for `CharacterBody2D`
3. Click **Create**
4. Rename the root node to `Player`
5. Save the scene as `scenes/player_animated.tscn`

**Why CharacterBody2D?**
- Built for player/NPC characters
- Has built-in physics and collision handling
- Works with `move_and_slide()` for smooth movement

---

### **Step 2: Add AnimatedSprite2D Node**

1. Right-click on `Player` node
2. Select **Add Child Node**
3. Search for `AnimatedSprite2D`
4. Click **Create**

**Key Difference:**
- **Sprite2D**: Shows one static texture
- **AnimatedSprite2D**: Can play multiple frames and switch between animations

---

### **Step 3: Configure Pixel-Perfect Rendering**

With `AnimatedSprite2D` selected:

1. In the **Inspector** panel (right side)
2. Find **CanvasItem → Texture**
3. Set **Filter** to `Nearest` (or value `1`)

**Why?**
- Prevents blurry pixels in pixel art
- Keeps crisp, sharp edges when zoomed

---

### **Step 4: Create SpriteFrames Resource**

With `AnimatedSprite2D` still selected:

1. In **Inspector**, find **Animation → Sprite Frames**
2. Click `[empty]` dropdown
3. Select **New SpriteFrames**
4. Click the **SpriteFrames** panel that appears at the bottom

**What is SpriteFrames?**
- A resource that stores all your animations
- Each animation contains multiple frames (images)
- Can be reused across multiple scenes

---

### **Step 5: Create First Animation (walk_south)**

In the **SpriteFrames** panel at the bottom:

1. You'll see a default animation called `"default"`
2. Click the **rename** button (pencil icon)
3. Rename it to `walk_south`
4. Click the **Add frames from sprite sheet** button (grid icon)
5. Navigate to `rotations/south.png`
6. Click **Open**
7. The image appears in the grid - click it to add
8. Click **Add Frame(s)**

**Understanding the Interface:**
- **Left panel**: List of animations
- **Right panel**: Frames within selected animation
- **Top toolbar**: Add/remove animations and frames

---

### **Step 6: Set Animation Speed**

With `walk_south` animation selected:

1. Look at the **Speed (FPS)** field at the top
2. Set it to `8` (8 frames per second)

**Why 8 FPS?**
- Good for pixel art walk cycles
- Not too fast, not too slow
- Can be adjusted per animation

---

### **Step 7: Create Remaining 7 Animations**

Repeat for each direction:

1. Click **Add Animation** button (plus icon in left panel)
2. Name it exactly as shown below
3. Add the corresponding sprite

**Animation Names (MUST match exactly):**
- `walk_south` → `rotations/south.png`
- `walk_south_east` → `rotations/south-east.png`
- `walk_east` → `rotations/east.png`
- `walk_north_east` → `rotations/north-east.png`
- `walk_north` → `rotations/north.png`
- `walk_north_west` → `rotations/north-west.png`
- `walk_west` → `rotations/west.png`
- `walk_south_west` → `rotations/south-west.png`

**💡 Naming Convention:**
- Use underscores `_` not hyphens `-`
- GDScript uses underscores for matching directions
- Must match exactly what the script expects

---

### **Step 8: Add Collision Shape**

1. Right-click `Player` node
2. **Add Child Node** → `CollisionShape2D`
3. In **Inspector**, find **Shape**
4. Click `[empty]` → **New CircleShape2D**
5. Click the **CircleShape2D** to edit
6. Set **Radius** to `12`

**Why CircleShape2D?**
- Best for top-down characters
- Smooth sliding along walls
- No corner catching

---

### **Step 9: Add Camera**

1. Right-click `Player` node
2. **Add Child Node** → `Camera2D`
3. In **Inspector**, find **Zoom**
4. Set both X and Y to `3.0`

**What does this do?**
- Camera follows player automatically (it's a child node)
- 3× zoom makes pixel art more visible
- Keeps player centered on screen

---

### **Step 10: Save Scene**

- Press `Ctrl+S`
- Scene should already be saved as `player_animated.tscn`

**Scene Tree Should Look Like:**
```
Player (CharacterBody2D)
├── AnimatedSprite2D
├── CollisionShape2D
└── Camera2D
```

---

### **Step 11: Create Animation Control Script**

1. Right-click `Player` node
2. Select **Attach Script**
3. Path: `res://scripts/player_animated.gd`
4. Click **Create**
5. Replace all content with this code:

```gdscript
extends CharacterBody2D

@export var speed: float = 150.0

@onready var animated_sprite = $AnimatedSprite2D

var current_direction = "south"

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	# Update velocity
	velocity = input_direction * speed

	# Update sprite direction and animation based on movement
	if input_direction.length() > 0:
		update_sprite_direction(input_direction)
		animated_sprite.play("walk_" + current_direction)
	else:
		# Idle - show first frame of walk animation
		animated_sprite.play("walk_" + current_direction)
		animated_sprite.pause()
		animated_sprite.frame = 0

	# Move the character
	move_and_slide()

func update_sprite_direction(direction: Vector2):
	# Calculate angle in degrees (0 = right, 90 = down, etc.)
	var angle = rad_to_deg(direction.angle())

	# Normalize angle to 0-360 range
	if angle < 0:
		angle += 360

	# Map angle to 8 directions
	var new_direction = get_direction_from_angle(angle)

	if new_direction != current_direction:
		current_direction = new_direction

func get_direction_from_angle(angle: float) -> String:
	# 8-directional mapping (45-degree segments)
	if angle >= 337.5 or angle < 22.5:
		return "east"
	elif angle >= 22.5 and angle < 67.5:
		return "south_east"
	elif angle >= 67.5 and angle < 112.5:
		return "south"
	elif angle >= 112.5 and angle < 157.5:
		return "south_west"
	elif angle >= 157.5 and angle < 202.5:
		return "west"
	elif angle >= 202.5 and angle < 247.5:
		return "north_west"
	elif angle >= 247.5 and angle < 292.5:
		return "north"
	else:  # 292.5 to 337.5
		return "north_east"
```

---

### **Step 12: Understanding the Script**

#### **Key Concepts:**

**1. @onready Variable**
```gdscript
@onready var animated_sprite = $AnimatedSprite2D
```
- Waits until scene is loaded
- Gets reference to AnimatedSprite2D node
- `$NodeName` is shorthand for `get_node("NodeName")`

**2. Playing Animations**
```gdscript
animated_sprite.play("walk_south")
```
- Plays animation by name
- Loops automatically if animation is set to loop
- Can be called every frame without issues

**3. Animation Control**
```gdscript
if input_direction.length() > 0:
    animated_sprite.play("walk_" + current_direction)
else:
    animated_sprite.pause()
    animated_sprite.frame = 0
```
- When moving: play walk animation
- When idle: pause and show first frame
- `frame = 0` resets to standing pose

**4. Direction Mapping**
```gdscript
var angle = rad_to_deg(direction.angle())
```
- Converts movement vector to angle
- `direction.angle()` returns radians
- `rad_to_deg()` converts to degrees (0-360)

**5. String Concatenation**
```gdscript
"walk_" + current_direction
```
- Builds animation name dynamically
- Example: `"walk_" + "south"` = `"walk_south"`
- Must match SpriteFrames animation names exactly

---

### **Step 13: Update Main Scene**

1. Open `scenes/main.tscn`
2. Select the `Player` node
3. In **Inspector**, look for **Scene** property
4. Click the **folder icon**
5. Navigate to `scenes/player_animated.tscn`
6. Click **Open**

**Alternative Method (Manual Edit):**
1. Right-click `main.tscn` in FileSystem
2. Select **Open in External Editor**
3. Change line:
```
[ext_resource type="PackedScene" path="res://scenes/player.tscn" id="1_player"]
```
to:
```
[ext_resource type="PackedScene" path="res://scenes/player_animated.tscn" id="1_player"]
```
4. Save and reload scene in Godot

---

### **Step 14: Test the Game**

1. Press `F5` to run
2. Move with WASD or arrow keys
3. Observe sprite changing based on direction
4. Stop moving - sprite should pause

**Expected Behavior:**
- ✅ Puggle faces movement direction
- ✅ Smooth 8-directional movement
- ✅ Sprite pauses when idle
- ✅ No errors in Output panel

---

## 🎓 Advanced: Adding Multi-Frame Animations

If you have actual animated sprites (multiple frames per direction):

### **Example: 4-frame walk cycle**

In SpriteFrames panel for `walk_south`:

1. Click **Add frames from sprite sheet**
2. Select sprite sheet with 4 frames
3. Click each frame in order
4. Click **Add Frame(s)**
5. Adjust **Speed (FPS)** to control animation speed

**Frame Order Matters:**
- Godot plays frames left-to-right
- First frame → Last frame → Loop

---

## 🐛 Common Issues & Solutions

### **Issue: Animation doesn't play**
**Cause:** Animation name mismatch
**Solution:**
- Check animation names in SpriteFrames panel
- Ensure script uses exact same names
- Remember: `south_east` not `south-east`

### **Issue: Sprite is blurry**
**Cause:** Texture filter not set to Nearest
**Solution:**
- Select AnimatedSprite2D
- Inspector → CanvasItem → Texture → Filter: Nearest

### **Issue: Character moves but sprite doesn't change**
**Cause:** `@onready` variable not set
**Solution:**
- Check node name matches: `$AnimatedSprite2D`
- Check Output panel for errors

### **Issue: Wrong direction shown**
**Cause:** Angle mapping is off
**Solution:**
- Test movement in all 8 directions
- Adjust angle thresholds in `get_direction_from_angle()`

---

## 📊 Performance Tips

1. **Reuse SpriteFrames:**
   - Save as `.tres` file
   - Load same resource across multiple characters

2. **Optimize Frame Count:**
   - 4-8 frames is ideal for walk cycles
   - More frames = smoother but more memory

3. **Use Texture Atlases:**
   - Combine all sprites into one image
   - Faster GPU loading
   - Less draw calls

---

## 🎨 Next Steps

Now that you have animations working:

1. **Add Idle Animations:**
   - Create `idle_south`, `idle_east`, etc.
   - Play when velocity is zero

2. **Add Run Animation:**
   - Detect Shift key press
   - Switch to `run_` animations
   - Increase speed variable

3. **Add Jump Animation:**
   - Create 3-4 frame jump cycle
   - Trigger with Spacebar
   - Add jump physics

4. **State Machine:**
   - Enum for states: IDLE, WALK, RUN, JUMP
   - Switch animations based on state
   - Cleaner code organization

---

## 📝 Key Takeaways

1. **AnimatedSprite2D** is for frame-based animations
2. **SpriteFrames** stores all animation data
3. Animation names must match in both SpriteFrames and script
4. Use `play()`, `pause()`, and `frame` to control animations
5. `@onready` ensures nodes are loaded before accessing them
6. String concatenation builds dynamic animation names

---

## 🔗 Godot Documentation

- [AnimatedSprite2D](https://docs.godotengine.org/en/stable/classes/class_animatedsprite2d.html)
- [SpriteFrames](https://docs.godotengine.org/en/stable/classes/class_spriteframes.html)
- [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html)

---

## ✅ Checklist

Use this when rebuilding from scratch:

- [ ] Create new CharacterBody2D scene
- [ ] Add AnimatedSprite2D child node
- [ ] Set texture filter to Nearest
- [ ] Create SpriteFrames resource
- [ ] Add 8 walk animations with correct names
- [ ] Set animation speed (8 FPS)
- [ ] Add CollisionShape2D with CircleShape2D (radius 12)
- [ ] Add Camera2D with zoom 3.0
- [ ] Attach script to Player node
- [ ] Copy animation control code
- [ ] Update main scene to use new player scene
- [ ] Test all 8 movement directions
- [ ] Verify idle state works (paused animation)

---

**Happy animating! 🐶**
