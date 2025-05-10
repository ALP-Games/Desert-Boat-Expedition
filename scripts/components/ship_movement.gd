## TODO: Add short component description
class_name ShipMovement
extends Component

@export var acceleration: float = 100
@export var turn_acceleration: float = 50
@export var max_turn_speed: float = 2.0

var _parent: RigidBody3D = null
var _input_polling_component: IInputPollingComponent = null

static func core() -> ComponentCore:
	return ComponentCore.new(ShipMovement)


func _ready() -> void:
	_parent = get_parent()
	_input_polling_component = IInputPollingComponent.core().get_of_type_from(_parent)


func _physics_process(delta: float) -> void:
	var acceleration_input := _input_polling_component.get_acceleration()
	var turn_input := _input_polling_component.get_turn() * -1.0
	
	if acceleration_input:
		var acceleration_direction := _parent.transform.basis * Vector3(0.0, 0.0, acceleration_input)
		_parent.apply_central_force(acceleration_direction * acceleration * _parent.mass)
	
	if turn_input:
		var inverse_inertia := PhysicsServer3D.body_get_direct_state(_parent.get_rid()).inverse_inertia.y
		var acceleration_defficit := (max_turn_speed - absf(_parent.angular_velocity.y)) / delta
		var torque_to_apply: float = turn_input * clamp(turn_acceleration, -acceleration_defficit, acceleration_defficit) / inverse_inertia
		_parent.apply_torque(Vector3(0.0, torque_to_apply, 0.0))
	else:
		var inverse_inertia := PhysicsServer3D.body_get_direct_state(_parent.get_rid()).inverse_inertia.y
		if inverse_inertia != 0:
			var reverse_angular_acceleration := -_parent.angular_velocity.y / delta as float
			reverse_angular_acceleration = clamp(reverse_angular_acceleration, -turn_acceleration, turn_acceleration)
			var torque_to_apply: float = reverse_angular_acceleration / inverse_inertia
			_parent.apply_torque(Vector3(0.0, torque_to_apply, 0.0))
	#_input_polling_component.get_turn()
