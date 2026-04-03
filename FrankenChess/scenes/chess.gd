extends Sprite3D

enum PartTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
@onready var dots: Node = $Dots

# Variables 
var selected_piece = null
var spaces = {}
@onready var cam_pivot: Node3D = get_node("../CameraPivot")
var camera_flipped := false
var is_flipping := false #Stops the user from pressing f while already flipping
@onready var turn = "black"

signal delete_parts

@onready var piece_info: Node2D = $"../UI/CanvasLayer/PieceInfo"
@onready var piece_info_active: Marker2D = $"../UI/CanvasLayer/PieceInfoActive"
@onready var piece_info_inactive: Marker2D = $"../UI/CanvasLayer/PieceInfoInactive"

# use the f key to flip the camera 180 degrees
func _process(_delta: float) -> void:
	if turn != Global.turn:
		turn = Global.turn
		#flip_camera_smooth()
	if Input.is_action_just_released("Flip") and not is_flipping:
		flip_camera_smooth()
		
	#this is broken and i'll fix it later
	#if $"../CameraPivot/Camera3D".current and Global.assembled_piece != null:
		#print("Assembled piece going to the board")
		#_on_add_piece_pressed()

func flip_camera_smooth():
	await get_tree().create_timer(.15).timeout
	is_flipping=true
	
	var tween = create_tween()
	tween.tween_property(
		cam_pivot,
		"rotation:y",
		cam_pivot.rotation.y + PI,
		0.85
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func():
		is_flipping=false
		camera_flipped = !camera_flipped
	)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game_over.tscn");

#  Ready builds the board grid, debugs and auto-places pieces
func _ready():
	flip_camera_smooth()
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
		@warning_ignore("integer_division")
		var y = index / 8
		marker.set_meta("board_pos", Vector2i(x, y))
		spaces[Vector2i(x, y)] = null
		index += 1
		
	#print("Markers in running scene:")
	#for m in dots.get_children():
		#print(m.name, " type:", m.get_class(), " has collision:", m.get_child_count())
#
	#print(" Marker Coordinates ")
	#for marker in markers:
		#print(marker.name, " -> ", marker.get_meta("board_pos"))

@warning_ignore("shadowed_variable_base_class")
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
		#print("Ray result raw:", result)

		if result and result.collider:
			var hit = result.collider

				# 1. If we clicked a PIECE
			if hit.has_method("is_piece"):
				var clicked_piece = hit

				#if clicked_piece.color != Global.turn and !selected_piece:
					#print("That is not your piece")
					#select_piece(clicked_piece)
				# If a piece is already selected...
				if selected_piece:

				# 1. Clicking the SAME piece → deselect
					if clicked_piece == selected_piece:
						highlight_moves([])
						deselect_piece()
						return

				# 2. Clicking someone else's piece → switch selection
					if clicked_piece.color != selected_piece.color:
						highlight_moves([])
					# Switches selection for your piece or opponent's piece
					select_piece(clicked_piece)
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
	#print("Clicked square:", pos)

	# If no piece is selected, do nothing
	if selected_piece == null:
		#print("selected piece is null (chess, line:201)")
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
	#var piece = spaces.get(pos)
	#if piece:
		#print("You clicked:", piece.name, "at", pos)
	#else:
		#print("Square is empty.")

func select_piece(piece):
	$"../SFX/SelectPiece".play()
	if selected_piece:
		
		if Global.assembled_piece:
			selected_piece.queue_free()
			selected_piece = null
			Global.global_top = null
			Global.global_mid = null
			Global.global_base = null
	 
			Global.assembled_piece = null
		deselect_piece()
		await get_tree().create_timer(.47).timeout

	selected_piece = piece
	#print("Selected piece:", piece.name, " at ", piece.board_pos)
	
	piece_info.change_sprites(piece._top, piece._mid, piece._base, piece.color)
	var active = piece_info_active.global_position
	var tween = create_tween()
	tween.tween_property(piece_info, "global_position", active, .35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if selected_piece.color == Global.turn:
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
	
	var inactive = piece_info_inactive.global_position
	var tween = create_tween()
	tween.tween_property(piece_info, "global_position", inactive, .8).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_IN_OUT)

	
func move_piece(piece, pos):
	$"../SFX/PlacePiece".play()
	
	var marker = get_marker_at(pos)
	if marker == null:
		return

	var target_piece = spaces.get(pos)
	
	if piece.board_pos == Vector2i(-1, -1):
		
		if target_piece and target_piece.color != piece.color:
			capture_piece(target_piece)
			$"../SFX/CapturePiece".play()
		
		piece.board_pos = pos
		spaces[pos] = piece
		
		piece.global_position = marker.global_position
		
		if piece.color == "black":
			piece.rotation.y += PI
		
		if Global.turn == "white":
			Global.turn = "black"
		else:
			Global.turn = "white"
		
		if Global.black_king and Global.white_king:
			evaluate_game_state(Global.turn)
			if Global.game_result:
				return
		
		highlight_moves([])
		
		flip_camera_smooth()
		
		#send a signal to delete the pieces from the assembly lists
		delete_parts.emit()
		return
	
	# Remove from old position in board state
	spaces[piece.board_pos] = null
	
	# Capture if needed
	if target_piece and target_piece.color != piece.color:
		capture_piece(target_piece)
		$"../SFX/CapturePiece".play()

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
		
		#flip the camera
		flip_camera_smooth()
		
		# After the move finishes, check the OTHER player's state
		var next_color = "black" if piece.color == "white" else "white"
		evaluate_game_state(next_color)
		
	)
	
	if Global.turn == "white":
		Global.turn = "black"

	else:
		Global.turn = "white"
	
