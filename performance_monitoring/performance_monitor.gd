class_name PerformanceMonitor extends CanvasLayer

@onready var stats_container: PanelContainer = $StatsContainer
@onready var fps_label: Label = $StatsContainer/StatsDisplay/FPSLabel
@onready var memory_label: Label = $StatsContainer/StatsDisplay/MemoryLabel
@onready var objects_label: Label = $StatsContainer/StatsDisplay/ObjectsLabel
@onready var draw_label: Label = $StatsContainer/StatsDisplay/DrawLabel


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	fps_label.text = (
		"FPS: %.1f (Process: %.2f ms)"
		% [
			Performance.get_monitor(Performance.TIME_FPS),
			Performance.get_monitor(Performance.TIME_PROCESS) * 1000
		]
	)

	memory_label.text = (
		"Memory: %s" % _format_memory(Performance.get_monitor(Performance.MEMORY_STATIC))
	)

	objects_label.text = (
		"Objects: %d | Nodes: %d | Resources: %d"
		% [
			Performance.get_monitor(Performance.OBJECT_COUNT),
			Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
			Performance.get_monitor(Performance.OBJECT_RESOURCE_COUNT)
		]
	)

	draw_label.text = (
		"Draw calls: %d" % Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	)


func _format_memory(bytes: float) -> String:
	if bytes < 1024:
		return "%d B" % bytes
	elif bytes < 1024 * 1024:
		return "%.1f KB" % (bytes / 1024)
	else:
		return "%.1f MB" % (bytes / (1024 * 1024))


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_performance"):
		stats_container.visible = not stats_container.visible
