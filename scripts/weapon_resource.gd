@tool
extends Resource
class_name WeaponResource

enum WeaponType {
	MELEE,
	PROJECTILE
}

@export var name: String
@export var weapon_type: WeaponType:
	set(type):
		if type == weapon_type: return
		weapon_type = type
		notify_property_list_changed()

@export var animation: String
@export var damage: int
@export var attack_speed: float

var projectile_scene: PackedScene
var projectile_speed: float

var hitbox_size: Vector2
var attack_angle: float

func _get_property_list():
	if Engine.is_editor_hint():
		var ret = []
		
		match weapon_type:
			WeaponType.MELEE:
				pass
			WeaponType.PROJECTILE:
				ret.append({
					"name": &"projectile_scene",
					"type": TYPE_OBJECT,
					"hint": PROPERTY_HINT_RESOURCE_TYPE,
					"hint_string": "PackedScene",
					"usage": PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_SCRIPT_VARIABLE
				})
		
		return ret
