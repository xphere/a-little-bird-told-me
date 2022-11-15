extends "res://modules/action/serial.gd"


func execute() -> void:
	owner.cursor_lock(true)
	yield(.execute(), "completed")
	owner.cursor_lock(false)
