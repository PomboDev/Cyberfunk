extends Node
class_name HealthComponent

signal on_death()
signal health_changed(health: int)

@export var _max_health: int = 100
@onready var _health: int = _max_health

var max_health: int = _max_health:
	get: return _max_health
	set(val):
		if val > _max_health:
			_max_health = val
			heal(val - _max_health)
		else:
			_max_health = val
	
		health_changed.emit(_health)

var health: int = _health:
	get: return _health
	set(val):
		var old_health: int = _health
		_health = clamp(val, 0, _max_health)
		
		if old_health != _health:
			health_changed.emit(_health)

var is_alive: bool:
	get: return _health > 0

func damage(amount: int) -> void:
	_health = clamp(_health - amount, 0, _max_health)
	health_changed.emit(_health)

	if _health <= 0:
		on_death.emit()

func heal(amount: int) -> void:
	_health = clamp(_health + amount, 0, _max_health)
	health_changed.emit(_health)
