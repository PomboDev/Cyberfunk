extends Area2D
class_name HurtboxComponent

signal hit(hitbox: HitboxComponent)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is HitboxComponent:
		hit.emit(area)
