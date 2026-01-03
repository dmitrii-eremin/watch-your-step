extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse
@onready var _golden_goblet := $YSortedObjects/Goblets/GoldenGoblet
@onready var _silver_goblet := $YSortedObjects/Goblets/SilverGoblet

var _prefs: Preferences = Preferences.new()
var _scores: Scores = Scores.new()

func _ready() -> void:
	TranslationServer.set_locale(_prefs.get_language())
	_initialize_camera()
	_hud.show_stats(false)
	_original_mushroom_house.call_deferred("queue_free")
	_update_goblets()

func _on_start_game(_point: Node2D) -> void:
	Globals.current_level = Globals.get_level_to_continue()
	Transition.change_scene(Globals.LEVELS[Globals.current_level].path)
	
func _on_select_level_house_player_hit(_point: Node2D) -> void:
	Transition.change_scene("res://scenes/levels/select_level.tscn")

func _on_language_npc_language_change(lang: LanguageNpc.Language) -> void:
	match lang:
		LanguageNpc.Language.Finnish:
			_set_language("fi")
		LanguageNpc.Language.Russian:
			_set_language("ru")
		LanguageNpc.Language.English:
			_set_language("en")

func _set_language(lang: String) -> void:
	TranslationServer.set_locale(lang)
	_prefs.set_language(lang)

func _update_goblets() -> void:
	_silver_goblet.visible =  _scores.is_game_completed()
	_golden_goblet.visible =  _scores.is_game_completed() and _scores.is_all_mushrooms_collected()
	
