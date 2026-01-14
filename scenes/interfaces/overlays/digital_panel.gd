extends CenterContainer

@export var answer_input: String

var input: String = "": set = set_input

@onready var exit_button: TextureButton = $TextureRect/ExitButton
@onready var numpad: GridContainer = $TextureRect/Numpad
@onready var input_display: TextureProgressBar = $TextureRect/InputDisplay


func _ready() -> void:
	#gui_input.connect(_on_gui_input)
	exit_button.pressed.connect(_on_exit_button_pressed)
	var numbut: Array[TextureButton] = []
	numbut.assign(numpad.get_children().filter(func(c: Node) -> bool:
		return c is TextureButton))
	for num: TextureButton in numbut:
		num.pressed.connect(_add_input.bind(num.name))
	if GlobalVariables.water_off:
		input = answer_input


func _add_input(num: String) -> void:
	input += num


func set_input(value: String) -> void:
	input = value
	_update_display()


func _update_display() -> void:
	input_display.set_value(input.length())
	if answer_input.is_empty() or input.length() < 4:
		return
	if input == answer_input:
		(input_display.texture_progress as AtlasTexture).region.position.x = 78
		GlobalSignalBus.emit_water_off()
		await get_tree().create_timer(1.0).timeout
		close_overlay()
	else:
		(input_display.texture_progress as AtlasTexture).region.position.x = 52
		_reset_display()


func _reset_display() -> void:
	await get_tree().create_timer(1.0).timeout
	input = ""
	input_display.set_value(0.0)
	(input_display.texture_progress as AtlasTexture).region.position.x = 26


func close_overlay() -> void:
	OverlayLayer.unload_current_overlay()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"escape"):
		get_viewport().set_input_as_handled()
		close_overlay()


func _on_gui_input(event: InputEvent) -> void:
	if event.is_pressed():
		get_viewport().set_input_as_handled()
		close_overlay()


func _on_exit_button_pressed() -> void:
	close_overlay()
