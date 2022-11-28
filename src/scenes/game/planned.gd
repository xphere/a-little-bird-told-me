extends Node

var _current := 0
var _planned := {}


func execute(day: int, time: int) -> void:
	var execution = null

	if time > 0 and time < 5:
		_current = 4 * day + time - 1
		execution = _execute_planned(_current)

	yield(RefSignal.as_async(execution), "completed")


func register(in_steps: int, node: Action) -> void:
	var programmed_for := _current + in_steps
	if not _planned.has(programmed_for):
		_planned[programmed_for] = []

	_planned[programmed_for].append(node)


func _execute_planned(index: int):
	if not _planned.has(index):
		return null

	var planned : Array = _planned[index]
	_planned.erase(index)

	for child in planned:
		yield(RefSignal.as_async(child.execute()), "completed")
