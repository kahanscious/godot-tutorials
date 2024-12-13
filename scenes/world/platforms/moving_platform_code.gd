extends AnimatableBody2D

@export var speed: float = 20.0
@export var pause_time: float = 0.5
@export var left_marker: NodePath
@export var right_marker: NodePath

var left_point: Marker2D
var right_point: Marker2D
var direction: float = 1.0
var is_paused: bool = false


func _ready() -> void:
	# Verify markers are set
	assert(left_marker and right_marker, "Platform markers not set!")
	left_point = get_node(left_marker)
	right_point = get_node(right_marker)


func _physics_process(delta: float) -> void:
	if is_paused:
		return

	var movement = speed * delta * direction
	position.x += movement

	if direction > 0 and position.x >= right_point.global_position.x:
		pause_at_endpoint(-1.0)
	elif direction < 0 and position.x <= left_point.global_position.x:
		pause_at_endpoint(1.0)


func pause_at_endpoint(new_direction: float) -> void:
	is_paused = true
	get_tree().create_timer(pause_time).timeout.connect(
		func():
			direction = new_direction
			is_paused = false,
		CONNECT_ONE_SHOT  # Cleanup connection after use
	)
