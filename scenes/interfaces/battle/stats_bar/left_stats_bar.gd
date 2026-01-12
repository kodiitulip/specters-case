class_name StatsBar
extends PanelContainer

@export var battler: Battler
@export var name_label: Label
@export var progress_bar: ProgressBar
@export var hp_label: Label


func _ready() -> void:
	assert(battler != null)
	progress_bar.set_indeterminate(false)
	battler.stats.changed.connect(_on_stats_changed)
	battler.current_hp_changed.connect(_on_stats_changed)
	_on_stats_changed.call_deferred()


func _on_stats_changed() -> void:
	name_label.set_text(battler.stats.name)
	hp_label.set_text("%s / %s" % [battler.current_hp, battler.stats.max_hp])
	
	progress_bar.set_max(battler.stats.max_hp)
	progress_bar.set_value(battler.current_hp)
