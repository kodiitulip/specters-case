extends Control


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"left_mouse_button"):
		queue_free()
