extends RigidBody3D

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
	print("SET ID:", get_instance_id())
	if board_pos == Vector2i(-1, -1):
		var starting_pos = get_starting_pos(_top)
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

# All piece attack functions
func pawn_attacks(board_state: Dictionary):
	print("works!")
	
func rook_attacks(board_state: Dictionary):
	print("works!")
	
func knight_attacks(board_state: Dictionary):
	print("works!")
	
func bishop_attacks(board_state: Dictionary):
	print("works!")

func queen_attacks(board_state: Dictionary):
	print("works!")

func king_attacks(board_state: Dictionary):
	print("works!")
	
# All Piece move functions
func pawn_move(board_state: Dictionary):
	print("works!")
	
func rook_move(board_state: Dictionary):
	print("works!")
	
func knight_move(board_state: Dictionary):
	print("works!")
	
func bishop_move(board_state: Dictionary):
	print("works!")

func queen_move(board_state: Dictionary):
	print("works!")

func king_move(board_state: Dictionary):
	print("works!")
	
func get_starting_pos(top_type):
	var starting = []
	if Global.turn:
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
				starting.append(Vector2i(3, 7))
			"king":
				starting.append(Vector2i(4, 7)) 
			"":
				print("Broken starting positions") 
	return starting
