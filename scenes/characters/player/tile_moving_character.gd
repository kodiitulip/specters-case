class_name TileMovingCharacter
extends Node2D

const SELECTOR: AtlasTexture = preload("uid://cmb6cnhyqd6oj")

@export var speed: float = 150.0

var target_path: Array[Vector2]

var map: WorldTileMapLayer
var grid: AStarGrid2D

var _mouse_busy: bool = false
var _line: Line2D
var _marker: Sprite2D

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	GlobalSignalBus.mouse_busy.connect(func(v: bool) -> void: _mouse_busy = v)
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
	_marker.top_level = true
	add_child(_marker)


func _on_new_player_path_goal_sent(pos: Vector2, set_busy: bool = true) -> void:
	target_path = _get_path_to(map.local_to_map(pos))
	_line.points = target_path
	#_marker.global_position = map.map_to_local(map.local_to_map(pos))
	_set_direction_blending()
	_mouse_busy = set_busy
	if GlobalSignalBus.player_path_goal_reached.is_connected(
			_on_player_path_goal_reached):
		return
	GlobalSignalBus.player_path_goal_reached.connect(
		_on_player_path_goal_reached, CONNECT_ONE_SHOT)


func _on_player_path_goal_reached() -> void:
	_line.clear_points()
	_mouse_busy = false


func _unhandled_input(event: InputEvent) -> void:
	if _mouse_busy or not event.is_action_pressed(&"left_mouse_button"):
		return
	_on_new_player_path_goal_sent(get_global_mouse_position(), false)


func _process(_delta: float) -> void:
	var mouse: Vector2 = get_global_mouse_position()
	if _is_pos_solid(mouse):
		_marker.hide()
	else:
		_marker.show()
	_marker.global_position = map.map_to_local(map.local_to_map(mouse))


func _physics_process(delta: float) -> void:
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
	var m: Vector2 = map.local_to_map(pos)
	return grid.is_in_boundsv(m) and grid.is_point_solid(m)


func _set_direction_blending() -> void:
	if target_path.is_empty():
		return
	animation_tree.set(&"parameters/Walk/blend_position",
		global_position.direction_to(target_path[0]))
	animation_tree.set(&"parameters/Idle/blend_position",
		global_position.direction_to(target_path[0]))
