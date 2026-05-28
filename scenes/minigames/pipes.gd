extends Node2D

var level_1 = [
	[0, 0, 1, 1],
	[1, 1, 0, 1],
	[0, 1, 1, 1],
	[1, 0, 0, 0],
]

var pipes_grid = []

func _ready():
	for y in range(4):
		var row = []
		for x in range(4):
			var tile = preload("res://scenes/minigames/pipe_tile.tscn").instantiate()
			add_child(tile)
			tile.position = Vector2(x * 100 + 475, y * 100 + 170)
			tile.setup(level_1[y][x])
			row.append(tile)
		pipes_grid.append(row)

	check_solution()


func get_open_ends(type: int, pipe_rotation: int) -> Array: # 0: up, 1: right, 2: down, 3: left
	match type:
		0: # straight, open ends on up/down
			if pipe_rotation == 0 or pipe_rotation == 2:
				return [0, 2]
			else:
				return [1, 3]
		
		1: # corner: open ends on right/down
			match pipe_rotation:
				0: return [1, 2] # right/down
				1: return [2, 3] # down/left
				2: return [3, 0] # left/up
				3: return [0, 1] # up/right

		2: # t-junction: open ends on left/up/down
			match pipe_rotation:
				0: return [3, 0, 2] # left/up/down
				1: return [0, 1, 3] # up/right/left
				2: return [1, 2, 0] # right/down/up
				3: return [2, 3, 1] # down/left/right

		3: # cross
			return [0, 1, 2, 3]
	
	return []


func check_solution() -> bool:
	# Flood-fill style implementation
	var visited = {} # If we've seen it, don't check it again
	var queue = [Vector2i(0, 0)] # The origin of our flood-fill

	var offsets = [Vector2i(0, -1), Vector2i(1, 0), Vector2i(0, 1), Vector2i(-1, 0)] # Up, right, down, and left neighbords of pipe
	var opposite = [2, 3, 0, 1] # the other end of the pipes

	while queue.size() > 0: # traverse flood-fill style
		var pos = queue.pop_front()
		if pos in visited: # Skip anything we've already seen
			continue

		var tile = pipes_grid[pos.y][pos.x]
		var ends = get_open_ends(tile.type, tile.pipe_rotation)

		if pos == Vector2i(0, 0) and not (3 in ends): # don't even bother continuing if our source is not connected
			break

		visited[pos] = true

		for neigbor in ends:
			var neighbor_pos = pos + offsets[neigbor]
			
			if visited.has(neighbor_pos): # skip if visited 
				continue

			if neighbor_pos.x < 0 or neighbor_pos.x >= 4 or neighbor_pos.y < 0 or neighbor_pos.y >= 4: # skip if outside bounds
				continue

			# add the neighbor to the queue
			var new_neighbor = pipes_grid[neighbor_pos.y][neighbor_pos.x]
			var n_ends = get_open_ends(new_neighbor.type, new_neighbor.pipe_rotation)

			if opposite[neigbor] in n_ends: # does the neighbor connect back to the pipe (eg, a -- and | dont connect)
				queue.append(neighbor_pos)

	# for every pipe, update the connection
	for y in range(4):
		for x in range(4):
			pipes_grid[y][x].set_connected(Vector2i(x, y) in visited)

	# check the end pipe
	var end_pos = Vector2i(3, 3)
	var end_tile = pipes_grid[3][3]
	if end_pos in visited: # if the end tile is connected
		if 1 in get_open_ends(end_tile.type, end_tile.pipe_rotation): # if end tile is open to right, we win
				return true

	return false
