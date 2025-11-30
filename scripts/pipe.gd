extends Node2D

signal hit

const SPEED = 150

func _ready() -> void:
	print("Area Layer:", $Area2D.collision_layer)
	print("Area Mask:", $Area2D.collision_mask)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= SPEED * delta
	
	if position.x < -200:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Colidiu")
	print(body.name)
	if body.name == "Bird":
		hit.emit()
