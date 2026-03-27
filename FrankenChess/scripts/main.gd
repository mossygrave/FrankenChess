extends Node3D

@onready var board: Sprite3D = $Board

#added by morgan to test the fully assembled pieces being transported from assembly to main
func _ready() -> void:
	$UI/CanvasLayer.visible = false
	$CameraPivot/Camera3D.current = false

func _process(delta: float) -> void:
	if $CameraPivot/Camera3D.current == true:
		$UI/CanvasLayer.visible = true
	
func _on_assembly_pressed() -> void:
	#get_tree().change_scene_to_file("res://scenes/assembly.tscn")
	var cam = $CameraPivot/Camera3D
	var ui = $UI/CanvasLayer
	$Assembly.visible = true
	Global.change_scene(cam, ui)
