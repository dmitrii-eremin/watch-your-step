extends Node

const LEVELS: Dictionary[String, String] = {
    "level00": "res://scenes/levels/level_00.tscn",
    "level01": "res://scenes/levels/level_01.tscn",
    "level02": "res://scenes/levels/level_02.tscn",
    "level03": "res://scenes/levels/level_03.tscn",
}

var current_level: String = "level00"
var level_to_continue: String = "level00"

func get_next_level() -> String:
    var keys: Array[String] = LEVELS.keys()
    var current_index: int = keys.find(current_level)
    if current_index == -1 or current_index == keys.size() - 1:
        return ""
    return keys[current_index + 1]