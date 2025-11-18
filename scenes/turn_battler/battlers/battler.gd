@tool
@abstract class_name Battler
extends Node2D

signal dead()
@warning_ignore("unused_signal")
signal turn_ended()

@export var mirrored: bool = false:
	set(v):
		mirrored = v
		await ready
		sprite.flip_h = mirrored
@export var stats: BattlerStats
@export var current_hp: int: set = _set_current_hp

@export var sprite: AnimatedSprite2D

func _ready() -> void:
	current_hp = stats.max_hp


func end_turn() -> void:
	turn_ended.emit()


func be_damaged(damage: int) -> void:
	current_hp -= damage
	if current_hp <= 0:
		current_hp = 0
		dead.emit()


func heal_self(amount: int) -> void:
	current_hp += amount


func _set_current_hp(value: int) -> void:
	current_hp = value
