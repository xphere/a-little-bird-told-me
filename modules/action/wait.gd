extends Action

export(float, 0.0, 16.0, 0.1) var waiting_time := 1.0


func execute() -> void:
	yield(get_tree().create_timer(waiting_time), "timeout")
