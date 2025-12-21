extends StaticBody2D

@export var season: Globals.Season = Globals.Season.Summer

@onready var _summer: Sprite2D = $Summer
@onready var _autumn: Sprite2D = $Autumn

func _ready() -> void:
	_summer.visible = season == Globals.Season.Summer
	_autumn.visible = season == Globals.Season.Autumn
