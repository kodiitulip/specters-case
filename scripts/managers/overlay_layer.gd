extends CanvasLayer

var current_overlay: Node


func _enter_tree() -> void:
	layer = 10


func unload_current_overlay() -> void:
	remove_child(current_overlay)
	current_overlay.queue_free()
	current_overlay = null


func change_overlay_to(new_overlay: Node) -> void:
	if current_overlay:
		self.unload_current_overlay()
	current_overlay = new_overlay
	add_child(current_overlay)
