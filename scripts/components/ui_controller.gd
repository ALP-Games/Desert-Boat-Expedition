## TODO: Add short component description
class_name UIController
extends Component


var _input_poller: LocalInputPollComponent

enum UIState {
	GAMEPLAY,
	CREW_OVERVIEW
}
var _current_state := UIState.GAMEPLAY

static func core() -> ComponentCore:
	return ComponentCore.new(UIController)


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_input_poller = LocalInputPollComponent.core().get_from(get_parent())
	#var crew_overview_ui: CrewOverviewUI = get_tree().get_first_node_in_group(CrewOverviewUI.GROUP_NAME) 
	#crew_overview_ui.visible = false


func _physics_process(delta: float) -> void:
	match _current_state:
		UIState.GAMEPLAY:
			_process_gameplay_state(delta)
		UIState.CREW_OVERVIEW:
			_process_crew_overview_state(delta)


func _process_gameplay_state(delta: float) -> void:
	if _input_poller.get_toggle_crew_menu().is_just_pressed():
		_current_state = UIState.CREW_OVERVIEW
		# or maybe better to keep track of all the currently active nodes?
		# don't matter for now
		# there was that cool idea about UI stack I had when working on CF!
		#_disable_all_ui_nodes()
		var crew_overview_ui: CrewOverviewUI = get_tree().get_first_node_in_group(CrewOverviewUI.GROUP_NAME)
		crew_overview_ui.visible = true
		get_tree().paused = true


func _process_crew_overview_state(delta: float) -> void:
	if _input_poller.get_toggle_crew_menu().is_just_pressed() or\
	_input_poller.get_back().is_just_pressed():
		_current_state = UIState.GAMEPLAY
		#_disable_all_ui_nodes()
		var crew_overview_ui: CrewOverviewUI = get_tree().get_first_node_in_group(CrewOverviewUI.GROUP_NAME)
		crew_overview_ui.visible = false
		#var gameplay_ui: GameplayUI = get_tree().get_first_node_in_group(GameplayUI.GROUP_NAME)
		#gameplay_ui.visible = true
		get_tree().paused = false


func _disable_all_ui_nodes() -> void:
	var ui_nodes := get_tree().get_nodes_in_group(GlobalStrings.UI_GROUP)
	for ui_node: Control in ui_nodes:
		ui_node.visible = false
