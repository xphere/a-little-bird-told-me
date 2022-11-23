extends Control

signal on_help_request(element)
signal on_interact(element)

export var current_day := 0


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
	yield(get_tree().create_timer(wait_time), "timeout")

func sound(name: String, pitch := 1.0) -> void:
	print([ "sound", name, pitch ])

func dialog(text: String, speaker: String, characters_per_sec: int) -> void:
	$Cursor.lock(true)
	yield($DialogBox.dialog(text, speaker, characters_per_sec), "completed")
	$Cursor.lock(false)

func info(text: String, wait_input := true) -> void:
	$Cursor.lock(true)
	yield($DialogBox.info(text, wait_input), "completed")
	$Cursor.lock(false)

func allow_topics(value: bool) -> void:
	$Letter.allow_topics(value)


var _lock : Resource

func is_unlocked() -> bool:
	return not $Cursor.is_locked()

func lock() -> Resource:
	var previous := _lock
	_lock = Resource.new()
	if previous:
		yield(previous, "changed")
	else:
		yield(RefSignal.to_async(), "completed")
	$Cursor.lock(true)
	return _lock

func unlock(lock: Resource) -> void:
	if _lock == lock:
		_lock = null
	$Cursor.lock(false)
	lock.emit_changed()

func discover(url: String) -> void:
	var split = url.split(":", false, 1)
	var topic = split[0] if split.size() > 1 else url
	var value = split[1] if split.size() > 1 else ""
	if  value.is_valid_integer():
		$Context.set_if_higher(topic, value.to_int())
	else:
		$Context.set_flag(topic, value)

	var action : Action = $Topics.topic(topic)
	if action and _lock:
		yield(RefSignal.as_async(action.execute()), "completed")
	elif action:
		var lock = yield(lock(), "completed")
		yield(RefSignal.as_async(action.execute()), "completed")
		unlock(lock)


var _birds := {}

func register_bird(bird_resource: Resource) -> void:
	_birds[bird_resource.name] = bird_resource

func bird_arrives(bird: Node2D) -> void:
	$Tower.bird_arrives(bird)


func _ready() -> void:
	randomize()
	$Context.merge({
		"day": current_day,
	})
	$Story.execute()


func has_stacked_screen() -> bool:
	return not _screens_stack.empty()


var _letters := {}

func register_letter(letter: Resource) -> void:
	_letters[letter.letter_id] = letter


func add_to_maildesk(letter: Node2D) -> void:
	letter.global_position = Vector2(rand_range(40, 256 - 40), rand_range(15, 240 - 15))
	$MailDesk.add_child(letter)


func context(name: String, default_value = null):
	return $Context.context(name, default_value)


func context_flag(name: String, flag: String) -> bool:
	return $Context.context_flag(name, flag)


func context_flag_count(name: String) -> int:
	return $Context.context_flag_count(name)


func set_context(name: String, value):
	$Context.set_value(name, value)


func consume_context(name: String, default_value = null):
	return $Context.consume_context(name, default_value)


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

	yield($Cursor, "exited")

	if node.has_method("get_name_when_selected"):
		$DialogBox.hide()

	if _current_screen and _current_screen.has_method("on_unselect"):
		_current_screen.on_unselect(node)

	if node.has_method("select"):
		node.select(false)


func _on_Cursor_interact(node: CollisionObject2D) -> void:
	_try_interactions(node, "on-interact", "on_interact")


func _on_Cursor_help(node: CollisionObject2D) -> void:
	_try_interactions(node, "on-help-request", "on_help_request")


func _try_interactions(node: Node, child_name: String, method_name: String) -> void:
	var lock = yield(lock(), "completed")
	var ref_signal : GDScriptFunctionState

	if node.has_node(child_name):
		var child_node := node.get_node(child_name) as Action
		if child_node:
			ref_signal = RefSignal.as_async(child_node.execute())

	elif node.has_method(method_name):
		ref_signal = RefSignal.as_async(node.call(method_name))

	elif _current_screen and _current_screen.has_method(method_name):
		ref_signal = RefSignal.as_async(
			_current_screen.call(method_name, node)
		)

	if ref_signal:
		yield(ref_signal, "completed")

	emit_signal(method_name, node)
	unlock(lock)


func _set_current_screen(next_screen: Node) -> void:
	_current_screen = next_screen
	$Cursor.set_context(_current_screen)


func _on_Tower_bird_arrived(bird: Resource) -> void:
	set_context("bird", bird)


func _on_Tower_bird_picked(bird: Resource) -> void:
	set_context("bird", null)
