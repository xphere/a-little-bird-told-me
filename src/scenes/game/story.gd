extends Node

var _executing := false


func execute(day: int, time: String) -> void:
	var matching_node_name := str(_evaluate(day, time))
	var execution := _execute_node(matching_node_name)

	_executing = true
	yield(RefSignal.as_async(execution), "completed")
	_executing = false


func _execute_node(name: String) -> GDScriptFunctionState:
	if not name:
		return null

	var branch : Action = get_node(name)
	if branch:
		return branch.execute()

	return null


func _evaluate(day: int, time: String) -> String:
	if _executing:
		return ""

	if time == "laudes":
		var branch = "Day#%s" % [day]
		if has_node(branch):
			return branch

	var branch := "Day#%s#%s" % [day, time]
	if has_node(branch):
		return branch

	return ""
