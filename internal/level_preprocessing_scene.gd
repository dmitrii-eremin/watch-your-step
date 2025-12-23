extends Node2D

@export var level_type: LevelPreprocessor.LevelType = LevelPreprocessor.LevelType.Summer

@onready var _tilemap: TileMapLayer = $TileMapLayer

@onready var _tilesets: Dictionary = {
	LevelPreprocessor.LevelType.Summer: preload("res://tilesets/summer.tres"),
	LevelPreprocessor.LevelType.Autumn: preload("res://tilesets/autumn.tres"),
	LevelPreprocessor.LevelType.Winter: preload("res://tilesets/winter.tres"),
}

var _is_already_processed: bool = false
var processor: LevelPreprocessor = LevelPreprocessor.new()

func _ready() -> void:
	_tilemap.tile_set = _tilesets[level_type]

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_process_level()

func _process_level() -> void:
	if _is_already_processed:
		return
	_is_already_processed = true
	processor.run(_tilemap, level_type)
	var encoded: String = Marshalls.raw_to_base64(_tilemap.tile_map_data)
	DisplayServer.clipboard_set(encoded)
