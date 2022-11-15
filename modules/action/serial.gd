extends Action

export var lock := false


func execute() -> void:
	for child in get_children():
		if child is Action:
			yield(RefSignal.as_async(child.execute()), "completed")
