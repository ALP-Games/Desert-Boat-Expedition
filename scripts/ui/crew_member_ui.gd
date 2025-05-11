@tool
class_name CrewMemberUI extends PanelContainer

# Texture
@export var character_name: String = "Name":
	set(value):
		character_name = value
		if is_node_ready():
			name_label.text = character_name
@export var portrait_texture: Texture = load("res://Assets/ui/Characters/Sailor.jpg"):
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

func _ready() -> void:
	name_label.text = character_name
	portrait_rect.texture = portrait_texture
