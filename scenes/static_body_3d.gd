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
