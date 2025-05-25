class_name NavigatorProfession extends IProfession

@export var detection_range: float = 200.0 # this will be increased to a much bigger number, probably
## In game minute
@export var scans_per_minute: float = 0.1 # maybe have some kind of variance? like on random the scans would be performed every 0,5 to 1,5 minutes
@export var effort_for_work: float = 0.3
@export var oasis_pointer_scene: PackedScene = preload("res://addons/desert_expedition_extension/scenes/oasis_pointer.tscn")

var _navigator_node: Node3D
var _detection_area: Area3D
var _detection_shape: SphereShape3D
var _instantiated_pointers: Array[Node3D]

var _day_night_cycle: DayNightCycle

var _detection_cooldown: float = 0.0

static func get_profession_name() -> StringName:
	return &"Navigator"


func initialize(crew_member: CrewMember, player_node: Node) -> void:
	# TODO: free these nodes in deinitializer when created
	_navigator_node = Node3D.new() # this node might need to have it's own script, or the child compass nodes
	_detection_area = Area3D.new()
	_detection_area.collision_layer = 0
	_detection_area.collision_mask = 0
	_detection_area.set_collision_mask_value(DeserExpedition.Layers.OASIS, true)
	var collision_shape := CollisionShape3D.new()
	_detection_shape = SphereShape3D.new()
	_detection_shape.radius = detection_range
	collision_shape.shape = _detection_shape
	_detection_area.add_child(collision_shape)
	_detection_area.name = "NavigatorDetectionArea"
	_navigator_node.add_child(_detection_area)
	_navigator_node.name = "NavigatorNode"
	player_node.add_child.call_deferred(_navigator_node)
	
	var world = player_node.get_tree().get_first_node_in_group(World.GROUP_NAME)
	_day_night_cycle = DayNightCycle.core().get_from(world)


## Returns effort spent on work
func perform_work(delta: float, crew_member: CrewMember, player_node: Node) -> float:
	_detection_cooldown += delta / _day_night_cycle.minute_time_scale * scans_per_minute
	if _detection_cooldown >= 1.0:
		_detection_cooldown -= 1.0
		_detection_shape.radius = detection_range * crew_member.get_efficiency()
		var areas := _detection_area.get_overlapping_areas()
		var pointer_defficit := areas.size() - _instantiated_pointers.size()
		if pointer_defficit > 0:
			for index in pointer_defficit:
				var pointer := oasis_pointer_scene.instantiate()
				_navigator_node.add_child(pointer)
				_instantiated_pointers.append(pointer)
		else:
			for pointer: Node3D in _instantiated_pointers:
				pointer.visible = false
				(FaceTargetComp.core().get_from(pointer) as FaceTargetComp).target = null
		
		for index in areas.size():
			var pointer := _instantiated_pointers[index]
			pointer.visible = true
			(FaceTargetComp.core().get_from(pointer) as FaceTargetComp).target = areas[index]
		return effort_for_work
	return 0.0
