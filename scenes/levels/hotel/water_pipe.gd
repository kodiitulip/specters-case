extends DialogInteractableItemTraderArea2D

func _ready() -> void:
	super._ready()
	area_entered.connect(_setup)


func _setup(_a: Area2D) -> void:
	if GlobalInventory.has_item(item_to_check_for):
		on_interact_started()
