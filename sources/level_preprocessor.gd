extends Node
class_name LevelPreprocessor

enum CellType {
	None, Grass, Water,
}

const ATLAS_LT := Vector2i(5, 7)
const ATLAS_T :=  Vector2i(6, 7)
const ATLAS_RT := Vector2i(7, 7)
const ATLAS_L :=  Vector2i(5, 8)
const ATLAS_C :=  Vector2i(6, 8)
const ATLAS_R :=  Vector2i(7, 8)
const ATLAS_LB := Vector2i(5, 9)
const ATLAS_B :=  Vector2i(6, 9)
const ATLAS_RB := Vector2i(7, 9)

const ATLAS_ISL_LT := Vector2i(0, 7)
const ATLAS_ISL_RT := Vector2i(1, 7)
const ATLAS_ISL_LB := Vector2i(0, 8)
const ATLAS_ISL_RB := Vector2i(1, 8)

func _get_atlas(data: Dictionary[Vector2i, CellType], coords: Vector2i) -> Vector2i:
	var cells: Array = _get_cells_square(data, coords)
	if cells[1][1] == CellType.Grass:
		if cells[1][0] == CellType.Grass and cells[2][1] == CellType.Grass and cells[2][0] == CellType.Water:
			return ATLAS_LB
		if cells[1][0] == CellType.Grass and cells[0][1] == CellType.Grass and cells[0][0] == CellType.Water:
			return ATLAS_RB
		if cells[2][1] == CellType.Grass and cells[1][2] == CellType.Grass and cells[2][2] == CellType.Water:
			return ATLAS_LT
		if cells[0][1] == CellType.Grass and cells[1][2] == CellType.Grass and cells[0][2] == CellType.Water:
			return ATLAS_RT
		if cells[1][0] == CellType.Water:
			if cells[2][1] == CellType.Water:
				return ATLAS_ISL_RT
			if cells[0][1] == CellType.Water:
				return ATLAS_ISL_LT
			return ATLAS_B
		if cells[1][2] == CellType.Water:
			if cells[2][1] == CellType.Water:
				return ATLAS_ISL_RB
			if cells[0][1] == CellType.Water:
				return ATLAS_ISL_LB
			return ATLAS_T
		if cells[0][1] == CellType.Water:
			return ATLAS_R
		if cells[2][1] == CellType.Water:
			return ATLAS_L
	return Vector2i.ZERO

const GRASS_ATLAS_COORDS: Vector2i = Vector2i(3, 1)
const WATER_ATLAS_COORDS: Vector2i = Vector2i(6, 8)

const V_H: Vector2i = Vector2i(1, 0)
const V_V: Vector2i = Vector2i(0, 1)

func run(tilemap: TileMapLayer) -> void:
	var original_map = _save_original_map(tilemap)
	_update_tilemap(tilemap, original_map)

func _update_tilemap(tilemap: TileMapLayer, original_map: Dictionary[Vector2i, CellType]) -> void:
	var used_rect: Rect2i = tilemap.get_used_rect()
	for ix in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for iy in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var coords: Vector2i = Vector2i(ix, iy)
			var atlas: Vector2i = _get_atlas(original_map, coords)
			if atlas == Vector2i.ZERO:
				continue
			tilemap.set_cell(coords, 0, atlas)

func _get_cells_square(data: Dictionary[Vector2i, CellType], coords: Vector2i) -> Array:
	var cells: Array = [
		[_get_type(data, coords - V_H - V_V), _get_type(data, coords - V_H), _get_type(data, coords - V_H + V_V),],
		[_get_type(data, coords - V_V), _get_type(data, coords), _get_type(data, coords + V_V),],
		[_get_type(data, coords + V_H - V_V), _get_type(data, coords + V_H), _get_type(data, coords + V_H + V_V),],
	]
	var fallback_cell_value = cells[1][1]
	for i in range(cells.size()):
		for j in range(cells.size()):
			if cells[i][j] == CellType.None:
				cells[i][j] = fallback_cell_value
	return cells


func _save_original_map(tilemap: TileMapLayer) -> Dictionary[Vector2i, CellType]:
	var data: Dictionary[Vector2i, CellType] = {}

	var used_rect: Rect2i = tilemap.get_used_rect()
	for ix in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for iy in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(Vector2i(ix, iy))
			match atlas_coords:
				GRASS_ATLAS_COORDS:
					data[Vector2i(ix, iy)] = CellType.Grass
				WATER_ATLAS_COORDS:
					data[Vector2i(ix, iy)] = CellType.Water
	return data

func _get_type(data: Dictionary[Vector2i, CellType], coords: Vector2i) -> CellType:
	if data.has(coords):
		return data[coords]
	return CellType.None
