extends "res://scenes/world_scene.gd"

@onready var _original_mushroom_house = $YSortedObjects/MushroomHouse

func _ready() -> void:
	TranslationServer.set_locale(OS.get_locale_language())
	_initialize_camera()
	_hud.show_stats(false)
	_original_mushroom_house.call_deferred("queue_free")

func _on_start_game(_point: Node2D) -> void:
	Globals.current_level = Globals.get_level_to_continue()
	Transition.change_scene(Globals.LEVELS[Globals.current_level].path)
	
func _on_select_level_house_player_hit(_point: Node2D) -> void:
	Transition.change_scene("res://scenes/levels/select_level.tscn")

func _on_language_npc_language_change(lang: LanguageNpc.Language) -> void:
	match lang:
		LanguageNpc.Language.Finnish:
			TranslationServer.set_locale("fi")
		LanguageNpc.Language.Russian:
			TranslationServer.set_locale("ru")
		LanguageNpc.Language.English:
			TranslationServer.set_locale("en")
