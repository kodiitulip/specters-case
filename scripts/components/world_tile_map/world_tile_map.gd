class_name WorldTileMapLayer
extends TileMapLayer

@export var diagonal_mode: AStarGrid2D.DiagonalMode = AStarGrid2D.DIAGONAL_MODE_ALWAYS:
	set(v):
		diagonal_mode = v
		_setup()

static var astar_grid: AStarGrid2D
static var instance: WorldTileMapLayer

func _ready() -> void:
	_setup()
	if not instance:
		instance = self
	hide()

func _setup() -> void:
	if astar_grid == null:
		_setup_grid()
	else:
		_update_grid()


func _setup_grid() -> void:
	astar_grid = AStarGrid2D.new()
	astar_grid.cell_size = tile_set.tile_size
	astar_grid.cell_shape = AStarGrid2D.CELL_SHAPE_SQUARE
	astar_grid.diagonal_mode = diagonal_mode
	astar_grid.region = get_used_rect()
	astar_grid.update()
	_update_solid_cells()


func _update_grid() -> void:
	astar_grid.region = get_used_rect().merge(astar_grid.region)
	astar_grid.diagonal_mode = diagonal_mode
	astar_grid.update()
	_update_solid_cells()


func _update_solid_cells() -> void:
	for cell_x: int in range(get_used_rect().size.x):
		for cell_y: int in range(get_used_rect().size.y):
			var cell: Vector2i = Vector2i(
				cell_x + get_used_rect().position.x,
				cell_y + get_used_rect().position.y,
			)
			if get_cell_atlas_coords(cell) == Vector2i.ZERO:
				continue
			astar_grid.set_point_solid(cell)
