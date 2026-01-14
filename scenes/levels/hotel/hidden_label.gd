extends Label

const LUPA: ItemData = preload("uid://uhlf2go07knm")


func _process(_delta: float) -> void:
	set_visible(GlobalInventory.has_item(LUPA))
