class_name BattlerStats
extends Resource

enum BattlerType {
	PLAYER,
	ENEMY,
}

@export var type: BattlerType
@export var max_hp: int

var current_hp: int:
	set(value):
		current_hp = value
		emit_changed()


func _init() -> void:
	_setup.call_deferred()


func _setup() -> void:
	current_hp = max_hp
