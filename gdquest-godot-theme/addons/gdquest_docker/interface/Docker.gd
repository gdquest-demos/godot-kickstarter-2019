tool
extends MarginContainer
class_name Docker

onready var _widget_container: VBoxContainer = $Column/WidgetContainer/List

func get_widget_container() -> VBoxContainer:
	return _widget_container as VBoxContainer

