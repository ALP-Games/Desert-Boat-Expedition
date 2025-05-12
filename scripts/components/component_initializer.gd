## TODO: Add short component description
class_name ComponentInitializer
extends Component

@export var component_initializers: Array[IComponentInitializer]


static func core() -> ComponentCore:
	return ComponentCore.new(ComponentInitializer)


func _ready() -> void:
	for initializer in component_initializers:
		initializer.initialize_component(get_parent())
	queue_free()
