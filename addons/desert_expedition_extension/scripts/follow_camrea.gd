extends Camera3D

@export var object_to_follow: Node3D

var _initial_position: Vector3

func _ready() -> void:
	_initial_position = object_to_follow.global_position

func _process(delta: float) -> void:
	var current_position := object_to_follow.global_position
	var position_delta := current_position - _initial_position
	_initial_position = current_position
	
	global_position += position_delta
