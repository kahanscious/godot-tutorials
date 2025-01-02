extends Node2D

@onready var point_light: PointLight2D = $PointLight2D
@onready var flicker_timer: Timer = $FlickerTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var base_energy: float = 1.2
@export var flicker_range: float = 0.05
@export var light_color: Color = Color(1, 0.6, 0.2, 1)
@export var light_radius: float = 2.0


func _ready() -> void:
	flicker_timer.timeout.connect(_on_flicker_timer_timeout)
	animation_player.play("burn")

	point_light.color = light_color
	point_light.texture_scale = light_radius
	point_light.energy = base_energy


func _on_flicker_timer_timeout() -> void:
	var random_energy = randf_range(-flicker_range, flicker_range)
	point_light.energy = base_energy + random_energy
