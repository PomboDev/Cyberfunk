extends Area2D
class_name Watchbox

signal on_watch_entered(body: Node2D)
signal on_watch_exited(body: Node2D)

@export var groups: Array[StringName] = []

func _ready() -> void:
	body_entered.connect(_entered_watchbox)
	body_exited.connect(_exited_watchbox)

func _entered_watchbox(body: Node2D):
	for group in groups:
		if body.is_in_group(group):
			on_watch_entered.emit(body)

func _exited_watchbox(body: Node2D):
	for group in groups:
		if body.is_in_group(group):
			on_watch_exited.emit(body)
