class_name MechanicProfession extends IProfession

@export var minimum_speed_to_repair: float = 0.5
@export var repair_points_per_minute: float = 0.5
# TODO: maybe this should be moved to the interface class?
@export var effort_for_work: float = 1.0


static func get_profession_name() -> StringName:
	return &"Mechanic"


func initialize(crew_member: CrewMember, player_node: Node) -> void:
	pass


# TODO: add caching function to professions
# or add caching here directly
func perform_work(delta: float, crew_member: CrewMember, player_node: Node) -> float:
	if player_node is not RigidBody3D or \
	player_node.linear_velocity.length() > minimum_speed_to_repair:
		return 0.0
	# we can repair here
	
	# looks hacky
	var world: World = player_node.get_tree().get_first_node_in_group(World.GROUP_NAME)
	var day_night_cycle: DayNightCycle = DayNightCycle.core().get_from(world)
	
	var durability_comp: DurabilityComponent = DurabilityComponent.core().get_from(player_node)
	var current_repair := repair_points_per_minute * crew_member.get_current_efficiency() * delta / day_night_cycle.minute_time_scale
	var repaired_durability := durability_comp.add_durability(current_repair)
	return effort_for_work * repaired_durability / current_repair
