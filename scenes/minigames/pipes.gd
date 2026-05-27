extends Node2D

# Pipe minigame
var pipes_grid = []

func _ready():
	for y in range(4):
		var row = []

		for x in range(4):
			var tile = preload("res://scenes/minigames/pipe_tile.tscn").instantiate()
			add_child(tile)
			tile.position = Vector2(x * 100 + 475, y * 100 + 170)
			row.append([tile, 0])

		pipes_grid.append(row)
