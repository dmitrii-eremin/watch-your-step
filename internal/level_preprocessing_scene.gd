extends Node2D

@onready var _tilemap: TileMapLayer = $TileMapLayer

var _is_already_processed: bool = false
var processor: LevelPreprocessor = LevelPreprocessor.new()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		_process_level()

func _process_level() -> void:
	if _is_already_processed:
		return
	_is_already_processed = true
	processor.run(_tilemap)
	var encoded: String = Marshalls.raw_to_base64(_tilemap.tile_map_data)
	DisplayServer.clipboard_set(encoded)
