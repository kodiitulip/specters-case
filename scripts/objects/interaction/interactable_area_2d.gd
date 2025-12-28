@abstract class_name InteractableArea2D
extends Area2D
## InteractableArea2D
##
## This abstract class has the basic code to have a mouse interactable area 2D

var _interact_started: bool = false

@export var is_ghost_interaction: bool

func _ready() -> void:
	input_pickable = not is_ghost_interaction
	input_event.connect(_on_input_event)
	mouse_entered.connect(GlobalSignalBus.emit_mouse_busy.bind(true))
	mouse_exited.connect(GlobalSignalBus.emit_mouse_busy.bind(false))
	if is_ghost_interaction:
		GlobalSignalBus.specter_light_toggled.connect(
			func(toggle: bool) -> void: input_pickable = toggle)

## Called the first frame that the interaction starts
@abstract func on_interact_started() -> void;

## Called for every frame that the interaction is happening
@abstract func on_interacting() -> void;

## Called on the last frame that the interaction happens
@abstract func on_interact_ended() -> void;


func _process(_delta: float) -> void:
	if Input.is_action_pressed(&"left_mouse_button") and _interact_started:
		self.on_interacting()


func _on_input_event(v: Viewport, event: InputEvent, _s: int) -> void:
	if event.is_action_pressed(&"left_mouse_button") and not _interact_started:
		self.on_interact_started()
		_interact_started = true
	elif event.is_action_released(&"left_mouse_button"):
		self.on_interact_ended()
		_interact_started = false
	v.set_input_as_handled()
