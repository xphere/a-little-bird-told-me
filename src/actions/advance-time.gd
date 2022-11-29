class_name ActionAdvanceTime
extends Action


func execute() -> void:
	owner.call_deferred("move_time_forward")
