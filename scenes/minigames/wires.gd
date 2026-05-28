extends Node2D
 
var wires = {} # Dictionary that connects wire number to line
var colors = ["red", "blue", "green", "pink"]
var targets = []
var sprites = []

var current_wire: Area2D = null
var current_line: Line2D = null
var current_target: Area2D = null

var dragging := false
var connected := {} # Keep track of connected wires
var player = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	if player == null:
		return

	# Set up wires and targets for each pair, randomizing which target is associated to which wire
	for i in range(1, 5):
		var target = get_node("Target%d" % i)
		targets.append(target)
		
	targets.shuffle()

	for i in range(1, 5): 
		var target = targets[i - 1]
		var sprite = target.get_node("Sprite2D")
		var texture = load("res://assets/Wire.Assets/Textures/%s.png" % colors[i - 1])
		sprite.texture = texture

		var wire = get_node("WireNode%d" % i)
		var line = wire.get_node("Line2D")
		line.clear_points() # emtpy wire on start

		wires[wire] = {
			"index": i,
			"line": line
		}

		connected[i] = false
		

func start_drag(wire: Area2D) -> void:
	var index = wires[wire]["index"] # get the wire number of the clicked wire

	if connected[index]: # if already connected, skip
		return

	current_wire = wire # set current wire
	current_line = wires[wire]["line"] # set current line
	current_line.clear_points() # clear current line
	current_line.add_point(Vector2.ZERO) # add starting pont of line
	current_target = targets[index - 1] # set current target
	
	dragging = true
	var mouse_pos = current_line.to_local(get_global_mouse_position())
	current_line.add_point(mouse_pos) # add secondary end point of line


func _process(_delta: float) -> void:
	var count = player.wires_puzzle_solved.count(true)

	if count >= 3: # no more than 3 wire games
		close_minigame()
		return

	if dragging and current_line:
		var mouse_pos = current_line.to_local(get_global_mouse_position())
		current_line.set_point_position(1, mouse_pos) # update end point of line to match mouse

	if check_solution():
		print("Puzzle solved!")
		reset()
		close_minigame()

func close_minigame() -> void:
	var minigame = get_node("/root/World/CanvasLayer/MinigameWires")
	if minigame:
		minigame.visible = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

		if player == null:
			return
		player.minigame_active = false


func _is_point_inside_area(point: Vector2, area: Area2D) -> bool:
	var cs = area.get_node_or_null("CollisionShape2D")
	if cs == null:
		return false

	# check if within rectangle
	var shape = cs.shape
	var local = area.to_local(point)
	return abs(local.x) <= shape.size.x * 0.5 and abs(local.y) <= shape.size.y * 0.5 # check if within bounds of rect


func _input(event) -> void:
	if dragging and event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and not event.pressed: # released mouse button after dragging
			var mouse_pos = get_global_mouse_position()

			if _is_point_inside_area(mouse_pos, current_target): # if correct target
				var end = current_line.to_local(current_target.global_position)
				current_line.set_point_position(1, end) # set end point of the line
				var index = wires[current_wire]["index"]
				connected[index] = true

			else:
				current_line.clear_points() # bad line :( kill it

			dragging = false
			current_wire = null
			current_line = null
			current_target = null


func _on_wire_node_1_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		start_drag($WireNode1)

func _on_wire_node_2_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		start_drag($WireNode2)

func _on_wire_node_3_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		start_drag($WireNode3)

func _on_wire_node_4_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		start_drag($WireNode4)

func check_solution() -> bool:
	for i in range(1, 5):
		if not connected[i]: # check that all wires are connected
			return false

	var count = player.wires_puzzle_solved.count(true) # mark the next false index as true
	player.wires_puzzle_solved[count] = true
	return true

func reset() -> void:
	targets.clear()
	connected.clear()
	wires.clear()

	# Set up wires and targets for each pair, randomizing which target is associated to which wire
	for i in range(1, 5):
		var target = get_node("Target%d" % i)
		targets.append(target)
		
	targets.shuffle()

	for i in range(1, 5): 
		var target = targets[i - 1]
		var sprite = target.get_node("Sprite2D")
		var texture = load("res://assets/Wire.Assets/Textures/%s.png" % colors[i - 1])
		sprite.texture = texture

		var wire = get_node("WireNode%d" % i)
		var line = wire.get_node("Line2D")
		line.clear_points() # emtpy wire on start

		wires[wire] = {
			"index": i,
			"line": line
		}

		connected[i] = false
