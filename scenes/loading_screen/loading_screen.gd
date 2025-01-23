extends CanvasLayer

signal scene_loaded

@onready var dots_timer: Timer = $DotsTimer
@onready var loading_text: Label = $LoadingText

var dots_count: int = 0
var scene_path: String = ""
var loading_status: int = 0
var scene_ready_to_load: bool = false
var loaded_scene: PackedScene
var artificial_delay_timer: Timer


func _ready() -> void:
	# Hide initially
	hide()
	set_process(false)

	# Setup timers
	dots_timer.timeout.connect(_on_dots_timer_timeout)

	# Setup artificial delay timer
	artificial_delay_timer = Timer.new()
	artificial_delay_timer.wait_time = 5.0
	artificial_delay_timer.one_shot = true
	artificial_delay_timer.timeout.connect(_on_artificial_delay_timeout)
	add_child(artificial_delay_timer)


func start_loading(path: String) -> void:
	# Store the scene path
	scene_path = path

	# Show the loading screen
	show()
	set_process(true)
	dots_timer.start()

	# Reset loading text
	loading_text.text = "loading"

	# Start loading the target scene in the background
	ResourceLoader.load_threaded_request(scene_path)

	# Start artificial delay
	artificial_delay_timer.start()


func _process(_delta: float) -> void:
	loading_status = ResourceLoader.load_threaded_get_status(scene_path)

	match loading_status:
		ResourceLoader.THREAD_LOAD_LOADED:
			_on_scene_loaded()
		ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Scene loading failed!")


func _on_dots_timer_timeout() -> void:
	dots_count = (dots_count + 1) % 4
	var dots = ""
	match dots_count:
		0:
			dots = ""
		1:
			dots = "."
		2:
			dots = ".."
		3:
			dots = "..."
	loading_text.text = "loading" + dots


func _on_scene_loaded() -> void:
	# Store the loaded scene
	loaded_scene = ResourceLoader.load_threaded_get(scene_path)
	scene_ready_to_load = true

	# Wait for artificial delay if still running
	if artificial_delay_timer.time_left > 0:
		return

	_change_scene()


func _on_artificial_delay_timeout() -> void:
	if scene_ready_to_load:
		_change_scene()


func _change_scene() -> void:
	# Stop animations
	set_process(false)
	dots_timer.stop()
	artificial_delay_timer.stop()

	# Change scene
	var tree = get_tree()
	var current_scene = tree.current_scene
	var scene_instance = loaded_scene.instantiate()
	tree.root.add_child(scene_instance)
	tree.current_scene = scene_instance

	# Cleanup old scene
	current_scene.queue_free()
	hide()

	# Reset variables
	scene_path = ""
	scene_ready_to_load = false
	loaded_scene = null

	# Emit completion signal
	scene_loaded.emit()
