tool
extends EditorPlugin
"""
A container for plugins' widgets that provides an easy access to enable/disable valid plugins

Notes
---
A valid plugin must have the EditorPlugin.get_plugin_name() -> String virtual method implemented
and also a custom get_interface() -> Control method implemented.
"""

onready var _interface: Docker
onready var _editor: EditorInterface = get_editor_interface()

const INTERFACE_SCENE: PackedScene = preload("res://addons/gdquest_docker/interface/Docker.tscn")
const PLUGIN_CHECKBOX: PackedScene = preload("res://addons/gdquest_docker/interface/plugin_checkbox/PluginCheckBox.tscn")
const ADDONS_FOLDER_PATH: String = "res://addons"


func _enter_tree() -> void:
	_interface = INTERFACE_SCENE.instance()
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_UL, _interface)


func _exit_tree() -> void:
	var plugins: = _interface.get_plugins_list()

	for checkbox in plugins.get_children():
		if not checkbox.pressed:
			continue
		_editor.set_plugin_enabled(checkbox.plugin_name, false)

	remove_control_from_docks(_interface)

func _ready():
	load_plugins()


func load_plugins() -> void:
	var addons_folder: Directory = Directory.new()
	if not addons_folder.dir_exists(ADDONS_FOLDER_PATH):
		return

	addons_folder.open(ADDONS_FOLDER_PATH)
	addons_folder.list_dir_begin(true)
	var addon: String = addons_folder.get_next()

	while not addon == "":
		add_plugin_to_list(addon)
		addon = addons_folder.get_next()


func add_plugin_to_list(plugin_name: String) -> void:
	if plugin_name == get_plugin_name():
		return

	var plugin_checkbox: PluginCheckBox = PLUGIN_CHECKBOX.instance()
	plugin_checkbox.plugin_name = plugin_name
	plugin_checkbox.connect("toggled", self, "set_plugin_enabled", [plugin_name])
	_interface.add_plugin_checkbox(plugin_checkbox)


func remove_plugin_from_list(plugin_name: String) -> void:
	var plugins_list: = _interface.get_plugins_list()

	for c in plugins_list:
		if c.plugin_name == plugin_name:
			_interface.remove_plugin_checkbox(c)
			break


func add_widget(widget : Control) -> void:
	var container: = _interface.get_widget_container()
	container.add_child(widget)


func remove_widget(widget : Control) -> void:
	var container: = _interface.get_widget_container()
	container.remove_child(widget)


func set_plugin_enabled(enabled: bool, plugin_name: String) -> void:
	if not _editor.is_plugin_enabled(plugin_name):
		if enabled:
			_editor.set_plugin_enabled(plugin_name, true)

	var plugin: = get_plugin(plugin_name)

	if plugin.has_method("get_interface"):
		if enabled:
			add_widget(plugin.get_interface())
		else:
			remove_widget(plugin.get_interface())
			_editor.set_plugin_enabled(plugin_name, enabled)


func get_plugin_name() -> String:
	return "gdquest_docker"


"""
Currently is not possible to get the plugin's node directly in the Editor,
i.e. to simply EditorInterface.get_plugin(String plugin_name) -> EditorPlugin
So these two methods are used as a workaround to find an EditorPlugin's Node
"""
func get_plugins_list() -> Array:
	var plugins: Array = []

	"""
	Since is uncertain what is the actual Node's name in the parent,
	we presume that an EditorPlugin is valid when it implements the
	get_plugin_name virtual method, otherwise we ignore it
	"""
	for n in get_parent().get_children():
		if not n.has_method("get_plugin_name"):
			continue
		if n.get_plugin_name() == "":
			continue
		plugins.append(n)

	return plugins


func get_plugin(plugin_name) -> EditorPlugin:
	var plugin: = EditorPlugin.new()
	for p in get_plugins_list():
		if p.get_plugin_name() == plugin_name:
			plugin = p
			break
	return plugin
