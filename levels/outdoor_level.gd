class_name OutdoorLevel extends Node2D

@onready var day_night_manager: DayNightManager = $DayNightManager
@onready var time_label: Label = $CanvasLayer/TimeLabel
@onready var top_down_player: TopDownPlayer = $TopDownPlayer
@onready var minimap: CanvasLayer = $Minimap
@onready var cursor_sprite: Sprite2D = $CursorSprite

@export var enable_day_night_cycle: bool = true


func _ready() -> void:
	Input.set_custom_mouse_cursor(cursor_sprite.texture)

	if enable_day_night_cycle:
		_setup_day_night_cycle()
	else:
		day_night_manager.visible = false
		day_night_manager.process_mode = Node.PROCESS_MODE_DISABLED

	if minimap and top_down_player:
		minimap.player_node = top_down_player


func _setup_day_night_cycle() -> void:
	day_night_manager.time_changed.connect(_on_time_changed)


func _on_time_changed(_hour: float, time_string: String) -> void:
	if time_label:
		time_label.text = time_string
