extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_flap: AudioStreamPlayer2D = $AudioFlap
@onready var audio_collide: AudioStreamPlayer2D = $AudioCollide

const JUMP_VELOCITY = -280.0

var is_alive = true

func die() -> void:
	is_alive = false
	audio_collide.play()

func _ready() -> void:
	anim.play("fly")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if is_alive and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY
		audio_flap.play()

	move_and_slide()
	# Inclinação do personagem pela velocidade
	rotation = lerp_angle(rotation, velocity.y * 0.002, 0.1)
