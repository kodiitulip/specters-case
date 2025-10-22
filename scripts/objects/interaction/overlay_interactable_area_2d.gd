class_name OverlayInteractableArea2D
extends InteractableArea2D
## OverlayInteractableArea2D
##
## This [InteractableArea2D] allows an Item to open an overlay on the users
## screen. The scene file for the overlay must be set!

## The scene used to instanciate the overlay
@export var overlay_scene: PackedScene

## Called the first frame that the interaction starts
func on_interact_started() -> void:
	assert(overlay_scene != null, "[code]overlay_scene[/code] must not be null")
	var overlay: Node = overlay_scene.instantiate()
	OverlayLayer.change_overlay_to(overlay)

## Called for every frame that the interaction is happening
func on_interacting() -> void:
	pass


## Called on the last frame that the interaction happens
func on_interact_ended() -> void:
	pass
