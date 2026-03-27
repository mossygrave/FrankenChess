extends Node3D

@onready var base_location: Marker3D = $BaseLocation
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var constant: VBoxContainer = $Control/Constant
@onready var current_parts = {
	"base" : null,
	"mid" : null,
	"top" : null
}
@onready var current_dictionaries = {
	"base": null,
	"mid": null,
	"top": null
}
@onready var spawn_point = $TopLocation

@export var base_piece: PackedScene

@onready var parts = {}

func _process(delta: float) -> void:
	if $Camera3D.current == true:
		$Control.visible = true

func _ready():
	
	if Global.turn:
		parts = Global.white_parts
	else:
		parts = Global.black_parts

	for part in parts:
		var button = Button.new()
		button.text = part
		button.pressed.connect(_on_part_selected.bind(parts[part]))
		v_box_container.add_child(button)
	
	var clear = Button.new()
	clear.text = "Clear"
	clear.pressed.connect(_clear_pieces.bind())
	constant.add_child(clear)
	
	var board = Button.new()
	board.text = "Board"
	board.pressed.connect(_change_to_board.bind())
	constant.add_child(board)
	
	var confirm = Button.new()
	confirm.text = "Confirm"
	confirm.pressed.connect(_confirm_pieces.bind())
	constant.add_child(confirm)
	

func _clear_pieces():
	var active: Node = $CurrentParts
	for child in active.get_children():
		child.queue_free()
	current_parts = {
	"base" : null,
	"mid" : null,
	"top" : null
	}
	current_dictionaries = {
	"base": null,
	"mid": null,
	"top": null
	}

func _change_to_board():
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
	var cam = $Camera3D
	var ui = $Control
	visible = false
	Global.change_scene(cam, ui)
	
func _confirm_pieces():
	var top_type = current_dictionaries["top"]["type"]
	var mid_type = current_dictionaries["mid"]["type"]
	var base_type = current_dictionaries["base"]["type"]
	
	var what_we_have = $CurrentParts

	for part in current_parts:
		if part == null:
			return #cancels the function if the player doesnt have all the parts
	
	var assembled_piece = Marker3D.new()
	assembled_piece.name = "AssembledPiece"
	add_child(assembled_piece)
	
	for child in what_we_have.get_children(): 
		for baby in child.get_children():
			if baby.name == "RockBottom":
				assembled_piece.global_position = baby.global_position
	
	for child in what_we_have.get_children():
		child.reparent(assembled_piece)
	
	
	
	var main = get_parent()
	assembled_piece.reparent(main)
	
	Global.global_top = top_type
	Global.global_mid = mid_type
	Global.global_base = base_type
	
	var cam = $Camera3D
	var ui = $Control
	visible = false

	_clear_pieces()
	Global.change_scene(cam, ui)
	#get_tree().change_scene_to_file("res://scenes/main.tscn")
# adds part to scene and moves it to the right position
func _on_part_selected(part : Dictionary):
	#print(part)
	var scene = load(part["model"])
	var instance = scene.instantiate()
	
	$CurrentParts.add_child(instance)
	
	if Global.turn == false:
		var mesh = get_mesh3d(instance)
		if mesh:
			var mat = preload("res://assets/Chess Pieces/Pawn Piece/black-piece.tres")
			mesh.set_surface_override_material(0, mat)
		
	if part["slot"] != "mid":
		var mid = current_parts["mid"]
		
		if mid == null:
			instance.global_transform = spawn_point.global_transform
			if part["slot"] == "base":
				instance.rotation.x += PI
		else:
			if part["slot"] == "top":
				var socket = mid.top_socket
				instance.global_transform = socket.global_transform
			if part["slot"] == "base":
				var socket = mid.base_socket
				instance.global_transform = socket.global_transform
				instance.rotation.x += PI
				
	elif part["slot"] == "mid":
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
		
	if current_parts[part["slot"]]:
		var active_part = current_parts[part["slot"]]
		active_part.queue_free()
	current_parts[part["slot"]] = instance
	current_dictionaries[part["slot"]] = part
	
func get_mesh3d(node: Node) -> MeshInstance3D:
	for child in node.get_children():
		if child is MeshInstance3D:
			return child
		elif child is Node3D:
			for baby in child.get_children():
				if baby is MeshInstance3D:
					return baby
	return null
