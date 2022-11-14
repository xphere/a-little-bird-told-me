extends CanvasItem

signal exited(node)
signal entered(node)

var selected : CollisionObject2D

var _context : Node


func set_context(context: Node) -> void:
	_context = context
	set_process(_context != null)


func _process(_delta: float) -> void:
	if _context == null:
		set_process(false)

	_check_selected_element()


func _check_selected_element() -> void:
	var space := get_world_2d().direct_space_state
	var mouse_position : Vector2 = get_tree().root.get_mouse_position()
	var intersects := space.intersect_point(mouse_position, 64, [], 0x7FFFFFFF, true, true)

	var collider : Node
	for intersect in intersects:
		var collision := intersect.collider as CanvasItem
		if not collision or not collision.visible:
			continue

		if _context.is_a_parent_of(collision):
			collider = collision
			break

	if collider == null:
		if selected:
			emit_signal("exited", selected)
			selected = null
		return

	if collider == selected:
		return

	selected = collider

	emit_signal("entered", selected)
