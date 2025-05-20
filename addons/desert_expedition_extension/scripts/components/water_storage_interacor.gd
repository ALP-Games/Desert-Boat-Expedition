## TODO: Add short component description
class_name WaterStorageInteractor
extends Component

signal possible_to_interact(node: Node3D)
signal interaction_closed

@export var interaction_range_area: Area3D

var _water_storage: WaterStorage

var _interaction_targets: Array[Node3D]

static func core() -> ComponentCore:
	return ComponentCore.new(WaterStorageInteractor)


func _ready() -> void:
	interaction_range_area.area_entered.connect(_entered_shape)
	interaction_range_area.area_exited.connect(_exited_shape)
	_water_storage = WaterStorage.core().get_from(get_parent())
	assert(_water_storage != null, "Water storage component on parent is required!")
	set_physics_process(false)
	possible_to_interact.connect(func(node: Node3D):set_physics_process(true))
	interaction_closed.connect(func():set_physics_process(false))


func _entered_shape(area: Area3D) -> void:
	var foreign_storage := WaterStorage.core().get_from(area) as WaterStorage
	if foreign_storage != null and foreign_storage.current_water > 0:
		if _interaction_targets.is_empty():
			possible_to_interact.emit(area)
		_interaction_targets.append(area)


func _exited_shape(area: Area3D) -> void:
	var index := _interaction_targets.find(area)
	if index != -1:
		_interaction_targets.remove_at(index)
	if _interaction_targets.is_empty():
		interaction_closed.emit()
	elif index == 0:
		possible_to_interact.emit(_interaction_targets.front())


func _physics_process(delta: float) -> void:
	var input_poller := LocalInputPollComponent.core().get_from(get_parent()) as IInputPollingComponent
	if input_poller.get_refill().is_just_pressed():
		var avalible_capacity := _water_storage.get_avalible_capacity()
		var other_storage: WaterStorage = WaterStorage.core().get_from(_interaction_targets.front())
		_water_storage.current_water += other_storage.take_out_water_amount(avalible_capacity)
