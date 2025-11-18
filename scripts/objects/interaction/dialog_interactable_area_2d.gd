class_name DialogInteractableArea2D
extends InteractableArea2D

@export var dialog: DialogicTimeline


func on_interact_started() -> void:
	GlobalSignalBus.send_new_position_to_player(global_position)
	await GlobalSignalBus.player_path_goal_reached
	Dialogic.start(dialog)


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
