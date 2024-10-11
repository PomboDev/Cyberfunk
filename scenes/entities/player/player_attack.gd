extends Node

@export var animation_player : AnimatedSprite2D
@onready var player : CharacterBody2D = get_owner()

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_pressed("jump"):
		print("Attacking")
