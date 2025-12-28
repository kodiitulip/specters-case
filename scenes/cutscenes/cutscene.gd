class_name CutSceneManager extends Node

@export_file("*.tscn") var scene_after: String

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var quit: Button = %sQuit

var next_shot: bool = false:
	set(v):
		next_shot = v
		await get_tree().create_timer(.1).timeout
		next_shot = false


func _on_intro_letter_closed() -> void:
	Dialogic.start("intro")
	await Dialogic.timeline_ended
	next_shot = true


func change_to_world() -> void:
	SceneTransitionManager.transition_to(scene_after)


func _on_button_pressed(source: BaseButton) -> void:
	source.hide()
	quit.hide()
	animation_tree.active = true


func _on_quit_pressed() -> void:
	if OS.has_feature("web"):
		return JavaScriptBridge.eval("window.location.reload()", true)
	get_tree().quit()
