class_name PlayerWallJump
extends State

func enter():
	owner.animation_player.play("wall_jump")
	owner.velocity = owner.wall_jump_force
	owner.velocity.x *= -owner.get_wall_normal().x

func physics_update(delta):
	owner.velocity.y += owner.gravity * delta
	owner.velocity.y = min(owner.velocity.y, owner.max_fall_speed)
	owner.move_and_slide()

	if owner.is_on_floor():
		state_machine.change_state("Idle")
	elif owner.velocity.y > 0:
		state_machine.change_state("Fall")

func handle_input(event):
	if event.is_action_released("jump") and owner.velocity.y < 0:
		owner.velocity.y *= 0.5