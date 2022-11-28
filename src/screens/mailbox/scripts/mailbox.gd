extends Control

onready var _list := $"Center/List"
onready var _message_box := $"MessageBox"

var _text := ""


func on_enter() -> void:
	var task

	$Back.visible = owner.has_stacked_screen()
	_clear()
	show()

	task = _select("recipient", owner.get_recipients())
	var recipient : Node = yield(task, "completed")
	if not recipient:
		return
	_add_content(recipient.content)

	task = _select("topics", owner.get_topics_for(recipient.name))
	var topic : Node = yield(task, "completed")
	if not topic:
		return
	_add_content(topic.content)

	task = _select("closing", owner.get_closings())
	var closing : Node = yield(task, "completed")
	if not closing:
		return
	_add_content(closing.content)

	task = _select("signature", owner.get_signatures())
	var signature : Node = yield(task, "completed")
	if not signature:
		return
	_add_content(signature.content)


func on_leave() -> void:
	hide()
	_clear()
	_list.cancel()


func _on_Back_pressed() -> void:
	owner.pop_screen()


func _select(title: String, options: Array) -> Node:
	if options.size() > 1:
		return yield(
			_list.select(title, options),
			"completed"
		)

	yield(RefSignal.to_async(), "completed")
	return null if options.empty() else options[0]


func _clear() -> void:
	_text = ""
	_message_box.set_contents(_text)


func _add_content(content: String) -> void:
	_text += content + "\n\n"
	_message_box.set_contents(_text)
