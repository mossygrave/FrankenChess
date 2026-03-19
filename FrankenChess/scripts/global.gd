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
@export var black_parts = []

@export var white_parts = []

func _ready() -> void:
	var top
	var mid
	var base
	
	for i in range(9):
		top = PartDatabase.get_random_top()
		white_parts.append(top)
		mid = PartDatabase.get_random_mid()
		white_parts.append(mid)
		base = PartDatabase.get_random_base()
		white_parts.append(base)
		
	base = PartDatabase.get_random_base()
	white_parts.append(base)
	mid = PartDatabase.get_random_mid()
	white_parts.append(mid)
	top = PartDatabase.get_king_top()
	white_parts.append(top)
	
	for i in range(9):
		top = PartDatabase.get_random_top()
		black_parts.append(top)
		mid = PartDatabase.get_random_mid()
		black_parts.append(mid)
		base = PartDatabase.get_random_base()
		black_parts.append(base)
		
	base = PartDatabase.get_random_base()
	black_parts.append(base)
	mid = PartDatabase.get_random_mid()
	black_parts.append(mid)
	top = PartDatabase.get_king_top()
	black_parts.append(top)
	
