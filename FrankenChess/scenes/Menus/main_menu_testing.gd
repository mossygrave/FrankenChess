extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	options.visible = false
	credits.visible = false
	flash_thunder_light()
	start_lightning_loop()



# Called every frame. delta is the amount of time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn");
	

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

func start_lightning_loop():
	while true:
		# Waits 5–15 seconds randomly
		var wait_time = randf_range(5.0, 15.0)
		await get_tree().create_timer(wait_time).timeout

		# Do the lightning sequence
		await flash_thunder_light()

func flash_thunder_light():
	var light := $Node3D/KingFlashLight

	# Big Flash
	light.visible = true
	light.light_energy = 0.0

	var tween := create_tween()
	tween.tween_property(light, "light_energy", 20.0, 0.15)  # fade in
	tween.tween_property(light, "light_energy", 0.0, 0.20)   # fade out
	await tween.finished
	shake_camera(0.25, 0.22)

	light.visible = false
	await get_tree().create_timer(0.1).timeout

	# short flaash
	light.visible = true
	light.light_energy = 0.0

	var tween2 := create_tween()
	tween2.tween_property(light, "light_energy", 12.0, 0.05)  # quick fade in
	tween2.tween_property(light, "light_energy", 0.0, 0.10)   # quick fade out
	await tween2.finished
	
	light.visible = false

	# Thunder sound
	$Node3D/ThunderSound.play()
	
func shake_camera(intensity := 0.2, duration := 0.25):
	var rig = $Node3D/CameraRig
	var original_pos = rig.position
	
	var tween = create_tween()

	# Number of shakes. 10 seems like a good amount. 3 is what I had before but it seemed to be too unnatural? IDK it looked weird.
	var shakes = 10

	for i in range(shakes):
		# Moved to a random offset
		tween.tween_property(
			rig,
			"position",
			original_pos + Vector3(
				randf_range(-intensity, intensity),
				randf_range(-intensity, intensity),
				randf_range(-intensity, intensity)
			),
				duration / (shakes * 2.0)
		)
		# Snap back toward original
		tween.tween_property(
			rig,
			"position",
			original_pos,
			duration / (shakes * 2.0)
		)
