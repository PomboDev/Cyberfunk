extends Area2D

@export var reset_delay : float = 1.0
@export var fade_color : Color = Color.BLACK
@onready var current_scene = get_tree().current_scene
@onready var fade: ColorRect = $"../Player/ColorRect"
@onready var sprite: Sprite2D = $"../Player/Sprite2D"

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_process(false)
		body.set_physics_process(false)

		fade.color = fade_color
		fade.modulate.a = 0

		get_tree().create_tween().tween_property(sprite, "modulate:a", 0.0, 0.5)
		get_tree().create_timer(reset_delay).timeout.connect(_reset_scene)

func _reset_scene():
	get_tree().reload_current_scene()
