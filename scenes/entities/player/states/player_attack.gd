class_name PlayerAttack
extends State

var attack_timer: float = 0.0

func enter():
	owner.animation_player.play("attack")
	attack_timer = owner.attack_duration
	owner.perform_attack()

func update(delta):
	attack_timer -= delta
	if attack_timer <= 0:
		if owner.is_on_floor():
			state_machine.change_state("Idle")
		else:
			state_machine.change_state("Fall")

func physics_update(delta):
	owner.velocity.x = 0
	owner.velocity.y += owner.gravity * delta
	owner.move_and_slide()