extends "res://scripts/Piece.gd"
func get_moves(board_state):
	var moves = []
	var directions = [
		Vector2i(1, 1),
		Vector2i(1, -1),
		Vector2i(-1, 1),
		Vector2i(-1, -1)
	]

	for dir in directions:
		var pos = board_pos + dir
		while board_state.has(pos):
			var piece = board_state.get(pos)
			if piece == null:
				moves.append(pos)
			else:
				if piece.color != color:
					moves.append(pos)  # capture square
				break
			pos += dir

	return moves
