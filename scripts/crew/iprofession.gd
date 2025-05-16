class_name IProfession extends Resource
# should this even be a resource????
# so far it does not seem like it

# TODO: figure out the architecture
# it's difficult to figure this out
# I think we need a function interface to perform the job
# but we also need a function for job condition?

func get_profession_name() -> StringName:
	assert(false, "Has to be overriden by implementation")
	return &""


func perform_work(delta: float, crew_member: CrewMember, player_node: Node3D) -> void:
	assert(false, "Has to be overriden by implementation")
