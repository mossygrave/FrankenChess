extends Node3D

@onready var camera_3d: Camera3D = $Camera3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var piece: Node3D = $Piece

var draggingCollider
var mousePosition
var doDrag = false

func _input(event):
	var intersect = get_mouse_intersect(event.position)
	
	if event is InputEventMouse:
		if intersect: mousePosition = intersect.position
		
	if event is InputEventMouseButton:
		var leftButtonPressed = event.button_index == MOUSE_BUTTON_LEFT && event.pressed
		var leftButtonReleased = event.button_index == MOUSE_BUTTON_LEFT && !event.pressed
		
		if leftButtonReleased:
			doDrag = false
			drag_and_drop(intersect)
		elif leftButtonPressed:
			doDrag = true
			drag_and_drop(intersect)
	
func process(delta):
	if draggingCollider:
		draggingCollider.global_position = mousePosition

func drag_and_drop(intersect):
	if !draggingCollider && doDrag:
		draggingCollider = intersect.collider
		draggingCollider.set_collision_layer(false)
	elif draggingCollider:
		draggingCollider.set_collision_layer(true)
		draggingCollider = null
		
		
func get_mouse_intersect(mousePosition):
	var currentCamera = get_viewport().get_camera_3d()
	var params = PhysicsRayQueryParameters3D.new()
	
	params.from = currentCamera.project_ray_origin(mousePosition)
	params.to = currentCamera.project_position(mousePosition, 1000)
	
	var worldspace = get_world_3d().direct_space_state
	var result = worldspace.intersect_ray(params)
	
	return result
