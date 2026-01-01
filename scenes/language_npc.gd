extends CharacterBody2D
class_name LanguageNpc

enum Language {
	English,
	Russian,
	Finnish
}

signal language_change(lang: Language)

const _flags: Dictionary = {
	Language.English: "🇺🇸",
	Language.Russian: "🇷🇺",
	Language.Finnish: "🇫🇮",
}

@export var language: Language = Language.English

@onready var _label := $Label
@onready var _lang_changed := $LanguageChangedLabel
@onready var _lang_changed_timer := $Timer

func _ready() -> void:
	_label.text = _flags[language]

func _on_hit_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group(&"player"):
		return
	language_change.emit(language)
	_lang_changed.show()
	_lang_changed_timer.start()
	
func _on_timer_timeout() -> void:
	_lang_changed.hide()
