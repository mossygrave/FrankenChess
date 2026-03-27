extends Sprite3D

enum PartTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
@onready var dots: Node = $Dots

# Variables 
var selected_piece = null
var spaces = {}
@onready var cam_pivot: Node3D = get_node("../CameraPivot")
var camera_flipped := false
var is_flipping := false #Stops the user from pressing f while already flipping

# use the f key to flip the camera 180 degrees
func _process(delta: float) -> void:
	if Input.is_action_just_released("Flip") and not is_flipping:
		flip_camera_smooth()

func flip_camera_smooth():
	is_flipping=true
	
	var tween = create_tween()
	tween.tween_property(
		cam_pivot,
		"rotation:y",
		cam_pivot.rotation.y + PI,
		0.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func():
		is_flipping=false
		camera_flipped = !camera_flipped
	)

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
	#auto_place_pieces()
	
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
#func auto_place_pieces():
	#var back_rank = {
		#"rook":   [0, 7],
		#"knight": [1, 6],
		#"bishop": [2, 5],
		#"queen":  [3],
		#"king":   [4]
	#}
#
	##  Place the white pieces
	#for piece in $White.get_children():
		#piece.color = "white"
		#piece.piece_type = String(get_type_from_name(piece.name))
#
		#if piece.piece_type == "pawn":
			#var file = int(piece.name.substr(piece.name.length() - 1)) - 1
			#place_piece(piece, Vector2i(file, 1))
		#else:
			#var type = String(piece.piece_type)
			#var name_str = String(piece.name)
			#var last_char = name_str[name_str.length() - 1]
			#var index = int(last_char) - 1 if last_char.is_valid_int() else 0
			#var file = back_rank[type][index]
			#place_piece(piece, Vector2i(file, 0))
#
	## Black pieces
	#for piece in $Black.get_children():
		#piece.color = "black"
		#piece.piece_type = String(get_type_from_name(piece.name))
#
		#if piece.piece_type == "pawn":
			#var file = int(piece.name.substr(piece.name.length() - 1)) - 1
			#place_piece(piece, Vector2i(file, 6))
		#else:
			#var name_str = String(piece.name)
			#var last_char = name_str[name_str.length() - 1]
			#var index = int(last_char) - 1 if last_char.is_valid_int() else 0
#
			#var type = String(piece.piece_type)
			#var file = back_rank[type][index]
			#place_piece(piece, Vector2i(file, 7))

func _input(event):
	#print("INPUT FIRED")
	if event.is_action_pressed("click"):
		var camera = get_node("../CameraPivot/Camera3D")
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
		print("selected piece is null (chess, line:201)")
		return
		
	if pos == Vector2i(-1,-1):
		move_piece(selected_piece, pos)

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
	print("Selected piece:", piece.name, " at ", piece.board_pos)

	var legal_moves
	
	if piece.board_pos == Vector2i(-1, -1):
		legal_moves = piece.get_moves(spaces)
	else:
		var raw_moves = piece.get_moves(spaces)
		legal_moves = []

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
	var marker = get_marker_at(pos)
	if marker == null:
		return

	
	if piece.board_pos == Vector2i(-1, -1):
		piece.board_pos = pos
		spaces[pos] = piece
		
		print(piece.global_position)
		print(marker.global_position)
		piece.global_position = marker.global_position
		print(piece.global_position)
		print(marker.global_position) 
		
		highlight_moves([])
		return
	
	# Remove from old position in board state
	spaces[piece.board_pos] = null

	# Capture if needed
	var target_piece = spaces.get(pos)
	if target_piece and target_piece.color != piece.color:
		capture_piece(target_piece)

	# Update internal board position
	piece.board_pos = pos
	spaces[pos] = piece

	# --- Smooth movement animation ---
	var start = piece.global_transform.origin
	var end = marker.global_transform.origin

	var lift_height = 0.5  # how high the piece lifts
	var lift_pos = start + Vector3(0, lift_height, 0)
	var drop_pos = end + Vector3(0, lift_height, 0)

	var tween = create_tween()

	# Lift up
	tween.tween_property(piece, "global_transform:origin", lift_pos, 0.15)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Move across
	tween.tween_property(piece, "global_transform:origin", drop_pos, 0.25)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	# Drop down
	tween.tween_property(piece, "global_transform:origin", end, 0.15)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	# When animation finishes → clear highlights
	tween.finished.connect(func():
		highlight_moves([])
	)
	
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
			sprite.modulate = Color(1, 1, 1, 0)  # fully invisible

	if moves.is_empty():
		return

	# --- Ripple effect setup ---
	# Sort moves by distance from selected piece
	moves.sort_custom(func(a, b):
		var da = selected_piece.board_pos.distance_to(a)
		var db = selected_piece.board_pos.distance_to(b)
		return da < db
	)

	# Fade-in timing
	var base_delay := 0.03  # delay between each ripple step
	var fade_time := 0.15   # how long each fade takes

	# Apply fade-in ripple
	for i in range(moves.size()):
		var pos = moves[i]
		var marker = get_marker_at(pos)
		if marker:
			var sprite = marker.get_node("Sprite3D")
			if sprite:
				var target_color: Color

				# Enemy piece → red
				var piece_at_pos = spaces[pos]
				if piece_at_pos and piece_at_pos.color != selected_piece.color:
					target_color = Color(0.9, 0.2, 0.2, 0.7)
				else:
					target_color = Color(0.2, 0.8, 0.2, 0.6)

				# Tween fade-in with ripple delay
				var tween = create_tween()
				tween.tween_property(
					sprite,
					"modulate",
					target_color,
					fade_time
				).set_delay(i * base_delay)

"""
Three King safety checks: (Prevents the king from entering check)
"""
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
	


func _on_add_piece_pressed() -> void:
	var full_piece = StaticBody3D.new()
	var main = get_parent()
	var piece
	var piece_name = Global.global_top.capitalize() + Global.global_mid.capitalize() + Global.global_base.capitalize()
	for child in main.get_children(): 
		if child.name == "AssembledPiece":
			piece = child
			piece.reparent(self)
		else:
			print("cound not find current parts node")

	full_piece.name = piece_name
	
	full_piece.set_script(load("res://scripts/piece.gd"))
	
	if Global.turn:
		$White.add_child(full_piece)
	else:
		$Black.add_child(full_piece)
	
	#full_piece needs to have the same position as rock bottom
	full_piece.global_position = piece.global_position
	
	piece.reparent(full_piece)
	
	for part in piece.get_children():
		var collider = add_collider(part)
		collider.reparent(full_piece)
	
	full_piece._top = Global.global_top
	full_piece._mid = Global.global_mid
	full_piece._base = Global.global_base
	
	Global.assembled_piece = null
	
	#print(full_piece._top)
	select_piece(full_piece)

func add_collider(part): #this is also broken
	print("=======")
	print("Adding Colliders")
	for item in part.get_children():
		if item is MeshInstance3D:
			var mesh = item.mesh
			var shape = mesh.create_trimesh_shape()

			var collider = CollisionShape3D.new()
			collider.shape = shape
			collider.transform = item.transform
			
			part.add_child(collider)
			return collider
		if item is Node3D:
			print(item)
			for child in item.get_children():
				print(child)
				if child is MeshInstance3D:
					var mesh = child.mesh
					var shape = mesh.create_trimesh_shape()

					var collider = CollisionShape3D.new()
					collider.shape = shape
					collider.transform = child.transform
					
					part.add_child(collider)
					return collider
	print(part)
	print("===")
	return 
