class_name PlayerFall
extends State

func enter():
	owner.animation_player.play("Fall")

func physics_update(delta):
	var input_dir: float = Input.get_axis("move_left", "move_right")
	owner.velocity.x = input_dir * owner.move_speed
	owner.sprite.flip_h = input_dir < 0
	owner.velocity.y += owner.gravity * delta
	owner.velocity.y = min(owner.velocity.y, owner.max_fall_speed)
	owner.move_and_slide()

	if owner.is_on_floor():
		if input_dir != 0:
			state_machine.change_state("Run")
		else:
			state_machine.change_state("Idle")
	elif owner.is_on_wall() and input_dir != 0:
		state_machine.change_state("WallSlide")
