extends Node
#global script 

"""
This script will hold:
	Board state
	Player's parts
	Created pieces
"""
var global_top = null
var global_mid = null
var global_base = null

@onready var assembled_piece = null

@onready var white_king: bool = false
@onready var black_king: bool = false
@onready var game_result: String

@onready var turn: String = "white" #true for white's turn, false for black's turn
#on ready this should fill with a bunch of random parts
#pulls part options from the db
@export var black_parts = {}
@export var white_parts = {}

func _ready() -> void:
	
	var top
	var mid
	var base
	#these are not an accurate representation of how many you have of each part
	#they count based on slot and not type
	#im not changing this yet
	var count_top = 0
	var count_mid = 0
	var count_base = 0
	
	#I should probably make the following a series of functions that can be called but I'm not 
	#oh well
	
	for i in range(5):
		top = PartDatabase.get_random_top()
		if white_parts.has(top):
			var new_top = "{top} {count}".format({
				"top": top,
				"count": count_top
			})
			count_top += 1
			white_parts[new_top] = PartDatabase.top_parts[top]
		else:
			white_parts[top] = PartDatabase.top_parts[top]
			
		mid = PartDatabase.get_random_mid()
		if white_parts.has(mid):
			var new_mid = "{mid} {count}".format({
				"mid": mid,
				"count" : count_mid
			})
			count_mid += 1
			white_parts[new_mid] = PartDatabase.mid_parts[mid]
		else:
			white_parts[mid] = PartDatabase.mid_parts[mid]
			
		base = PartDatabase.get_random_base()
		if white_parts.has(base):
			var new_base = "{base} {count}".format({
				"base": base,
				"count" : count_base
			})
			count_mid += 1
			white_parts[new_base] = PartDatabase.base_parts[base]
		else:
			white_parts[base] = PartDatabase.base_parts[base]
		
	base = PartDatabase.get_random_base()
	if white_parts.has(base):
		var new_base = "{base} {count}".format({
			"base": base,
			"count" : count_base
		})
		count_mid += 1
		white_parts[new_base] = PartDatabase.base_parts[base]
	else:
		white_parts[base] = PartDatabase.base_parts[base]
		
	mid = PartDatabase.get_random_mid()
	if white_parts.has(mid):
		var new_mid = "{mid} {count}".format({
			"mid": mid,
			"count" : count_mid
		})
		count_mid += 1
		white_parts[new_mid] = PartDatabase.mid_parts[mid]
	else:
		white_parts[mid] = PartDatabase.mid_parts[mid]
	
	top = PartDatabase.get_king_top()
	white_parts["King Top"] = top
	
	count_top = 0
	count_mid = 0
	count_base = 0
	
	for i in range(5):
		top = PartDatabase.get_random_top()
		if black_parts.has(top):
			var new_top = "{top} {count}".format({
				"top": top,
				"count": count_top
			})
			count_top += 1
			black_parts[new_top] = PartDatabase.top_parts[top]
			black_parts[new_top]["white"] = false
		else:
			black_parts[top] = PartDatabase.top_parts[top]
			black_parts[top]["white"] = false
			
		mid = PartDatabase.get_random_mid()
		if black_parts.has(mid):
			var new_mid = "{mid} {count}".format({
				"mid": mid,
				"count" : count_mid
			})
			count_mid += 1
			black_parts[new_mid] = PartDatabase.mid_parts[mid]
			black_parts[new_mid]["white"] = false
		else:
			black_parts[mid] = PartDatabase.mid_parts[mid]
			black_parts[mid]["white"] = false
			
		base = PartDatabase.get_random_base()
		if black_parts.has(base):
			var new_base = "{base} {count}".format({
				"base": base,
				"count" : count_base
			})
			count_mid += 1
			black_parts[new_base] = PartDatabase.base_parts[base]
			black_parts[new_base]["white"] = false
		else:
			black_parts[base] = PartDatabase.base_parts[base]
			black_parts[base]["white"] = false
		
	base = PartDatabase.get_random_base()
	if black_parts.has(base):
		var new_base = "{base} {count}".format({
			"base": base,
			"count" : count_base
		})
		count_mid += 1
		black_parts[new_base] = PartDatabase.base_parts[base]
		black_parts[new_base]["white"] = false
	else:
		black_parts[base] = PartDatabase.base_parts[base]
		black_parts[base]["white"] = false
		
	mid = PartDatabase.get_random_mid()
	if black_parts.has(mid):
		var new_mid = "{mid} {count}".format({
			"mid": mid,
			"count" : count_mid
		})
		count_mid += 1
		black_parts[new_mid] = PartDatabase.mid_parts[mid]
		black_parts[new_mid]["white"] = false
	else:
		black_parts[mid] = PartDatabase.mid_parts[mid]
		black_parts[mid]["white"] = false
		
	top = PartDatabase.get_king_top()
	black_parts["King Top"] = top
	black_parts["King Top"]["white"] = false

func change_scene(cam : Camera3D, ui):
	cam.current = false
	ui.visible = false
