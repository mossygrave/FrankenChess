extends Node3D

#added by morgan to test the fully assembled pieces being transported from assembly to main

func _on_add_piece_pressed() -> void:
	var piece = Global.assembled_piece
	add_child(piece)
	Global.assembled_piece = null
	
func _on_assembly_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/assembly.tscn")
