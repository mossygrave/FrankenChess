extends Node3D

@onready var base_location: Marker3D = $BaseLocation
@onready var v_box_container: VBoxContainer = $Control/VBoxContainer
@onready var spawn_points = {
	"bottom" : $BaseLocation,
	"middle" : $TopLocation,
	"top" : $TopLocation
}

@export var base_piece: PackedScene

@export var parts = [
	{ "path": "res://assets/Chess Pieces/Pawn Piece/Pawn-BottomFlip.glb", "type": "bottom"},
	{ "path": "res://assets/Chess Pieces/Pawn Piece/Pawn-Middle.glb", "type": "middle"},
	{ "path": "res://assets/Chess Pieces/Pawn Piece/Pawn-Top.glb", "type": "top"},
	{ "path": "res://scenes/middle parts/bishop_mid.tscn", "type": "middle"}
]

func _on_piece_button_pressed() -> void:
	var new_object = base_piece.instantiate()
	new_object.position = base_location.position
	add_child(new_object)

func _ready():
	for part in parts:
		var button = Button.new()
		button.text = part["path"].get_file().get_basename()
		button.pressed.connect(_on_part_selected.bind(part))
		v_box_container.add_child(button)
		
func _on_part_selected(part : Dictionary):
	var scene = load(part["path"])
	var instance = scene.instantiate()
	
	var spawn_node = spawn_points.get(part["type"])
	if spawn_node:
		instance.position = spawn_node.position
		
	add_child(instance)
