@tool
class_name DeserExpedition
extends ExtendedPlugin


enum Layers {
	OASIS = 24
}


class Groups:
	const PLAYER := &"Player"
	const UI := &"UI"


static func _get_addon_root() -> String:
	return (DeserExpedition as Resource).resource_path.get_base_dir()


func _plugin_init() -> void:
	_setup_input_config()
	InputComponentGenerator.generate_input_components(false)
	_setup_groups()
	_set_layers()


func _setup_input_config() -> void:
	if ExtensionCorePlugin.input_configuration_setting.is_empty():
		return
	var input_config := ProjectSettings.get_setting(ExtensionCorePlugin.input_configuration_setting, "") as String
	if not input_config.is_empty():
		return
	ProjectSettings.set_setting(ExtensionCorePlugin.input_configuration_setting, _get_addon_root() + "/configs/input_configuration.json")


func _setup_groups() -> void:
	add_global_group(Groups.PLAYER, "Group for the player object")
	add_global_group(Groups.UI, "Group for UI elements")


func _set_layers() -> void:
	add_3d_physics_layer(Layers.OASIS, "Oasis")
