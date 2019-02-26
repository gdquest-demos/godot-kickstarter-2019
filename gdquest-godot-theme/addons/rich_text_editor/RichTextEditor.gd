tool
extends EditorPlugin
class_name RichTextPlugin

signal text_edit_popped(new_text_edit)

const BUTTON_SCENE: PackedScene = preload("res://addons/rich_text_editor/interface/Button.tscn")
const INTERFACE_SCENE: PackedScene = preload("res://addons/rich_text_editor/interface/RichEditorInterface.tscn")

var rich_labels: Array = []
var text_edit: TextEdit = TextEdit.new()

var _editor: = get_editor_interface()
var _button: Button = BUTTON_SCENE.instance()
var _selection: = _editor.get_selection()
var _interface: RichEditorInterface

func _ready() -> void:
	_button.hide()
	_button.connect("pressed", self, "_on_Button_pressed")
	
	if not _editor.is_plugin_enabled("gdquest_docker"):
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, _button)
	
	_selection.connect("selection_changed", self, "_on_EditorSelection_selection_changed")


func _exit_tree() -> void:
	if not _editor.is_plugin_enabled("gdquest_docker"):
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, _button)


func _on_Button_pressed() -> void:
	initialize_interface()


func _on_TextEdit_tree_exited() -> void:
	_button.disabled = false


func _on_TextEdit_text_changed() -> void:
	var undo: = get_undo_redo()
	
	undo.create_action("Set BBCode Text")
	for rich_text_label in rich_labels:
		rich_text_label.bbcode_enabled = true
		undo.add_undo_property(rich_text_label, "bbcode_text", rich_text_label.bbcode_text)
		undo.add_do_property(rich_text_label, "bbcode_text", text_edit.text)
		rich_text_label.bbcode_text = text_edit.text
	
	undo.commit_action()


func _on_ColorButton_popup_closed() -> void:
	colorize_selection(_interface.color_button.color)


func _on_EditorSelection_selection_changed() -> void:
	var rich_labels_only: = is_rich_text_selection(_selection)
	if rich_labels_only:
		rich_labels = _selection.get_selected_nodes()
	else:
		rich_labels.clear()
	
	_button.visible = rich_labels_only


func _on_ColorPalette_color_picked(hex_color: String) -> void:
	_interface.color_button.color = Color(hex_color)
	colorize_selection(Color(hex_color))


func initialize_interface():
	_interface = INTERFACE_SCENE.instance()
	
	if not _editor.is_plugin_enabled("gdquest_docker"):
		_editor.get_base_control().add_child(_interface)
	emit_signal("text_edit_popped", _interface)
	
	text_edit = _interface.text_edit
	
	if rich_labels.size() < 2:
		var rich_text: RichTextLabel = _editor.get_selection().get_selected_nodes()[0]
		text_edit.text = rich_text.text
		if rich_text.bbcode_enabled and not rich_text.bbcode_text.empty():
			text_edit.text = rich_text.bbcode_text
	
	text_edit.connect("text_changed", self, "_on_TextEdit_text_changed")
	text_edit.connect("tree_exited", self, "_on_TextEdit_tree_exited")
	
	_interface.bold_button.connect("pressed", self, "bold_selection")
	_interface.italic_button.connect("pressed", self, "italic_selection")
	_interface.color_button.connect("popup_closed", self, "_on_ColorButton_popup_closed")
	
	_button.disabled = true


func get_plugin_name() -> String:
	return "rich_text_editor"


func get_interface() -> Control:
	return _button


func colorize_selection(color: Color) -> void:
	var text: = text_edit.get_selection_text()
	text = "%s" + text + "%s"
	text = text%["[color=#" + color.to_html() + "]", "[/color]"]
	
	insert_bbcode_text(text)


func bold_selection() -> void:
	var text: = text_edit.get_selection_text()
	text = "%s" + text + "%s"
	text = text%["[b]", "[/b]"]
	
	insert_bbcode_text(text)


func italic_selection() -> void:
	var text: = text_edit.get_selection_text()
	text = "%s" + text + "%s"
	text = text%["[i]", "[/i]"]
	
	insert_bbcode_text(text)


func insert_bbcode_text(new_text: String) -> void:
	var undo: = get_undo_redo()
	
	undo.create_action("Insert BBCode Text")
	
	undo.add_undo_property(text_edit, "text", text_edit.text)
	text_edit.cut()
	text_edit.insert_text_at_cursor(new_text)
	undo.add_do_property(text_edit, "text", text_edit.text)
	undo.commit_action()


static func is_rich_text_selection(selection: EditorSelection) -> bool:
	var rich_labels_only: bool = true
	var nodes: Array = selection.get_selected_nodes()
	
	rich_labels_only = nodes.size() > 0
	
	for node in nodes:
		if not node is RichTextLabel:
			rich_labels_only = false
			break
	
	return rich_labels_only
	