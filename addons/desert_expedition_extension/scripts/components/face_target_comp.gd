## TODO: Add short component description
class_name FaceTargetComp
extends Component

var _parent: Node3D

var target: Node3D:
	set(value):
		set_process(value != null)
		target = value


static func core() -> ComponentCore:
	return ComponentCore.new(FaceTargetComp)


func _ready() -> void:
	_parent = get_parent()


func _process(delta: float) -> void:
	_parent.look_at(Vector3(target.global_position.x, _parent.global_position.y, target.global_position.z))
