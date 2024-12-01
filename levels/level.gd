class_name Level extends Node2D

@onready var button: Button = $Button
@onready var player: Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.42, 0, 0.63))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	if player and player.get_node("Camera2D"):
		var camera: PlayerCamera = player.get_node("Camera2D")
		camera.configure_shake(Utils.ShakeType.EXPLOSION)
		camera.add_trauma(0.6)
