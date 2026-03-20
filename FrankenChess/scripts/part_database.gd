extends Node

# i think it would probably be best to include all the movement functions
# in this database so we can access them easily
#everything that pulls from this makes a copy. this DB should never be changed directly

var top_parts = {
	"Pawn Top": {
		"slot" : "top",
		"script" : "res://scenes/Pawn.gd",
		"model" : "res://assets/Chess Pieces/Pawn Piece/Pawn-Top.glb",
		"white" : true
	},
	"Rook Top": {
		"slot" : "top",
		"script" : "res://scenes/Rook.gd",
		"model" : "res://assets/Chess Pieces/Castle Piece/Castle-Top.glb",
		"white" : true
	},
	"Knight Top": {
		"slot" : "top",
		"script" : "res://scenes/Knight.gd",
		"model" : "res://assets/Chess Pieces/Knight Piece/Knight-Top.glb",
		"white" : true
	},
	"Bishop Top": {
		"slot" : "top",
		"script" : "res://scenes/Bishop.gd",
		"model" : "res://assets/Chess Pieces/Bishop Piece/Bishop-Top.glb",
		"white" : true
	},
	"Queen Top": {
		"slot" : "top",
		"script" : "res://scenes/Queen.gd",
		"model" : "res://assets/Chess Pieces/Queen Piece/Queen-Top.glb",
		"white" : true
	},
	"King Top": {
		"slot" : "top",
		"script" : "res://scenes/King.gd",
		"model" : "res://assets/Chess Pieces/King Piece/King-Top.glb",
		"white" : true
	}
}

var mid_parts = {
	"Pawn Mid": {
		"slot" : "mid",
		"script" : "res://scenes/Pawn.gd",
		"model" : "res://scenes/middle parts/pawn_mid.tscn",
		"white" : true
	},
	"Rook Mid": {
		"slot" : "mid",
		"script" : "res://scenes/Rook.gd",
		"model" : "res://scenes/middle parts/rook_mid.tscn",
		"white" : true
	},
	"Knight Mid": {
		"slot" : "mid",
		"script" : "res://scenes/Knight.gd",
		"model" : "res://scenes/middle parts/knight_mid.tscn",
		"white" : true
	},
	"Bishop Mid": {
		"slot" : "mid",
		"script" : "res://scenes/Bishop.gd",
		"model" : "res://scenes/middle parts/bishop_mid.tscn",
		"white" : true
	},
	"Queen Mid": {
		"slot" : "mid",
		"script" : "res://scenes/Queen.gd",
		"model" : "res://scenes/middle parts/queen_mid.tscn",
		"white" : true
	},
	"King Mid": {
		"slot" : "mid",
		"script" : "res://scenes/King.gd",
		"model" : "res://scenes/middle parts/king_mid.tscn",
		"white" : true
	}
}

var base_parts = {
	"Pawn Base": {
		"slot" : "base",
		"script" : "res://scenes/Pawn.gd",
		"model" : "res://scenes/Base Parts/pawn_base.tscn",
		"white" : true
	},
	"Rook Base": {
		"slot" : "base",
		"script" : "res://scenes/Rook.gd",
		"model" : "res://assets/Chess Pieces/Castle Piece/Castle-Bottom.glb",
		"white" : true
	},
	"Knight Base": {
		"slot" : "base",
		"script" : "res://scenes/Knight.gd",
		"model" : "res://assets/Chess Pieces/Knight Piece/Knight-Bottom.glb",
		"white" : true
	},
	"Bishop Base": {
		"slot" : "base",
		"script" : "res://scenes/Bishop.gd",
		"model" : "res://assets/Chess Pieces/Bishop Piece/Bishop-Bottom.glb",
		"white" : true
	},
	"Queen Base": {
		"slot" : "base",
		"script" : "res://scenes/Queen.gd",
		"model" : "res://assets/Chess Pieces/Queen Piece/Queen-Bottom.glb",
		"white" : true
	},
	"King Base": {
		"slot" : "base",
		"script" : "res://scenes/King.gd",
		"model" : "res://assets/Chess Pieces/King Piece/King-Bottom.glb",
		"white" : true
	}
}

	
func get_random_top():
	var key = top_parts.keys().pick_random()
	
	while key == "King Top":
		key = top_parts.keys().pick_random()

	return key
	
func get_random_mid():
	var key = mid_parts.keys().pick_random()
	return key
	
func get_random_base():
	var key = base_parts.keys().pick_random()
	return key
	
	
func get_king_top():
	var king = top_parts["King Top"]
	return king
