extends GutTest

var Hero = preload("res://unit_testing/hero.gd")
var hero: Hero


func before_each() -> void:
	hero = Hero.new()
	add_child(hero)
	await get_tree().process_frame


func after_each() -> void:
	hero.queue_redraw()


func test_initial_health() -> void:
	assert_eq(hero.health, hero.max_health, "Hero should start with full health.")


func test_take_damage() -> void:
	hero.take_damage(30)
	assert_eq(hero.health, 70, "Health should be reduced by damage amount")


func test_heal() -> void:
	hero.take_damage(50)
	hero.heal(20)
	assert_eq(hero.health, 70, "Health should increase by heal amount")


func test_damage_wrong() -> void:
	hero.take_damage(30)
	assert_eq(hero.health, 80, "This test will fail - wrong damage calculation")


func test_healing_overflow() -> void:
	hero.heal(150)
	assert_eq(hero.health, 150, "This test will fail - trying to heal beyond max")
