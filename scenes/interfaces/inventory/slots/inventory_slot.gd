class_name InventorySlot
extends PanelContainer

signal on_item_dropped_on(origin_id: int, destination_id: int)

@export var slot_item: ItemData:
	set = fill_slot

var slot_id: int = -1

@onready var _texture_rect: TextureRect = $MarginContainer/TextureRect


func is_full() -> bool:
	return slot_item != null


func fill_slot(data: ItemData) -> void:
	slot_item = data
	if is_full():
		_texture_rect.texture = slot_item.item_icon
	else:
		_texture_rect.texture = null


func _get_drag_data(_pos: Vector2) -> Variant:
	if is_full():
		var preview: TextureRect = TextureRect.new()
		preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		preview.size = slot_item.item_icon.get_size()
		# preview.pivot_offset = slot_item.item_icon.get_size() / 2.0
		preview.rotation_degrees = 10.0
		preview.texture = slot_item.item_icon
		set_drag_preview(preview)
		return {"type": "ItemData", "id": slot_id}
	return false


func _can_drop_data(_pos: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data["type"] == "ItemData"


func _drop_data(_pos: Vector2, data: Variant) -> void:
	on_item_dropped_on.emit(data["id"], slot_id)
