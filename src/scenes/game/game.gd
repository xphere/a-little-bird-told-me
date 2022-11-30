extends Control

signal on_help_request(element)
signal on_interact(element)

enum TimeOfDay {
	LAUDES,
	PRIMA,
	TERCIA,
	SEXTA,
	NONA,
	VISPERAS,
}

export var current_day := 0
export(TimeOfDay) var time_of_day := TimeOfDay.LAUDES

var _current_screen : CanvasItem
var _screens_stack := []
var _is_ready := false


func _ready() -> void:
	randomize()
	yield(_update_time(), "completed")
	_is_ready = true


var _casting := {}

func cast(name: String, node: Node2D) -> void:
	_casting[name] = node

func character(name: String) -> Node2D:
	return _casting[name]

func animate(name: String, animation: String) -> void:
	if _casting.has(name):
		_casting[name].animate(animation)

func wait(wait_time: float) -> void:
	yield(get_tree().create_timer(wait_time), "timeout")

func sound(name: String, pitch := 1.0) -> void:
	print([ "sound", name, pitch ])

func dialog(text: String, speaker: String, characters_per_sec: int) -> void:
	$Cursor.lock(true)
	_casting[speaker].animate("talk")
	yield($DialogBox.dialog(text, speaker, characters_per_sec), "completed")
	_casting[speaker].animate("idle")
	$Cursor.lock(false)

func info(text: String, wait_input := true) -> void:
	$Cursor.lock(true)
	yield($DialogBox.info(text, wait_input), "completed")
	$Cursor.lock(false)

func allow_topics(value: bool) -> void:
	$Letter.allow_topics(value)

var _notice_queue := Wait.queue()

func notice(text: String) -> void:
	yield($Notice.notice(text, 1.0), "completed")


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

var discovery := {}

func discover(url: String) -> void:
	var split = url.split(":", false, 1)
	var topic = split[0] if split.size() > 1 else url
	var value = split[1] if split.size() > 1 else ""
	var previous = $Context.context(topic, "")
	if  value.is_valid_integer():
		$Context.set_if_higher(topic, value.to_int())
	else:
		$Context.set_flag(topic, value)
	var current = $Context.context(topic)

	discovery = {
		"topic": topic,
		"value": value,
		"from": previous,
		"to": current,
	}

	var action : Action = $Discoveries.discover(topic)
	if action and _lock:
		yield(RefSignal.as_async(action.execute()), "completed")
	elif action:
		var lock = yield(lock(), "completed")
		yield(RefSignal.as_async(action.execute()), "completed")
		unlock(lock)

func plan_action(in_steps: int, action: Action) -> void:
	$Planned.register(in_steps, action)


func get_recipients() -> Array:
	return $Sections/Recipients.get_available()


func set_recipient(name: String, unlock: bool = true) -> void:
	$Sections/Recipients.set_availability(name, unlock)
	if unlock and _is_ready:
		notice("Unlocked new recipient")


func get_topics_for(recipient: String) -> Array:
	return $Sections/Topics.get_available_for(recipient)


func set_topic(name: String, unlock: bool = true) -> void:
	$Sections/Topics.set_availability(name, unlock)
	if unlock and _is_ready:
		notice("Unlocked new topic")


func get_closings() -> Array:
	return $Sections/Closings.get_available()


func set_closing(name: String, unlock: bool = true) -> void:
	$Sections/Closings.set_availability(name, unlock)
	if unlock and _is_ready:
		notice("Unlocked new closing")


func get_signatures() -> Array:
	return $Sections/Signatures.get_available()


func set_signature(name: String, unlock: bool = true) -> void:
	$Sections/Signatures.set_availability(name, unlock)
	if unlock and _is_ready:
		notice("Unlocked new signature")


var _birds := {}

func register_bird(bird_resource: Resource) -> void:
	_birds[bird_resource.name] = bird_resource

func bird_arrives(bird: BirdResource) -> void:
	$Tower.bird_arrives(bird)

func bird_pickup(bird: BirdResource) -> void:
	bird.call_deferred("emit_signal", "picked")
	if bird.carries is LetterResource:
		to_maildesk(bird.carries)

func update_birds() -> void:
	$Tower.update_birds()

func has_stacked_screen() -> bool:
	return not _screens_stack.empty()


var _letters := {}

func register_letter(letter: Resource) -> void:
	_letters[letter.letter_id] = letter


func to_maildesk(letter: LetterResource) -> void:
	$MailDesk.add_letter(letter)


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
	if not has_node(name):
		return

	var next_screen := get_node(name) as CanvasItem
	if next_screen == null:
		return

	$Context.merge(context)

	if _current_screen and _current_screen.has_method("on_leave"):
		_current_screen.on_leave()

	_set_current_screen(next_screen)

	if _current_screen and _current_screen.has_method("on_enter"):
		_current_screen.on_enter()


func move_time_forward() -> void:
	if time_of_day == TimeOfDay.VISPERAS:
		current_day += 1
		time_of_day = TimeOfDay.LAUDES
	else:
		time_of_day += 1
	yield(_update_time(), "completed")


func _update_time() -> void:
	var time_string : String = TimeOfDay.keys()[time_of_day]
	time_string = time_string.to_lower()

	$Context.merge({
		"day": current_day,
		"time": time_string,
	})

	yield($Tower.on_time_change(current_day, time_of_day), "completed")
	yield($Planned.execute(current_day, time_of_day), "completed")
	yield($Story.execute(current_day, time_string), "completed")


func _on_Cursor_entered(node: CollisionObject2D) -> void:
	if node.has_method("select"):
		node.select(true)

	var node_name := _get_name_of(node)
	if node_name:
		$DialogBox.info(node_name)

	if _current_screen and _current_screen.has_method("on_select"):
		_current_screen.on_select(node)

	yield($Cursor, "exited")

	if node_name:
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
		$Cursor/Select.play()
		yield(ref_signal, "completed")

	emit_signal(method_name, node)
	unlock(lock)


func _get_name_of(node: Node) -> String:
	if node.has_node("with-name"):
		return node.get_node("with-name").evaluate()

	if node.has_method("get_name_when_selected"):
		return node.get_name_when_selected()

	return ""


func _set_current_screen(next_screen: Node) -> void:
	_current_screen = next_screen
	$Cursor.set_context(_current_screen)
