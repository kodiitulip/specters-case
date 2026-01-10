class_name StatsBar
extends PanelContainer

@export var battler: Battler
@export var name_label: Label
@export var progress_bar: ProgressBar
@export var hp_label: Label

var battler_stats: BattlerStats


func _ready() -> void:
	assert(battler != null)
	progress_bar.set_indeterminate(false)
	battler_stats = battler.stats
	battler_stats.changed.connect(_on_stats_changed)
	battler_stats.emit_changed()


func _on_stats_changed() -> void:
	name_label.set_text(battler_stats.resource_name)
	hp_label.set_text("%s / %s" % [battler_stats.current_hp, battler_stats.max_hp])
	
	progress_bar.set_max(battler_stats.max_hp)
	progress_bar.set_value(battler_stats.current_hp)
