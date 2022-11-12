extends CanvasItem

signal exited(node)
signal entered(node)

var selected : Node

var _screen_ratio : Vector2


func _ready() -> void:
	get_tree().connect("screen_resized", self, "_update_screen_ratio")
	_update_screen_ratio()


func _update_screen_ratio() -> void:
	_screen_ratio = get_viewport_rect().size / OS.window_size


func _process(_delta: float) -> void:
	_check_selected_element()


func _check_selected_element() -> void:
	var space := get_world_2d().direct_space_state
	var mouse_position := get_local_mouse_position() * _screen_ratio
	var intersect := space.intersect_point(mouse_position, 1, [], 0x7FFFFFFF, true, true)

	if intersect.empty():
		if selected:
			emit_signal("exited", selected)
			selected = null
		return

	if intersect[0].collider == selected:
		return

	selected = intersect[0].collider

	emit_signal("entered", selected)
