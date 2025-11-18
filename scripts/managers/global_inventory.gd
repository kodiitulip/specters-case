extends Node

var items: Dictionary[ItemData, int] = {}


func has_item(item: ItemData) -> bool:
	return items.has(item) and items.get(item, 0) > 0


func add_item(item: ItemData, amount: int = 1) -> void:
	if has_item(item):
		return items.set(item, items.get(item, 0) + amount)
	items.set(item, amount)
