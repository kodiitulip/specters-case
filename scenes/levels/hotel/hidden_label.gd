extends Label

const LUPA: ItemData = preload("uid://uhlf2go07knm")

func _ready() -> void:
	var t: String = "  ".join(GlobalVariables.water_code.split())
	set_text(t)
	Dialogic.VAR.set_variable("puzzles.water_code", GlobalVariables.water_code)


func _process(_delta: float) -> void:
	set_visible(GlobalInventory.has_item(LUPA))
