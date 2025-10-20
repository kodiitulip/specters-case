class_name OverlayInteractableArea2D
extends InteractableArea2D

@export var overlay_scene: PackedScene


func on_interact_started() -> void:
	assert(overlay_scene != null, "[code]overlay_scene[/code] must not be null")
	var overlay: Node = overlay_scene.instantiate()
	OverlayLayer.change_overlay_to(overlay)


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
