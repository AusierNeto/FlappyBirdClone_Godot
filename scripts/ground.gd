extends Node2D

const SPEED := 150.0

func _process(delta):
	position.x -= SPEED * delta
	
	var width = $Sprite2D.texture.get_width()

	if position.x < -width:
		position.x += 2 * width
