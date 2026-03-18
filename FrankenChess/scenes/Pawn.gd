extends "res://scripts/Piece.gd"

func is_on_board(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8

func get_moves(board_state):
	var moves = []
	var dir = 1 if color == "white" else -1

	# Forward move
	var forward = Vector2i(board_pos.x, board_pos.y + dir)
	if is_on_board(forward) and board_state.get(forward) == null:
		moves.append(forward)

	# Double move from starting rank
	var start_rank = 1 if color == "white" else 6
	if board_pos.y == start_rank:
		var double_forward = Vector2i(board_pos.x, board_pos.y + dir * 2)
		if is_on_board(double_forward) \
		and board_state.get(forward) == null \
		and board_state.get(double_forward) == null:
			moves.append(double_forward)

	# Diagonal captures
	var left = Vector2i(board_pos.x - 1, board_pos.y + dir)
	var right = Vector2i(board_pos.x + 1, board_pos.y + dir)

	for diag in [left, right]:
		if is_on_board(diag):
			var target = board_state.get(diag)
			if target and target.color != color:
				moves.append(diag)

	return moves
