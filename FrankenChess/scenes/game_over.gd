extends CanvasLayer


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenuTesting.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
