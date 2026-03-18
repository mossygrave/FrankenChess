extends "res://scripts/Piece.gd"

func get_moves(board_state):
	var moves = []
	var offsets = [
		Vector2i(1, 2), Vector2i(2, 1),
		Vector2i(-1, 2), Vector2i(-2, 1),
		Vector2i(1, -2), Vector2i(2, -1),
		Vector2i(-1, -2), Vector2i(-2, -1)
	]

	for off in offsets:
		var pos = board_pos + off
		if board_state.has(pos):
			var piece = board_state[pos]
			if piece == null or piece.color != color:
				moves.append(pos)

	return moves
