class_name DialogInteractableArea2D
extends InteractableArea2D

@export var dialog: DialogicTimeline
@export var interact_position_marker: Marker2D

@export_group("Battle Scene", "battle_scene_")
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "") var battle_scene_enable: bool = false
@export_file("*.tscn") var battle_scene_file: String

func _ready() -> void:
	super._ready()
	if not battle_scene_enable:
		return
	GlobalSignalBus.battle_dialog_ended.connect(func() -> void:
		SceneTransitionManager.transition_to(battle_scene_file))


func on_interact_started() -> void:
	var pos: Vector2 = (interact_position_marker.global_position
		if interact_position_marker else global_position)
	GlobalSignalBus.send_new_position_to_player(pos)
	await GlobalSignalBus.player_path_goal_reached
	if not dialog: return
	Dialogic.start(dialog)


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
