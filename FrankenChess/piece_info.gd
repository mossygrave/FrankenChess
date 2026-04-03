extends Node2D

@onready var top_sprite: Sprite2D = $TopSprite
@onready var mid_sprite: Sprite2D = $MidSprite
@onready var base_sprite: Sprite2D = $BaseSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func change_sprites(top, mid, base, color):
	set_sprite(top, top_sprite, color)
	set_sprite(mid, mid_sprite, color)
	set_sprite(base, base_sprite, color)

func set_sprite(part, sprite: Sprite2D, color):
	match(part):
		"pawn":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-pawn.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-pawn.png")
		"rook":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-rook.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-rook.png")
		"knight":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-knight.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-knight.png")
		"bishop":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-bishop.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-bishop.png")
		"queen":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-queen.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-queen.png")
		"king":
			if color == "white":
				sprite.texture = load("res://assets/2d pieces/white-king.png")
			else:
				sprite.texture = load("res://assets/2d pieces/black-king.png")
		"":
			print("Error changing the top sprite piece_info, 44")
