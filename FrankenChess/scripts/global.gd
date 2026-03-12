extends Node
#global script 

"""
This script will hold:
	Board state
	Player's parts
	Created pieces
"""
const STARTING_PIECES = 8

@onready var assembled_piece = null

#on ready this should fill with a bunch of random parts
#pulls part options from the 
@export var black_parts = [
	{ "path": "res://scenes/Base Parts/pawn_base.tscn", "type": "base"},
	{ "path": "res://assets/Chess Pieces/Bishop Piece/Bishop-Bottom.glb", "type": "base"},
	{ "path": "res://assets/Chess Pieces/Knight Piece/Knight-Bottom.glb", "type": "base"},
	{ "path": "res://scenes/middle parts/pawn_mid.tscn", "type": "middle"},
	{ "path": "res://scenes/middle parts/bishop_mid.tscn", "type": "middle"},
	{ "path": "res://scenes/middle parts/knight_mid.tscn", "type": "middle"},
	{ "path": "res://assets/Chess Pieces/Pawn Piece/Pawn-Top.glb", "type": "top"},
	{ "path": "res://assets/Chess Pieces/Bishop Piece/Bishop-Top.glb", "type": "top"},
	{ "path": "res://assets/Chess Pieces/King Piece/King-Top.glb", "type": "top"}
	
]

@export var white_parts = [
	
]

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
	
