@icon("Area2D")
@abstract class_name InteractableArea2D
extends Area2D

var _interact_started: bool = false


func _ready() -> void:
	input_pickable = true
	input_event.connect(_on_input_event)


@abstract func on_interact_started() -> void

@abstract func on_interacting() -> void

@abstract func on_interact_ended() -> void


func _process(_delta: float) -> void:
	if Input.is_action_pressed(&"left_mouse_button") and _interact_started:
		self.on_interacting()


func _on_input_event(_v: Viewport, event: InputEvent, _s: int) -> void:
	if event.is_action_pressed(&"left_mouse_button") and not _interact_started:
		self.on_interact_started()
		_interact_started = true
	if event.is_action_released(&"left_mouse_button"):
		self.on_interact_ended()
		_interact_started = false