func capture_piece(piece):
	# Remove from board state
	spaces[piece.board_pos] = null

	# Remove from the scene
	piece.queue_free()

func highlight_moves(moves: Array):
	print(spaces)
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
		if piece and piece._top == "king" and piece.color == color:
			return pos
	return Vector2i(-2, -1)

func square_is_attacked(pos: Vector2i, by_color: String) -> bool:
	for other_pos in spaces.keys():
		var piece = spaces[other_pos]
		if piece and piece.color == by_color:
			var moves = piece.get_attacks(spaces) 
			#print(pos)
			#print(moves)
			if pos in moves or pos == Vector2i(-2, -1):
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

	var in_check
	# Check if king is attacked
	if piece._top == "king":
		in_check = square_is_attacked(
		king_pos,
		"black" if piece.color == "white" else "white"
		)

	# Undo move
	spaces[target_pos] = captured_piece
	spaces[original_pos] = piece
	piece.board_pos = original_pos

	return not in_check
	
func is_in_check(color: String) -> bool:
	var king_pos = find_king(color)
	if king_pos == Vector2i(-2, -1):
		return false  # king not found (should never happen)
	
	var enemy_color = "white" if color == "black" else "black"
	return square_is_attacked(king_pos, enemy_color)

# This function loops through every single piece, then loops through every single move they can make.
# If there is any move that is legal they are not in checkmate or in a stalemate

# this needs to change to it only checks the king's moves
# maybe attacks to get the king out of check but that sounds complicated
func player_has_legal_moves(color: String) -> bool:
	for pos in spaces.keys():
		var piece = spaces[pos]
		if piece and piece.color == color:
			if piece._top == "king":
				var raw_moves = piece.get_moves(spaces)

				for move in raw_moves:
					if move_is_legal(piece, move):
						return true  # Found at least one legal move

	return false  # No legal moves exist

func evaluate_game_state(color: String):
	var in_check = is_in_check(color)
	print(in_check)
	var has_moves = player_has_legal_moves(color)
	print(has_moves)

	if in_check and not has_moves:
		print(color, " is checkmated!")
		game_over(color)
		return

	if not in_check and not has_moves:
		print("Stalemate!")
		game_over("stalemate")
		return

	# Debug: announce check
	if in_check:
		print(color, " is in check!")
		show_check_popup("%s is in check!" % color.capitalize())


func game_over(result):
	Global.game_result = result
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	

func show_check_popup(text: String):
	
	var popup = get_node("/root/Main/CanvasLayer/CheckPopup")
	popup.text = text
	popup.visible = true

	# Reset appearance
	popup.modulate = Color(1, 1, 1, 0)
	popup.scale = Vector2(0.8, 0.8)  # start smaller for the bloop

	var tween = create_tween()

	# --- Bloop scale animation ---
	tween.tween_property(
		popup,
		"scale",
		Vector2(1, 1),
		0.2
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# --- Fade in ---
	tween.parallel().tween_property(
		popup,
		"modulate",
		Color(1, 1, 1, 1),
		0.3
	)

	# Hold for 2 seconds
	tween.tween_interval(2.0)

	# Fade out
	tween.tween_property(
		popup,
		"modulate",
		Color(1, 1, 1, 0),
		0.3
	)

	tween.finished.connect(func():
		popup.visible = false
	)

"""func show_check_popup_once(color: String):
	if color == "white" and not white_check_popup_shown:
		white_check_popup_shown = true
		show_check_popup("White is in check!")
	elif color == "black" and not black_check_popup_shown:
		black_check_popup_shown = true
		show_check_popup("Black is in check!")
"""

func _on_assembly_confirm_pieces() -> void:
	if Global.global_top == null:
		return
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
	
	if Global.turn == "white":
		$White.add_child(full_piece)
		full_piece.color = "white"
	else:
		$Black.add_child(full_piece)
		full_piece.color = "black"
	
	#full_piece needs to have the same position as rock bottom
	full_piece.global_position = piece.global_position
	
	piece.reparent(full_piece)
	
	for part in piece.get_children():
		var collider = add_collider(part)
		collider.reparent(full_piece)
	
	full_piece._top = Global.global_top
	full_piece._mid = Global.global_mid
	full_piece._base = Global.global_base
	
	Global.assembled_piece = full_piece

	select_piece(full_piece)

func add_collider(part): #this is also broken
	#print("=======")
	#print("Adding Colliders")
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
			#print(item)
			for child in item.get_children():
				#print(child)
				if child is MeshInstance3D:
					var mesh = child.mesh
					var shape = mesh.create_trimesh_shape()

					var collider = CollisionShape3D.new()
					collider.shape = shape
					collider.transform = child.transform
					
					part.add_child(collider)
					return collider
	#print(part)
	#print("===")
	return 
