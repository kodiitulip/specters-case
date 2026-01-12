@tool
class_name EnemyBattler extends Battler

@export var actions: Array[BattleAction] = []

@onready var health_bar: ProgressBar = $HealthBar


func _ready() -> void:
	super._ready()
	assert(self.stats != null)
	health_bar.set_indeterminate(false)
	current_hp_changed.connect(_on_stats_changed)
	stats.changed.connect(_on_stats_changed)
	_on_stats_changed.call_deferred()


func _on_stats_changed() -> void:
	health_bar.set_max(self.stats.max_hp)
	health_bar.set_value(current_hp)
