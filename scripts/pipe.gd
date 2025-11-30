extends Node2D

signal hit

const SPEED = 150

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x -= SPEED * delta
	
	if position.x < -200:
		queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		hit.emit()
