extends Control

@export var answer_order: Array[TextureButton]
@export var random_answer: bool = false
@export var item_to_give: ItemData

var order_to_check: Array[TextureButton]
var _buttons_pressed: Array[TextureButton]

@onready var texture_rect: TextureRect = $TextureRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var grid: GridContainer = $GridContainer

func _ready() -> void:
	assert(item_to_give, "Must have loot")
	texture_rect.texture = item_to_give.item_icon
	if random_answer:
		answer_order.shuffle()
	order_to_check = answer_order.duplicate()
	@warning_ignore("unsafe_property_access")
	Dialogic.VAR.set_variable("puzzles.item_name", item_to_give.item_name)
	Dialogic.VAR.set_variable("puzzles.item_icon", item_to_give.item_icon.resource_path)
	var buttons: Array[TextureButton] = []
	buttons.assign(grid.get_children().filter(func(c: Node) -> bool:
		return c is TextureButton))
	for b: TextureButton in buttons:
		b.toggled.connect(_on_button_toggled.bind(b))


func _on_button_toggled(toggled_on: bool, source: TextureButton) -> void:
	if not toggled_on:
		_reset_buttons()
	_buttons_pressed.append(source)
	if order_to_check.front() == source:
		order_to_check.pop_front()
	else:
		_reset_buttons()
	if order_to_check.size() == 0 and _buttons_pressed.size() == answer_order.size():
		animation_player.play(&"win")
		Dialogic.start("you_got_item_toilet")
		GlobalInventory.add_item(item_to_give)
		await Dialogic.timeline_ended
		close_overlay()


func _reset_buttons() -> void:
	for b: TextureButton in _buttons_pressed:
		b.set_pressed_no_signal(false)
	_buttons_pressed.clear()
	order_to_check = answer_order.duplicate()


func close_overlay() -> void:
	OverlayLayer.unload_current_overlay()
