extends Control

var _current_state : CanvasItem


func _ready() -> void:
	to_state("Tower")


func to_state(name: String) -> void:
	if not has_node(name):
		return

	var next_state := get_node(name) as CanvasItem
	if next_state == null:
		return

	if _current_state and _current_state.has_method("on_leave"):
		_current_state.on_leave()

	_current_state = next_state
	$Cursor.set_context(_current_state)

	if _current_state and _current_state.has_method("on_enter"):
		_current_state.on_enter()


func dialog(speaker: String, contents: String) -> void:
	$DialogBox.dialog(speaker, contents)


func info(contents: String) -> void:
	$DialogBox.info(contents)


func _on_Cursor_entered(node: CollisionObject2D) -> void:
	if node.has_method("select"):
		node.select(true)

	if node.has_method("get_name_when_selected"):
		$DialogBox.info(node.get_name_when_selected())

	if _current_state and _current_state.has_method("on_select"):
		_current_state.on_select(node)

	while true:
		var exited : CanvasItem = yield($Cursor, "exited")
		if exited == node:
			break

	if node.has_method("get_name_when_selected"):
		$DialogBox.hide()

	if _current_state and _current_state.has_method("on_unselect"):
		_current_state.on_unselect(node)

	if node.has_method("select"):
		node.select(false)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.is_pressed():
		var selected : Node = $Cursor.selected
		if _current_state and _current_state.has_method("on_interact"):
			_current_state.on_interact(selected)
