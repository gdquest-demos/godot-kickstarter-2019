tool
extends CheckBox
class_name PluginCheckBox

var plugin_name : String = "" setget set_plugin_name

func set_plugin_name(new_name : String):
	plugin_name = new_name
	text = plugin_name.capitalize()
