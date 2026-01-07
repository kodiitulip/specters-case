extends TileMovingCharacter

func _ready() -> void:
	super._ready()
	if GlobalVariables.player_last_position.is_zero_approx():
		GlobalVariables.player_last_position = global_position
	else:
		global_position = GlobalVariables.player_last_position
