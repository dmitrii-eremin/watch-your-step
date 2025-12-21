extends Node

class LevelInfo:
	var name: String
	var path: String
	var seconds: int
	
	func _init(p_name: String, p_path: String, p_seconds: int) -> void:
		name = p_name
		path = p_path
		seconds = p_seconds



var LEVELS: Dictionary[String, LevelInfo] = {
	"level00": LevelInfo.new("0-0", "res://scenes/levels/level_00.tscn", 240),
	"level01": LevelInfo.new("0-1", "res://scenes/levels/level_01.tscn", 300),
	"level02": LevelInfo.new("0-2", "res://scenes/levels/level_02.tscn", 300),
	"level03": LevelInfo.new("0-3", "res://scenes/levels/level_03.tscn", 400),
	"level04": LevelInfo.new("0-4", "res://scenes/levels/level_04.tscn", 600),
	"level05": LevelInfo.new("0-5", "res://scenes/levels/level_05.tscn", 700),
}

var current_level: String = "level00"
var level_to_continue: String = "level00"

var target_mushrooms_count: int = 0
var collected_mushrooms_count: int = 0
var is_died: bool = false

func get_next_level() -> String:
	var keys: Array[String] = LEVELS.keys()
	var current_index: int = keys.find(current_level)
	if current_index == -1 or current_index == keys.size() - 1:
		return ""
	return keys[current_index + 1]
