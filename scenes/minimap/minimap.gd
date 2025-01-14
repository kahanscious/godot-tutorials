extends CanvasLayer

@onready var sub_viewport_container: SubViewportContainer = $UI/MarginContainer/SubViewportContainer
@onready var sub_viewport: SubViewport = $UI/MarginContainer/SubViewportContainer/SubViewport
@onready
var minimap_camera: Camera2D = $UI/MarginContainer/SubViewportContainer/SubViewport/MinimapCamera
@onready
var player_marker: ColorRect = $UI/MarginContainer/SubViewportContainer/SubViewport/PlayerMarker

var player_node: Node2D


func _ready() -> void:
	for tilemap in owner.get_node("TileMaps").get_children():
		var minimap_tilemap = tilemap.duplicate()
		setup_minimap(minimap_tilemap)

		if tilemap.name == "Ground":
			var used_rect: Rect2i = tilemap.get_used_rect()
			set_minimap_limits(used_rect)


func _process(delta: float) -> void:
	if player_node:
		minimap_camera.global_position = lerp(
			minimap_camera.global_position, player_node.global_position, 0.2
		)
		player_marker.global_position = player_node.global_position


func setup_minimap(minimap_tilemap: TileMapLayer) -> void:
	sub_viewport.add_child(minimap_tilemap)


func set_minimap_limits(used_rect: Rect2i) -> void:
	minimap_camera.limit_left = used_rect.position.x * 16
	minimap_camera.limit_top = used_rect.position.y * 16
	minimap_camera.limit_right = (used_rect.position.x + used_rect.size.x) * 16
	minimap_camera.limit_bottom = (used_rect.position.y + used_rect.size.y) * 16
