extends CanvasItem


signal exited(node)
signal entered(node)
signal interact(node)
signal drag(node)
signal drop(node)


var _context : Node
var _selected : Node2D
var _dragging : Node2D = null
var _drag_offset : Vector2
var _pressed : Node2D


func set_context(context: Node) -> void:
	_context = context
	set_process(_context != null)


func _process(_delta: float) -> void:
	if _context == null:
		set_process(false)

	if not _dragging:
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
		if _selected:
			emit_signal("exited", _selected)
			_selected = null
		return

	if collider == _selected:
		return

	_selected = collider

	emit_signal("entered", _selected)


func _input(event: InputEvent) -> void:
	if _pressed and _is_drag_event(event) and _is_draggable(_selected):
		_on_drag(event.position)

	elif event is InputEventMouseButton:
		_on_button(event)


func _is_drag_event(event: InputEvent) -> bool:
	return event is InputEventMouseMotion or event is InputEventScreenDrag


func _on_button(event: InputEventMouseButton) -> void:
	if event.button_index != BUTTON_LEFT:
		return

	if event.is_pressed():
		if _selected:
			_pressed = _selected
			_drag_offset = _selected.global_position - event.position

	elif _dragging:
		emit_signal("drop", _dragging)
		_dragging = null
		_pressed = null

	elif _selected and _selected == _pressed:
		_pressed = null
		_interact_with(_selected)


func _is_draggable(node: Node) -> bool:
	return node and node.has_method("is_draggable") and node.is_draggable()


func _on_drag(position: Vector2) -> void:
	if not _pressed:
		return

	if not _dragging:
		_dragging = _pressed
		emit_signal("drag", _dragging)

	_dragging.drag_to(_drag_offset + position)


func _interact_with(node: Node) -> void:
	emit_signal("interact", node)
