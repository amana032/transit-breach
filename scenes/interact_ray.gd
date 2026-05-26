extends RayCast3D

@onready var trAnim; 

# WIP NOT DONE NOT DONE

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_colliding():
		# Global.canInteract = true;
		
		if Input.is_action_just_released("interact"):
			pass
		
	# else:
		# Global.canInteract = false; 
