extends CanvasLayer

signal overlay_unloaded()
signal overlay_loaded()

var current_overlay: Node

func _enter_tree() -> void:
	layer = 0


func unload_current_overlay() -> void:
	remove_child(current_overlay)
	current_overlay.queue_free()
	current_overlay = null
	overlay_unloaded.emit()


func change_overlay_to(new_overlay: Node) -> void:
	if current_overlay:
		self.unload_current_overlay()
	current_overlay = new_overlay
	add_child(current_overlay)
	await current_overlay.ready
	overlay_loaded.emit()
