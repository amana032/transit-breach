extends SpotLight3D

@export var light_on: bool = true
@onready var sound = $"../AudioStreamPlayer3D"

func _ready() -> void:
	set_light_on(light_on)

func set_light_on(value: bool) -> void:
	light_on = value
	visible = light_on

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("l_click"):
		set_light_on(not light_on)

		sound.stream = load(
			"res://assets/sounds/flash-off.wav"
			if not light_on
			else "res://assets/sounds/flash-on.wav"
		)

		sound.play()
