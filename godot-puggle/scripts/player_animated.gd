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
