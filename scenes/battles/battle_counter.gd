extends TurnBattleManager


func _ready() -> void:
	super._ready()
	self.battle_ended.connect(func(player_won: bool) -> void:
		GlobalVariables.front_desk_ghost_defeated = player_won)
