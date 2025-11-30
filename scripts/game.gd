extends Node2D

@onready var pipe_scene = preload("res://scenes/instances/pipe.tscn")
@onready var spawner = $PipeSpawner
@onready var score_container: HBoxContainer = $UI/ScoreContainer

const GAP := 80.0
const TOP_MARGIN := -100.0
const BOTTOM_MARGIN := 450.0

var score: int = 0
var digit_sprites: Array[Texture2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game Ready")
	
	spawner.timeout.connect(_on_spawn_pipe)
	for i in range(10):
		digit_sprites.append(load("res://sprites/digits/%d.png" %i))
	update_score_display()
	
func _process(delta: float) -> void:
	$ParallaxBackground.scroll_offset.x -= 50 * delta

func _on_spawn_pipe() -> void:
	var pipe = pipe_scene.instantiate()
	
	var spawn_x = get_viewport_rect().size.x + 100
	
	var min_y := TOP_MARGIN + GAP / 2.0
	var max_y := get_viewport_rect().size.y - BOTTOM_MARGIN - GAP / 2.0
	var spawn_y := randf_range(min_y, max_y)
	
	pipe.position = Vector2(spawn_x, spawn_y)
	
	pipe.hit.connect(game_over)
	pipe.score.connect(update_score_display)

	add_child(pipe)

func update_score_display() -> void:
	for child in score_container.get_children():
		child.queue_free()	
	
	print(score)
	# Cria um sprite para cada dígito
	for digit_char in str(score):
		var sprite = Sprite2D.new()
		sprite.texture = digit_sprites[int(digit_char)]
		score_container.add_child(sprite)
	
	score += 1

func game_over() -> void:
	print("Game Over Triggered")
	get_tree().reload_current_scene()

# Ground Collision
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		game_over()
