extends ColorRect

@export_file("*.tscn") var intro_scene: String

func _ready() -> void:
	await get_tree().create_timer(1.0).timeout
	Dialogic.start("ending_demo")
	await Dialogic.timeline_ended
	SceneTransitionManager.transition_to(intro_scene)
