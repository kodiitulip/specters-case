class_name WASDTileMovement
extends Node

@export_custom(PROPERTY_HINT_LINK, "Vector2i") var world_tile_size: Vector2i = Vector2i(16, 16)
@export var tile_moving_character: TileMovingCharacter

var _busy: bool


func _ready() -> void:
	GlobalSignalBus.player_path_goal_reached.connect(func() -> void:
		_busy = false)


func _process(_delta: float) -> void:
	assert(tile_moving_character != null, "No Character Selected!")
	var direction: Vector2 = Input.\
		get_vector(&"move_left", &"move_right", &"move_up", &"move_down")
	if _busy or direction.is_zero_approx():
		return
	_send_new_path(direction)


func _send_new_path(direction: Vector2) -> void:
	GlobalSignalBus.send_new_position_to_player(
		tile_moving_character.global_position +
		direction * Vector2(world_tile_size) * 3)
	_busy = true
