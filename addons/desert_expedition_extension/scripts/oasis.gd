extends Area3D

@export var component_initializers: Array[IComponentInitializer]

func _ready() -> void:
	ComponentInitializerWorker.initialize_components(self, component_initializers)
	component_initializers.clear()
