class_name ActionCursorLock, "res://src/actions/cursor-lock.icon.png"
extends ActionSerial

export var unlock_parent := false

var _lock


func execute() -> void:
	var execution

	if unlock_parent:
		execution = _unlock_parent_lock()
	else:
		execution = _lock()

	yield(execution, "completed")


func _lock() -> void:
	_lock = yield(owner.lock(), "completed")
	yield(.execute(), "completed")
	owner.unlock(_lock)


func _unlock_parent_lock() -> void:
	var parent := _find_parent_lock()
	if not parent:
		yield(.execute(), "completed")
	else:
		owner.unlock(parent._lock)
		yield(.execute(), "completed")
		parent._lock = yield(owner.lock(), "completed")


func _find_parent_lock() -> ActionCursorLock:
	var parent := get_parent()
	while parent is Node and not (parent as ActionCursorLock):
		parent = parent.get_parent()

	return parent as ActionCursorLock
