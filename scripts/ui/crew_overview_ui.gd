class_name CrewOverviewUI extends Control

const CREW_MEMBER_UI := preload("res://ui/crew_ui_modules/crew_member_ui.tscn")
#@export var something: PackedScene
const GROUP_NAME := &"CrewOverviewUI"

@onready var crew_container := $VBoxContainer/CrewContainer

var _crew_cabin: CrewCabin
var _crew_member_hash: int

func _ready() -> void:
	add_to_group(GROUP_NAME)
	add_to_group(GlobalStrings.UI_GROUP)
	visible = false
	var player := get_tree().get_first_node_in_group(GlobalStrings.PLAYER_GROUP)
	_crew_cabin = CrewCabin.core().get_from(player)
	_crew_member_hash = _crew_cabin.crew_members.hash()
	_rebuild_crew_container()
	
	#print("Crew cabin - ", _crew_cabin)
	#print("Crew cabin size - ", _crew_cabin.crew_members.size())


func show_ui(show: bool) -> void:
	visible = show
	if show:
		var crew_member_hash := _crew_cabin.crew_members.hash()
		if crew_member_hash != _crew_member_hash:
			_crew_member_hash = crew_member_hash
			_rebuild_crew_container()


func _rebuild_crew_container() -> void:
	_delete_crew_container_members()
	for crew_member in _crew_cabin.crew_members:
		var crew_member_ui := CREW_MEMBER_UI.instantiate()
		crew_container.add_child(crew_member_ui)
		crew_member_ui.set_crew_member(crew_member)


func _delete_crew_container_members() -> void:
	for child in crew_container.get_children():
		child.queue_free()
