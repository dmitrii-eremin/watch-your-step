extends Node
class_name Scores

const FILENAME: String = "user://scores.data"

func get_value(level_name: String, value_name: String) -> int:
	var score_file = ConfigFile.new()
	var err = score_file.load(FILENAME)
	if err != OK: 
		return 0
	return score_file.get_value(level_name, value_name, 0)

func get_score(level_name: String) -> int:
	return get_value(level_name, "collected")

func get_target(level_name: String) -> int:
	return get_value(level_name, "target")

func set_score(level_name: String, score: int, target_score: int) -> void:
	var score_file = ConfigFile.new()
	score_file.load(FILENAME)
	score_file.set_value(level_name, "collected", score)
	score_file.set_value(level_name, "target", target_score)
	score_file.save(FILENAME)

func update_score(level_name, score: int, target_score: int) -> void:
	var old_score = get_score(level_name)
	if score > old_score:
		set_score(level_name, score, target_score)
