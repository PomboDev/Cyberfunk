class_name PlayerIdle
extends State

func enter():
	owner.animation_player.play("Idle")
	owner.velocity.x = 0

func update(_delta):
	if Input.is_action_pressed("move_right") or Input.is_action_pressed("move_left"):
		state_machine.change_state("Run")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack")
	elif not owner.is_on_floor():
		state_machine.change_state("Fall")
