class_name PlayerCamera extends Camera2D

@export var tile_map: TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_camera_limits(tile_map.get_used_rect())


func setup_camera_limits(used_rect: Rect2i):
	limit_left = used_rect.position.x
	limit_right = (used_rect.position.x + used_rect.size.x) * 16
	limit_bottom = (used_rect.position.y + used_rect.size.y) * 16
