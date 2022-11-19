extends "expression.gd"

export(String, MULTILINE) var expression_contents := ""

var _expression := Expression.new()


func _ready() -> void:
	if _expression.parse(expression_contents) != OK:
		push_error(_expression.get_error_text())


func context(name: String, default_value = null):
	return owner.context(name, default_value)


func evaluate():
	var result = _expression.execute([], self)
	if _expression.has_execute_failed():
		return null

	return result
