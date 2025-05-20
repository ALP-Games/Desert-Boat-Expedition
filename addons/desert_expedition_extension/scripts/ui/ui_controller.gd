class_name UIManager extends Control

@onready var gameplay_ui := $GameplayUI
@onready var crew_overview_ui := $CrewOverviewUI

func _ready() -> void:
	crew_overview_ui.visible = false
