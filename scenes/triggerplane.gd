extends Area3D

@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export_multiline var flavor_text := "" # mmmm flavor
@export var sound_clip: AudioStream # optional sound clip

var triggered := false

func _on_body_entered(body: Node3D) -> void:
	if triggered:
		return

	if body.is_in_group("Player"):
		triggered = true

		body.show_text(flavor_text)

		if sound_clip:
			audio.stream = sound_clip
			audio.play()

			# wait until audio finishes before hiding text
			await audio.finished
			body.hide_text()
