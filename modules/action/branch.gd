extends "expression.gd"

var _if : Node
var _else : Node


func _ready() -> void:
	_if = $"if" if has_node("if") else null
	_else = $"else" if has_node("else") else null


func execute() -> void:
	var result = _execute_expression()
	var branch := _else if result == false or result == null else _if
	yield(RefSignal.as_async(branch.execute() if branch else null), "completed")
