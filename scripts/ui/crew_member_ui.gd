@tool
class_name CrewMemberUI extends PanelContainer

const WATER_FORMAT := &"%d/%d drams"

# Texture
@export var character_name: String = "Name":
	set(value):
		character_name = value
		if is_node_ready():
			name_label.text = character_name
@export var portrait_texture: Texture = preload("res://Assets/ui/Characters/Sailor.jpg"):
	set(value):
		portrait_texture = value
		if is_node_ready():
			portrait_rect.texture = value

@onready var name_label := $VBoxContainer/NameContainer/NameLabel
@onready var portrait_rect := $VBoxContainer/Portrait

@onready var thirst_ui := $VBoxContainer/Thirst
@onready var fatigue_ui := $VBoxContainer/Fatigue
@onready var efficiency_ui := $VBoxContainer/Efficiency

@onready var water_consumption_label := $VBoxContainer/WaterConsumption/Label

@onready var water_consumption_control := $VBoxContainer/WaterConsumptionControl
@onready var button_add_water := $VBoxContainer/WaterConsumptionControl/HBoxContainer/ButtonAdd
@onready var button_subtract_water := $VBoxContainer/WaterConsumptionControl/HBoxContainer/ButtonSubtract


var _crew_member: CrewMember


func set_crew_member(crew_member: CrewMember) -> void:
	_crew_member = crew_member
	character_name = crew_member.name
	portrait_texture = crew_member.portrait
	update_water_consumption()

func _ready() -> void:
	if Engine.is_editor_hint():
		name_label.text = character_name
		portrait_rect.texture = portrait_texture
	if not Engine.is_editor_hint():
		water_consumption_control.visible = false


func update_water_consumption() -> void:
	if not _crew_member:
		return
	water_consumption_label.text = WATER_FORMAT % [_crew_member.rationed_water, _crew_member.water_consumption]
