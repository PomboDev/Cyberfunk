class_name Player
extends CharacterBody2D

@export var move_speed: float = 300.0
@export var jump_force: float = 600.0
@export var gravity: float = 1500.0
@export var max_fall_speed: float = 1000.0
@export var wall_slide_speed: float = 100.0
@export var wall_jump_force: Vector2 = Vector2(400, -600)
@export var attack_cooldown: float = 0.5
@export var attack_duration: float = 0.3

@export var state_machine: StateMachine
@export var animation_player: AnimationPlayer
@export var sprite: Sprite2D
