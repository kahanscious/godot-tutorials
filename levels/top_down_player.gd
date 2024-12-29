class_name TopDownPlayer extends CharacterBody2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var animations: AnimationPlayer = $AnimationPlayer

@export_group("Movement Properties")
@export var move_speed: float = 100.0
@export var acceleration: float = 15.0

@export_group("Animation")
@export var enable_rotation: bool = false
@export var rotation_speed: float = 10.0

var movement_direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	movement_direction = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if movement_direction.length() > 0:
		movement_direction = movement_direction.normalized()
	move(delta)


func move(delta: float) -> void:
	if movement_direction != Vector2.ZERO:
		velocity = movement_direction * move_speed
		if abs(movement_direction.x) > abs(movement_direction.y):
			if movement_direction.x > 0:
				animations.play("move_right")
			else:
				animations.play("move_left")

		else:
			if movement_direction.y > 0:
				animations.play("move_down")
			else:
				animations.play("move_up")
	else:
		velocity = Vector2.ZERO
		animations.play("idle")

	move_and_slide()
