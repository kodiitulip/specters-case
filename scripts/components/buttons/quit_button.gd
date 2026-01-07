class_name QuitButton
extends Button

func _ready() -> void:
	if OS.get_name() == "web":
		queue_free()


func _on_pressed() -> void:
	get_tree().quit.call_deferred()
