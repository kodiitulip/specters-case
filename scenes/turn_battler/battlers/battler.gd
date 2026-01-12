@tool
class_name Battler
extends Node2D

signal dead()
signal turn_ended()
signal current_hp_changed()

@export var mirrored: bool = false:
	set(v):
		mirrored = v
		await ready
		sprite.flip_h = mirrored
@export var stats: BattlerStats

@export var sprite: AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var current_hp: int: set = set_current_hp


func _ready() -> void:
	current_hp = stats.max_hp


func end_turn() -> void:
	turn_ended.emit()


func be_damaged(damage: int) -> void:
	current_hp -= damage
	animation_player.play(&"battle/hit_flipped" if mirrored else &"battle/hit")
	if current_hp <= 0:
		current_hp = 0
		dead.emit()


func heal_self(amount: int) -> void:
	current_hp += amount
	animation_player.play(&"battle/heal")


func set_current_hp(value: int) -> void:
	current_hp = clampi(value, 0, stats.max_hp if stats else value)
	current_hp_changed.emit()
