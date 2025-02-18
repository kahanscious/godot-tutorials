extends CharacterBody2D

@export var speed: float = 100.0
@onready var animation_tree: AnimationTree = $AnimationTree
@onready
var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")


func _physics_process(_delta: float) -> void:
	var input_dir = Vector2.ZERO
	input_dir.x = Input.get_axis("left", "right")
	input_dir.y = Input.get_axis("up", "down")

	if input_dir != Vector2.ZERO:
		input_dir = input_dir.normalized()
		# Update both blend positions to maintain direction
		animation_tree.set("parameters/Walk/blend_position", input_dir)
		animation_tree.set("parameters/Idle/blend_position", input_dir)
		state_machine.travel("Walk")
	else:
		state_machine.travel("Idle")

	velocity = input_dir * speed
	move_and_slide()
