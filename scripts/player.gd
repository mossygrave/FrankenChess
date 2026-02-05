extends Camera3D

var speed: float = 250.0

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * 0.25
		$Camera3D.rotation_degrees.x -= event.relative.y * 0.25
		
