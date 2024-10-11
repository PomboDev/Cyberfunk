extends CharacterBody2D

const SPEED = 300.0

func _physics_process(_delta: float) -> void:
	var horizontal := Input.get_axis("move_left", "move_right")
	if horizontal:
		velocity.x = horizontal * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
