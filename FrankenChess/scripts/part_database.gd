extends Node

# i think it would probably be best to include all the movement functions
# in this database so we can access them easily

var top_parts = {
	"Pawn Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Pawn Piece/Pawn-Top.glb"
	},
	"Rook Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Castle Piece/Castle-Top.glb"
	},
	"Knight Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Knight Piece/Knight-Top.glb"
	},
	"Bishop Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Bishop Piece/Bishop-Top.glb"
	},
	"Queen Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Queen Piece/Queen-Top.glb"
	},
	"King Top": {
		"slot" : "top",
		"script" : "",
		"model" : "res://assets/Chess Pieces/King Piece/King-Top.glb"
	}
}

var mid_parts = {
	"Pawn Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/pawn_mid.tscn"
	},
	"Rook Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/rook_mid.tscn"
	},
	"Knight Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/knight_mid.tscn"
	},
	"Bishop Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/bishop_mid.tscn"
	},
	"Queen Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/queen_mid.tscn"
	},
	"King Mid": {
		"slot" : "mid",
		"script" : "",
		"model" : "res://scenes/middle parts/king_mid.tscn"
	}
}

var base_parts = {
	"Pawn Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://scenes/Base Parts/pawn_base.tscn"
	},
	"Rook Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Castle Piece/Castle-Bottom.glb"
	},
	"Knight Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Knight Piece/Knight-Bottom.glb"
	},
	"Bishop Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Bishop Piece/Bishop-Bottom.glb"
	},
	"Queen Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://assets/Chess Pieces/Queen Piece/Queen-Bottom.glb"
	},
	"King Base": {
		"slot" : "base",
		"script" : "",
		"model" : "res://assets/Chess Pieces/King Piece/King-Bottom.glb"
	}
}

	
func get_random_top():
	var key = top_parts.keys().pick_random()
	
	while key == "King Top":
		key = top_parts.keys().pick_random()
		
	return top_parts[key]
	
func get_random_mid():
	var key = mid_parts.keys().pick_random()
	return mid_parts[key]
	
func get_random_base():
	var key = base_parts.keys().pick_random()
	return base_parts[key]
	
func get_king_top():
	var king = top_parts["King Top"]
	return king
