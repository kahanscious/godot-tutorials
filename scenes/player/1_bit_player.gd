@icon("res://assets/icons/control/icon_character_green.png")
class_name OneBitPlayer extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animations: AnimationPlayer = $AnimationPlayer

@export var speed: float = 200.0
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1
@export var jump_force: float = -400.0
@export var gravity: Vector2 = Vector2(0, 980.0)
@export var coyote_time: float = 0.2
@export var jump_buffer_time: float = 0.1

var was_on_floor: bool = false
var can_coyote_jump: bool = false
var jump_pressed: bool = false
var jump_buffer_timer: Timer
var direction: float


func _ready() -> void:
	jump_buffer_timer = Timer.new()
	jump_buffer_timer.one_shot = true
	jump_buffer_timer.timeout.connect(func(): jump_pressed = false)
	add_child(jump_buffer_timer)


func _physics_process(delta: float) -> void:
	was_on_floor = is_on_floor()

	if not is_on_floor():
		velocity += gravity * delta

		if was_on_floor and velocity.y >= 0:
			can_coyote_jump = true
			get_tree().create_timer(coyote_time).timeout.connect(func(): can_coyote_jump = false)

	else:
		if jump_pressed:
			velocity.y = jump_force
			jump_pressed = false
			jump_buffer_timer.stop()

	if Input.is_action_just_pressed("jump"):
		if is_on_floor() or can_coyote_jump:
			velocity.y = jump_force
			can_coyote_jump = false
		else:
			jump_pressed = true
			jump_buffer_timer.start(jump_buffer_time)

	direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * speed
		sprite.flip_h = true if direction < 0 else false
		if is_on_floor():
			animations.play("run")
		else:
			velocity.x = lerp(velocity.x, direction * air_speed, air_acceleration)
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, speed)
			animations.play("idle")
		else:
			velocity.x = lerp(velocity.x, 0.0, air_acceleration * 0.5)

	move_and_slide()
