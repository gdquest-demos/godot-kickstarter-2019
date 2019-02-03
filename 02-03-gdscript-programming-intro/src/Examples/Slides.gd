extends Node


onready var _camera : Camera2D = $Camera2D

var index_active : = 0 setget set_index_active 

var _slide_current : Control
var _slide_nodes : = []


func set_index_active(value : int) -> void:
	var index_previous : = index_active
	index_active = clamp(value, 0, _slide_nodes.size() - 1)
	if index_active == index_previous:
		set_process_input(true)
	else:
		_display(index_active)


func _display(slide_index : int) -> void:
	_slide_current = _slide_nodes[slide_index]
	_camera.position = _slide_current.rect_position + _slide_current.rect_size / 2


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('ui_right'):
		self.index_active += 1
		get_tree().set_input_as_handled()
	if event.is_action_pressed('ui_left'):
		self.index_active -= 1
		get_tree().set_input_as_handled()


func _ready() -> void:
	for child in get_children():
		if not child is Control:
			continue
		_slide_nodes.append(child)
	var index : = 1
	for slide in _slide_nodes:
		var title : Label = slide.find_node("Title")
		if not title:
			continue
		title.text = "%01d. %s" % [index, title.text]
		index += 1
		
	_slide_current = _slide_nodes[index_active]
