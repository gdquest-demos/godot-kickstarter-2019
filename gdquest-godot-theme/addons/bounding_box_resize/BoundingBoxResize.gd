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
	add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _interface)
	
	_selection.connect("selection_changed", self, "_on_EditorSelection_selection_changed")


func _exit_tree():
	remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _interface)


func _on_EditorSelection_selection_changed() -> void:
	var show_interface: bool = true
	show_interface = _selection.get_selected_nodes().size() > 0

	for n in _selection.get_selected_nodes():
		if n is RichTextLabel or n is TextEdit:
			continue
		show_interface = false
		break
	_interface.visible = show_interface


func _on_Button_pressed() -> void:
	var nodes: = _selection.get_selected_nodes()
	for n in nodes:
		fit_rect_vertically(n)


func fit_rect_vertically(control: Control) -> void:
	
	var undo: = get_undo_redo()
	undo.create_action("Resize Rect Vertically")

	undo.add_undo_property(control, "rect_min_size", control.rect_min_size)
	control.rect_min_size.y = get_content_size(control).y
	undo.add_do_property(control, "rect_min_size", control.rect_min_size)
	
	undo.commit_action()


"""
Note that this is generalized because Control is the unique common
ancestor between RichTextLabel and TextEdit, so to prevent any other
node to go through this function we must have an assertion on their 
text property
"""
func get_content_size(control: Control) -> Vector2:
	assert(control.has_method("get_text"))
	
	var font: Font
	var custom_font: String = "font"
	
	if control is RichTextLabel:
		custom_font = "normal_font"
	
	font = control.get_font(custom_font)
	
	return get_size_with_lines(font, control.text) + get_padding(control)


func get_size_with_lines(font: Font, string: String) -> Vector2:
	var size: = Vector2(0, 0)
	var lines: PoolStringArray = string.split("\n")
	
	for line in lines:
		var line_size: = font.get_string_size(line)
		size.x = max(size.x, line_size.x)
		size.y += max(line_size.y, font.get_height())
		
	return size


"""
Returns an offset to compensate scrollbars
"""
func get_padding(control: Control) -> Vector2:
	var padding: = Vector2(0, 0)
	
	if control is RichTextLabel:
		if control.scroll_active:
			padding = Vector2(20, 0)
	elif control is TextEdit:
		padding = Vector2(20, 20)
		
	return padding

