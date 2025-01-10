extends CharacterBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D

@export var move_speed: float = 60.0
@export var loop_path: bool = true

var last_position: Vector2


func _ready() -> void:
	position = path_follow.global_position
	last_position = position


func _physics_process(delta: float) -> void:
	path_follow.progress += move_speed * delta
	position = path_follow.global_position

	var movement := position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)

	last_position = position


func _update_animation(movement: Vector2) -> void:
	var anim_name := "walk_"
	anim_name += (
		"right"
		if abs(movement.x) > abs(movement.y) and movement.x > 0
		else "left" if abs(movement.x) > abs(movement.y) else "down" if movement.y > 0 else "up"
	)

	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
