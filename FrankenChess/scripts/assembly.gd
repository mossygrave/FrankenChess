extends Node3D

@onready var base_location: Marker3D = $BaseLocation
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var current_parts = {
	"base" : null,
	"middle" : null,
	"top" : null
}
@onready var spawn_point = $TopLocation

@export var base_piece: PackedScene

@export var parts = [
	{ "path": "res://scenes/Base Parts/pawn_base.tscn", "type": "base"},
	{ "path": "res://assets/Chess Pieces/Bishop Piece/Bishop-Bottom.glb", "type": "base"},
	{ "path": "res://assets/Chess Pieces/Knight Piece/Knight-Bottom.glb", "type": "base"},
	{ "path": "res://scenes/middle parts/pawn_mid.tscn", "type": "middle"},
	{ "path": "res://scenes/middle parts/bishop_mid.tscn", "type": "middle"},
	{ "path": "res://scenes/middle parts/knight_mid.tscn", "type": "middle"},
	{ "path": "res://assets/Chess Pieces/Pawn Piece/Pawn-Top.glb", "type": "top"},
	{ "path": "res://assets/Chess Pieces/Bishop Piece/Bishop-Top.glb", "type": "top"},
	{ "path": "res://assets/Chess Pieces/King Piece/King-Top.glb", "type": "top"}
	
]

#func _on_piece_button_pressed() -> void:
	#var new_object = base_piece.instantiate()
	#new_object.position = base_location.position
	#add_child(new_object)

func _ready():
	for part in parts:
		var button = Button.new()
		button.text = part["path"].get_file().get_basename()
		button.pressed.connect(_on_part_selected.bind(part))
		v_box_container.add_child(button)
	
	var clear = Button.new()
	clear.text = "Clear"
	clear.pressed.connect(_clear_pieces.bind())
	v_box_container.add_child(clear)
	
	var board = Button.new()
	board.text = "Board"
	board.pressed.connect(_change_to_board.bind())
	v_box_container.add_child(board)
	
	var confirm = Button.new()
	confirm.text = "Confirm"
	confirm.pressed.connect(_confirm_pieces.bind())
	v_box_container.add_child(confirm)
	

func _clear_pieces():
	var active: Node = $CurrentParts
	for child in active.get_children():
		child.queue_free()

func _change_to_board():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _confirm_pieces():
	var assembled_piece = $CurrentParts
	
	assembled_piece.get_parent().remove_child(assembled_piece)
	Global.assembled_piece = assembled_piece #this adds the piece to the global script
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
# adds part to scene and moves it to the right position
func _on_part_selected(part : Dictionary):
	var scene = load(part["path"])
	var instance = scene.instantiate()
	
	$CurrentParts.add_child(instance)
	
	if Global.turn == false:
		var mesh = get_mesh3d(instance)
		if mesh:
			var mat = preload("res://assets/Chess Pieces/Pawn Piece/black-piece.tres")
			mesh.set_surface_override_material(0, mat)
		
	if part["type"] != "middle":
		var mid = current_parts["middle"]
		
		if mid == null:
			instance.global_transform = spawn_point.global_transform
			if part["type"] == "base":
				instance.rotation.x += PI
		else:
			if part["type"] == "top":
				var socket = mid.top_socket
				instance.global_transform = socket.global_transform
			if part["type"] == "base":
				var socket = mid.base_socket
				instance.global_transform = socket.global_transform
				instance.rotation.x += PI
				
	elif part["type"] == "middle":
		var top = current_parts["top"]
		var base = current_parts["base"]
		
		instance.global_transform = spawn_point.global_transform
		
		if top:
			var socket = instance.top_socket
			top.global_transform = socket.global_transform
		if base:
			var socket = instance.base_socket
			base.global_transform = socket.global_transform
			base.rotation.x += PI
		
	if current_parts[part["type"]]:
		var active_part = current_parts[part["type"]]
		active_part.queue_free()
	current_parts[part["type"]] = instance
	
func get_mesh3d(node: Node) -> MeshInstance3D:
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
	for child in node.get_children():
		if child is Node3D:
			for baby in child.get_children():
				if baby is MeshInstance3D:
					return baby
	return null
