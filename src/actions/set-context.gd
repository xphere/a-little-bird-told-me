extends "res://modules/action/native-expression.gd"

export var context_name : String


func execute() -> void:
	var value = _expression.execute([], self)
	if _expression.has_execute_failed():
		return

	owner.set_context(context_name, value)


func evaluate() -> bool:
	return false
