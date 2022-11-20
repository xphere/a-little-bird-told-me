extends "res://modules/action/serial.gd"


func execute() -> void:
	var lock = yield(owner.lock(), "completed")
	yield(.execute(), "completed")
	owner.unlock(lock)
