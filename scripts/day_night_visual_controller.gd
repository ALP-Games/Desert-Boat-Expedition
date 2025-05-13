extends AnimationTree

const DAY_START_OFFSET := 13.0


func _ready() -> void:
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME)
	var day_night_cycle: DayNightCycle = DayNightCycle.core().get_from(world)
	
	var current_hour := day_night_cycle.current_hour
	var current_minutes := day_night_cycle.current_minutes
	var animation_offset := current_hour + (current_minutes as float / day_night_cycle.MINUTES_IN_HOUR)
	set("parameters/TimeSeek/seek_request", DAY_START_OFFSET + animation_offset)
	
	# TODO: can move to the DayNightCycle script
	var day_cycle_time := day_night_cycle.hours_in_day * day_night_cycle.MINUTES_IN_HOUR * day_night_cycle.minute_time_scale
	var ratio := day_cycle_time / get_animation("Day_Night").length
	set("parameters/TimeScale/scale", 1.0 / ratio)
