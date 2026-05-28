extends Area3D

var locked := false
var triggered := false
var top_open := false
var timer = 0.0 # kind of more like door progress in a way? like animation frames?? idk how to explain it image 0 to 1 is door going from moot to open, so going backwards is like closing it
var door_coords: Vector3 

@onready var doortop = $Door_Small_Top

func _ready() -> void:
	door_coords = doortop.position

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		triggered = true

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		triggered = false

func _process(delta: float) -> void: # who needs state machines anyways
	if not locked:
		if triggered and timer < 1.0: # if we trigger the door, add to the timer to play the animation
			timer += delta

		elif not triggered and timer > 0.0: # if the door isnt triggered, lower the timer
			timer -= delta

		timer = clamp(timer, 0.0, 1.0) 

		doortop.position = door_coords + (Vector3(0, 1, 0) * (timer * 20.0)) # basically, take the timer, multiply by speed, and use that as the door offset
