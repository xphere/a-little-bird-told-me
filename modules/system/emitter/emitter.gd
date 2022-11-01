extends Node

export(Resource) var _signal = ResourceSignal.new()


func emit(value = "") -> void:
	_signal.emit_signal("signaled", value)


func listen(object: Object, method: String, binds := [], flags := 0) -> int:
	return _signal.connect("signaled", object, method, binds, flags)
