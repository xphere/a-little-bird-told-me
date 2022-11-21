class_name ActionBranch, "branch.icon.png"
extends "native-expression.gd"

var _if : Node
var _else : Node


func _ready() -> void:
	var child_count := get_child_count()
	_if = get_child(0) if child_count > 0 else null
	_else = get_child(1) if child_count > 1 else null


func execute() -> void:
	var result = evaluate()
	var branch := _else if not result else _if
	yield(RefSignal.as_async(branch.execute() if branch else null), "completed")
