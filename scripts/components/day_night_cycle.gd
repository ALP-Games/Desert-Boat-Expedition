## TODO: Add short component description
class_name DayNightCycle
extends Component

signal minutes_updated(DayNightCycle)
signal day_updated(int)

const MINUTES_IN_HOUR := 60
const DEFAULT_HOURS_IN_DAY := 24.0

@export var hours_in_day: float = DEFAULT_HOURS_IN_DAY:
	get:
		return _minutes_in_a_day / MINUTES_IN_HOUR
	set(value):
		_minutes_in_a_day = MINUTES_IN_HOUR * value
## how much realtime has to pass for a minute to pass
@export var minute_time_scale := 0.1

@export var current_hours: int = 0:
	get:
		return _minutes_elapsed / MINUTES_IN_HOUR
	set(value):
		_minutes_elapsed = value * MINUTES_IN_HOUR + current_minutes
@export var current_minutes: int = 0:
	get:
		return _minutes_elapsed % MINUTES_IN_HOUR
	set(value):
		_minutes_elapsed += value

var _minutes_in_a_day: int = DEFAULT_HOURS_IN_DAY * MINUTES_IN_HOUR
var _minutes_elapsed: int = 0:
	set(value):
		_minutes_elapsed = value
		minutes_updated.emit(self)
var _current_day: int = 1:
	set(value):
		_current_day = value
		day_updated.emit(_current_day)

var _realtime_elapsed: float = 0

static func core() -> ComponentCore:
	return ComponentCore.new(DayNightCycle)


func get_day_passed() -> float:
	return (_minutes_elapsed + _realtime_elapsed / minute_time_scale) / _minutes_in_a_day


#func _ready() -> void:
	#print("Minutes in a day - ", _minutes_in_a_day)
	#print("Minutes elapsed - ", _minutes_elapsed)
	#print("Current day - {0}; Current time {1}:{2}".format([_current_day, current_hours, current_minutes]))


func _process(delta: float) -> void:
	_realtime_elapsed += delta
	var minutes_passed := _realtime_elapsed / minute_time_scale
	if minutes_passed >= 1:
		_realtime_elapsed -= minutes_passed * minute_time_scale
		_minutes_elapsed += minutes_passed
	if _minutes_elapsed >= _minutes_in_a_day:
		_current_day += 1
		_minutes_elapsed -= _minutes_in_a_day
	#print("Current day - {0}; Current time {1}:{2}".format([_current_day, current_hours, current_minutes]))
