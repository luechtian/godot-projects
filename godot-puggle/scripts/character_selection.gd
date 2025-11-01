extends CanvasLayer

@onready var puggle_button = $Control/CenterContainer/Panel/VBoxContainer/PuggleButton
@onready var shepherd_button = $Control/CenterContainer/Panel/VBoxContainer/ShepherdButton

func _ready():
	puggle_button.pressed.connect(_on_puggle_selected)
	shepherd_button.pressed.connect(_on_shepherd_selected)

func _on_puggle_selected():
	_load_character("res://scenes/player_animated.tscn")

func _on_shepherd_selected():
	_load_character("res://scenes/player_shepherd.tscn")

func _load_character(player_scene_path: String):
	# Remove any existing player
	var existing_player = get_tree().root.get_node_or_null("Main/Player")
	if existing_player:
		existing_player.queue_free()

	# Load and instantiate the new player scene
	var player_scene = load(player_scene_path)
	var new_player = player_scene.instantiate()
	new_player.position = Vector2(400, 301)

	# Add to main scene
	get_tree().root.get_node("Main").add_child(new_player)

	# Hide the selection menu
	hide()
