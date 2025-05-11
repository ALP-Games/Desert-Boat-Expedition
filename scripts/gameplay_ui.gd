class_name GameplayUI extends Control

const TIME_FORMAT := &"%02d:%02d"
const WATER_FORMAT := &"%d/%d"

@onready var hours_label := $Time/Hours
@onready var water_laber := $Water/Label
@onready var refill_prompt := $"Refill Prompt"

static var GROUP_NAME := &"GameplayUI"

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)


func _ready() -> void:
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME)
	var day_night_cycle := DayNightCycle.core().get_from(world) as DayNightCycle
	day_night_cycle.minutes_updated.connect(_update_time_label)
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene
	var player := get_tree().get_first_node_in_group(GlobalStrings.PLAYER_GROUP)
	var water_storage := WaterStorage.core().get_from(player) as WaterStorage
	water_storage.water_updated.connect(_update_water_label)
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene
	refill_prompt.visible = false
	var water_interactor := WaterStorageInteractor.core().get_from(player) as WaterStorageInteractor
	water_interactor.possible_to_interact.connect(_enable_refill_prompt.bind(true))
	water_interactor.interaction_closed.connect(_enable_refill_prompt.bind(null, false))
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene


func _update_time_label(day_night_cycle: DayNightCycle) -> void:
	hours_label.text = TIME_FORMAT % [day_night_cycle.current_hour, day_night_cycle.current_minutes]


func _update_water_label(current_water: int, max_water: int) -> void:
	water_laber.text = WATER_FORMAT % [current_water, max_water]


func _enable_refill_prompt(other_storage: Node3D, enable_prompt: bool) -> void:
	refill_prompt.visible = enable_prompt
