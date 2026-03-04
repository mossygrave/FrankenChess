extends Sprite3D

enum PartTypes {PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING}
@onready var dots: Node = $Board/Dots

# Variables 
var board : Array
var brown : bool
var state : bool # False: selecting move True: confirming the move
var moves = [] 
var selected_piece : Vector3 #only using x and z coords. y will stay the same
#var move_generator
var spaces = {}

#func _ready() -> void:
#	for marker in dots.get_children():
#		spaces[marker.marker_id] = null

	



#use the f key to flip the board
func _process(delta: float) -> void:
		
	if (Input.is_action_just_released("Flip")): #f to flip
		rotate_y(PI)
