class_name ActionAdvanceTime
extends Action

export var wait := false


func execute() -> void:
	if wait:
		yield(owner.move_time_forward(), "completed")
	else:
		owner.call_deferred("move_time_forward")
