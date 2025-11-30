extends Node2D

@onready var pipe_scene = preload("res://scenes/pipe.tscn")
@onready var spawner = $PipeSpawner
const GAP := 80.0  # espaço para passar
const TOP_MARGIN := -100.0
const BOTTOM_MARGIN := 450.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game Ready")
	spawner.timeout.connect(_on_spawn_pipe)
	
func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 50 * delta

func _on_spawn_pipe() -> void:
	var pipe = pipe_scene.instantiate()
	
	var spawn_x = get_viewport_rect().size.x + 100
	
	var min_y := TOP_MARGIN + GAP / 2.0
	var max_y := get_viewport_rect().size.y - BOTTOM_MARGIN - GAP / 2.0
	var spawn_y := randf_range(min_y, max_y)

	#var spawn_y = randf_range(-100, get_viewport_rect().size.y - 100)
	
	pipe.position = Vector2(spawn_x, spawn_y)
	
	pipe.hit.connect(game_over)

	add_child(pipe)

func game_over() -> void:
	print("Game Over Triggered")
	get_tree().reload_current_scene()
