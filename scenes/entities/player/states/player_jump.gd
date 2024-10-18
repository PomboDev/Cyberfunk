class_name PlayerJump
extends State

func enter():
	owner.animation_player.play("Jump")
	owner.velocity.y = -owner.jump_force

func physics_update(delta):
	var input_dir: float = Input.get_axis("move_left", "move_right")
	owner.velocity.x = input_dir * owner.move_speed
	owner.sprite.flip_h = input_dir < 0
	owner.velocity.y += owner.gravity * delta
	owner.velocity.y = min(owner.velocity.y, owner.max_fall_speed)
	owner.move_and_slide()

	if owner.velocity.y > 0:
		state_machine.change_state("Fall")
	elif owner.is_on_wall() and input_dir != 0:
		state_machine.change_state("WallSlide")

func handle_input(event):
	if event.is_action_released("jump") and owner.velocity.y < 0:
		owner.velocity.y *= 0.5