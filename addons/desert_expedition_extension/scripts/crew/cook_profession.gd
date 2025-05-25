class_name CookProfession extends IProfession

@export var water_efficiency: float = 0.35
# TODO: maybe this should be moved to the interface class?
@export var effort_for_work: float = 75.0

var effort_expanded: float = 0.0
var job_callable: Callable

static func get_profession_name() -> StringName:
	return &"Cook"


func initialize(crew_member: CrewMember, player_node: Node) -> void:
	var world: World = player_node.get_tree().get_first_node_in_group(World.GROUP_NAME)
	var day_night_cycle: DayNightCycle = DayNightCycle.core().get_from(world)
	job_callable = func()->void:
		var current_water_efficiency := 1.0 - (water_efficiency * crew_member.get_efficiency())
		# TODO: maybe fatigue check should be done before we calc efficiency
		effort_expanded = effort_for_work
		var crew_cabin: CrewCabin = CrewCabin.core().get_from(player_node)
		for cabin_member in crew_cabin.crew_members:
			cabin_member.set_water_consumption_multiplier(current_water_efficiency)
	day_night_cycle.morning_started.connect(job_callable)


# has to be executed when day starts
# we would get the efficiency stat
# so maybe it should be bound to morning?
# needs to be executed before UI is showm?
# or can it update ui during runtime?
func perform_work(delta: float, crew_member: CrewMember, player_node: Node) -> float:
	var effort_from_work := effort_expanded
	effort_expanded = 0.0
	return effort_from_work
