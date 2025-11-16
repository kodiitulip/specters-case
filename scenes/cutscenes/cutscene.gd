class_name CutSceneManager extends Node

@export_file("*.tscn") var scene_after: String

var next_shot: bool = false:
	set(v):
		next_shot = v
		await get_tree().create_timer(.1).timeout
		next_shot = false


func _on_intro_letter_closed() -> void:
	next_shot = true


func change_to_world() -> void:
	SceneTransitionManager.transition_to(scene_after)
