extends Control


var _current_screen : CanvasItem
var _screens_stack := []


var _casting := {}

func cast(name: String, node: Node2D) -> void:
	_casting[name] = node

func character(name: String) -> Node2D:
	return _casting[name]

func animation(element: String, animation: String) -> void:
	print([ "animation", element, animation ])

func wait(wait_time: float) -> void:
	print([ "wait", wait_time ])
	yield(get_tree().create_timer(wait_time), "timeout")

func sound(name: String, pitch := 1.0) -> void:
	print([ "sound", name, pitch ])

func dialog(text: String, speaker: String, characters_per_sec: int) -> void:
	yield($DialogBox.dialog(text, speaker, characters_per_sec), "completed")

func info(text: String) -> void:
	$DialogBox.info(text)
	yield()
	$DialogBox.hide()

func cursor_lock(lock: bool) -> void:
	$Cursor.lock(lock)


func _ready() -> void:
	_play_story($Story.get_child(0))


func has_stacked_screen() -> bool:
	return not _screens_stack.empty()


var _letters := {}

func register_letter(letter: Node) -> Node:
	_letters[letter.letter_id] = letter
	return letter


func move_letter_to_mail_desk(letter_id: String) -> Node:
	var node = _letters[letter_id]
	var letter_scene := preload("res://src/objects/letters/letter.tscn") as PackedScene
	var letter := letter_scene.instance() as Node2D
	letter.connect("closed", node, "emit_signal", ["closed"], CONNECT_DEFERRED)
	letter.id = letter_id
	letter.letter_name = node.letter_name
	letter.letter_content = node.letter_contents
	letter.global_position = Vector2(rand_range(40, 256 - 40), rand_range(15, 240 - 15))
	$MailDesk.add_child(letter)
	return letter


func context(name: String):
	return $Context.context(name)


func consume_context(name: String):
	return $Context.consume_context(name)


func to_next_story(story: Node) -> void:
	var index := 1 + story.get_index()
	var parent := story.get_parent()
	if parent.get_child_count() > index:
		_play_story(parent.get_child(index))


func _play_story(story: Action) -> void:
	story and story.call_deferred("execute")


func push_screen(name: String, context: Dictionary = {}) -> void:
	$Context.merge(context)

	if not has_node(name):
		return

	var next_screen := get_node(name) as CanvasItem
	if next_screen == null:
		return

	if _current_screen and _current_screen.has_method("on_hold"):
		_current_screen.on_hold()

	if _current_screen:
		_screens_stack.push_back(_current_screen)

	_set_current_screen(next_screen)

	if _current_screen.has_method("on_enter"):
		_current_screen.on_enter()


func pop_screen(context: Dictionary = {}) -> void:
	$Context.merge(context)

	if _screens_stack.empty() or not _current_screen:
		return

	var next_screen := _screens_stack.pop_back() as CanvasItem
	if next_screen == null:
		return

	if _current_screen.has_method("on_leave"):
		_current_screen.on_leave()

	_set_current_screen(next_screen)

	if _current_screen.has_method("on_resume"):
		_current_screen.on_resume()


func to_screen(name: String, context: Dictionary = {}) -> void:
	$Context.merge(context)

	if not has_node(name):
		return

	var next_screen := get_node(name) as CanvasItem
	if next_screen == null:
		return

	if _current_screen and _current_screen.has_method("on_leave"):
		_current_screen.on_leave()

	_set_current_screen(next_screen)

	if _current_screen and _current_screen.has_method("on_enter"):
		_current_screen.on_enter()


func _on_Cursor_entered(node: CollisionObject2D) -> void:
	if node.has_method("select"):
		node.select(true)

	if node.has_method("get_name_when_selected"):
		$DialogBox.info(node.get_name_when_selected())

	if _current_screen and _current_screen.has_method("on_select"):
		_current_screen.on_select(node)

	while true:
		var exited : CanvasItem = yield($Cursor, "exited")
		if exited == node:
			break

	if node.has_method("get_name_when_selected"):
		$DialogBox.hide()

	if _current_screen and _current_screen.has_method("on_unselect"):
		_current_screen.on_unselect(node)

	if node.has_method("select"):
		node.select(false)


func _on_Cursor_interact(node: CollisionObject2D) -> void:
	if node.has_node("on-interact"):
		var interact_node := node.get_node("on-interact") as Action
		interact_node and interact_node.execute()

	elif node.has_method("on_interact"):
		node.on_interact()

	elif _current_screen and _current_screen.has_method("on_interact"):
		_current_screen.on_interact(node)


func _on_Cursor_help(node: CollisionObject2D) -> void:
	$Cursor.lock(true)

	if node.has_node("on-help-request"):
		var help_node := node.get_node("on-help-request") as Action
		help_node and yield(help_node.execute(), "completed")

	elif node.has_method("on_help_request"):
		yield(node.on_help_request(), "completed")

	elif _current_screen and _current_screen.has_method("on_help_request"):
		yield(_current_screen.on_help_request(node), "completed")

	$Cursor.lock(false)


func _set_current_screen(next_screen: Node) -> void:
	_current_screen = next_screen
	$Cursor.set_context(_current_screen)
