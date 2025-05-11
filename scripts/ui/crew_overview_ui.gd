class_name CrewOverviewUI extends Control

static var GROUP_NAME := &"CrewOverviewUI"

func _ready() -> void:
	add_to_group(GROUP_NAME)
	add_to_group(GlobalStrings.UI_GROUP)
	visible = false
