extends Sprite2D

@export var max_stretch_width: float = 1.5
@export var min_stretch_height: float = 0.7


func start_fade(lifetime: float) -> void:
	var tween = create_tween()

	tween.parallel().tween_property(
		self, "scale", Vector2(max_stretch_width, min_stretch_height), lifetime
	)
	tween.parallel().tween_property(self, "modulate:a", 0.0, lifetime)
	tween.tween_callback(queue_free)
