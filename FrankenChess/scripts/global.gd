extends Node
#global script 

"""
This script will hold:
	Board state
	Player's parts
	Created pieces
"""
const STARTING_PARTS = 20

@onready var assembled_piece = null

#on ready this should fill with a bunch of random parts
#pulls part options from the 
@export var parts = [
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

func _ready() -> void:
	#for _ in STARTING_PARTS: PartDB.get_random_part()
	pass
