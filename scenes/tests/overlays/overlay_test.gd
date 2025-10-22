extends Control

func close_overlay() -> void:
	OverlayLayer.unload_current_overlay()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"escape"):
		get_viewport().set_input_as_handled()
		close_overlay()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_mouse_button"):
		get_viewport().set_input_as_handled()
		close_overlay()


func _on_button_pressed() -> void:
	close_overlay()
