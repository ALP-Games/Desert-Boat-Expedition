class_name CrewMember extends Resource

signal water_ration_changed(delta: int)

@export var name: String
@export var portrait: Texture
@export var water_consumption: int = 800

@export var profession: IProfession

@export var efficiency_max: float = 100
var _current_efficiency: float = efficiency_max

var rationed_water: int = 0:
	set(value):
		var delta := value - rationed_water
		rationed_water = value
		water_ration_changed.emit(delta)

## Returns float value
## 1.0 means the efficiency is at 100%
## 0.0 means the efficiency is at 0%
func get_current_efficiency() -> float:
	return _current_efficiency / efficiency_max

# this is for a 1 day grace period
#var consumes_water: bool = false

func process(delta: float, player_node: Node3D) -> void:
	if profession:
		profession.perform_work(delta, self, player_node)
