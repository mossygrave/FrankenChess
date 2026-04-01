extends StaticBody3D

var piece_type : String
var color : String
var board_pos : Vector2i = Vector2i(-1, -1)
@onready var _top = ""
@onready var _mid = ""
@onready var _base = ""

func is_piece():
	return true

func get_moves(board_state: Dictionary) -> Array:
	# check the mid and base pieces
	# determine what moves to add
	# return moves
	if board_pos == Vector2i(-1, -1):
		var starting_pos = get_starting_pos(_top, board_state)
		return starting_pos
	
	var attack = []
	var move = []
	var final_moves = []
	
	match(_mid): #these will all retrun arrays that will be added to the moves array
		"pawn":
			attack = pawn_attacks(board_state)
		"rook":
			attack = rook_attacks(board_state)
		"knight":
			attack = knight_attacks(board_state)
		"bishop":
			attack = bishop_attacks(board_state)
		"queen":
			attack = queen_attacks(board_state)
		"king":
			attack = king_attacks(board_state)
			
	match(_base): #these will all retrun arrays that will be added to the moves array
		"pawn":
			move = pawn_move(board_state)
		"rook":
			move = rook_move(board_state)
		"knight":
			move = knight_move(board_state)
		"bishop":
			move = bishop_move(board_state)
		"queen":
			move = queen_move(board_state)
		"king":
			move = king_move(board_state)
	
	for a in attack:
		final_moves.append(a)
	for m in move:
		final_moves.append(m)
	
	return final_moves

func is_on_board(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < 8 and pos.y >= 0 and pos.y < 8

# All piece attack functions
func pawn_attacks(board_state: Dictionary):
	var moves = []
	var dir = 1 if color == "white" else -1
	var left = Vector2i(board_pos.x - 1, board_pos.y + dir)
	var right = Vector2i(board_pos.x + 1, board_pos.y + dir)

	for diag in [left, right]:
		if is_on_board(diag):
			var target = board_state.get(diag)
			if target and target.color != color:
				moves.append(diag)
	
	return moves
	
func rook_attacks(board_state: Dictionary):
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

			if piece and piece.color != color:
				moves.append(pos)
				break

			pos += dir

	return moves
	
func knight_attacks(board_state: Dictionary):
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
			if piece and piece.color != color:
				moves.append(pos)

	return moves
	
func bishop_attacks(board_state: Dictionary):
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
			if piece and piece.color != color:
				moves.append(pos)  # capture square
				break
			pos += dir

	return moves

func queen_attacks(board_state: Dictionary):
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
			
				#If the spot is taken, the piece can take it depending on its position.
			if piece and piece.color != color:
				moves.append(pos)
				break
			pos += dir
	#This returns the whole list of the possible moves
	return moves

func king_attacks(board_state: Dictionary):
	var moves = []
	var offsets = [
		Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),
		Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
	]

	for off in offsets:
		var pos = board_pos + off
		if board_state.has(pos):
			var piece = board_state.get(pos)
			if piece and piece.color != color:
				moves.append(pos)

	return moves
	
# All Piece move functions
func pawn_move(board_state: Dictionary):
	var moves = []
	var dir = 1 if color == "white" else -1

	# Forward move
	var forward = Vector2i(board_pos.x, board_pos.y + dir)
	if is_on_board(forward) and board_state.get(forward) == null:
		moves.append(forward)

	# Double move from starting rank
	# if a pawn starts at rank 0 then it gets the double move at rank 1
	# not sure if i want to change this yet cause i think it's funny
	var start_rank = 1 if color == "white" else 6
	if board_pos.y == start_rank:
		var double_forward = Vector2i(board_pos.x, board_pos.y + dir + 1)
		if is_on_board(double_forward) \
		and board_state.get(forward) == null \
		and board_state.get(double_forward) == null:
			moves.append(double_forward)

	return moves
	
func rook_move(board_state: Dictionary):
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
			else:
				break

			pos += dir

	return moves
	
func knight_move(board_state: Dictionary):
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
			if piece == null:
				moves.append(pos)

	return moves
	
func bishop_move(board_state: Dictionary):
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
			elif piece != null:
				break
			pos += dir

	return moves

func queen_move(board_state: Dictionary):
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
				#If the spot is taken, the piece can't move further
				break
			pos += dir
	#This returns the whole list of the possible moves
	return moves

func king_move(board_state: Dictionary):
	var moves = []
	var offsets = [
		Vector2i(1,0), Vector2i(-1,0), Vector2i(0,1), Vector2i(0,-1),
		Vector2i(1,1), Vector2i(1,-1), Vector2i(-1,1), Vector2i(-1,-1)
	]

	for off in offsets:
		var pos = board_pos + off
		if board_state.has(pos):
			var piece = board_state.get(pos)
			if piece == null:
				moves.append(pos)

	return moves
	
func get_starting_pos(top_type, board_state):
	var starting = []
	var final = []
	if Global.turn == "white":
		match(top_type):
			"pawn":
				starting.append(Vector2i(0, 1))
				starting.append(Vector2i(1, 1))
				starting.append(Vector2i(2, 1))
				starting.append(Vector2i(3, 1))
				starting.append(Vector2i(4, 1))
				starting.append(Vector2i(5, 1))
				starting.append(Vector2i(6, 1))
				starting.append(Vector2i(7, 1))
			"rook":
				starting.append(Vector2i(0, 0))
				starting.append(Vector2i(7, 0))
			"knight":
				starting.append(Vector2i(1, 0))
				starting.append(Vector2i(6, 0))
			"bishop":
				starting.append(Vector2i(2, 0))
				starting.append(Vector2i(5, 0))
			"queen":
				starting.append(Vector2i(3, 0)) 
			"king":
				starting.append(Vector2i(4, 0))
			"":
				print("Broken starting positions")  
	else:
		match(top_type):
			"pawn":
				starting.append(Vector2i(0, 6))
				starting.append(Vector2i(1, 6))
				starting.append(Vector2i(2, 6))
				starting.append(Vector2i(3, 6))
				starting.append(Vector2i(4, 6))
				starting.append(Vector2i(5, 6))
				starting.append(Vector2i(6, 6))
				starting.append(Vector2i(7, 6))
			"rook":
				starting.append(Vector2i(0, 7))
				starting.append(Vector2i(7, 7))
			"knight":
				starting.append(Vector2i(1, 7))
				starting.append(Vector2i(6, 7))
			"bishop":
				starting.append(Vector2i(2, 7))
				starting.append(Vector2i(5, 7))
			"queen":
				starting.append(Vector2i(4, 7)) 
			"king":
				starting.append(Vector2i(3, 7))
			"":
				print("Broken starting positions") 
				
	for pos in starting:
		if board_state.has(pos):
			var piece = board_state.get(pos)
			if piece == null:
				final.append(pos)
	return final


func get_attacks(board_state):
	var attack = []
	var final_moves = []
	
	match(_mid): #these will all retrun arrays that will be added to the moves array
		"pawn":
			attack = pawn_attacks(board_state)
		"rook":
			attack = rook_attacks(board_state)
		"knight":
			attack = knight_attacks(board_state)
		"bishop":
			attack = bishop_attacks(board_state)
		"queen":
			attack = queen_attacks(board_state)
		"king":
			attack = king_attacks(board_state)
	
	for a in attack:
		final_moves.append(a)
		
	return final_moves
