extends Node

@export var animation_player : AnimatedSprite2D

@export var SPEED := 300.0
@export var JUMP_STRENGTH := -100.0
@export var JUMP_DAMPENING := 0.8

@onready var player : CharacterBody2D = get_owner()
@onready var jump_force = JUMP_STRENGTH

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	var velocity = player.velocity
	
	if not player.is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("jump"):
		velocity.y += jump_force
		jump_force *= JUMP_DAMPENING
	elif player.is_on_floor():
		jump_force = JUMP_STRENGTH

	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	player.velocity = velocity
	player.move_and_slide()
