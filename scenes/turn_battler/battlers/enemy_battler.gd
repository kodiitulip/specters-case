@tool
class_name EnemyBattler extends Battler

@export var actions: Array[BattleAction] = []

@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	assert(self.stats != null)
	health_bar.set_indeterminate(false)
	self.stats.changed.connect(_on_stats_changed)


func _on_stats_changed() -> void:
	health_bar.set_max(self.stats.max_hp)
	health_bar.set_value(self.stats.current_hp)
