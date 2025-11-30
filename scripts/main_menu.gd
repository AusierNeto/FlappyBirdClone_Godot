extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 20.0 * delta
	if Input.is_action_just_pressed("ui_accept"):
		_start_game()

func _start_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
