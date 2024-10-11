extends Node
class_name VelocityComponent

@export var inital_velocity: Vector2 = Vector2()
@export var SPEED: float = 300.0

var _velocity: Vector2 = Vector2.ZERO

func _ready() -> void:
	_velocity = inital_velocity

func set_velocity(velocity: Vector2) -> void:
	_velocity = velocity

func change_velocity(by: Vector2) -> void:
	_velocity += by

func get_velocity() -> Vector2:
	return _velocity

func set_direction(direction: Vector2) -> void:
	_velocity = direction.normalized() * SPEED
