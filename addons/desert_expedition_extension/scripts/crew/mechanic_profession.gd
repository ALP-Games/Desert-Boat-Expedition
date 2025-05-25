class_name MechanicProfession extends IProfession

@export var minimum_speed_to_repair: float = 0.5
@export var repair_points_per_minute: float = 0.5
# TODO: maybe this should be moved to the interface class?
@export var effort_for_work: float = 1.0

var _day_night_cycle: DayNightCycle


static func get_profession_name() -> StringName:
	return &"Mechanic"


func initialize(crew_member: CrewMember, player_node: Node) -> void:
	var world: World = player_node.get_tree().get_first_node_in_group(World.GROUP_NAME)
	_day_night_cycle = DayNightCycle.core().get_from(world)


# TODO: add caching function to professions
# or add caching here directly
func perform_work(delta: float, crew_member: CrewMember, player_node: Node) -> float:
	if player_node is not RigidBody3D or \
	player_node.linear_velocity.length() > minimum_speed_to_repair:
		return 0.0
	
	var durability_comp: DurabilityComponent = DurabilityComponent.core().get_from(player_node)
	var current_repair := repair_points_per_minute * crew_member.get_efficiency() * delta / _day_night_cycle.minute_time_scale
	var repaired_durability := durability_comp.add_durability(current_repair)
	return effort_for_work * repaired_durability / current_repair
