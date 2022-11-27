extends Control

var _button_template : Node
var _signal := ResourceSignal.new()


func _ready() -> void:
	_button_template = $Button
	remove_child(_button_template)


func _exit_tree() -> void:
	_button_template.queue_free()


func cancel() -> void:
	_signal.emit_signal("signaled", null)


func select(title: String, options: Array) -> Node:
	$Label.text = title

	var buttons := []
	for option in options:
		var button : Button = _button_template.duplicate()
		button.connect(
			"pressed",
			_signal, "emit_signal", ["signaled", option],
			CONNECT_DEFERRED | CONNECT_ONESHOT
		)
		button.text = option.name
		add_child(button)
		buttons.append(button)

	show()

	var result : Node = yield(_signal, "signaled")

	hide()
	for button in buttons:
		button.queue_free()

	return result
