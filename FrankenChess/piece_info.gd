extends Node2D

@onready var top_sprite: Sprite2D = $TopSprite
@onready var mid_sprite: Sprite2D = $MidSprite
@onready var base_sprite: Sprite2D = $BaseSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_sprites(top, mid, base):
	set_sprite(top, top_sprite)
	set_sprite(mid, mid_sprite)
	set_sprite(base, base_sprite)

func set_sprite(part, sprite: Sprite2D):
	match(part):
		"pawn":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-pawn.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-pawn.png")
		"rook":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-rook.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-rook.png")
		"knight":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-knight.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-knight.png")
		"bishop":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-bishop.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-bishop.png")
		"queen":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-queen.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-queen.png")
		"king":
			if Global.turn == "white":
				sprite.texture = load("res://assets/2d pieces/white-king.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-king.png")
		"":
			print("Error changing the top sprite piece_info, 44")
