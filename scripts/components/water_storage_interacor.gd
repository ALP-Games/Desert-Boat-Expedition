## TODO: Add short component description
class_name WaterStorageInteractor
extends Component

@export var interaction_range_area: Area3D

static func core() -> ComponentCore:
	return ComponentCore.new(WaterStorageInteractor)


func _ready() -> void:
	interaction_range_area.area_entered.connect(_entered_shape)


func _entered_shape(area: Area3D) -> void:
	print("Eneterd shape - ", area.name)
