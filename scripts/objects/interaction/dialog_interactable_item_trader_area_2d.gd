class_name  DialogInteractableItemTraderArea2D
extends DialogInteractableItemGiverArea2D

@export var item_to_check_for: ItemData
@export var should_consume_item: bool = false


func _handle_dropping_item() -> void:
	super._handle_dropping_item()
	if should_consume_item:
		GlobalInventory.remove_item(item_to_check_for)
