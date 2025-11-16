extends NinePatchRect

signal closed()

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_exit_button_pressed() -> void:
	close()


func open() -> void:
	animation_player.play_backwards(&"fade")


func close() -> void:
	animation_player.play(&"fade")
	await animation_player.animation_finished
	closed.emit()
