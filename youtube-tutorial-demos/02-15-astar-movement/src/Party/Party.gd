extends YSort
"""
This can be thought of as the player object.

It has multiple Members (child nodes) that it manages. The leader Member (child node with index
position of 0) is special. He has the Detect node which is a four RayCast2D system pointing
South, West, North & East as expected. Apart from that the leader also gets the RemoteTransform
which is used with the Camera. This has to be done to simplify Camera movement when cycling
through Member positions. Without it, it would be a bit tricky to make the Camera move smoothly.

The Detect scene is used by the Walk behavior to verify adjacent encounters. It does this so we
have a way of identifying which encounter the Party... encounters. This tirggers some changes in
the in other Systems like Dialog etc. (to be further explored).
"""


var _cell_size: = Utils.V2_00


func setup(board_size: Vector2, cell_size: Vector2) -> void:
	_cell_size = cell_size
	for member in get_members():
		member.setup(board_size)


func get_member_count() -> int:
	return get_child_count() - 1


func get_members() -> Array:
	var members: = []
	for member in get_children():
		not member is Camera2D and members.push_back(member)
	return members


func get_member(idx: int) -> Node:
	var member: = get_child(idx) if idx >= 0 and idx < get_member_count() else null
	member = null if member is Camera2D else member
	return member


func get_member_by_position(p: Vector2) -> Node:
	var member: Node = null
	for m in get_members():
		if (m.position - p).length() < (_cell_size/2).length():
			member = m
			break
	return member