extends Control

onready var _list := $"Center/Margin/List"
onready var _message_box := $"MessageBox"

var _text := ""


func on_enter() -> void:
	_clear()
	$Back.visible = owner.has_stacked_screen()
	$Center.visible = true
	show()
	yield(_write_letter(), "completed")
	$Center.visible = false


func _write_letter() -> void:
	var task

	task = _select("To who should I write?", owner.get_recipients())
	var recipient : Node = yield(task, "completed")
	if not recipient:
		return
	_add_content(recipient.content)

	task = _select("About what topic?", owner.get_topics_for(recipient.name))
	var topic : Node = yield(task, "completed")
	if not topic:
		return
	_add_content(topic.content)

	task = _select("Any closing words?", owner.get_closings())
	var closing : Node = yield(task, "completed")
	if not closing:
		return
	_add_content(closing.content)

	task = _select("Who should I sign as?", owner.get_signatures(), true)
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


func _select(title: String, options: Array, skippable := false) -> Node:
	if skippable and options.size() <= 1:
		yield(RefSignal.to_async(), "completed")
		return null if options.empty() else options[0]

	return yield(_list.select(title, options), "completed")


func _clear() -> void:
	_text = ""
	_message_box.set_contents(_text)


func _add_content(content: String) -> void:
	_text += content + "\n\n"
	_message_box.set_contents(_text)
