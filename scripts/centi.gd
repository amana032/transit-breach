# Credits to Metachronal waves of legs: https://www.nablu.com/2022/12/metachronal-waves-of-legs.html

extends Node3D

var xmotion = 1 # gonna be honest. not sure what this does?? increasing it makes bigger radius. might just kill it 
var segment_distance = 0.5 # distance between targets
var phase = 0.0 # "phase" of cycle 
var speed = 200 # gotta go fast

# Offsets for the entire chain, move it in xyz yippee
var x_offset = 0.5
var y_offset = -0.5
var z_offset = -3.0

var targets_l = [] 
var targets_r = []

func _ready() -> void:
	# initialize all targets in order of leg
	for i in range(1, 12):
		var target = get_node("Targets/l%02dtarget" % i)
		targets_l.append(target)
		var target2 = get_node("Targets/r%02dtarget" % i)
		targets_r.append(target2)

func _process(delta):
	phase += speed * delta
	
	for i in range(targets_l.size()):
		var target = targets_l[i]

		var base_z = i * segment_distance
		var ph = fmod(phase + i * 45.0, 360.0) # offset every target by 45 degrees of each other, increasing this number changes wave patternn
		
		if ph < 180.0: # move target in position of arc
			target.position.z = (base_z + 0.5 * xmotion * cos(deg_to_rad(ph)) + z_offset)
			target.position.y = (0.5 * xmotion * sin(deg_to_rad(ph)) + y_offset)
			
		else: # move target across the ground (the walking contact point)
			target.position.z = (base_z + xmotion * ((ph - 180.0) / 180.0 - 0.5) + z_offset)
			target.position.y = y_offset

		target.position.x = x_offset
		
	for i in range(targets_r.size()):
		var target = targets_r[i]

		var base_z = i * segment_distance
		var ph = fmod(phase + i * 45.0, 360.0) # offset every target by 45 degrees of each other, increasing this number changes wave patternn
		
		if ph < 180.0: # move target in position of arc
			target.position.z = (base_z + 0.5 * xmotion * cos(deg_to_rad(ph)) + z_offset)
			target.position.y = (0.5 * xmotion * sin(deg_to_rad(ph)) + y_offset)
			
		else: # move target across the ground (the walking contact point)
			target.position.z = (base_z + xmotion * ((ph - 180.0) / 180.0 - 0.5) + z_offset)
			target.position.y = y_offset

		target.position.x = x_offset - 2.0
