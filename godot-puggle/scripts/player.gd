extends CharacterBody2D

@export var speed: float = 150.0

@onready var sprite = $Sprite2D

# Direction mapping to sprite textures
var direction_textures = {
	"south": preload("res://rotations/south.png"),
	"south-west": preload("res://rotations/south-west.png"),
	"west": preload("res://rotations/west.png"),
	"north-west": preload("res://rotations/north-west.png"),
	"north": preload("res://rotations/north.png"),
	"north-east": preload("res://rotations/north-east.png"),
	"east": preload("res://rotations/east.png"),
	"south-east": preload("res://rotations/south-east.png")
}

var current_direction = "south"

func _physics_process(_delta):
	# Get input direction
	var input_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)

	# Update velocity
	velocity = input_direction * speed

	# Update sprite direction based on movement
	if input_direction.length() > 0:
		update_sprite_direction(input_direction)

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
		sprite.texture = direction_textures[current_direction]

func get_direction_from_angle(angle: float) -> String:
	# 8-directional mapping (45-degree segments)
	# East: 337.5-22.5, Southeast: 22.5-67.5, South: 67.5-112.5, etc.

	if angle >= 337.5 or angle < 22.5:
		return "east"
	elif angle >= 22.5 and angle < 67.5:
		return "south-east"
	elif angle >= 67.5 and angle < 112.5:
		return "south"
	elif angle >= 112.5 and angle < 157.5:
		return "south-west"
	elif angle >= 157.5 and angle < 202.5:
		return "west"
	elif angle >= 202.5 and angle < 247.5:
		return "north-west"
	elif angle >= 247.5 and angle < 292.5:
		return "north"
	else:  # 292.5 to 337.5
		return "north-east"
