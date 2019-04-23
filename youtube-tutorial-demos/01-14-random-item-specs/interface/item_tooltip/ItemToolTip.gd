extends Panel

onready var name_label : Label = $Column/Name
onready var column : VBoxContainer = $Column

const SPEC_LABEL = preload("res://interface/item_tooltip/SpecLabel.tscn")

func _ready() -> void:
	set_process(false)
	connect("draw", self, "_on_draw")
	connect("hide", self, "_on_hide")

func _process(delta : float) -> void:
	rect_global_position = get_viewport().get_mouse_position()
	
func _on_draw() -> void:
	set_process(true)

func _on_hide() -> void:
	set_process(false)

func initialize(item_name : String, specs : Array, rarity : ItemRarity) -> void:
	name_label.text = "%s %s" % [rarity.rarity_name, item_name]
	name_label.add_color_override("font_color", rarity.ui_color)
	for spec in specs:
		var label = SPEC_LABEL.instance()
		spec = spec as Spec
		label.text = "%s: %s" % [spec.name, spec.value]
		column.add_child(label)
