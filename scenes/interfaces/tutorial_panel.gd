class_name TutorialPanel
extends Control


var start: bool = false:
	set(value):
		start = value
		if value:
			timer.start()
			create_tween().tween_property(self, ^"modulate:a", 1.0, 0.7).from(0.0)

@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.timeout.connect(_end)
	if GlobalVariables.tutorial_ended:
		_end()


func _unhandled_input(event: InputEvent) -> void:
	if start and event.is_action_pressed(&"left_mouse_button"):
		GlobalVariables.tutorial_ended = true
		_end()


func _end() -> void:
	start = false
	await create_tween().tween_property(self, ^"modulate:a", 0.0, 0.5
		).from(1.0).finished
	queue_free()
