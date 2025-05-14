class_name GameplayUI extends Control

const TIME_FORMAT := &"%02d:%02d"
const WATER_FORMAT := &"%d/%d"
const SPEED_FORMAT := &"%.1f km/s"

const INACTIVE_TICK := preload("res://Assets/ui/other/grey_circle.png")
const ACTIVE_TICK := preload("res://Assets/ui/other/grey_boxTick.png")

const GROUP_NAME := &"GameplayUI"

@onready var durability_bar := $Durability
@onready var hours_label := $Time/Hours
@onready var water_laber := $Water/Label
@onready var refill_prompt := $"Refill Prompt"
@onready var speed_label := $VBoxContainer/Speed/Label
@onready var speed_selection_container := $VBoxContainer/PanelContainer/SpeedSelectionContainer

var _player: RigidBody3D
var _day_night_cycle: DayNightCycle
var _durability_component: DurabilityComponent

var speed_selection_nodes: Array[TextureRect]

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)
	add_to_group(GlobalStrings.UI_GROUP)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME)
	_day_night_cycle = DayNightCycle.core().get_from(world)
	#day_night_cycle.minutes_updated.connect(_update_time_label)
	
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene
	_player = get_tree().get_first_node_in_group(GlobalStrings.PLAYER_GROUP)
	var water_storage := WaterStorage.core().get_from(_player) as WaterStorage
	water_storage.water_updated.connect(_update_water_label)
	_update_water_label(water_storage.current_water, water_storage.water_capacity)
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene
	refill_prompt.visible = false
	var water_interactor := WaterStorageInteractor.core().get_from(_player) as WaterStorageInteractor
	water_interactor.possible_to_interact.connect(_enable_refill_prompt.bind(true))
	water_interactor.interaction_closed.connect(_enable_refill_prompt.bind(null, false))
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene
	_collect_speed_selection_nodes()
	var ship_movement := ShipMovement.core().get_from(_player) as ShipMovement
	ship_movement.acceleration_variant_changed.connect(_update_speed_indicator)
	
	_durability_component = DurabilityComponent.core().get_from(_player)
	durability_bar.max_value = _durability_component.max_durability


func _process(delta: float) -> void:
	_update_time_label()
	_update_speed_label()
	_update_durability()


func _collect_speed_selection_nodes() -> void:
	speed_selection_nodes.clear()
	for child in speed_selection_container.get_children():
		if child is TextureRect:
			speed_selection_nodes.push_back(child)


func _update_speed_indicator(previous: int, current: int) -> void:
	speed_selection_nodes[previous].texture = INACTIVE_TICK
	speed_selection_nodes[current].texture = ACTIVE_TICK


func _update_time_label() -> void:
	hours_label.text = TIME_FORMAT % [_day_night_cycle.current_hour, _day_night_cycle.current_minutes]


func _update_water_label(current_water: int, max_water: int) -> void:
	water_laber.text = WATER_FORMAT % [current_water, max_water]


func _enable_refill_prompt(other_storage: Node3D, enable_prompt: bool) -> void:
	refill_prompt.visible = enable_prompt


func _update_speed_label() -> void:
	speed_label.text = SPEED_FORMAT % [_player.linear_velocity.length()]


func _update_durability() -> void:
	durability_bar.value = _durability_component.get_durability()
