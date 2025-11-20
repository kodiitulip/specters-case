extends Control

signal closed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var exit_button: TextureButton = $Letter/ExitButton

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"escape"):
		_on_exit_button_pressed()

func _on_exit_button_pressed() -> void:
	close()


func open() -> void:
	animation_player.play_backwards(&"fade")


func close() -> void:
	animation_player.play(&"fade")
	await animation_player.animation_finished
	closed.emit()
