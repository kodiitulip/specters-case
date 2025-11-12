class_name DialogInteractableArea2D
extends InteractableArea2D

@export var dialog: DialogicTimeline


func on_interact_started() -> void:
	Dialogic.start(dialog)


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
