class_name PlayerFall
extends State

func enter():
	owner.animation_player.play("Fall")

func physics_update(delta):
	owner.process_movement(delta)

	if owner.is_on_floor():
		if owner.input_dir != 0:
			state_machine.change_state("Run")
		else:
			state_machine.change_state("Idle")
	elif owner.is_on_wall() and owner.input_dir != 0:
		state_machine.change_state("WallSlide")
