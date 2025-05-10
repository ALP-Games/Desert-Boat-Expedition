## TODO: Add short component description
class_name DayOrbitComponent
extends Component

var _parent: Node3D = null
var _initial_rotation: Vector3

var day_night_cycle_component: DayNightCycle = null

@export var rotation_axis := Vector3.LEFT

static func core() -> ComponentCore:
	return ComponentCore.new(DayOrbitComponent)


func _ready() -> void:
	_parent = get_parent()
	_initial_rotation = _parent.rotation
	var world := get_tree().get_first_node_in_group(World.GROUP_NAME)
	day_night_cycle_component = DayNightCycle.core().get_from(world)


func _update_orbit(delta: float) -> void:
	_parent.rotation = _initial_rotation
	_parent.rotate(rotation_axis, deg_to_rad(360 * day_night_cycle_component.get_day_passed()))


func _process(delta: float) -> void:
	_update_orbit(delta)
