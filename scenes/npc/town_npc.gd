extends CharacterBody2D

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var path: Path2D = $Path2D
@onready var path_follow: PathFollow2D = $Path2D/PathFollow2D
@onready var sprite: Sprite2D = $Sprite2D

@export var move_speed: float = 60.0
@export var loop_path: bool = true

@export_group("Movement Settings")
@export var pause_at_points: bool = false
@export var min_pause_time: float = 1.0
@export var max_pause_time: float = 3.0
@export var acceleration: float = 0.5
@export var deceleration: float = 0.5

@export_group("Animation Settings")
@export var use_idle_animations: bool = true
@export var blend_animations: bool = true

# State tracking
enum NPCState { MOVING, PAUSED }
var current_state: NPCState = NPCState.MOVING
var last_position: Vector2
var current_speed: float = 0.0
var pause_timer: Timer


func _ready() -> void:
	# Initialize position
	position = path_follow.global_position
	last_position = position

	# Setup pause timer
	pause_timer = Timer.new()
	pause_timer.one_shot = true
	pause_timer.timeout.connect(_on_pause_timer_timeout)
	add_child(pause_timer)

	# Initialize speed
	current_speed = move_speed if current_state == NPCState.MOVING else 0.0


func _physics_process(delta: float) -> void:
	match current_state:
		NPCState.MOVING:
			_handle_movement(delta)
		NPCState.PAUSED:
			_handle_paused(delta)


func _handle_movement(delta: float) -> void:
	# Smooth acceleration
	current_speed = lerp(current_speed, move_speed, acceleration * delta)

	# Update path progress
	path_follow.progress += current_speed * delta
	position = path_follow.global_position

	# Handle movement animation
	var movement := position - last_position
	if movement.length() > 0.1:
		_update_animation(movement)

	# Check for path completion
	if path_follow.progress_ratio >= 1.0:
		if loop_path:
			path_follow.progress_ratio = 0.0
		elif pause_at_points:
			_start_pause()

	last_position = position


func _handle_paused(delta: float) -> void:
	# Smooth deceleration
	current_speed = lerp(current_speed, 0.0, deceleration * delta)

	# Play idle animation
	if use_idle_animations:
		_play_idle_animation()


func _update_animation(movement: Vector2) -> void:
	var anim_name := "walk_"
	anim_name += (
		"right"
		if abs(movement.x) > abs(movement.y) and movement.x > 0
		else "left" if abs(movement.x) > abs(movement.y) else "down" if movement.y > 0 else "up"
	)
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)

	if movement.length() < 0.1:
		return

	# Play animation with blending if enabled
	if anim_player.current_animation != anim_name:
		if blend_animations:
			anim_player.play(anim_name, 0.2)  # 0.2 second blend
		else:
			anim_player.play(anim_name)


func _play_idle_animation() -> void:
	var current_anim = anim_player.current_animation
	if not current_anim.begins_with("idle"):
		var idle_anim = "idle_" + current_anim.trim_prefix("walk_")
		if anim_player.has_animation(idle_anim):
			anim_player.play(idle_anim, 0.2)


func _start_pause() -> void:
	current_state = NPCState.PAUSED
	var pause_duration = randf_range(min_pause_time, max_pause_time)
	pause_timer.start(pause_duration)


func _on_pause_timer_timeout() -> void:
	current_state = NPCState.MOVING
