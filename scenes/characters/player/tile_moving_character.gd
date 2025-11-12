@icon("CharacterBody2D")
class_name TileMovingCharacter
extends Node2D

@export var speed: float = 150.0

var target_path: Array[Vector2]

var map: WorldTileMapLayer
var grid: AStarGrid2D

var _mouse_busy: bool = false

@onready var animation_tree: AnimationTree = $AnimationTree

func _ready() -> void:
	GlobalSignalBus.mouse_busy.connect(func(v: bool) -> void: _mouse_busy = v)
	assert(WorldTileMapLayer.instance and WorldTileMapLayer.astar_grid,
		"No WorldTileMapLayer found")
	map = WorldTileMapLayer.instance
	grid = WorldTileMapLayer.astar_grid


func _unhandled_input(event: InputEvent) -> void:
	if _mouse_busy or not event.is_action_pressed(&"left_mouse_button"):
		return
	target_path = _get_path_to(map.local_to_map(get_global_mouse_position()))
	_set_direction_blending()


func _physics_process(delta: float) -> void:
	if target_path.size() == 0:
		return
	global_position = global_position.move_toward(target_path[0], delta * speed)
	
	if global_position.is_equal_approx(target_path[0]):
		target_path.pop_front()
		_set_direction_blending()


func _get_path_to(point: Vector2) -> Array[Vector2]:
	var from: Vector2i = map.local_to_map(global_position)
	var path: Array[Vector2i] = grid.get_id_path(from, point, true)
	path.pop_front()
	var res: Array[Vector2] = []
	res.assign(
		path.map(func(p: Vector2i) -> Vector2: return map.map_to_local(p)))
	return res


func _set_direction_blending() -> void:
	if target_path.is_empty():
		return
	animation_tree.set(&"parameters/Walk/blend_position",
		global_position.direction_to(target_path[0]))
