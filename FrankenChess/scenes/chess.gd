extends Sprite3D

enum PartTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
@onready var dots: Node = $Dots

# Variables 
var selected_piece = null
var spaces = {}

#use the f key to flip the board
func _process(delta: float) -> void:
		
	if (Input.is_action_just_released("Flip")): #f to flip
		rotate_y(PI)


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn");


#  Ready builds the board grid, debugs and auto-places pieces

func _ready():
	var markers = dots.get_children()

	# Sort markers by Z then X
	markers.sort_custom(func(a, b):
		var az = a.global_transform.origin.z
		var bz = b.global_transform.origin.z
		var ax = a.global_transform.origin.x
		var bx = b.global_transform.origin.x

		if abs(az - bz) > 0.01:
			return az < bz
		return ax < bx
	)

	# Assign coordinates to markers
	var index = 0
	for marker in markers:
		var x = index % 8
		var y = index / 8
		marker.set_meta("board_pos", Vector2i(x, y))
		spaces[Vector2i(x, y)] = null
		index += 1
	print("Markers in running scene:")
	for m in dots.get_children():
		print(m.name, " type:", m.get_class(), " has collision:", m.get_child_count())

	print(" Marker Coordinates ")
	for marker in markers:
		print(marker.name, " -> ", marker.get_meta("board_pos"))

	# Place all pieces automatically
	auto_place_pieces()
	
	print("=== Piece Debug ===")
	for piece in $White.get_children():
		print(piece.name, " | pos:", piece.board_pos, " | color:", piece.color, " | type:", piece.piece_type)

	for piece in $Black.get_children():
		print(piece.name, " | pos:", piece.board_pos, " | color:", piece.color, " | type:", piece.piece_type)


func get_type_from_name(name: String) -> String:
	var raw = name.substr(1).to_lower()  # remove W/B
	raw = raw.rstrip("0123456789")       # remove trailing numbers
	return raw


func place_piece(piece: Node3D, pos: Vector2i):
	piece.board_pos = pos
	spaces[pos] = piece

	var marker = get_marker_at(pos)
	if marker:
		piece.global_transform.origin = marker.global_transform.origin


func get_marker_at(pos: Vector2i):
	for marker in dots.get_children():
		if marker.get_meta("board_pos") == pos:
			return marker
	return null

#  Automatically place all 32 pieces

func auto_place_pieces():
	var back_rank = {
		"rook":   [0, 7],
		"knight": [1, 6],
		"bishop": [2, 5],
		"queen":  [3],
		"king":   [4]
	}

	#  Place the white pieces
	for piece in $White.get_children():
		piece.color = "white"
		piece.piece_type = String(get_type_from_name(piece.name))

		if piece.piece_type == "pawn":
			var file = int(piece.name.substr(piece.name.length() - 1)) - 1
			place_piece(piece, Vector2i(file, 1))
		else:
			var type = String(piece.piece_type)
			var name_str = String(piece.name)
			var last_char = name_str[name_str.length() - 1]
			var index = int(last_char) - 1 if last_char.is_valid_int() else 0
			var file = back_rank[type][index]
			place_piece(piece, Vector2i(file, 0))

	# Black pieces
	for piece in $Black.get_children():
		piece.color = "black"
		piece.piece_type = String(get_type_from_name(piece.name))

		if piece.piece_type == "pawn":
			var file = int(piece.name.substr(piece.name.length() - 1)) - 1
			place_piece(piece, Vector2i(file, 6))
		else:
			var name_str = String(piece.name)
			var last_char = name_str[name_str.length() - 1]
			var index = int(last_char) - 1 if last_char.is_valid_int() else 0

			var type = String(piece.piece_type)
			var file = back_rank[type][index]
			place_piece(piece, Vector2i(file, 7))

func _input(event):
	#print("INPUT FIRED")
	if event.is_action_pressed("click"):
		var camera = get_node("../Camera3D")
		var mouse_pos = get_viewport().get_mouse_position()

		# Builds a ray from the camera through the mouse cursor
		var from = camera.project_ray_origin(mouse_pos)
		var to = from + camera.project_ray_normal(mouse_pos) * 1000
		#print("Ray from:", from, " to:", to)

		# shoot the ray 
		var space_state = get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.new()
		query.from = from
		query.to = to
		
		#query.collision_mask = 1 << 1   # Only hit layer 2
		var result = space_state.intersect_ray(query)
		print("Ray result raw:", result)

		if result and result.collider:
			var hit = result.collider

				# 1. If we clicked a PIECE
			if hit.has_method("is_piece"):
				var clicked_piece = hit

				# If a piece is already selected...
				if selected_piece:

				# 1. Clicking the SAME piece → deselect
					if clicked_piece == selected_piece:
						deselect_piece()
						return

				# 2. Clicking your OWN piece → switch selection
					if clicked_piece.color == selected_piece.color:
						select_piece(clicked_piece)
						return

				# 3. Clicking an ENEMY piece → attempt capture
					handle_square_click(clicked_piece.board_pos)
					return

				# No piece selected yet → select normally
				select_piece(clicked_piece)
				return


			# 2. If it clicked a BOARD SQUARE
			if hit.has_meta("board_pos"):
				var pos = hit.get_meta("board_pos")
				handle_square_click(pos)
				return





