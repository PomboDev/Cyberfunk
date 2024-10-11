extends Camera2D

@export var target : Player
@export var sensitivity := 0.1

@onready var player : CharacterBody2D = get_owner()


func _physics_process(delta: float) -> void:
	if player.velocity:
		position = position.round()