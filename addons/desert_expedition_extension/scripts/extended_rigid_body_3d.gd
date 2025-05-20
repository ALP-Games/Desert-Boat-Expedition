class_name ExtendedRigidBody3D extends RigidBody3D

signal on_integrate_forces(state: PhysicsDirectBodyState3D)

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	on_integrate_forces.emit(state)
