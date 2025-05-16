class_name MechanicProfession extends IProfession

@export var minimum_speed_to_repair: float = 0.5
@export var repair_points_per_minute: float = 0.5


func get_profession_name() -> StringName:
	return &"Mechanic"


func perform_work(delta: float, crew_member: CrewMember, player_node: Node3D) -> void:
	
	if player_node is not RigidBody3D or \
	player_node.linear_velocity.length() > minimum_speed_to_repair:
		return
	# we can repair here
	var durability_comp: DurabilityComponent = DurabilityComponent.core().get_from(player_node)
	var current_repair := repair_points_per_minute * crew_member.get_current_efficiency() * delta
	durability_comp.add_durability(current_repair)
