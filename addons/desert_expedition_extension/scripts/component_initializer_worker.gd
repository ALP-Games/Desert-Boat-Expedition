class_name ComponentInitializerWorker

static func initialize_components(owner: Node, initializers: Array[IComponentInitializer]) -> void:
	for initializer in initializers:
		initializer.initialize_component(owner)
