class_name WaterStorageInitializer extends IComponentInitializer

@export var water_capacity: int = 0
@export var starting_water: int = 0

func initialize_component(owner: Node) -> void:
	var water_storage := WaterStorage.core().get_from(owner) as WaterStorage
	water_storage.water_capacity = water_capacity
	water_storage.current_water = starting_water
