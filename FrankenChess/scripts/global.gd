extends Node
#global script 

"""
This script will hold:
	Board state
	Player's parts
	Created pieces
"""

@onready var assembled_piece = null
@onready var turn: bool = false #true for white's turn, false for black's turn
#on ready this should fill with a bunch of random parts
#pulls part options from the 
@export var black_parts = {}

@export var white_parts = {}

func _ready() -> void:
	
	var top
	var mid
	var base
	
	for i in range(9):
		top = PartDatabase.get_random_top()
		white_parts[top] = PartDatabase.top_parts[top]
		mid = PartDatabase.get_random_mid()
		white_parts[mid] = PartDatabase.mid_parts[mid]
		base = PartDatabase.get_random_base()
		white_parts[base] = PartDatabase.base_parts[base]
		
	base = PartDatabase.get_random_base()
	white_parts[base] = PartDatabase.base_parts[base]
	mid = PartDatabase.get_random_mid()
	white_parts[mid] = PartDatabase.mid_parts[mid]
	top = PartDatabase.get_king_top()
	white_parts["King Top"] = top
	
	for i in range(9):
		top = PartDatabase.get_random_top()
		black_parts[top] = PartDatabase.top_parts[top]
		black_parts[top]["white"] = false
		mid = PartDatabase.get_random_mid()
		black_parts[mid] = PartDatabase.mid_parts[mid]
		black_parts[mid]["white"] = false
		base = PartDatabase.get_random_base()
		black_parts[base] = PartDatabase.base_parts[base]
		black_parts[base]["white"] = false
		
	base = PartDatabase.get_random_base()
	black_parts[base] = PartDatabase.base_parts[base]
	black_parts[base]["white"] = false
	mid = PartDatabase.get_random_mid()
	black_parts[mid] = PartDatabase.mid_parts[mid]
	black_parts[mid]["white"] = false
	top = PartDatabase.get_king_top()
	black_parts["King Top"] = top
	black_parts["King Top"]["white"] = false

#func hide_board(): # BROKEN
	#Main.visible = false
	#var cam = Main.get_node("CameraPivot/Camera3D")
	#cam.current = false
	#Main.position.y = -50
	#
#func show_board(): #Broken
	#Main.visible = true
	#var cam = Main.get_node("CameraPivot/Camera3D")
	#cam.current = true
	#Main.position.y = 0
	
