extends Node2D

@onready var sprite = get_node("Area2D/Sprite2D")
var pipe_rotation:= 0 # 0: up, 1: right, 2: down, 3: left
var type:= 0 # 0: straight, 1: corner, 2: t-junction, 3: cross
var connected := false

var textures = [
	preload("res://assets/Pipe Assets/straight-pipe.png"),
	preload("res://assets/Pipe Assets/curved-pipe.png"),
	preload("res://assets/Pipe Assets/t-pipe.png"),
	preload("res://assets/Pipe Assets/cross-pipe.png"),
]

var connected_textures = [
	preload("res://assets/Pipe Assets/straight-pipe-connected.png"),
	preload("res://assets/Pipe Assets/curved-pipe-connected.png"),
	preload("res://assets/Pipe Assets/t-pipe-connected.png"),
	preload("res://assets/Pipe Assets/cross-pipe-connected.png"),
]

func setup(new_type: int):
	type = new_type
	pipe_rotation = randi() % 4
	sprite.texture = textures[type]
	rotation = deg_to_rad(float(pipe_rotation) * 90.0)
	scale = Vector2(0.5, 0.5)

func set_connected(new_connected: bool):
	if connected == new_connected: # skip changing if already same connection status
		return
		
	connected = new_connected

	# update sprites
	if connected:
		sprite.texture = connected_textures[type]
	else:
		sprite.texture = textures[type]

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pipe_rotation = (pipe_rotation + 1) % 4
			rotation = deg_to_rad(float(pipe_rotation) * 90.0)
			if get_parent().check_solution():
				print("Puzzle solved!")
	