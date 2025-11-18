@tool
class_name EnemyBattler extends Battler

@onready var health_bar: TextureProgressBar = $HealthBar
@export var actions: Array[BattleAction] = []

func _ready() -> void:
	super._ready()
	health_bar.value = current_hp
	health_bar.max_value = stats.max_hp


func _set_current_hp(value: int) -> void:
	super._set_current_hp(value)
	if not health_bar:
		return
	health_bar.value = current_hp
