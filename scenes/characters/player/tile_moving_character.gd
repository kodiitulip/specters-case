class_name TileMovingCharacter
extends Node2D

const SELECTOR: AtlasTexture = preload("uid://cmb6cnhyqd6oj")

@export var speed: float = 150.0
@export var busy: bool = false

var target_path: Array[Vector2]

var wasd_direction: Vector2

var map: WorldTileMapLayer
var grid: AStarGrid2D

var _line: Line2D
var _marker: Sprite2D

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	GlobalSignalBus.mouse_busy.connect(func(v: bool) -> void: busy = v)
	GlobalSignalBus.new_player_path_goal_sent.connect(_on_new_player_path_goal_sent)
	assert(WorldTileMapLayer.instance and WorldTileMapLayer.astar_grid,
		"No WorldTileMapLayer found")
	map = WorldTileMapLayer.instance
	grid = WorldTileMapLayer.astar_grid
	_line = Line2D.new()
	_line.width = 1
	_line.default_color = Color.BISQUE
	_line.top_level = true
	add_child(_line)
	_marker = Sprite2D.new()
	_marker.texture = SELECTOR
	_marker.material = CanvasItemMaterial.new()
	(_marker.material as CanvasItemMaterial).light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
	_marker.top_level = true
	add_child(_marker)


func _on_new_player_path_goal_sent(pos: Vector2) -> void:
	if not _is_pos_inbounds(pos):
		return
	target_path = _get_path_to(map.local_to_map(pos))
	_line.points = target_path
	#_marker.global_position = map.map_to_local(map.local_to_map(pos))
	_set_direction_blending()
	if GlobalSignalBus.player_path_goal_reached.is_connected(
			_on_player_path_goal_reached):
		return
	GlobalSignalBus.player_path_goal_reached.connect(
		_on_player_path_goal_reached, CONNECT_ONE_SHOT)


func _on_player_path_goal_reached() -> void:
	_line.clear_points()
	busy = false


func _unhandled_input(event: InputEvent) -> void:
	wasd_direction = Input.get_vector(
		&"move_left", &"move_right", &"move_up", &"move_down"
	).normalized()
	if not busy and event.is_action_pressed(&"left_mouse_button"):
		GlobalSignalBus.send_new_position_to_player(get_global_mouse_position())


func _process(delta: float) -> void:
	_handle_tile_movement(delta)
	_handle_wasd_movement(delta)
	_handle_mouse_marker()


func _handle_wasd_movement(delta: float) -> void:
	if busy or wasd_direction.is_zero_approx():
		return
	var tile_size: int = map.tile_set.tile_size.x
	var next_pos: Vector2 = global_position + wasd_direction * tile_size / 2
	var next_pos_is_solid: bool = _is_pos_solid(next_pos)
	next_pos = global_position if next_pos_is_solid else\
		global_position + wasd_direction * tile_size
	global_position = global_position.move_toward(next_pos, delta * speed)
	_set_manual_direction_blending()


func _handle_mouse_marker() -> void:
	if busy:
		return
	var mouse: Vector2 = get_global_mouse_position()
	_marker.set_visible(not _is_pos_solid(mouse))
	_marker.global_position = map.map_to_local(map.local_to_map(mouse))


func _handle_tile_movement(delta: float) -> void:
	if busy:
		return
	if target_path.size() == 0:
		GlobalSignalBus.emit_player_path_goal_reached()
		return
	global_position = global_position.move_toward(target_path[0], delta * speed)
	
	if global_position.is_equal_approx(target_path[0]):
		target_path.pop_front()
		_line.remove_point(0)
		_set_direction_blending()


func _get_path_to(point: Vector2) -> Array[Vector2]:
	var from: Vector2i = map.local_to_map(global_position)
	var path: Array[Vector2i] = grid.get_id_path(from, point, true)
	path.pop_front()
	var res: Array[Vector2] = []
	res.assign(
		path.map(func(p: Vector2i) -> Vector2: return map.map_to_local(p)))
	return res


func _is_pos_solid(pos: Vector2) -> bool:
	if not _is_pos_inbounds(pos):
		return true
	var m: Vector2 = map.local_to_map(pos)
	return grid.is_point_solid(m)


func _is_pos_inbounds(pos: Vector2) -> bool:
	var m: Vector2 = map.local_to_map(pos)
	return grid.is_in_boundsv(m)


func _set_direction_blending() -> void:
	if target_path.is_empty():
		return
	animation_tree.set(&"parameters/Walk/blend_position",
		global_position.direction_to(target_path[0]))
	animation_tree.set(&"parameters/Idle/blend_position",
		global_position.direction_to(target_path[0]))


func _set_manual_direction_blending() -> void:
	animation_tree.set(&"parameters/Walk/blend_position", wasd_direction)
	animation_tree.set(&"parameters/Idle/blend_position", wasd_direction)
