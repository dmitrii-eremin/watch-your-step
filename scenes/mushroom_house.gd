@tool
extends StaticBody2D

enum Season {
	Summer, Autumn
}

signal player_hit(point: Node2D)

@export var is_opened: bool = true
@export var label_text: String = ""
@export var season: Season = Season.Summer

@onready var _opened_door_sprite: Sprite2D = $OpenedDoorSprite
@onready var _closed_door_sprite: Sprite2D = $ClosedDoorSprite
@onready var _door_point: Node2D = $DoorPoint
@onready var _label: Label = $Label
@onready var _summer_sprite: Sprite2D = $SummerSprite2D
@onready var _autumn_sprite: Sprite2D = $AutumnSprite2D

func open_door(opened: bool) -> void:
	is_opened = opened
	_update_door_sprite()
	
func _ready() -> void:
	_update_main_sprite()
	_update_door_sprite()
	_load_label()
	
func _update_main_sprite() -> void:
	_summer_sprite.visible = season == Season.Summer
	_autumn_sprite.visible = season == Season.Autumn
	
func _update_door_sprite() -> void:
	_opened_door_sprite.visible = is_opened
	_closed_door_sprite.visible = not is_opened
	
func _load_label() -> void:
	_label.text = label_text
	_label.visible = label_text != ""

func _on_hit_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_hit.emit(_door_point)
