extends "native-expression.gd"


func execute() -> void:
	var result = str(evaluate())
	if not result:
		return

	var execution
	if has_node(result):
		var branch = get_node(result)
		execution = branch.execute()

	yield(RefSignal.as_async(execution), "completed")
