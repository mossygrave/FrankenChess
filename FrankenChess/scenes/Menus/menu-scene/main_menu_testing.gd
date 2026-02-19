extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	credits.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene();
	

func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed() -> void:
	main_buttons.visible = false
	options.visible = true



func _on_credits_button_pressed() -> void:
	main_buttons.visible = false
	options.visible = false
	credits.visible = true

@onready var main_buttons: VBoxContainer = $MainButtons
@onready var options: Panel = $Options
@onready var credits: Panel = $Credits

func _on_back_options_pressed() -> void:
	main_buttons.visible = true
	options.visible = false


func _on_back_credits_pressed() -> void:
	main_buttons.visible = true
	options.visible = false
	credits.visible = false
