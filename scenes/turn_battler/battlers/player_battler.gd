@tool
class_name PlayerBattler extends Battler

@onready var health_bar: TextureProgressBar = $HealthBar

func attack(enemy_target: Battler) -> void:
	await get_tree().create_timer(0.6).timeout
	enemy_target.be_damaged(_get_attack_damage())
	await get_tree().create_timer(0.6).timeout
	turn_ended.emit()


func heal_self() -> void:
	current_hp += _get_heal_amount()
	turn_ended.emit()


func _get_heal_amount() -> int:
	return randi_range(stats.min_damage, stats.max_damage)



func _ready() -> void:
	super._ready()
	health_bar.value = current_hp
	health_bar.max_value = stats.max_hp


func _set_current_hp(value: int) -> void:
	super._set_current_hp(value)
	if not health_bar:
		return
	health_bar.value = current_hp