func handle_square_click(pos: Vector2i):
	print("Clicked square:", pos)

	# If no piece is selected, do nothing
	if selected_piece == null:
		return

	# If a piece IS selected, check if this square is a valid move
	var raw_moves = selected_piece.get_moves(spaces)

	var legal_moves = []

	for m in raw_moves:
		if move_is_legal(selected_piece, m):
			legal_moves.append(m)

	if pos in legal_moves:
		move_piece(selected_piece, pos)
		deselect_piece()
		return


	# Otherwise just print info
	var piece = spaces.get(pos)
	if piece:
		print("You clicked:", piece.name, "at", pos)
	else:
		print("Square is empty.")


func select_piece(piece):
	if selected_piece:
		deselect_piece()

	selected_piece = piece
	print("Selected piece:", piece.name, "at", piece.board_pos)

	var raw_moves = piece.get_moves(spaces)
	var legal_moves = []

	for pos in raw_moves:
		if move_is_legal(piece, pos):
			legal_moves.append(pos)

	highlight_moves(legal_moves)


	# Visual feedback
	piece.scale = Vector3(1.1, 1.1, 1.1)

func deselect_piece():
	if selected_piece:
		selected_piece.scale = Vector3.ONE
	selected_piece = null

func move_piece(piece, pos):
	# Check if there's a piece on the target square
	var target_piece = spaces.get(pos)

	# If it's an enemy piece, capture it
	if target_piece and target_piece.color != piece.color:
		capture_piece(target_piece)

	# Remove the piece from its old position
	spaces[piece.board_pos] = null

	# Update the piece's internal board position
	piece.board_pos = pos

	# Place it in the new position
	spaces[pos] = piece

	# Move the piece visually
	var marker = get_marker_at(pos)
	piece.global_transform.origin = marker.global_transform.origin

func capture_piece(piece):
	# Remove from board state
	spaces[piece.board_pos] = null

	# Remove from the scene
	piece.queue_free()

func highlight_moves(moves: Array):
	# Clear old highlights
	for marker in dots.get_children():
		var sprite = marker.get_node("Sprite3D")
		if sprite:
			sprite.modulate = Color(1, 1, 1, 0)  # invisible

	# Highlight new moves
	for pos in moves:
		if spaces.has(pos):
			var marker = get_marker_at(pos)
			if marker:
				var sprite = marker.get_node("Sprite3D")
				if sprite:
					var piece_at_pos = spaces[pos]

					# If there's an enemy piece → RED
					if piece_at_pos and piece_at_pos.color != selected_piece.color:
						sprite.modulate = Color(0.9, 0.2, 0.2, 0.7)  # red
					else:
						# Otherwise → GREEN
						sprite.modulate = Color(0.2, 0.8, 0.2, 0.6)

#King safety checks: (Prevents the king from entering check)

func find_king(color: String) -> Vector2i:
	for pos in spaces.keys():
		var piece = spaces[pos]
		if piece and piece.piece_type == "king" and piece.color == color:
			return pos
	return Vector2i(-1, -1)

func square_is_attacked(pos: Vector2i, by_color: String) -> bool:
	for other_pos in spaces.keys():
		var piece = spaces[other_pos]
		if piece and piece.color == by_color:
			var moves = piece.get_moves(spaces)
			if pos in moves:
				return true
	return false

func move_is_legal(piece, target_pos: Vector2i) -> bool:
	var original_pos = piece.board_pos
	var captured_piece = spaces[target_pos]

	# Simulate move
	spaces[original_pos] = null
	spaces[target_pos] = piece
	piece.board_pos = target_pos

	# Find king position after move
	var king_pos = find_king(piece.color)

	# Check if king is attacked
	var in_check = square_is_attacked(
	king_pos,
	"black" if piece.color == "white" else "white"
	)


	# Undo move
	spaces[target_pos] = captured_piece
	spaces[original_pos] = piece
	piece.board_pos = original_pos

	return not in_check
