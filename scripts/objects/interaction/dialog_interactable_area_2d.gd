class_name DialogInteractableArea2D
extends InteractableArea2D

@export var dialog: String


func on_interact_started() -> void:
	Dialogic.start("res://dialogic/ghost/errante.dtl")


func on_interacting() -> void:
	pass


func on_interact_ended() -> void:
	pass
