class_name IProfession extends Resource
# should this even be a resource????
# so far it does not seem like it

# TODO: figure out the architecture
# it's difficult to figure this out
# I think we need a function interface to perform the job
# but we also need a function for job condition?

static func get_profession_name() -> StringName:
	assert(false, "Has to be overriden by implementation")
	return &""


## Returns effort spent on work
func perform_work(delta: float, crew_member: CrewMember, player_node: Node3D) -> float:
	assert(false, "Has to be overriden by implementation")
	return 0.0
