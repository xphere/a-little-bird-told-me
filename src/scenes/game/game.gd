extends Control


signal context_changed(key, value)


var _context := {}
var _current_state : CanvasItem
var _states_stack := []


func _ready() -> void:
	_trigger_story($Story.get_child(0))


func has_stacked_state() -> bool:
	return not _states_stack.empty()


func register_letter(letter: Node) -> Node:
	return letter


func move_letter_to_mail_desk(node: Node) -> Node:
	var letter_scene := preload("res://src/objects/letters/letter.tscn") as PackedScene
	var letter := letter_scene.instance() as Node2D
	letter.letter_name = node.letter_name
	letter.letter_content = node.letter_contents
	letter.global_position = Vector2(rand_range(40, 256 - 40), rand_range(15, 240 - 15))
	$MailDesk.add_child(letter)
	return letter


func context(name: String):
	return _context[name] if _context.has(name) else null


func consume_context(name: String):
	var result = context(name)
	_context.erase(name)

	return result


func to_next_story(story: Node) -> void:
	var index := 1 + story.get_index()
	var parent := story.get_parent()
	if parent.get_child_count() > index:
		_trigger_story(parent.get_child(index))


func _trigger_story(story: Node) -> void:
	story.trigger()


func push_state(name: String, context: Dictionary = {}) -> void:
	_merge_context(context)

	if not has_node(name):
		return

	var next_state := get_node(name) as CanvasItem
	if next_state == null:
		return

	if _current_state and _current_state.has_method("on_hold"):
		_current_state.on_hold()

	if _current_state:
		_states_stack.push_back(_current_state)

	_set_current_state(next_state)

	if _current_state.has_method("on_enter"):
		_current_state.on_enter()


func pop_state(context: Dictionary = {}) -> void:
	_merge_context(context)

	if _states_stack.empty() or not _current_state:
		return

	var next_state := _states_stack.pop_back() as CanvasItem
	if next_state == null:
		return

	if _current_state.has_method("on_leave"):
		_current_state.on_leave()

	_set_current_state(next_state)

	if _current_state.has_method("on_resume"):
		_current_state.on_resume()


func to_state(name: String, context: Dictionary = {}) -> void:
	_merge_context(context)

	if not has_node(name):
		return

	var next_state := get_node(name) as CanvasItem
	if next_state == null:
		return

	if _current_state and _current_state.has_method("on_leave"):
		_current_state.on_leave()

	_set_current_state(next_state)

	if _current_state and _current_state.has_method("on_enter"):
		_current_state.on_enter()


func dialog(speaker: String, contents: String) -> void:
	$DialogBox.dialog(speaker, contents)


func info(contents: String) -> void:
	$DialogBox.info(contents)


func _on_Cursor_interact(node: CollisionObject2D) -> void:
	if _current_state and _current_state.has_method("on_interact"):
		_current_state.on_interact(node)

	if node.has_method("on_interact"):
		node.on_interact()


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


func _set_current_state(next_state: Node) -> void:
	_current_state = next_state
	$Cursor.set_context(_current_state)


func _merge_context(context: Dictionary) -> void:
	for key in context.keys():
		var value = context[key]
		if value == null:
			_context.erase(key)
		else:
			_context[key] = value
