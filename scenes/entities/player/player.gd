class_name Player
extends CharacterBody2D

## Movement Variables
@export var move_speed: float = 350.0 :
	get:
		if is_dash_boosting:
			return move_speed * 1.6
		else:
			return move_speed

@export var gravity: float = 2000.0
@export var max_fall_speed: float = 1500.0

## Jump Variables
@export var jump_force: float = 650.0
@export var can_jump: bool = true
@export var ground_time: float = 0.0
@export var wall_time: float = 0.0
@export var coyote_time: float = 0.2
@export var wall_coyote_time: float = 0.2

## Wall Movement
@export var wall_slide_speed: float = 100.0
@export var wall_jump_force: Vector2 = Vector2(250, -650)
@export var wall_jump_duration: float = 0.2
var is_wall_jumping: bool = false
var wall_jump_timer: float = 0.0
var wall_direction: int = 0
var last_wall_direction: int = 0
var was_on_wall: bool = false

## Dash Variables
@export var dash_speed: float = 600.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 0.4
var can_dash: bool = true
var is_dashing: bool = false
var is_dash_boosting: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: int = 0

## References
@export var sprite: Sprite2D
@export var animation_player: AnimationPlayer

var input_dir: float 		  = 0.0
var dash_input_pressed: bool  = false
var was_on_floor: bool        = false
var ghost_effect: PackedScene = preload("res://scenes/entities/player/ghost_effect.tscn")
var ghost_timer: Timer 		  = Timer.new()

func is_running_against_wall() -> bool:
	if is_on_wall():
		var wall_normal: Vector2 = get_wall_normal()
		return (wall_normal.x > 0 and input_dir < 0) or (wall_normal.x < 0 and input_dir > 0)
	return false

func _ready():
	add_child(ghost_timer)
	ghost_timer.one_shot = false
	ghost_timer.wait_time = 0.03
	ghost_timer.timeout.connect(instance_ghost)
	
func _physics_process(delta: float) -> void:
	handle_input()
	
	apply_gravity(delta)
	handle_movement(delta)
	handle_wall_movement(delta)
	handle_dash(delta)
	update_timers(delta)
	
	move_and_slide()
	
	update_animation()
	check_landing()
	update_coyote_time(delta)

func handle_input() -> void:
	input_dir = Input.get_axis("move_left", "move_right")
	dash_input_pressed = Input.is_action_pressed("dash")

	if Input.is_action_just_pressed("jump"):
		if can_ground_jump() or can_wall_jump():
			jump()

	if Input.is_action_just_pressed("dash") and can_dash and input_dir != 0:
		start_dash()

func can_ground_jump() -> bool:
	return is_on_floor() or ground_time < coyote_time

func can_wall_jump() -> bool:
	return (is_running_against_wall() or wall_time < wall_coyote_time) and last_wall_direction != 0

func update_coyote_time(delta: float) -> void:
	if is_on_floor():
		ground_time = 0
	else:
		ground_time += delta

	if is_running_against_wall():
		wall_time = 0
		last_wall_direction = wall_direction
	else:
		wall_time += delta

func apply_gravity(delta: float) -> void:
	if not is_on_floor() and not is_dashing:
		velocity.y += gravity * delta
		velocity.y = min(velocity.y, max_fall_speed)

func handle_movement(_delta: float) -> void:
	if not is_dashing and not is_wall_jumping:
		if input_dir != 0:
			velocity.x = input_dir * move_speed
		else:
			velocity.x = 0

	if input_dir != 0 and not is_wall_jumping:
		sprite.flip_h = input_dir < 0

func handle_wall_movement(_delta: float) -> void:
	if is_running_against_wall() and not is_on_floor():
		sprite.position = Vector2(20 * -last_wall_direction, 0)
		velocity.y = min(velocity.y, wall_slide_speed)
		wall_direction = -round(get_wall_normal().x)
		sprite.flip_h = true if wall_direction > 0 else false
		can_jump = true
	else:
		wall_direction = 0

func handle_dash(delta: float) -> void:
	if is_dashing:
		velocity.x = dash_direction * dash_speed

		move_and_slide()

		if is_on_wall():
			end_dash()
			velocity.x = 0

		dash_timer -= delta
		if dash_timer <= 0:
			end_dash()

	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	else:
		can_dash = true

func start_dash() -> void:
	is_dashing = true
	dash_direction = input_dir
	dash_timer = dash_duration
	can_dash = false
	dash_cooldown_timer = dash_cooldown
	velocity.y = 0
	ghost_timer.start()

func end_dash() -> void:
	is_dashing = false
	velocity.x = dash_direction * move_speed
	ghost_timer.stop()

func jump() -> void:
	if is_dashing:
		end_dash()

	if dash_input_pressed:
		ghost_timer.start()
		is_dash_boosting = true
	else:
		ghost_timer.stop()
		is_dash_boosting = false
	
	if can_wall_jump():
		wall_jump()
	else:
		velocity.y = -jump_force
		can_jump = false

func wall_jump() -> void:
	velocity = wall_jump_force * Vector2(-last_wall_direction, 1)
	wall_jump_timer = wall_jump_duration
	sprite.flip_h = true if -last_wall_direction > 0 else false
	is_wall_jumping = true
	wall_time = wall_coyote_time
	last_wall_direction = 0

	await get_tree().create_timer(wall_jump_duration).timeout
	is_wall_jumping = false

func update_timers(delta: float) -> void:
	if wall_jump_timer > 0:
		wall_jump_timer -= delta

func check_landing() -> void:
	if is_on_floor() and !was_on_floor:
		can_jump = true
		if not is_dashing:
			can_dash = true
		
		if !is_dashing:
			is_dash_boosting = false
			ghost_timer.stop()

	was_on_floor = is_on_floor()

	if is_on_wall():
		is_dash_boosting = false
		ghost_timer.stop()
	
func instance_ghost() -> void:
	var ghost: Sprite2D = ghost_effect.instantiate()
	get_parent().get_parent().add_child(ghost)

	ghost.global_position = global_position
	ghost.texture = sprite.texture
	ghost.vframes = sprite.vframes
	ghost.hframes = sprite.hframes
	ghost.frame = sprite.frame
	ghost.flip_h = sprite.flip_h
	ghost.scale = sprite.scale
	
	
func update_animation() -> void:
	if is_dashing:
		animation_player.play("dash")
	elif not is_on_floor():
		if is_running_against_wall() and is_on_wall():
			animation_player.play("wall_slide")	
		else:
			animation_player.play("jump")
	else:
		if input_dir != 0:
			animation_player.play("run")
		else:
			animation_player.play("idle")
