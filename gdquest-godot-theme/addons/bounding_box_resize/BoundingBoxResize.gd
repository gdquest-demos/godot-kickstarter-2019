tool
extends EditorPlugin
"""
Updates RichTextLabel and TextEdit minimum rect size to fit their content
"""

onready var _editor: = get_editor_interface()
onready var _selection: = _editor.get_selection()
onready var _interface: Button

const INTERFACE_SCENE: PackedScene = preload("res://addons/bounding_box_resize/interface/RefreshButton.tscn")

func _ready() -> void:
	_interface = INTERFACE_SCENE.instance()
	_interface.visible = false
	_interface.connect("pressed", self, "_on_Button_pressed")
	
	if not _editor.is_plugin_enabled("gdquest_docker"):
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _interface)

	_selection.connect("selection_changed", self, "_on_EditorSelection_selection_changed")


func _exit_tree():
	if not _editor.is_plugin_enabled("gdquest_docker"):
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _interface)


func _on_EditorSelection_selection_changed() -> void:
	var show_interface: bool = true
	show_interface = _selection.get_selected_nodes().size() > 0

	for node in _selection.get_selected_nodes():
		if node is RichTextLabel or node is TextEdit:
			continue
		show_interface = false
		break
	_interface.visible = show_interface


func _on_Button_pressed() -> void:
	var nodes: = _selection.get_selected_nodes()
	for n in nodes:
		fit_rect_vertically(n)


func get_plugin_name() -> String:
	return "bounding_box_resize"


func get_interface() -> Control:
	return _interface


func fit_rect_vertically(control: Control) -> void:
	var content_size: = get_content_size(control)
	if content_size.y < control.rect_size.y:
		return

	var undo: = get_undo_redo()
	undo.create_action("Resize Rect Vertically")

	undo.add_undo_property(control, "rect_min_size", control.rect_min_size)
	undo.add_undo_property(control, "rect_size", control.rect_size)
	control.rect_min_size.y = content_size.y
	undo.add_do_property(control, "rect_min_size", control.rect_min_size)
	undo.add_do_property(control, "rect_size", control.rect_size)

	undo.commit_action()


"""
Note that this is generalized because Control is the unique common
ancestor between RichTextLabel and TextEdit, so to prevent any other
node to go through this function we must have an assertion on their
text property
"""
func get_content_size(control: Control) -> Vector2:
	if not control.has_method("get_text"):
		return control.rect_size

	var font: = get_control_font(control)
	var text: String = control.text

	var size: Vector2 = get_size_with_lines(text, font)
	var padding: Vector2 = get_padding(control)
	size += padding

	return size


func get_control_font(control: Control) -> Font:
	var font: Font
	var custom_font: String = "font"
	if control is RichTextLabel:
		custom_font = "normal_font"
	font = control.get_font(custom_font)
	return font


func get_size_with_lines(text: String, font: Font) -> Vector2:
	var size: = Vector2(0, 0)
	var lines: PoolStringArray = text.split("\n")

	size.y = lines.size() * font.get_height()
	size.x = get_longest_line_width(lines, font)

	return size


func get_longest_line_width(lines: PoolStringArray, font: Font) -> float:
	var larger_line_width: = 0.0
	for line in lines:
		var line_width: = font.get_string_size(line).x
		larger_line_width = max(larger_line_width, line_width)
		
	return larger_line_width


"""
Returns an offset to compensate scrollbars
"""
func get_padding(control: Control) -> Vector2:
	var padding: = Vector2(0, 0)

	if control is RichTextLabel:
		if control.scroll_active:
			padding = Vector2(30, 0)
	elif control is TextEdit:
		padding = Vector2(30, 30)

	return padding
