class_name CrewOverviewUI extends Control

const WANTER_CONSUMPTION_FORMAT := "Water consumption per day - %d drams"

const CREW_MEMBER_UI := preload("res://ui/crew_ui_modules/crew_member_ui.tscn")
#@export var something: PackedScene
const GROUP_NAME := &"CrewOverviewUI"

@onready var _crew_container := $VBoxContainer/CrewContainer
@onready var _water_consumption_label := $VBoxContainer/WaterConsumptionPanel/Label
@onready var _accept_rations_button := $VBoxContainer/HBoxContainer/AcceptRations

var _crew_cabin: CrewCabin
var _crew_member_hash: int

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	add_to_group(GROUP_NAME)
	add_to_group(GlobalStrings.UI_GROUP)
	visible = false
	_accept_rations_button.visible = false
	var player := get_tree().get_first_node_in_group(GlobalStrings.PLAYER_GROUP)
	_crew_cabin = CrewCabin.core().get_from(player)
	_update_water_consumption(_crew_cabin.get_water_consumption())
	_crew_cabin.water_consumption_changed.connect(_update_water_consumption)
	_crew_member_hash = _crew_cabin.crew_members.hash()
	_rebuild_crew_container()
	
	#print("Crew cabin - ", _crew_cabin)
	#print("Crew cabin size - ", _crew_cabin.crew_members.size())


func _update_water_consumption(amount: int) -> void:
	_water_consumption_label.text = WANTER_CONSUMPTION_FORMAT % amount


func show_ui(show: bool) -> void:
	visible = show
	if show:
		var crew_member_hash := _crew_cabin.crew_members.hash()
		if crew_member_hash != _crew_member_hash:
			_crew_member_hash = crew_member_hash
			_rebuild_crew_container()
	else:
		update_all_crew_members()


func update_all_crew_members() -> void:
	for crew_member in _crew_container.get_children():
		crew_member.update()


func enable_water_consumption_control(enable: bool) -> void:
	_accept_rations_button.visible = enable
	for child: CrewMemberUI in _crew_container.get_children():
		child.enable_water_consumption_control(enable)


func _rebuild_crew_container() -> void:
	_delete_crew_container_members()
	for crew_member in _crew_cabin.crew_members:
		var crew_member_ui := CREW_MEMBER_UI.instantiate()
		_crew_container.add_child(crew_member_ui)
		crew_member_ui.set_crew_member(crew_member)


func _delete_crew_container_members() -> void:
	for child in _crew_container.get_children():
		child.queue_free()
