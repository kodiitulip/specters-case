extends Node

signal inventory_changed()

var items: Dictionary[ItemData, int] = {}

func has_item(item: ItemData) -> bool:
	return items.has(item)


func add_item(item: ItemData, slot_id: int = -1) -> void:
	if has_item(item):
		return
	items.set(item, slot_id)
	inventory_changed.emit()
