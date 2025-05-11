## TODO: Add short component description
class_name WaterStorage
extends Component

signal water_updated(current: int, max: int)

# if capacity will rise dramatically maybe it would be worth it to add it's weight to the ship
# but in that case we would need to find out that this belongs to a rigid body
## Capacity is in liters
@export var water_capacity: int = 0

var current_water: int = 0:
	set(value):
		current_water = value
		assert(current_water <= water_capacity, "Current water should not exceed capacity!")
		water_updated.emit(current_water, water_capacity)

static func core() -> ComponentCore:
	return ComponentCore.new(WaterStorage)


func get_avalible_capacity() -> int:
	return water_capacity - current_water


func take_out_water_amount(amount: int) -> int:
	if amount > current_water:
		var result := current_water
		current_water = 0
		return result
	current_water -= amount
	return amount
