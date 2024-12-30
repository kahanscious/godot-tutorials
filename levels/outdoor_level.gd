class_name OutdoorLevel extends Node2D

@onready var day_night_manager: DayNightManager = $DayNightManager
@onready var time_label: Label = $TimeLabel

@export var enable_day_night_cycle: bool = false


func _ready() -> void:
	if enable_day_night_cycle:
		_setup_day_night_cycle()
	else:
		day_night_manager.visible = false
		day_night_manager.process_mode = Node.PROCESS_MODE_DISABLED


func _setup_day_night_cycle() -> void:
	day_night_manager.time_changed.connect(_on_time_changed)


func _on_time_changed(_hour: float, time_string: String) -> void:
	if time_label:
		time_label.text = time_string
