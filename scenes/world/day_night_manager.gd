class_name DayNightManager extends Node2D

signal time_changed(current_hour: float, time_string: String)

@onready var canvas_modulate: CanvasModulate = $CanvasModulate

@export_group("Time Settings")
@export var day_duration: float = 15.0
@export var starting_hour: float = 8.0
@export_range(0, 23) var sunrise_hour: int = 6
@export_range(0, 23) var sunset_hour: int = 19

@export_group("Color Settings")
@export var day_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var night_color: Color = Color(0.4, 0.4, 0.7, 1.0)
@export var sunset_color: Color = Color(0.84, 0.58, 0.28, 1.0)
@export var sunrise_color: Color = Color(0.86, 0.70, 0.70, 1.0)

var elapsed_time: float = 0.0
var current_hour: float = 0.0


func _ready() -> void:
	current_hour = starting_hour
	_update_world_color()
	time_changed.emit(current_hour, get_time_string())


func _process(delta: float) -> void:
	elapsed_time += delta

	current_hour = fmod(starting_hour + (elapsed_time * 24.0 / day_duration), 24.0)
	_update_world_color()
	time_changed.emit(current_hour, get_time_string())


func _update_world_color() -> void:
	var target_color: Color

	if current_hour >= sunrise_hour and current_hour < sunrise_hour + 2:
		var t = (current_hour - sunrise_hour) / 2
		target_color = night_color.lerp(sunrise_color, t)

	elif current_hour >= sunrise_hour + 2 and current_hour < sunrise_hour + 4:
		var t = (current_hour - (sunrise_hour + 2)) / 2
		target_color = sunrise_color.lerp(day_color, t)

	elif current_hour >= sunrise_hour + 4 and current_hour < sunset_hour - 2:
		target_color = day_color

	elif current_hour >= sunset_hour - 2 and current_hour < sunset_hour:
		var t = (current_hour - (sunset_hour - 2)) / 2
		target_color = day_color.lerp(sunrise_color, t)

	elif current_hour >= sunset_hour and current_hour < sunset_hour + 2:
		var t = (current_hour - sunset_hour) / 2
		target_color = sunset_color.lerp(night_color, t)

	else:
		target_color = night_color

	canvas_modulate.color = target_color


func get_time_string() -> String:
	var hour := floori(current_hour)
	var minute := floori((current_hour - hour) * 60)
	var ampm := "AM" if hour < 12 else "PM"

	if hour == 0:
		hour = 12
	elif hour > 12:
		hour -= 12

	return "%d:%02d %s" % [hour, minute, ampm]


func pause_cycle() -> void:
	set_process(false)


func resume_cycle() -> void:
	set_process(true)


func set_time(hour: float) -> void:
	current_hour = hour
	_update_world_color()
	time_changed.emit(current_hour, get_time_string())
