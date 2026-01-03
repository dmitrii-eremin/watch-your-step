extends Node
class_name Scores

const FILENAME: String = "user://scores.data"

class Score:
	var collected: int
	var total: int

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

func set_time_spent(level_name: String, seconds: int) -> void:
	var score_file = ConfigFile.new()
	score_file.load(FILENAME)
	score_file.set_value(level_name, "time_spent", seconds)
	score_file.save(FILENAME)

func get_time_spent(level_name: String) -> int:
	return get_value(level_name, "time_spent")

func update_time_spent(level_name: String, seconds: int) -> void:
	var old_value = get_time_spent(level_name)
	if seconds < old_value or old_value == 0:
		set_time_spent(level_name, seconds)

func set_game_completed(completed: bool) -> void:
	var score_file = ConfigFile.new()
	score_file.load(FILENAME)
	score_file.set_value("common", "game_completed", completed)
	score_file.save(FILENAME)

func is_game_completed() -> bool:
	var score_file = ConfigFile.new()
	var err = score_file.load(FILENAME)
	if err != OK: 
		return 0
	return score_file.get_value("common", "game_completed", false)

func get_score_for_level(level_name: String) -> Score:
	var s: Score = Score.new()
	s.collected = get_score(level_name)
	s.total = get_target(level_name)
	return s

func get_all_scores() -> Array[Score]:
	var scores: Array[Score] = []
	for level_name in Globals.LEVELS.keys():
		scores.push_back(get_score_for_level(level_name))
	return scores
	
func is_all_mushrooms_collected() -> bool:
	var all_scores = get_all_scores()
	for score in all_scores:
		if score.collected < score.total:
			return false
	return true
