extends TileMovingCharacter

var _specter_light_toggle: bool = false:
	set = _set_specter_light_toggle

@onready var light: AnimationPlayer = $LightAnimation

func _unhandled_input(event: InputEvent) -> void:
	super._unhandled_input(event)
	if event.is_action_pressed(&"space"):
		_specter_light_toggle = not _specter_light_toggle


func _set_specter_light_toggle(value: bool) -> void:
	_specter_light_toggle = value
	var anim: Callable = (light.play
		if _specter_light_toggle else light.play_backwards)\
		.bind(&"Light/light_swap")
	anim.call()
	GlobalSignalBus.emit_specter_light_toggled(_specter_light_toggle)
