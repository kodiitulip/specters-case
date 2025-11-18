extends Node

signal mouse_busy(busy: bool)
signal new_player_path_goal_sent(pos: Vector2)
signal player_path_goal_reached()
#
#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action(&"escape"):
		#get_tree().quit()


func emit_mouse_busy(busy: bool) -> void:
	mouse_busy.emit(busy)


func emit_player_path_goal_reached() -> void:
	player_path_goal_reached.emit()


func send_new_position_to_player(global_pos: Vector2) -> void:
	mouse_busy.emit(true)
	new_player_path_goal_sent.emit(global_pos)
