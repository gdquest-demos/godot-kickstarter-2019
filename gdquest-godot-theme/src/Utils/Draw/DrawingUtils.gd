extends CanvasItem
# Drawing utilities for tool scripts in the viewport or in-game visual debugging
# Use sprites, SVG shapes, or meshes instead of drawing from the code whenever possible

const DEFAULT_POINTS_COUNT : = 32

func draw_circle_outline(radius:float, color:=Color(), offset:=Vector2(), thickness:=1.0) -> void:
	var points_array : = PoolVector2Array()
	for i in range(DEFAULT_POINTS_COUNT + 1):
		var angle : = 2 * PI * i / DEFAULT_POINTS_COUNT
		var point : = offset + Vector2(cos(angle) * radius, sin(angle) * radius)
		points_array.append(point)
	draw_polyline(points_array, color, thickness, true)
