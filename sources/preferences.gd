extends Node
class_name Preferences

const FILENAME: String = "user://preferences.data"

func get_language() -> String:
	var prefs = ConfigFile.new()
	var err = prefs.load(FILENAME)
	if err != OK: 
		return OS.get_locale_language()
	return prefs.get_value("common", "language", OS.get_locale_language())

func set_language(lang: String) -> void:
	var score_file = ConfigFile.new()
	score_file.load(FILENAME)
	score_file.set_value("common", "language", lang)
	score_file.save(FILENAME)
