tool
extends MarginContainer
class_name Docker

onready var _widget_container: VBoxContainer = $Column/WidgetContainer/List
onready var _plugins_list: VBoxContainer = $Column/PluginsList

func get_widget_container() -> VBoxContainer:
	return _widget_container as VBoxContainer


func get_plugins_list() -> VBoxContainer:
	return _plugins_list as VBoxContainer


func add_plugin_checkbox(checkbox: PluginCheckBox) -> void:
	_plugins_list.add_child(checkbox)


func remove_plugin_checkox(checkbox: PluginCheckBox) -> void:
	_plugins_list.remove_child(checkbox)


func _on_Plugins_toggled(button_pressed: bool):
	_plugins_list.visible = button_pressed

