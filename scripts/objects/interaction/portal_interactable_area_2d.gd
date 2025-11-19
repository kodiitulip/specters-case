class_name PortalInteractableArea2D
extends InteractableArea2D

@export_file("*.tscn") var scene_to_teleport_to: String

func on_interact_started() -> void:
	GlobalSignalBus.send_new_position_to_player(global_position)
	await GlobalSignalBus.player_path_goal_reached
	SceneTransitionManager.transition_to(scene_to_teleport_to)


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
