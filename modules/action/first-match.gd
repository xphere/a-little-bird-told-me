class_name ActionFirstMatch, "first-match.icon.png"
extends "expression.gd"

const ActionExpression := preload("expression.gd")


func execute() -> void:
	var branch := evaluate()
	yield(RefSignal.as_async(branch.execute() if branch else null), "completed")


func evaluate() -> Node:
	for child in get_children():
		var expression := child as ActionExpression
		if expression and expression.evaluate():
			return expression
		if expression == null and child is Action:
			return child
	return null
