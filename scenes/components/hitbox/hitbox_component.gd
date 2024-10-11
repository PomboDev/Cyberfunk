extends Area2D
class_name HitboxComponent

@export var damage: int = 1

func set_damage(value: int):
	damage = value
	
func get_damage() -> int:
	return damage
