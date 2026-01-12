extends DialogInteractableArea2D

@export var item_to_check_for: ItemData


func on_interact_started() -> void:
	if item_to_check_for and GlobalInventory.has_item(item_to_check_for):
		pass
	else:
		super.on_interact_started()
