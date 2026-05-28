extends Area3D

var locked := false
var triggered := false
var top_open := false
var timer = 0.0 # kind of more like door progress in a way? like animation frames?? idk how to explain it image 0 to 1 is door going from moot to open, so going backwards is like closing it
var door_coordsL: Vector3 
var door_coordsR: Vector3 
var player = null

@onready var doorL = $Door_Big_L
@onready var doorR = $Door_Big_R
@onready var door_sound = $AudioStreamPlayer3D

@export var lock_number: int = 0 # 0: no lock, 1: wire lock, 2: pipe lock, 3: wire lock 1 only

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return

	door_coordsL = doorL.position
	door_coordsR = doorR.position

	if lock_number > 0:
		locked = true

func _on_body_entered(body: Node3D) -> void:
	if locked:
		if lock_number == 1 and player.wires_puzzle_solved.count(true) == 3: 
			locked = false
		elif lock_number == 2 and player.pipe_puzzle_solved.count(true) == 2: 
			locked = false
		elif lock_number == 3 and player.wires_puzzle_solved[0]:
			locked = false

	if locked:
		return

	if body.is_in_group("Player"):
		if timer == 0:
			triggered = true
			door_sound.play()

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		if timer == 1:
			triggered = false
			door_sound.play()

func _process(delta: float) -> void: # who needs state machines anyways
	
	if triggered and timer < 1.0: # if we trigger the door, add to the timer to play the animation
		timer += delta

	elif not triggered and timer > 0.0: # if the door isnt triggered, lower the timer
		timer -= delta

	timer = clamp(timer, 0.0, 1.0) 

	if not locked:
		doorL.position = door_coordsL + (Vector3.LEFT * (timer * 7.0)) # basically, take the timer, multiply by speed, and use that as the door offset
		doorR.position = door_coordsR + (Vector3.RIGHT * (timer * 7.0)) # basically, take the timer, multiply by speed, and use that as the door offset
