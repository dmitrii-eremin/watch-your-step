extends StaticBody2D

signal player_hit(point: Node2D)

@export var is_opened: bool = true

@onready var _opened_door_sprite: Sprite2D = $OpenedDoorSprite
@onready var _closed_door_sprite: Sprite2D = $ClosedDoorSprite
@onready var _door_point: Node2D = $DoorPoint

func open_door(opened: bool) -> void:
	is_opened = opened
	_update_door_sprite()
	
func _ready() -> void:
	_update_door_sprite()
	
func _update_door_sprite() -> void:
	_opened_door_sprite.visible = is_opened
	_closed_door_sprite.visible = not is_opened

func _on_hit_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_hit.emit(_door_point)
