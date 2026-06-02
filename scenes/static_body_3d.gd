extends StaticBody3D

@export_multiline var flavor_text : String

func interact():
	print(flavor_text)
	
	var player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return
		
	# Locker shenanigans
	var locker = get_parent().get_parent().get_parent() # lol hierarchy isn't real not real
	if locker and locker.is_in_group("Locker"):
		if player.is_hidden:
			player.exit_locker()
		else:
			player.enter_locker(locker)

	# If we interact with wires, open the minigame
	var wires = get_parent().get_parent() # 
	if wires and wires.is_in_group("wires"):
		var minigame = get_node("/root/World/CanvasLayer/MinigameWires")
		if minigame:
			minigame.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.minigame_active = true
			print("start wires minigame")
			return

	# If we interact with pipes, open the minigame
	var pipes = get_parent()
	if pipes and pipes.is_in_group("pipes"):
		var minigame = get_node("/root/World/CanvasLayer/MinigamePipes")
		if minigame:
			minigame.visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			player.minigame_active = true
			print("start pipes minigame")
			return
