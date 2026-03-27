extends Control

@onready var credits := [
	$Morgan,
	$Byron,
	$Smedley,
	$Joey,
	$Jonathan,
	$Corben,
	$Cinder
]

var index := 0

func _ready():
	# Make sure only the first label is visible
	show_credit(index)
	print("Credits array:", credits)
	print("Morgan modulate:", $Morgan.modulate)

func show_credit(i: int):
	for j in range(credits.size()):
		var label = credits[j]
		print("Label:", label.name, "target alpha:", 1.0 if j == i else 0.0)

		var tween = create_tween()

		if j == i:
			tween.tween_property(label, "self_modulate:a", 1.0, 0.4)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		else:
			tween.tween_property(label, "self_modulate:a", 0.0, 0.3)\
				.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	print("Showing credit index:", i)


func check_for_easter_egg(i: int):
	match i:
		0:
			# Morgan’s easter egg
			pass
		1:
			# Byron’s easter egg
			pass
		2:
			# Smedley’s easter egg
			pass
		3:
			# Joey’s easter egg
			pass
		4:
			# Jonathan’s easter egg
			pass
		5:
			# Corben’s easter egg
			pass
		6:
			# Cinder’s easter egg
			pass


func _on_RightButton_pressed() -> void:
	index = (index + 1) % credits.size()
	show_credit(index)
	check_for_easter_egg(index)
	print ("right")


func _on_LeftButton_pressed() -> void:
	index = (index - 1 + credits.size()) % credits.size()
	show_credit(index)
	check_for_easter_egg(index)
	print ("left")
