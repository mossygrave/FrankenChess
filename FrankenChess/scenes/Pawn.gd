extends "res://scripts/Piece.gd"

func get_moves(board_state):
	var moves = []
	var dir = 1 if color == "white" else -1
	
	var forward = Vector2i(board_pos.x, board_pos.y + dir)
	
	# This moves it forward if the space ahead is empty
	if board_state.get(forward) == null:
		moves.append(forward)
		
	# Move forward twice only if it hasnt moved yet
	var start_rank = 1 if color == "white" else 6
	if board_pos.y == start_rank:
		var double_forward = Vector2i(board_pos.x, board_pos.y + dir * 2)
		if board_state.get(double_forward) == null and board_state.get(forward) == null:
			moves.append(double_forward)

	# Captures
	var left = Vector2i(board_pos.x - 1, board_pos.y + dir)
	var right = Vector2i(board_pos.x + 1, board_pos.y + dir)

	for diag in [left, right]:
		var target = board_state.get(diag)
		if target and target.color != color:
			moves.append(diag)

	return moves
