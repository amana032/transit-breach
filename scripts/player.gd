extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ladder_speed = 3.0

@onready var camera = $Neck/Camera3D
@onready var neck = $Neck
@onready var footstep_sound = $AudioFootsteps
@onready var current_text : Label

var footstep_variants = [
	load("res://assets/sounds/footsteps/foot1.wav"),
	load("res://assets/sounds/footsteps/foot2.wav"),
	load("res://assets/sounds/footsteps/foot3.wav"),
	load("res://assets/sounds/footsteps/foot4.wav"),
]

var on_ladder := false
var flavor_text_active := false
var is_hidden := false
var minigame_active := false
var pipe_puzzle_solved := [false, false]
var wires_puzzle_solved := [false, false, false]

func _ready() -> void:
	add_to_group("Player")

func _unhandled_input(event: InputEvent) -> void:
	# Check if mouse motion or escape key is pressed to handle mouse
	if minigame_active:
		return # don't let player do anything if minigame time

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# debug mouse for now, this will make a menu pop up later
	elif event.is_action_pressed("l_click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	elif event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED and !is_hidden: # don't let player move camera if hidden
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		# If we're rotating the camera, hide the cursor rotate player + camera
		neck.rotate_y(-event.relative.x * 0.002)
		camera.rotate_x(-event.relative.y * 0.002)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)


func _physics_process(delta: float) -> void:
	# Interact logic
	%InteractText.hide()
	if %InteractCast.is_colliding():
		var target = %InteractCast.get_collider()
		if target != null and target.has_method("interact"):
			%InteractText.show()
			if Input.is_action_just_pressed("interact"):
				target.interact()
				%FlavorText.text = target.flavor_text
				%FlavorText.show()
	else:
		if not flavor_text_active:
			%FlavorText.hide()

	# Don't let the player move if they're hidden (in a locker)
	if !is_hidden:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("left", "right", "forward", "back")
		var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		if is_on_floor() and direction:
			if not footstep_sound.playing:
				footstep_sound.stream = footstep_variants[randi() % footstep_variants.size()]
				footstep_sound.play()
				
		if on_ladder:
			if Input.is_action_pressed("forward"):
				velocity.y = ladder_speed

		move_and_slide()

func show_text(flavor_text: String) -> void: # Shows text on the flavor text box
	%FlavorText.text = flavor_text
	%FlavorText.show()
	flavor_text_active = true

func hide_text() -> void: # Hides text on the flavor text box
	%FlavorText.hide()
	flavor_text_active = false


func enter_locker(locker: Node3D) -> void: # Swap to the camera locker, enter hiding state
	camera.current = false

	var locker_cam = locker.find_child("Camera3D", true, false)
	if locker_cam:
		locker_cam.current = true
		is_hidden = true

	# hide flashlight mesh 
	var flashlight = get_tree().get_first_node_in_group("Flashlight")
	if flashlight:
		flashlight.visible = false


func exit_locker(): # Swap back to player cam, exit hiding state
	$Neck/Camera3D.current = true
	is_hidden = false
	
	var flashlight = get_tree().get_first_node_in_group("Flashlight")
	if flashlight:
		flashlight.visible = true
