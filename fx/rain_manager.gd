class_name RainManager extends Node2D

@onready var rain_particles: CPUParticles2D = $CPUParticles2D

@export_range(0.0, 1.0) var intensity: float = 0.5:
	set(value):
		intensity = value
		_update_rain_intensity()

const BASE_PARTICLE_AMOUNT: int = 1000


func _ready() -> void:
	if rain_particles:
		setup_rain_particles()
		rain_particles.emitting = false
		position = Vector2(0, -200)


func _process(_delta: float) -> void:
	if rain_particles:
		var camera: Camera2D = get_node_or_null("/root/TestLevel/Player/Camera2D")
		if camera:
			global_position = camera.global_position + Vector2(0, -200)


func setup_rain_particles() -> void:
	rain_particles.amount = BASE_PARTICLE_AMOUNT
	rain_particles.lifetime = 0.7
	rain_particles.preprocess = 1.0

	rain_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	rain_particles.emission_rect_extents = Vector2(500, 100)

	rain_particles.direction = Vector2(0, 1)
	rain_particles.spread = 5.0
	rain_particles.gravity = Vector2(0, 980)

	rain_particles.initial_velocity_min = 400.0
	rain_particles.initial_velocity_max = 500.0

	rain_particles.scale_amount_min = 0.3
	rain_particles.scale_amount_max = 0.5


func _update_rain_intensity() -> void:
	if rain_particles:
		rain_particles.emitting = intensity > 0
