extends CanvasLayer


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	Global.black_parts = {}
	Global.white_parts = {}
	Global.black_king = false
	Global.white_king = false
	Global.add_random_parts()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MainMenuTesting.tscn")
	Global.black_parts = {}
	Global.white_parts = {}
	Global.black_king = false
	Global.white_king = false
	Global.add_random_parts()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
