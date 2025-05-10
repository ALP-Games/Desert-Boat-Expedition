class_name World extends Node3D

static var GROUP_NAME := &"World"


func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
