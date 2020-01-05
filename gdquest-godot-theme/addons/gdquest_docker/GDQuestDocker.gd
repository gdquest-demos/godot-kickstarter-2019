tool
extends EditorPlugin
# A container for plugins' widgets that provides an easy access to enable/disable valid plugins

# # Notes
# ---
# A valid plugin must have the EditorPlugin.get_plugin_name() -> String virtual method implemented
# and also a custom get_interface() -> Control method implemented.

const INTERFACE_SCENE: PackedScene = preload("res://addons/gdquest_docker/interface/Docker.tscn")
const ADDONS_FOLDER_PATH: String = "res://addons"

var _interface: Docker = INTERFACE_SCENE.instance()
var _editor: EditorInterface = get_editor_interface()
var _selection: EditorSelection = _editor.get_selection()
var _plugins: Array = []

func _enter_tree() -> void:
	add_control_to_dock(EditorPlugin.DOCK_SLOT_LEFT_BR, _interface)
	_selection.connect("selection_changed", self, "_on_selection_changed")


func _exit_tree() -> void:
	remove_control_from_docks(_interface)


func _ready():
	load_plugins()
	_initialize()


func _initialize() -> void:
	for plugin in _plugins:
		if validate_plugin(plugin):
			add_widget(get_plugin(plugin).get_interface())
		else:
			remove_plugin_from_list(plugin)
		
	hook_color_palette()
	hook_rich_editor()


func _on_selection_changed() -> void:
	if not _editor.is_plugin_enabled("rich_text_editor"):
		return
	var widgets: Control = _interface.get_widget_container()
	
	if widgets.has_node("RichEditorInterface"):
		widgets.get_node("RichEditorInterface").queue_free()
		
	var plugin: RichTextPlugin = get_plugin("rich_text_editor") as RichTextPlugin
	
	if RichTextPlugin.is_rich_text_selection(_selection):
		plugin.initialize_interface()

func get_plugin_name() -> String:
	return "gdquest_docker"


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
	_plugins.append(plugin_name)


func remove_plugin_from_list(plugin_name: String) -> void:
	_plugins.erase(plugin_name)


func add_widget(widget : Control) -> void:
	var container: = _interface.get_widget_container()
	container.add_child(widget)


func remove_widget(widget : Control) -> void:
	var container: = _interface.get_widget_container()
	container.remove_child(widget)


func validate_plugin(plugin_name: String) -> bool:
	#Plugins must be enabled to be validated
	var is_enabled: = _editor.is_plugin_enabled(plugin_name)
	if not is_enabled:
		_editor.set_plugin_enabled(plugin_name, true)
	var plugin: = get_plugin(plugin_name)
		
	var is_valid: bool = false
	is_valid = not plugin.get_plugin_name() == ""
	is_valid = plugin.has_method("get_interface")
	
	if not is_enabled and not is_valid:
		_editor.set_plugin_enabled(plugin_name, false)
	
	return is_valid


func hook_color_palette() -> void:
	if not _editor.is_plugin_enabled("color_palette"):
		return
	if not _editor.is_plugin_enabled("rich_text_editor"):
		return
	
	var color_palette: ColorPalette = get_plugin("color_palette").get_interface() as ColorPalette
	var rich_editor: RichTextPlugin = get_plugin("rich_text_editor") as RichTextPlugin
	
	if not color_palette.is_connected("color_picked", rich_editor, "_on_ColorPalette_color_picked"):
		color_palette.connect("color_picked", rich_editor, "_on_ColorPalette_color_picked")


func hook_rich_editor() -> void:
	if not _editor.is_plugin_enabled("rich_text_editor"):
		return
		
	var rich_editor: RichTextPlugin = get_plugin("rich_text_editor") as RichTextPlugin
	
	if not rich_editor.is_connected("text_edit_popped", self, "add_widget"):
		rich_editor.connect("text_edit_popped", self, "add_widget")


# Currently is not possible to get the plugin's node directly in the Editor,
# i.e. to simply EditorInterface.get_plugin(String plugin_name) -> EditorPlugin
# So these two methods are used as a workaround to find an EditorPlugin's Node
func get_plugins_list() -> Array:
	var plugins: Array = []

	# Since is uncertain what is the actual Node's name in the parent,
	# we presume that an EditorPlugin is valid when it implements the
	# get_plugin_name virtual method, otherwise we ignore it
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
