class_name CutSceneManager extends Node

@export_file("*.tscn") var scene_after: String

@onready var menu_buttons: VBoxContainer = %MenuButtons
@onready var master_animation_player: AnimationPlayer = $MasterAnimationPlayer
@onready var player: TileMovingCharacter = $World/TileMovingCharacter
@onready var tutorial_panel: TutorialPanel = $CanvasLayer/TutorialPanel


func _on_play_button_pressed() -> void:
	menu_buttons.hide()
	master_animation_player.play(&"car_in")


func _on_intro_letter_closed() -> void:
	player.busy = false
	tutorial_panel.start = true
