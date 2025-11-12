class_name Battler
extends Node2D

@export var stats: BattlerStats

var current_hp: int

signal dead()
signal turn_ended()

func _ready() -> void:
	stop_turn()
	
	current_hp = stats.max_hp


func start_turn() -> void:
	pass


func stop_turn() -> void:
	pass


func attack(enemy_target: Battler) -> void:
	enemy_target.be_damaged(_get_attack_damage())
	await get_tree().create_timer(0.6).timeout
	turn_ended.emit()


func be_damaged(damage: int) -> void:
	current_hp -= damage
	if current_hp <= 0:
		current_hp = 0
		dead.emit()


func _get_attack_damage() -> int:
	return randi_range(stats.min_damage, stats.max_damage)
