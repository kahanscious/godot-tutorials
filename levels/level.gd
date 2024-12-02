class_name Level extends Node2D

@onready var button: Button = $Button
@onready var player: Player = $Player
@onready var rain_manager: RainManager = $RainManager
@onready var rain_button: Button = $RainButton
@onready var damage_button: Button = $DamageButton
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var texture_progress_bar: TextureProgressBar = $TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.42, 0, 0.63))

	if rain_manager:
		rain_manager.intensity = 0.0

	progress_bar.value = player.current_health
	progress_bar.max_value = player.max_health

	texture_progress_bar.value = player.current_health
	texture_progress_bar.max_value = player.max_health


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if player and player.get_node("Camera2D"):
		var camera: PlayerCamera = player.get_node("Camera2D")
		camera.configure_shake(Utils.ShakeType.EXPLOSION)
		camera.add_trauma(0.6)


func _on_rain_button_pressed() -> void:
	if rain_manager.intensity == 0.0:
		rain_manager.intensity = 1.0
		rain_button.text = "Stop Rain"
	else:
		rain_manager.intensity = 0.0
		rain_button.text = "Start Rain"


func _on_damage_button_pressed() -> void:
	player.take_damage(20)
	progress_bar.value = player.current_health
	texture_progress_bar.value = player.current_health
