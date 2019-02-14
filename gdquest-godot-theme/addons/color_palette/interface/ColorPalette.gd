tool
extends MarginContainer
class_name ColorPalette
"""
An interface to display color palettes as sequence of buttons
"""

signal palette_selected(palette_name)
signal color_picked(hex_color)

export (PackedScene) var color_swatch: PackedScene = preload("res://addons/color_palette/interface/color_swatch/ColorSwatch.tscn")
var title: String = "Palette Name" setget set_title

func set_title(new_title: String) -> void:
	title = new_title
	var label: = $Column/Label
	label.text = title


func add_swatch(color_hex: String) -> void:
	var new_swatch: ColorSwatch = color_swatch.instance()
	var color: = Color(color_hex)
	new_swatch.color = color
	new_swatch.connect("button_up", self, "_on_Swatch_button_up", [new_swatch.color])
	
	var grid: = $Column/Grid
	grid.add_child(new_swatch)


func add_palette(unique_name: String) -> void:
	var option_button: = $Column/OptionButton
	option_button.add_item(unique_name)


func clear() -> void:
	for c in $Column/Grid.get_children():
		c.queue_free()


func _on_OptionButton_item_selected(ID: int) -> void:
	var option_button = $Column/OptionButton
	emit_signal("palette_selected", option_button.get_item_text(ID))


func _on_Swatch_button_up(color: Color) -> void:
	var hex_color: = color.to_html()
	emit_signal("color_picked", hex_color)

