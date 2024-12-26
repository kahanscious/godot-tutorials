class_name Hero extends Sprite2D

var health: int = 100
var max_health: int = 100


func take_damage(amount: int) -> void:
	health = max(0, health - amount)


func heal(amount: int) -> void:
	health = min(max_health, health + amount)


func is_alive() -> bool:
	return health > 0
