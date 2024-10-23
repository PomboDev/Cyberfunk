class_name PlayerRun
extends State

func enter():
	owner.animation_player.play("Run")

func physics_update(_delta):
	var input_dir: float = Input.get_axis("move_left", "move_right")
	owner.velocity.x = input_dir * owner.move_speed
	owner.sprite.flip_h = input_dir < 0
	owner.move_and_slide()

	if input_dir == 0:
		state_machine.change_state("Idle")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state("Jump")
	elif Input.is_action_just_pressed("attack"):
		state_machine.change_state("Attack")
	elif not owner.is_on_floor():
		state_machine.change_state("Fall")
