extends StaticBody2D

enum Season {
	Summer, Autumn,
}

@export var season: Season = Season.Summer

@onready var _summer: Sprite2D = $Summer
@onready var _autumn: Sprite2D = $Autumn

func _ready() -> void:
	_summer.visible = season == Season.Summer
	_autumn.visible = season == Season.Autumn
