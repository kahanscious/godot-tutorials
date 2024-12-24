extends GutTest

var TestPlayer = preload("res://unit_testing/player_test.gd")
var player: PlayerTest


func before_each() -> void:
	player = TestPlayer.new()
	add_child(player)
	await get_tree().process_frame


func after_each() -> void:
	player.queue_free()


func test_initial_health() -> void:
	assert_eq(player.health, player.max_health, "Player should start with full health")


func test_take_damage() -> void:
	player.take_damage(30)
	assert_eq(player.health, 70, "Health should be reduced by damage amount")


func test_heal() -> void:
	player.take_damage(50)  # Reduce health first
	player.heal(20)
	assert_eq(player.health, 70, "Health should increase by heal amount")


func test_health_boundaries() -> void:
	# Test minimum health
	player.take_damage(150)
	assert_eq(player.health, 0, "Health should not go below 0")

	# Test maximum health
	player.heal(999)
	assert_eq(player.health, player.max_health, "Health should not exceed max_health")


# Failing tests to demonstrate errors
func test_damage_wrong() -> void:
	player.take_damage(30)
	assert_eq(player.health, 80, "This test will fail - wrong damage calculation")  # Expected 70, not 80


func test_healing_overflow() -> void:
	player.heal(150)
	assert_eq(player.health, 150, "This test will fail - trying to heal beyond max")  # Can't exceed max_health (100)


func test_alive_incorrect() -> void:
	player.take_damage(100)  # Health = 0
	assert_true(player.is_alive(), "This test will fail - dead player isn't alive")  # Should be false
