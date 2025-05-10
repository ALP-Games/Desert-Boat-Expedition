## TODO: Add short component description
class_name DayNightCycle
extends Component

signal minutes_updated(DayNightCycle)
signal day_updated(int)

signal morning_started
signal night_started

const MINUTES_IN_HOUR := 60
const DEFAULT_HOURS_IN_DAY := 24.0

enum TimeOfDay {
	MORNING,
	NIGHT
}

@export_group("World time parameters")
@export var hours_in_day: float = DEFAULT_HOURS_IN_DAY:
	get:
		return _minutes_in_a_day / MINUTES_IN_HOUR
	set(value):
		_minutes_in_a_day = MINUTES_IN_HOUR * value
## how much realtime has to pass for a minute to pass
@export var minute_time_scale := 0.1

@export_group("Day Configuration")
@export_subgroup("Morning start")
@export var morning_hour: int = 0:
	get:
		return _morning_timestamp / MINUTES_IN_HOUR
	set(value):
		_morning_timestamp = value * MINUTES_IN_HOUR + morning_minute
@export var morning_minute: int = 0:
	get:
		return _morning_timestamp % MINUTES_IN_HOUR
	set(value):
		_morning_timestamp = morning_hour * MINUTES_IN_HOUR + value
var _morning_timestamp: int = 0
@export_subgroup("Night start")
@export var night_hour: int = 0:
	get:
		return _night_timestamp / MINUTES_IN_HOUR
	set(value):
		_night_timestamp = value * MINUTES_IN_HOUR + night_minute
@export var night_minute: int = 0:
	get:
		return _night_timestamp % MINUTES_IN_HOUR
	set(value):
		_night_timestamp = night_hour * MINUTES_IN_HOUR + value
var _night_timestamp: int = 0

@export_group("Time offset")
@export var current_hour: int = 0:
	get:
		return _minutes_elapsed / MINUTES_IN_HOUR
	set(value):
		_minutes_elapsed = value * MINUTES_IN_HOUR + current_minutes
@export var current_minutes: int = 0:
	get:
		return _minutes_elapsed % MINUTES_IN_HOUR
	set(value):
		_minutes_elapsed = current_hour * MINUTES_IN_HOUR + value

var _minutes_in_a_day: int = DEFAULT_HOURS_IN_DAY * MINUTES_IN_HOUR
var _minutes_elapsed: int = 0:
	set(value):
		_minutes_elapsed = value
		minutes_updated.emit(self)
var _current_day: int = 1:
	set(value):
		_current_day = value
		day_updated.emit(_current_day)
var _current_time_of_day: TimeOfDay

var _realtime_elapsed: float = 0

static func core() -> ComponentCore:
	return ComponentCore.new(DayNightCycle)

## Returns value from 0.0 to 1.0 based on how much time has passed in a day 
func get_day_passed() -> float:
	return (_minutes_elapsed + _realtime_elapsed / minute_time_scale) / _minutes_in_a_day


func _ready() -> void:
	if _minutes_elapsed >= _morning_timestamp and _minutes_elapsed < _night_timestamp:
		_current_time_of_day = TimeOfDay.MORNING
	else:
		_current_time_of_day = TimeOfDay.NIGHT
	
	night_started.connect(func():print("Night started!"))
	morning_started.connect(func():print("Morning started!"))
	
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
	_update_day_night_state()
	#print("Current day - {0}; Current time {1}:{2}".format([_current_day, current_hours, current_minutes]))


func _update_day_night_state() -> void:
	if _current_time_of_day == TimeOfDay.MORNING and _minutes_elapsed >= _night_timestamp:
		_current_time_of_day = TimeOfDay.NIGHT
		night_started.emit()
	elif  _current_time_of_day == TimeOfDay.NIGHT and _minutes_elapsed >= _morning_timestamp and _minutes_elapsed < _night_timestamp:
		_current_time_of_day = TimeOfDay.MORNING
		morning_started.emit()
