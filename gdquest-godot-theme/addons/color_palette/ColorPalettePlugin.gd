tool
extends EditorPlugin
# Enable the use of palettes to set CanvasItem's modulate from an easily accessible dock
onready var _interface: ColorPalette setget , get_interface

const PATH: = "res://addons/color_palette/palettes/"
const INTERFACE_SCENE: PackedScene = preload("res://addons/color_palette/interface/ColorPalette.tscn")

var palettes: Dictionary = {}
var _editor: = get_editor_interface()

func _enter_tree() -> void:
	_interface = INTERFACE_SCENE.instance() as ColorPalette
	_interface.connect("color_picked", self, "set_canvas_items_modulate")
	_interface.connect("palette_selected", self, "update_palette")

	if not _editor.is_plugin_enabled("gdquest_docker"):
		add_control_to_dock(DOCK_SLOT_LEFT_BL, _interface)
	
	load_palettes(PATH)
	update_palette(palettes.keys()[0])


func _exit_tree():
	if not _editor.is_plugin_enabled("gdquest_docker"):
		remove_control_from_docks(_interface)


func get_interface() -> ColorPalette:
	return _interface as ColorPalette


func get_plugin_name() -> String:
	return "color_palette"


func load_palettes(palettes_folder) -> void:
	var directory: Directory = Directory.new()

	if directory.dir_exists(palettes_folder):
		directory.open(palettes_folder)
		directory.list_dir_begin(true)
		var file_name: String = directory.get_next()
		var file: File = File.new()

		while file_name != "":
			file.open(palettes_folder + file_name, file.READ)

			var palette: Dictionary = parse_json(file.get_as_text())
			add_palette(palette["id"], palette)

			file_name = directory.get_next()


func update_palette(palette_name: String) -> void:
	_interface.clear()

	var palette: Dictionary = palettes[palette_name]
	_interface.title = palette["name"]

	var colors: Dictionary = palette["colors"]
	for color in colors.values():
		_interface.add_swatch(color)


func add_palette(unique_name: String, palette: Dictionary) -> void:
	assert(not palettes.has(unique_name))

	palettes[unique_name] = palette
	_interface.add_palette(unique_name)


func set_canvas_items_modulate(hex_color: String) -> void:
	var selection: = get_editor_interface().get_selection()
	if selection.get_selected_nodes().size() < 1:
		return
	
	var undo: = get_undo_redo()
	undo.create_action("Set Modulate")
	
	for n in selection.get_selected_nodes():
		if not n.has_method("set_modulate") or n is RichTextLabel:
			continue
		undo.add_undo_property(n, "modulate", n.modulate)
		n.modulate = Color(hex_color)
		undo.add_do_property(n, "modulate", n.modulate)
	
	undo.commit_action()

