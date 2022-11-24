extends CanvasItem

signal exited(node)
signal entered(node)
signal interact(node)
signal help(node)
signal drag(node)
signal drop(node)

export(int, LAYERS_2D_PHYSICS) var layers_2d_physics

var _context : Node
var _selected : Node2D
var _dragging : Node2D = null
var _drag_offset : Vector2
var _pressed : Node2D
var _locks := 0


func set_context(context: Node) -> void:
	_context = context
	set_process(_context != null)


func is_locked() -> bool:
	return _locks > 0


func lock(lock: bool) -> void:
	_locks = max(0, _locks + 1 if lock else -1)
	if is_locked():
		if _dragging:
			emit_signal("drop", _dragging)
			_dragging = null
		_pressed = null
	else:
		set_process(true)


func _process(_delta: float) -> void:
	if _context == null:
		set_process(false)

	if not _dragging:
		_check_selected_element()


func _check_selected_element() -> void:
	var collided := _get_objects_intersected()

	var collider : Node
	for intersect in collided:
		if _is_selectable(intersect.collider):
			collider = intersect.collider
			break

	if _selected and collider != _selected:
		emit_signal("exited", _selected)
		_selected = null

	if collider and collider != _selected:
		_selected = collider
		emit_signal("entered", _selected)


func _get_objects_intersected() -> Array:
	if is_locked():
		set_process(false)
		return []

	var space := get_world_2d().direct_space_state
	var mouse_position : Vector2 = get_tree().root.get_mouse_position()

	return space.intersect_point(
		mouse_position, 64, [],
		layers_2d_physics,
		true, true
	)


func _is_selectable(node: CanvasItem) -> bool:
	if not node or not node.visible:
		return false

	if not _context.is_a_parent_of(node):
		return false

	if node.has_method("is_selectable") and not node.is_selectable():
		return false

	return true


func _input(event: InputEvent) -> void:
	if _pressed and _is_drag_event(event) and _is_draggable(_selected):
		_on_drag(event.position)

	elif event is InputEventMouseButton:
		_on_button(event)


func _is_drag_event(event: InputEvent) -> bool:
	if event is InputEventMouseMotion:
		return true

	if event is InputEventScreenDrag:
		return event.relative

	return event is InputEventMouseMotion or event is InputEventScreenDrag


func _on_button(event: InputEventMouseButton) -> void:
	if event.button_index == BUTTON_RIGHT and _selected and not _dragging and not event.is_pressed():
		_request_help(_selected)
		return

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


func _request_help(node: Node) -> void:
	emit_signal("help", node)
