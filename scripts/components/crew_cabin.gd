## TODO: Add short component description
class_name CrewCabin
extends Component

@export var crew_members: Array[CrewMember]

var _day_night_cycle: DayNightCycle
var _water_storage: WaterStorage

var _water_consumption_total: int = 0:
	set(value):
		_water_consumption_total = value
		_water_consumption_interval = _day_night_cycle.minute_time_scale / \
			(_water_consumption_total / (_day_night_cycle.hours_in_day * DayNightCycle.MINUTES_IN_HOUR))
var _water_consumption_interval: float = 0
var _consumption_time_elapsed: float = 0

static func core() -> ComponentCore:
	return ComponentCore.new(CrewCabin)


func _ready() -> void:
	var wrold: World = get_tree().get_first_node_in_group(World.GROUP_NAME)
	_day_night_cycle = DayNightCycle.core().get_from(wrold)
	_water_storage = WaterStorage.core().get_from(get_parent())
	
	for crew_member in crew_members:
		crew_member.water_ration_changed.connect(func(delta: int): _water_consumption_total += delta)
		_water_consumption_total += crew_member.water_consumption
	# how much per delta time?


func _process(delta: float) -> void:
	_consumption_time_elapsed += delta
	if _consumption_time_elapsed >= _water_consumption_interval:
		_consumption_time_elapsed -= _water_consumption_interval
		_water_storage.take_out_water_amount(1)
	#print("Seconds elasped - ", seconds_elapsed, "; consumed count - ", consumption_count)
