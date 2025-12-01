extends Node2D

@onready var pipe_scene = preload("res://scenes/instances/pipe.tscn")
@onready var spawner = $PipeSpawner
@onready var score_container: HBoxContainer = $UI/ScoreContainer

const GAP := 80.0
const TOP_MARGIN := -100.0
const BOTTOM_MARGIN := 450.0

var score: int = -1
var is_gameover :bool = false
var digit_sprites: Array[Texture2D] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
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
	score += 1
	for child in score_container.get_children():
		child.queue_free()	
	
	# Cria um sprite para cada dígito
	for digit_char in str(score):
		var rect := TextureRect.new()
		rect.texture = digit_sprites[int(digit_char)]  
		score_container.add_child(rect)

func game_over() -> void:
	if is_gameover:
		return
	is_gameover = true
	
	# Stop generating pipe
	$Bird.die() 
	spawner.stop()
	
	await get_tree().create_timer(0.7).timeout
	_show_game_over()
	
func _show_game_over() -> void:
	var panel = $UI/GameOverPanel
	panel.visible = true  
	get_tree().paused = true

func _unhandled_input(event):
	if $UI/GameOverPanel.visible and event.is_action_pressed("ui_accept"):
		get_tree().paused = false
		get_tree().reload_current_scene()

# Ground Collision
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Bird":
		$Bird.velocity.y = 0
		game_over()
