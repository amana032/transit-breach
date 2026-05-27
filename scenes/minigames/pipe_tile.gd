extends Node2D

@onready var sprite = get_node("Area2D/Sprite2D")
var pipe_rotation:= 0
var type:= 0

func _ready():
	type = randi() % 4 # 0: straight, 1: corner, 2: t-junction, 3: cross
	pipe_rotation = randi() % 4 # 0: up, 1: right, 2: down, 3: left
	rotation = deg_to_rad(float(pipe_rotation) * 90.0)
	scale = Vector2(0.5, 0.5)

	match type:
		0:
			sprite.texture = preload("res://assets/Pipe Assets/straight-pipe.png")
			pass
		1:
			sprite.texture = preload("res://assets/Pipe Assets/curved-pipe.png")
			pass
		2:
			sprite.texture = preload("res://assets/Pipe Assets/t-pipe.png")
			pass
		3:
			sprite.texture = preload("res://assets/Pipe Assets/cross-pipe.png")
			pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			pipe_rotation = (pipe_rotation + 1) % 4
			rotation = deg_to_rad(float(pipe_rotation) * 90.0)
			print("Pipe rotated to: ", pipe_rotation)

func update_pipe(new_type: int):
	match new_type:
		0:
			sprite.texture = preload("res://assets/Pipe Assets/straight-pipe.png")
		1:
			sprite.texture = preload("res://assets/Pipe Assets/curved-pipe.png")
		2:
			sprite.texture = preload("res://assets/Pipe Assets/t-pipe.png")
		3:
			sprite.texture = preload("res://assets/Pipe Assets/cross-pipe.png")

	type = new_type
	
