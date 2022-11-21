class_name ActionSequential, "sequential.icon.png"
extends Action

export var loop := true

var _current : Action


func execute() -> void:
	yield(RefSignal.as_async(_execute()), "completed")


func _next_action() -> void:
	_current = _find_next_action(_current) if _current else _find_first_action()


func _find_first_action() -> Action:
	for child in get_children():
		if child is Action:
			return child
	return null


func _find_next_action(current: Action) -> Action:
	var index := current.get_index()
	var max_index := get_child_count()
	while true:
		index += 1
		if index >= max_index and loop:
			index = 0
		elif index >= max_index:
			break
		var next := get_child(index) as Action
		if next:
			return next
	return current


func _execute() -> void:
	_next_action()
	_current and yield(_current.execute(), "completed")
