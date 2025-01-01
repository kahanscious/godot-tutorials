class_name TopDownPlayer extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree

@export var move_speed: float = 100.0

var movement_direction: Vector2


func _ready() -> void:
	animation_tree.active = true


func _physics_process(_delta: float) -> void:
	movement_direction = Input.get_vector("left", "right", "up", "down")
	if movement_direction.length() > 0:
		movement_direction = movement_direction.normalized()

	velocity = movement_direction * move_speed
	move_and_slide()

	if movement_direction != Vector2.ZERO:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/not_moving"] = false
	else:
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/not_moving"] = true

	animation_tree["parameters/idle/blend_position"] = movement_direction
	animation_tree["parameters/walk/blend_position"] = movement_direction
