extends Node2D
class_name FollowPoints

@export var checkpoint_distance: float = 20.0
@export var store_checkpoint_every: float = 5.0

var _previous_global_pos: Vector2
var _checkpoints: Array[Vector2] = []
const _extra_mushrooms: int = 2

func _init() -> void:
	_previous_global_pos = _get_parent_global_pos()

func _set_targets(mushrooms: Array[Node2D]) -> void:
	for i in range(mushrooms.size()):
		var checkpoint_index = (i * 3) + 4
		var target: Vector2 = _checkpoints[checkpoint_index] if checkpoint_index < _checkpoints.size() else _checkpoints[_checkpoints.size() - 1]
		mushrooms[i].set_target(target)

func clear() -> void:
	_checkpoints.clear()

func update(mushrooms: Array[Node2D]) -> void:
	var current_global_position: Vector2 = _get_parent_global_pos()
	var diff: Vector2 = current_global_position - _previous_global_pos
	if diff.length_squared() < store_checkpoint_every ** 2:
		return
	var checkpoint: Vector2 = _previous_global_pos + diff.normalized() * store_checkpoint_every
	_checkpoints.push_front(checkpoint)
	_previous_global_pos = current_global_position

	_remove_extra_checkpoints(mushrooms)
	_set_targets(mushrooms)

func _remove_extra_checkpoints(mushrooms: Array[Node2D]) -> void:
	var number_of_checkpoints_to_keep = _get_mushrooms_count(mushrooms) * _get_multiplier()
	if _checkpoints.size() > number_of_checkpoints_to_keep:
		_checkpoints.resize(number_of_checkpoints_to_keep)

func _get_parent_global_pos() -> Vector2:
	var parent_node: Node2D = get_parent()
	if parent_node == null:
		return Vector2.ZERO
	return parent_node.global_position

func _get_mushrooms_count(mushrooms: Array[Node2D]) -> int:
	return mushrooms.size() + _extra_mushrooms

func _get_multiplier() -> float:
	return checkpoint_distance / store_checkpoint_every
