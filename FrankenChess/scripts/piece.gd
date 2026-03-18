extends StaticBody3D

var piece_type : String
var color : String
var board_pos : Vector2i

func is_piece():
	return true

func get_moves(board_state: Dictionary) -> Array:
	return []
