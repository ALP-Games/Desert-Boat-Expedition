## TODO: Add short component description
class_name DurabilityDegrader
extends Component

## Degradation per in game minute
@export var default_degradation_amount := 0.01
@export var minimum_speed_to_degenerate: float = 5.0

var _parent: RigidBody3D
var _durability_component: DurabilityComponent


static func core() -> ComponentCore:
	return ComponentCore.new(DurabilityDegrader)


func _ready() -> void:
	_parent = get_parent()
	_durability_component = DurabilityComponent.core().get_from(_parent)
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME) as World
	var day_night_cycle := DayNightCycle.core().get_from(world) as DayNightCycle
	var timer_node := Timer.new()
	add_child(timer_node)
	timer_node.start(day_night_cycle.minute_time_scale)
	timer_node.timeout.connect(_degrade_durability)


func _degrade_durability() -> void:
	if _parent.linear_velocity.length() >= minimum_speed_to_degenerate:
		_durability_component.subtract_durability(default_degradation_amount)
