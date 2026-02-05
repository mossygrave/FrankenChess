extends Button

@export var button_icon:Texture2D
@export var button_draggable:PackedScene

var _is_dragging:bool = false
var _draggable:Node

func _ready():
	icon = button_icon
	_draggable = button_draggable.instantiate()
	add_child(_draggable)
	#_draggable.visible = false

func _on_button_down() -> void:
	_is_dragging = true
	

func _on_button_up() -> void:
	_is_dragging = false
