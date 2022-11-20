extends "res://modules/action/serial.gd"

export var every_sec := 60

var _timer : SceneTreeTimer


func execute() -> void:
	start()


func start() -> void:
	if _timer:
		return

	var timer = get_tree().create_timer(every_sec)
	_timer = timer
	yield(timer, "timeout")
	if _timer != timer:
		return

	yield(.execute(), "completed")

	if _timer == timer:
		_timer = null
		call_deferred("start")


func stop() -> void:
	_timer = null


func restart() -> void:
	stop()
	start()
