tool
extends TextEdit
"""
Adds syntax highlighting for common GDScript keywords on
top of TextEdit's defaults
"""


export var class_color : = Color(0.6, 0.6, 1.0)
export var member_color : = Color(0.6, 1.0, 0.6)
export var keyword_color : = Color(1.0, 0.6, 0.6)
export var quotes_color : = Color(1.0, 1.0, 0.6)
export var comments_color : = Color("959595")


func _ready() -> void:
	_add_keywords_highlighting()


func _add_keywords_highlighting() -> void:
	add_color_region('"', '"', quotes_color)
	add_color_region("'", "'", quotes_color)
	add_color_region("# ", "\n", comments_color, true)
	
	var classes : = ClassDB.get_class_list()
	for cls in classes:
		add_keyword_color(cls, class_color)
		var properties : = ClassDB.class_get_property_list(cls)
		for property in properties:
			for key in property:
				add_keyword_color(key, member_color)
	
	var content : = get_file_content("res://src/Components/text_edit/keywords.json")
	var keywords : Array = parse_json(content)
	for keyword in keywords:
		add_keyword_color(keyword, keyword_color)


func get_file_content(path:String) -> String:
	var file = File.new()
	var error : int = file.open(path, file.READ)
	var content : = ""
	if error == OK:
		content = file.get_as_text()
		file.close()
	return content
