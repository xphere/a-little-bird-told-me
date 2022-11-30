class_name ActionCursorLock, "res://src/actions/cursor-lock.icon.png"
extends ActionSerial


func execute() -> void:
	var lock = yield(owner.lock(), "completed")
	yield(.execute(), "completed")
	owner.unlock(lock)
