extends Node

signal mouse_busy(busy: bool)
signal new_player_path_goal_sent(pos: Vector2, set_busy: bool)
signal player_path_goal_reached()
signal battle_dialog_ended()

func emit_mouse_busy(busy: bool) -> void:
	mouse_busy.emit(busy)


func emit_player_path_goal_reached() -> void:
	player_path_goal_reached.emit()


func send_new_position_to_player(global_pos: Vector2, set_busy: bool = false,
		save_position: bool = true) -> void:
	mouse_busy.emit(set_busy)
	new_player_path_goal_sent.emit(global_pos)
	if save_position:
		GlobalVariables.player_last_position = global_pos


func emit_battle_dialog_ended() -> void:
	battle_dialog_ended.emit()
