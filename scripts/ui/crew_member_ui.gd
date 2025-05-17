@tool
class_name CrewMemberUI extends PanelContainer

const WATER_RATION_INCREMENT := 50
const WATER_FORMAT := "%d/%d drams"

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
	_crew_member.water_ration_changed.connect(_on_water_ration_change)
	_update_water_consumption()
	_update_button_avalibility()
	_update_stats()


func update() -> void:
	_update_stats()


func _ready() -> void:
	if Engine.is_editor_hint():
		name_label.text = character_name
		portrait_rect.texture = portrait_texture
	if not Engine.is_editor_hint():
		water_consumption_control.visible = false
		button_add_water.pressed.connect(_add_water.bind(WATER_RATION_INCREMENT))
		button_subtract_water.pressed.connect(_add_water.bind(-WATER_RATION_INCREMENT))


func _update_stats() -> void:
	if not _crew_member:
		return
	efficiency_ui.set_progress(_crew_member.get_current_efficiency())


func _on_water_ration_change(_delta: int) -> void:
	_update_water_consumption()
	_update_button_avalibility()


func _update_button_avalibility() -> void:
	if _crew_member.rationed_water < WATER_RATION_INCREMENT:
		button_subtract_water.disabled = true
	else:
		button_subtract_water.disabled = false


func _update_water_consumption() -> void:
	if not _crew_member:
		return
	water_consumption_label.text = WATER_FORMAT % [_crew_member.rationed_water, _crew_member.water_consumption]


func enable_water_consumption_control(enable: bool) -> void:
	water_consumption_control.visible = enable


func _add_water(amount: int) -> void:
	_crew_member.rationed_water += amount
