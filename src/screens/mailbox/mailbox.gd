extends Control


func on_enter() -> void:
	$Back.visible = owner.has_stacked_screen()
	show()

	var recipients : Array = owner.get_recipients()
	var select_recipient = _select("recipients", recipients)
	var recipient : Node = yield(select_recipient, "completed")
	if not visible:
		return

	var text := "Dear %s" % recipient.name
	$MessageBox.set_contents(text)

	var topics : Array = owner.get_topics_for(recipient.name)
	var select_topic = _select("topics", topics)
	var topic : Node = yield(select_topic, "completed")
	if not visible:
		return

	text += "\n\n"
	text += "Want %s" % topic.name
	$MessageBox.set_contents(text)


func on_leave() -> void:
	hide()
	$MessageBox.set_contents("")
	$"%List".cancel()


func _on_Back_pressed() -> void:
	owner.pop_screen()


func _select(title: String, options: Array) -> Node:
	return yield($"%List".select(title, options), "completed")
