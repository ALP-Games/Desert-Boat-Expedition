class_name CrewMember extends Resource

signal water_ration_changed(delta: int)

@export var name: String
@export var portrait: Texture
@export var water_consumption: int = 800

var rationed_water: int = 0:
	set(value):
		var delta := value - rationed_water
		rationed_water = value
		water_ration_changed.emit(delta)

# this is for a 1 day grace period
#var consumes_water: bool = false

#func _phy
