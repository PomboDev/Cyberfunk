class_name PlayerWallSlide
extends State

func enter():
	owner.animation_player.play("WallSlide")

func physics_update(delta):
	var input_dir: float = Input.get_axis("move_left", "move_right")
	owner.velocity.x = input_dir * owner.move_speed
	owner.velocity.y = min(owner.velocity.y + owner.gravity * delta, owner.wall_slide_speed)
	owner.sprite.flip_h = owner.get_wall_normal().x > 0
	owner.move_and_slide()

	if not owner.is_on_wall() or owner.is_on_floor():
		state_machine.change_state("Fall")
	elif Input.is_action_just_pressed("jump"):
		state_machine.change_state("WallJump")