extends "res://scripts/Piece.gd"

func get_moves(board_state):
	var moves = []
	var directions = [
		Vector2i(1, 0),
		Vector2i(-1, 0),
		Vector2i(0, 1),
		Vector2i(0, -1)
	]

	for dir in directions:
		var pos = board_pos + dir
		while board_state.has(pos):
			var piece = board_state[pos]

			if piece == null:
				moves.append(pos)
			elif piece.color != color:
				moves.append(pos)
				break
			else:
				break

			pos += dir

	return moves
