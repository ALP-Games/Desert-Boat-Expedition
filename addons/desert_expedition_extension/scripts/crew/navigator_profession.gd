class_name NavigatorProfession extends IProfession

## In game minute
@export var scans_per_minute: float = 0.1

var _detection_area: Area3D
var _detection_shape: SphereShape3D

static func get_profession_name() -> StringName:
	return &"Navigator"


func initialize(crew_member: CrewMember, player_node: Node) -> void:
	_detection_area = Area3D.new()
	var collision_shape := CollisionShape3D.new()
	_detection_shape = SphereShape3D.new()
	collision_shape.shape = _detection_shape
	_detection_area.add_child(collision_shape)
	_detection_area.name = "NavigatorDetectionArea"
	player_node.add_child.call_deferred(_detection_area)


## Returns effort spent on work
func perform_work(delta: float, crew_member: CrewMember, player_node: Node) -> float:
	return 0.0
