# player_particle_manager.gd
class_name PlayerParticleManager extends Node2D

@onready var run_particles: CPUParticles2D = $RunParticles
@onready var ghost_container: Node2D = $GhostContainer

const GHOST_SPRITE = preload("res://scenes/player/ghost_sprite.tscn")
const GHOST_LIFETIME: float = 0.15
const GHOST_SPAWN_TIME: float = 0.008

var can_spawn_ghost: bool = true
var ghost_timer: Timer
var current_direction: Vector2 = Vector2.ZERO


func _ready() -> void:
	if run_particles:
		run_particles.emitting = false

	ghost_timer = Timer.new()
	ghost_timer.wait_time = GHOST_SPAWN_TIME
	ghost_timer.one_shot = true
	ghost_timer.timeout.connect(reset_ghost_spawn)
	add_child(ghost_timer)


func emit_run_particles(direction: float) -> void:
	if run_particles:
		var particle_direction = Vector2(-sign(direction), -0.1)
		run_particles.direction = particle_direction
		run_particles.position = Vector2(-sign(direction) * 10, -2)
		run_particles.emitting = true


func stop_run_particles() -> void:
	if run_particles:
		run_particles.emitting = false
		run_particles.restart()
		run_particles.emitting = false


func start_dash_effect(direction: Vector2) -> void:
	current_direction = direction
	spawn_ghost()


func spawn_ghost() -> void:
	if not can_spawn_ghost:
		return

	var player = get_parent()
	var player_sprite = player.get_node("Sprite2D")
	var animation_player = player.get_node("AnimationPlayer")

	var ghost = GHOST_SPRITE.instantiate()
	ghost_container.add_child(ghost)

	ghost.texture = player_sprite.texture
	ghost.hframes = player_sprite.hframes
	ghost.vframes = player_sprite.vframes

	ghost.frame = player_sprite.frame

	ghost.flip_h = player_sprite.flip_h
	ghost.position = player_sprite.position

	ghost.start_fade(GHOST_LIFETIME)

	can_spawn_ghost = false
	ghost_timer.start()


func reset_ghost_spawn() -> void:
	can_spawn_ghost = true
	if get_parent().is_dashing:
		spawn_ghost()


func stop_dash_effect() -> void:
	current_direction = Vector2.ZERO
