tool
extends Control
class_name RichEditorInterface

onready var bold_button: Button = $VBoxContainer/HBoxContainer/Bold
onready var italic_button: Button = $VBoxContainer/HBoxContainer/Italic
onready var text_edit: TextEdit = $VBoxContainer/TextEdit
onready var color_button: ColorPickerButton = $VBoxContainer/HBoxContainer/Color
