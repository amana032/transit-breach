extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("Player"):
		body.on_ladder = true
		print("Player entered ladder area")

func _on_area_3d_body_exited(body):
	if body.is_in_group("Player"):
		body.on_ladder = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
