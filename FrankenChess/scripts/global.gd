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
	print("Global instance ID:", get_instance_id())
	
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

func change_scene(cam : Camera3D, ui):
	cam.current = false
	ui.visible = false
