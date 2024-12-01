class_name PlayerParticleManager extends Node2D

@onready var run_particles: CPUParticles2D = $RunParticles


func _ready() -> void:
	if run_particles:
		setup_run_particles()
		run_particles.emitting = false


func setup_run_particles() -> void:
	run_particles.lifetime = 0.3
	run_particles.one_shot = false
	run_particles.amount = 20

	run_particles.explosiveness = 0.0
	run_particles.spread = 15.0
	run_particles.gravity = Vector2(0, 50.0)

	run_particles.initial_velocity_min = 30.0
	run_particles.initial_velocity_max = 50.0

	run_particles.scale_amount_min = 1.0
	run_particles.scale_amount_max = 2.0

	run_particles.modulate = Color.WHITE_SMOKE

	run_particles.local_coords = true


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
