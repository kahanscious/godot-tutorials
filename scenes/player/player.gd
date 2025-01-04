@icon("res://assets/icons/node_2D/icon_character.png")
class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var player_particle_manager: PlayerParticleManager = $PlayerParticleManager
@onready var progress_bar: ProgressBar = $"../ProgressBar"
@onready var texture_progress_bar: TextureProgressBar = $"../TextureProgressBar"

@export_category("Ground Movement")
@export var speed: float = 200.0

@export_category("Air Movement")
@export var gravity: Vector2 = Vector2(0, 980.0)
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1

@export_category("Jumping")
@export var jump_force: float = -400.0
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.1

@export_category("Dash Ability")
@export var dash_speed: float = 400.0
@export var dash_duration: float = 0.1
@export var dash_cooldown: float = 1.0

@export_category("Health")
@export var max_health: int = 100

var health: int = 100:
	set(value):
		health = clamp(value, 0, max_health)
		if is_node_ready():
			progress_bar.value = health
			texture_progress_bar.value = health
	get:
		return health

var was_on_floor: bool = false
var can_coyote_jump: bool = false
var jump_pressed: bool = false
var jump_buffer_timer: Timer
var direction: float

var can_dash: bool = true
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var dash_timer: Timer
var cooldown_timer: Timer


func _ready() -> void:
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.timeout.connect(func(): jump_pressed = false)
	add_child(jump_buffer_timer)

	dash_timer = Timer.new()
	dash_timer.one_shot = true
	dash_timer.wait_time = dash_duration
	dash_timer.timeout.connect(end_dash)
	add_child(dash_timer)

	cooldown_timer = Timer.new()
	cooldown_timer.one_shot = true
	cooldown_timer.wait_time = dash_cooldown
	cooldown_timer.timeout.connect(refresh_dash)
	add_child(cooldown_timer)


func _physics_process(delta: float) -> void:
	# Handle dash
	if Input.is_action_just_pressed("dash") and can_dash and not is_dashing:
		direction = Input.get_axis("left", "right")
		if not is_on_floor() or direction != 0:
			start_dash()

	if is_dashing:
		velocity.x = dash_direction.x * dash_speed
		velocity.y += gravity.y * delta * 0.5
		move_and_slide()
		return

	if not is_on_floor():
		velocity += gravity * delta
		if was_on_floor and velocity.y >= 0:
			can_coyote_jump = true
			get_tree().create_timer(coyote_time).timeout.connect(func(): can_coyote_jump = false)

		if velocity.y < 0:
			animations.play("jump")
			player_particle_manager.stop_run_particles()
		elif velocity.y == 0:
			animations.play("jump_apex")
			await animations.animation_finished
		elif velocity.y > 0:
			animations.play("fall")
	else:
		if jump_pressed:
			velocity.y = jump_force
			jump_pressed = false
			jump_buffer_timer.stop()
			player_particle_manager.stop_run_particles()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or can_coyote_jump:
			velocity.y = jump_force
			can_coyote_jump = false
			player_particle_manager.stop_run_particles()
		else:
			jump_pressed = true
			jump_buffer_timer.start(jump_buffer_time)

	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = true if direction < 0 else false
		if is_on_floor():
			animations.play("run")
			player_particle_manager.emit_run_particles(direction)
		else:
			velocity.x = lerp(velocity.x, direction * air_speed, air_acceleration)
			player_particle_manager.stop_run_particles()
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed)
			animations.play("idle")
			player_particle_manager.stop_run_particles()
		else:
			velocity.x = lerp(velocity.x, 0.0, air_acceleration * 0.5)

	move_and_slide()


func start_dash() -> void:
	is_dashing = true
	can_dash = false

	direction = Input.get_axis("left", "right")
	if direction != 0:
		dash_direction = Vector2(direction, 0)
	else:
		dash_direction = Vector2(-1 if sprite.flip_h else 1, 0)

	dash_timer.start()
	cooldown_timer.start()

	if player_particle_manager:
		player_particle_manager.start_dash_effect(dash_direction)


func end_dash() -> void:
	is_dashing = false
	velocity = Vector2.ZERO

	if player_particle_manager:
		player_particle_manager.stop_dash_effect()


func refresh_dash() -> void:
	can_dash = true
