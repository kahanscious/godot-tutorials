class_name Player extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animations: AnimationPlayer = $AnimationPlayer

@export var speed: float = 200.0
@export var air_speed: float = 150.0
@export var air_acceleration: float = 0.1
@export var jump_force: float = -400.0
@export var gravity: Vector2 = Vector2(0, 980.0)

var direction: float


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += gravity * delta
		if velocity.y < 0:
			animations.play("jump")
		elif velocity.y == 0:
			animations.play("jump_apex")
			await animations.animation_finished
		elif velocity.y > 0:
			animations.play("fall")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

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
