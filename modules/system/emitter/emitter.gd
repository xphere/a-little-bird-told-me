extends Node

export(Resource) var _signal = ResourceSignal.new()


func emit(value = "") -> void:
	_signal.emit_signal("signaled", value)
