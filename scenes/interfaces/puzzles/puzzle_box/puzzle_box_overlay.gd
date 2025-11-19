extends Control

@export var answer_order: Array[BaseButton]
@export var item_to_give: ItemData

var order_to_check: Array[BaseButton]
var _buttons_pressed: Array[BaseButton]

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	assert(item_to_give, "Must have loot")
	texture_rect.texture = item_to_give.item_icon
	order_to_check = answer_order.duplicate()
	@warning_ignore("unsafe_property_access")
	Dialogic.VAR.puzzles.item_name = item_to_give.item_name


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"escape"):
		get_viewport().set_input_as_handled()
		close_overlay()


func _on_b_1_toggled(toggled_on: bool, source: BaseButton) -> void:
	if not toggled_on:
		_reset_buttons()
	_buttons_pressed.append(source)
	if order_to_check.front() == source:
		order_to_check.pop_front()
	else:
		_reset_buttons()
	if order_to_check.size() == 0 and _buttons_pressed.size() == answer_order.size():
		animation_player.play(&"win")
		Dialogic.start("you_got_item")
		GlobalInventory.add_item(item_to_give)
		await Dialogic.timeline_ended
		close_overlay()


func _reset_buttons() -> void:
	for b: BaseButton in _buttons_pressed:
		b.set_pressed_no_signal(false)
	_buttons_pressed.clear()
	order_to_check = answer_order.duplicate()


func close_overlay() -> void:
	OverlayLayer.unload_current_overlay()
