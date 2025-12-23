extends Node

enum Season {
	Summer, Autumn, Winter,
}

class LevelInfo:
	var name: String
	var path: String
	var seconds: int
	var season: Season
	
	func _init(p_name: String, p_path: String, p_seconds: int, p_season: Season) -> void:
		name = p_name
		path = p_path
		seconds = p_seconds
		season = p_season

var LEVELS: Dictionary[String, LevelInfo] = {
	"level00": LevelInfo.new("0-0", "res://scenes/levels/level_00.tscn", 240, Season.Summer),

	"level01": LevelInfo.new("1-1", "res://scenes/levels/level_01.tscn", 360, Season.Summer),
	"level02": LevelInfo.new("1-2", "res://scenes/levels/level_02.tscn", 360, Season.Summer),
	"level03": LevelInfo.new("1-3", "res://scenes/levels/level_03.tscn", 460, Season.Summer),
	"level04": LevelInfo.new("1-4", "res://scenes/levels/level_04.tscn", 660, Season.Summer),
	"level05": LevelInfo.new("1-5", "res://scenes/levels/level_05.tscn", 720, Season.Summer),
	"level06": LevelInfo.new("1-6", "res://scenes/levels/level_06.tscn", 660, Season.Summer),
	
	"level10": LevelInfo.new("2-1", "res://scenes/levels/level_10.tscn", 550, Season.Autumn),
	"level11": LevelInfo.new("2-2", "res://scenes/levels/level_11.tscn", 600, Season.Autumn),
	"level12": LevelInfo.new("2-3", "res://scenes/levels/level_12.tscn", 600, Season.Autumn),
	"level13": LevelInfo.new("2-4", "res://scenes/levels/level_13.tscn", 900, Season.Autumn),
	"level14": LevelInfo.new("2-5", "res://scenes/levels/level_14.tscn", 720, Season.Autumn),
	"level15": LevelInfo.new("2-6", "res://scenes/levels/level_15.tscn", 800, Season.Autumn),
	
	"level20": LevelInfo.new("3-1", "res://scenes/levels/level_20.tscn", 600, Season.Winter),
	"level21": LevelInfo.new("3-2", "res://scenes/levels/level_21.tscn", 600, Season.Winter),
}

var current_level: String = "level00"
var level_to_continue: String = "level00"

var target_mushrooms_count: int = 0
var collected_mushrooms_count: int = 0
var time_left: int = 0
var is_died: bool = false

func get_next_level() -> String:
	var keys: Array[String] = LEVELS.keys()
	var current_index: int = keys.find(current_level)
	if current_index == -1 or current_index == keys.size() - 1:
		return ""
	return keys[current_index + 1]
