@tool
class_name StatUI extends HBoxContainer

@export var stat_name: String = "Stat":
	set(value):
		stat_name = value
		if value == null:
			stat_name_label.text = ""
		if is_node_ready():
			stat_name_label.text = value
@export var bar_color: Color = Color.WHITE:
	set(value):
		bar_color = value
		if is_node_ready():
			stat_representation_bar.modulate = value
#@export var bar_style_texture: StyleBoxTexture = load("res://resources/ui/white_bar.tres"):
	#set(value):
		#bar_style_texture = value
		#if is_node_ready():
			#stat_representation_bar.add_theme_stylebox_override("fill", value)
@export var bar_fill_mode: ProgressBar.FillMode = ProgressBar.FillMode.FILL_BEGIN_TO_END:
	set(value):
		if value == null:
			return
		bar_fill_mode = value
		if is_node_ready():
			stat_representation_bar.fill_mode = value

@onready var stat_name_label := $StatNameContainer/StatName
@onready var stat_representation_bar := $StatReprerentationContainer/ProgressBar

func _ready() -> void:
	stat_name_label.text = stat_name
	stat_representation_bar.modulate = bar_color
	stat_representation_bar.fill_mode = bar_fill_mode
	#stat_representation_bar.add_theme_stylebox_override("fill", bar_style_texture)
