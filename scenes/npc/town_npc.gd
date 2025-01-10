class_name TownNPC extends CharacterBody2D

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var debug_line: Line2D = $DebugLine
@onready var interaction_area: Area2D = $InteractionArea
@onready var wait_timer: Timer = $WaitTimer

@export_group("Movement")
@export var move_speed: float = 30.0
@export var path_color: Color = Color.LIGHT_BLUE
@export var path_width: float = 2.0

@export_group("Path Following")
@export var show_debug_path: bool = true
@export var loop_path: bool = true
@export var wait_at_points: bool = true
@export var min_wait_time: float = 2.0
@export var max_wait_time: float = 5.0

# Movement variables
var following_path: bool = false
var waiting_at_point: bool = false
var movement_direction: Vector2 = Vector2.ZERO
var current_movement_direction: Vector2 = Vector2.ZERO
var last_valid_direction: Vector2 = Vector2.UP
var movement_interpolation_speed: float = 10.0


func _ready() -> void:
	# Setup animation tree
	animation_tree.active = true

	# Setup debug visualization
	if show_debug_path:
		debug_line.default_color = path_color
		debug_line.width = path_width
		_update_debug_line()

	# Setup wait timer
	wait_timer.one_shot = true
	wait_timer.timeout.connect(_on_wait_timer_timeout)

	print("loop_path setting:", loop_path)

	# Setup PathFollow2D
	if path_follow:
		path_follow.loop = false
		path_follow.rotates = false
		# Position character at start of path
		path_follow.progress = 0.0
		global_position = path_follow.global_position
		print("PathFollow2D setup complete")

	# Start following path AFTER setup is complete
	start_following()


func _physics_process(delta: float) -> void:
	if not following_path or not path or not path_follow or waiting_at_point:
		# When not moving, smoothly transition to zero velocity but keep facing direction
		current_movement_direction = current_movement_direction.lerp(
			Vector2.ZERO, delta * movement_interpolation_speed
		)
		_update_animations()
		return

	# Get our current progress
	var current_ratio = path_follow.progress_ratio
	print("Current ratio: ", current_ratio)

	# Check for path completion first
	if current_ratio >= 0.99:
		print("Ratio >= 0.99")
		if not loop_path:
			print("Not looping, should stop")
			stop_following()
			return

	# Only update progress if we're still following
	if following_path:
		print("Still following path")
		path_follow.progress += move_speed * delta

		# Get movement direction from current position to target
		var target_pos = path_follow.global_position
		var direction = target_pos - global_position
		var distance = direction.length()

		print("Distance to target: ", distance)
		print("Target pos: ", target_pos)
		print("Current pos: ", global_position)

		if distance > 1.0:
			movement_direction = direction.normalized()
			if movement_direction.length() > 0.1:  # Only update if we have significant movement
				last_valid_direction = movement_direction

			current_movement_direction = current_movement_direction.lerp(
				movement_direction, delta * movement_interpolation_speed
			)
			velocity = current_movement_direction * move_speed
			print("Moving with velocity: ", velocity)
			move_and_slide()
		else:
			if wait_at_points and current_ratio >= 0.99:
				print("At end point, waiting")
				_wait_at_point()

		_update_animations()


func _update_animations() -> void:
	if current_movement_direction.length() > 0.1:
		animation_tree["parameters/conditions/is_moving"] = true
		animation_tree["parameters/conditions/not_moving"] = false
		animation_tree["parameters/idle/blend_position"] = current_movement_direction
		animation_tree["parameters/walk/blend_position"] = current_movement_direction
	else:
		animation_tree["parameters/conditions/is_moving"] = false
		animation_tree["parameters/conditions/not_moving"] = true
		animation_tree["parameters/idle/blend_position"] = last_valid_direction
		animation_tree["parameters/walk/blend_position"] = last_valid_direction


func start_following() -> void:
	if path and path_follow:
		following_path = true
		path_follow.progress = 0.0


func stop_following() -> void:
	following_path = false
	movement_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	print("Stopped following path")
	_update_animations()


func _wait_at_point() -> void:
	waiting_at_point = true
	movement_direction = Vector2.ZERO
	velocity = Vector2.ZERO
	_update_animations()

	var wait_time = randf_range(min_wait_time, max_wait_time)
	wait_timer.start(wait_time)


func _on_wait_timer_timeout() -> void:
	waiting_at_point = false
	if not loop_path and path_follow.progress_ratio >= 0.99:
		stop_following()


func _update_debug_line() -> void:
	if show_debug_path and path:
		debug_line.clear_points()
		var points = path.curve.get_baked_points()
		for point in points:
			debug_line.add_point(point)

		# Close the loop if needed
		if loop_path and points.size() > 0:
			debug_line.add_point(points[0])


# Add a point to the path (useful for editor tools)
func add_path_point(point: Vector2) -> void:
	if not path.curve:
		path.curve = Curve2D.new()
	path.curve.add_point(point)
	_update_debug_line()
