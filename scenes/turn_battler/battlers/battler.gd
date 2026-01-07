@tool
class_name Battler
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

@export var sprite: AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func end_turn() -> void:
	turn_ended.emit()


func be_damaged(damage: int) -> void:
	stats.current_hp -= damage
	animation_player.play(&"battle/hit_flipped" if mirrored else &"battle/hit")
	if stats.current_hp <= 0:
		stats.current_hp = 0
		dead.emit()


func heal_self(amount: int) -> void:
	stats.current_hp += amount
	animation_player.play(&"battle/heal")
