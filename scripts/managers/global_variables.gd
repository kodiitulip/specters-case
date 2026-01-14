class_name AbstractGlobalVariables
extends Node

var tutorial_ended: bool = false

var player_last_position: Vector2

var started_front_desk_battle: bool = false
var front_desk_ghost_defeated: bool = false

var water_off: bool = false

func _ready() -> void:
	var b: bool = OS.is_debug_build()
	Dialogic.VAR.set_variable("debug", b)
