class_name BattlerStats
extends Resource

enum BattlerType {
	PLAYER,
	ENEMY,
}

@export var name: String:
	set(value):
		name = value
		resource_name = name
@export var type: BattlerType
@export var max_hp: int:
	set(value):
		max_hp = value
		emit_changed()
