extends "res://scripts/Piece.gd"
func get_moves(board_state):
	var moves = []
	var directions = [
		Vector2i(1,0), #Rook movement (Right)
		Vector2i(-1,0), #left
		Vector2i(0,1), #up
		Vector2i(0,-1), #down
		Vector2i(1,1), #Bishop movement (up and right)
		Vector2i(1,-1), # down and right
		Vector2i(-1,1), # up and left
		Vector2i(-1,-1) # down and left
	]

	for dir in directions:
		# This starts one step away from the spot the queen is on.
		var pos = board_pos + dir
		#This means it keeps going until it doesnt have a spot to go.
		while board_state.has(pos):
			#This checks to see if there is a piece in that spot
			var piece = board_state.get(pos)
			#This says that if there isnt a piece, then the queen can move there.
			if piece == null:
				moves.append(pos)
			else:
				#If the spot is taken, the piece can take it depending on its position.
				if piece.color != color:
					moves.append(pos)
				break
			pos += dir
	#This returns the whole list of the possible moves
	return moves
