extends StaticBody3D

@export var object_to_follow: Node3D


func _physics_process(delta: float) -> void:
	global_position.x = object_to_follow.global_position.x
	global_position.z = object_to_follow.global_position.z
