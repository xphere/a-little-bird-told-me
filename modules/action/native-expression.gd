extends "expression.gd"

export var base_path : NodePath
export(String, MULTILINE) var expression_contents := ""

var _expression := Expression.new()


func _ready() -> void:
	if _expression.parse(expression_contents) != OK:
		push_error(_expression.get_error_text())


func evaluate():
	var instance : Node = get_node(base_path) if base_path else owner
	var result = _expression.execute([], instance, false)
	if _expression.has_execute_failed():
		return null

	return result
