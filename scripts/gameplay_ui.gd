class_name GameplayUI extends Control

const TIME_FORMAT := &"%02d:%02d"

@onready var time_label := $MarginContainer/Time

static var GROUP_NAME := &"GameplayUI"

func _enter_tree() -> void:
	add_to_group(GROUP_NAME)


func _ready() -> void:
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME)
	var day_night_cycle := DayNightCycle.core().get_from(world) as DayNightCycle
	day_night_cycle.minutes_updated.connect(_update_time_label)
	# not disconnecting, but should not be important, unless we are gonna be unloading this UI scene


func _update_time_label(day_night_cycle: DayNightCycle) -> void:
	time_label.text = TIME_FORMAT % [day_night_cycle.current_hour, day_night_cycle.current_minutes]
