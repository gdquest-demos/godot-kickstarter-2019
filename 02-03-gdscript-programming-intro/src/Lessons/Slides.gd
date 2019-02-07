tool
extends CanvasItem


onready var _camera : Camera2D = $Camera2D

export var add_titles : = true

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
	_reset_slides()
	get_tree().connect("tree_changed", self, '_reset_slides')
	# Draw connecting lines
	if Engine.editor_hint:
		update()

	if add_titles:
		_prepend_number_to_titles()


"""
Stores an ordered list of children that are slides
connects to them to redraw helper lines when moving or resizing
the slides
"""
func _reset_slides() -> void:
	for slide in _slide_nodes:
		slide.disconnect('item_rect_changed', self, 'update')
	
	_slide_nodes = []
	for child in get_children():
		if not child is Control:
			continue
		_slide_nodes.append(child)
		child.connect('item_rect_changed', self, 'update')
	_slide_current = _slide_nodes[index_active]


"""
Finds title nodes and prepends 1., 2., etc.
to their text property
Only on _ready
"""
func _prepend_number_to_titles() -> void:
	var index : = 1
	for slide in _slide_nodes:
		var title : Label = slide.find_node("Title")
		if not title:
			continue
		title.text = "%01d. %s" % [index, title.text]
		index += 1


"""
Draws a line connecting the slides' center, to indicate the move order
"""
func _draw() -> void:
	if not Engine.editor_hint:
		return
	var points : = PoolVector2Array()
	for slide in _slide_nodes:
		points.append(slide.rect_position + slide.rect_size / 2)
	draw_polyline(points, Color("aa888888"), 2.0, true)
