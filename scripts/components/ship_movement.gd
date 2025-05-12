## TODO: Add short component description
class_name ShipMovement
extends Component

@export_group("Movement parameters")
@export var acceleration_variants: PackedFloat32Array = [-25, -15, 0, 20, 30, 40, 55]
@export var drag_coefficient: float = 3000.0
@export var turn_acceleration: float = 20.0
@export var turn_factor_sensitivity: float = 2.0
@export var angular_drag: float = 1000000.0

@export_group("Pitch and roll control")
@export_range(0, 180, 0.001, "radians_as_degrees") var max_pitch: float = deg_to_rad(70.0)
@export_range(0, 180, 0.001, "radians_as_degrees") var max_yaw: float = deg_to_rad(15.0)

var _parent: RigidBody3D = null
var _input_polling_component: IInputPollingComponent = null
var _current_acceleration_variant: int = 5

var _on_floor = false

static func core() -> ComponentCore:
	return ComponentCore.new(ShipMovement)


func _ready() -> void:
	_parent = get_parent()
	_parent.on_integrate_forces.connect(_on_integrate_forces)
	_input_polling_component = IInputPollingComponent.core().get_of_type_from(_parent)


func _on_integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	_on_floor = state.get_contact_count() > 0
	if abs(_parent.rotation.x) > max_pitch:
		_parent.rotation.x = max_pitch if _parent.rotation.x > 0 else -max_pitch
	if abs(_parent.rotation.z) > max_yaw:
		_parent.rotation.z = max_yaw if _parent.rotation.z > 0 else -max_yaw


func _physics_process(delta: float) -> void:
	var acceleration_input := _input_polling_component.get_acceleration()
	var turn_input := _input_polling_component.get_turn() * -1.0
	
	if acceleration_input and _on_floor:
		var acceleration_direction := _parent.transform.basis * Vector3(0.0, 0.0, acceleration_input)
		_parent.apply_central_force(acceleration_direction * acceleration_variants[_current_acceleration_variant] * _parent.mass)
	
	
	if turn_input and _on_floor:
		var forward_speed = _parent.linear_velocity.dot(_parent.global_transform.basis.z.normalized())
		var turn_factor = clamp(abs(forward_speed) / turn_factor_sensitivity, 0.0, 1.0)
		if not is_zero_approx(forward_speed):
			var inverse_inertia := PhysicsServer3D.body_get_direct_state(_parent.get_rid()).inverse_inertia.y
			var torque_to_apply: float = turn_input * turn_acceleration * turn_factor / inverse_inertia
			_parent.apply_torque(Vector3(0.0, torque_to_apply, 0.0))
	
	
	if _on_floor:
		var drag_force = -_parent.linear_velocity * drag_coefficient
		_parent.apply_central_force(drag_force)
		var angular_drag_force = -_parent.angular_velocity.y * angular_drag
		_parent.apply_torque(Vector3(0.0, angular_drag_force, 0.0))
			
	#_input_polling_component.get_turn()
