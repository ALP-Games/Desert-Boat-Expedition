## TODO: Add short component description
class_name DurabilityComponent
extends Component

signal durability_ran_out


@export var max_durability: float

@onready var _current_durability: float = max_durability:
	set(value):
		if value <= 0.0:
			if _current_durability > 0.0:
				durability_ran_out.emit()
			_current_durability = 0.0
		else:
			_current_durability = value


static func core() -> ComponentCore:
	return ComponentCore.new(DurabilityComponent)


func get_durability() -> float:
	return _current_durability


func add_durability(amount: float) -> float:
	if _current_durability + amount > max_durability:
		var result := max_durability - _current_durability
		_current_durability = max_durability
		return result
	_current_durability += amount
	return amount


func subtract_durability(amount: float) -> void:
	_current_durability -= amount
