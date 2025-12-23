extends Node
class_name LevelPreprocessor

enum LevelType {
	Summer, Autumn, Winter
}

enum CellType {
	None, Grass, Water,
}

const V_H: Vector2i = Vector2i(1, 0)
const V_V: Vector2i = Vector2i(0, 1)

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

const GRASS_ATLAS_COORDS: Vector2i = Vector2i(3, 1)
const WATER_ATLAS_COORDS: Vector2i = Vector2i(6, 8)

const WINTER_GRASS_ATLAS_COORDS: Vector2i = Vector2i(1, 11)
const WINTER_WATER_ATLAS_COORDS: Vector2i = Vector2i(5, 12)

const WINTER_ATLAS_LT := ATLAS_LT + Vector2i(-1, 4)
const WINTER_ATLAS_T :=  ATLAS_T + Vector2i(-1, 4)
const WINTER_ATLAS_RT := ATLAS_RT + Vector2i(-1, 4)
const WINTER_ATLAS_L :=  ATLAS_L + Vector2i(-1, 4)
const WINTER_ATLAS_C :=  ATLAS_C + Vector2i(-1, 4)
const WINTER_ATLAS_R :=  ATLAS_R + Vector2i(-1, 4)
const WINTER_ATLAS_LB := ATLAS_LB + Vector2i(-1, 4)
const WINTER_ATLAS_B :=  ATLAS_B + Vector2i(-1, 4)
const WINTER_ATLAS_RB := ATLAS_RB + Vector2i(-1, 4)

func _get_atlas(data: Dictionary[Vector2i, CellType], coords: Vector2i, level_type: LevelType) -> Vector2i:
	var cells: Array = _get_cells_square(data, coords)
	if cells[1][1] == CellType.Grass:
		if cells[1][0] == CellType.Grass and cells[2][1] == CellType.Grass and cells[2][0] == CellType.Water:
			return ATLAS_LB if level_type != LevelType.Winter else WINTER_ATLAS_LB
		if cells[1][0] == CellType.Grass and cells[0][1] == CellType.Grass and cells[0][0] == CellType.Water:
			return ATLAS_RB if level_type != LevelType.Winter else WINTER_ATLAS_RB
		if cells[2][1] == CellType.Grass and cells[1][2] == CellType.Grass and cells[2][2] == CellType.Water:
			return ATLAS_LT if level_type != LevelType.Winter else WINTER_ATLAS_LT
		if cells[0][1] == CellType.Grass and cells[1][2] == CellType.Grass and cells[0][2] == CellType.Water:
			return ATLAS_RT if level_type != LevelType.Winter else WINTER_ATLAS_RT
		if cells[1][0] == CellType.Water:
			if cells[2][1] == CellType.Water:
				return ATLAS_ISL_RT
			if cells[0][1] == CellType.Water:
				return ATLAS_ISL_LT
			return ATLAS_B if level_type != LevelType.Winter else WINTER_ATLAS_B
		if cells[1][2] == CellType.Water:
			if cells[2][1] == CellType.Water:
				return ATLAS_ISL_RB
			if cells[0][1] == CellType.Water:
				return ATLAS_ISL_LB
			return ATLAS_T if level_type != LevelType.Winter else WINTER_ATLAS_T
		if cells[0][1] == CellType.Water:
			return ATLAS_R if level_type != LevelType.Winter else WINTER_ATLAS_R
		if cells[2][1] == CellType.Water:
			return ATLAS_L if level_type != LevelType.Winter else WINTER_ATLAS_L
	return Vector2i.ZERO

func run(tilemap: TileMapLayer, level_type: LevelType) -> void:
	var original_map = _save_original_map(tilemap, level_type)
	_update_tilemap(tilemap, original_map, level_type)

func _update_tilemap(tilemap: TileMapLayer, original_map: Dictionary[Vector2i, CellType], level_type: LevelType) -> void:
	var source_id: int = 0
	match level_type:
		LevelType.Summer:
			source_id = 0
		LevelType.Autumn:
			source_id = 3
		LevelType.Winter:
			source_id = 3
		_:
			source_id = 0
	var used_rect: Rect2i = tilemap.get_used_rect()
	for ix in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for iy in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var coords: Vector2i = Vector2i(ix, iy)
			var atlas: Vector2i = _get_atlas(original_map, coords, level_type)
			if atlas == Vector2i.ZERO:
				continue
			tilemap.set_cell(coords, source_id, atlas)

func _save_original_map(tilemap: TileMapLayer, level_type: LevelType) -> Dictionary[Vector2i, CellType]:
	var data: Dictionary[Vector2i, CellType] = {}
	
	var grass_atlas_coords = WINTER_GRASS_ATLAS_COORDS if level_type == LevelType.Winter else GRASS_ATLAS_COORDS
	var water_atlas_coords = WINTER_WATER_ATLAS_COORDS if level_type == LevelType.Winter else WATER_ATLAS_COORDS

	var used_rect: Rect2i = tilemap.get_used_rect()
	for ix in range(used_rect.position.x, used_rect.position.x + used_rect.size.x):
		for iy in range(used_rect.position.y, used_rect.position.y + used_rect.size.y):
			var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(Vector2i(ix, iy))
			match atlas_coords:
				grass_atlas_coords:
					data[Vector2i(ix, iy)] = CellType.Grass
				water_atlas_coords:
					data[Vector2i(ix, iy)] = CellType.Water
	return data
	
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

func _get_type(data: Dictionary[Vector2i, CellType], coords: Vector2i) -> CellType:
	if data.has(coords):
		return data[coords]
	return CellType.None
