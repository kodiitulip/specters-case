extends Node

signal mouse_busy(busy: bool)

func emit_mouse_busy(busy: bool) -> void:
	mouse_busy.emit(busy)
